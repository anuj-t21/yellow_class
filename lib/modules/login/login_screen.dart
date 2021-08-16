import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:yellow_class/modules/movies/movie_lists_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _isLoading = false;
  Future<void> signInWithGoogle(context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      setState(() {
        _isLoading = true;
      });
      var _googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication gauth =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gauth.accessToken,
        idToken: gauth.idToken,
      );
      final authRes = await _auth.signInWithCredential(credential);
      final User? user = authRes.user;
      //  bool userExists = await checkUser();

      var box = await Hive.openBox<bool>('logIn');
      box.put('isSigned', true);
      Navigator.of(context).pushNamed(MovieListsScreen.routeName);
//      await setUId();
//      final instance = await SharedPreferences.getInstance();
//      instance.setString('userID', user.uid);
//      instance.setString('email', user.email);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: Colors.black,
                  height: deviceSize.height * 0.6,
                  child: Center(
                    child: Text(
                      'YELLOW CLASS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Container(
                    width: double.infinity,
                    child: Card(
                      child: TextButton(
                        child: Text('Sign In With Google'),
                        onPressed: () => signInWithGoogle(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
