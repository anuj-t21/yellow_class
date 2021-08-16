import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:yellow_class/modules/login/login_screen.dart';
import 'package:yellow_class/modules/movies/movie_lists_screen.dart';
import 'package:yellow_class/modules/movies/movies_model.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(MoviesModelAdapter());
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yellow Class Assignment',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: FutureBuilder(
        future: Hive.openBox<bool>('logIn'),
        initialData: {},
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final data = snapshot.data;
            print(data.values);
            if (data == null || data.get('isSigned') == false || data.isEmpty) {
              return LoginScreen();
            }
            return MovieListsScreen();
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      routes: {
        MovieListsScreen.routeName: (ctx) => MovieListsScreen(),
      },
    );
  }
}
