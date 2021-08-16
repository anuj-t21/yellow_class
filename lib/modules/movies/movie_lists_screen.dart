import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:yellow_class/base/custom_text_field.dart';
import 'package:yellow_class/modules/login/login_screen.dart';
import 'package:yellow_class/modules/movies/movies_model.dart';
import 'package:yellow_class/modules/movies/pickers/movie_poster_picker.dart';
import 'package:yellow_class/utils/utility.dart';

class MovieListsScreen extends StatefulWidget {
  static const routeName = '/movie-list';
  @override
  _MovieListsScreenState createState() => _MovieListsScreenState();
}

class _MovieListsScreenState extends State<MovieListsScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final _addMovieForm = GlobalKey<FormState>();

  List<MoviesModel> listMovies = [];

  void getMovies() async {
    final box = await Hive.openBox<MoviesModel>('movie');
    setState(() {
      listMovies = box.values.toList().reversed.toList();
      print('check');
      print(listMovies.length);
    });
  }

  @override
  void initState() {
    getMovies();
    super.initState();
  }

  void signOut() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    GoogleSignIn _googleSignIn = GoogleSignIn();

    await _auth.signOut();
    await _googleSignIn.signOut();

    var box = await Hive.openBox<bool>('logIn');
    box.put('isSigned', false);

    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  Future<void> submitMovieForm({
    MoviesModel? moviesModel,
    bool? isEdit,
    int? position,
  }) async {
    final _isValid = _addMovieForm.currentState!.validate();
    if (!_isValid) {
      return;
    }
    _addMovieForm.currentState!.save();

    var box = await Hive.openBox<MoviesModel>('movie');
    isEdit!
        ? box.putAt(position!, moviesModel!).whenComplete(() {
            getMovies();
            titleController.clear();
            descriptionController.clear();
            Navigator.of(context).pop();
          })
        : box.add(moviesModel!).whenComplete(() {
            getMovies();
            titleController.clear();
            descriptionController.clear();
            Navigator.of(context).pop();
          });
  }

  Future<dynamic> _showAddDialog(
      {BuildContext? context,
      MoviesModel? moviesModel,
      bool? isEdit,
      int? position}) {
    titleController.text = moviesModel!.movieTitle!;
    descriptionController.text = moviesModel.directorName!;

    void _pickedImage(String imageString) {
      moviesModel.posterPath = imageString;
    }

    return showDialog(
      context: context!,
      builder: (ctx) => Center(
        child: Card(
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Form(
            key: _addMovieForm,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MoviePosterPicker(
                  _pickedImage,
                  Utility.imageFromBase64String(
                    moviesModel.posterPath!,
                  ),
                ),
                CustomTextField(
                  hintText: 'Enter title',
                  textEditingController: titleController,
                  onSave: (value) {
                    moviesModel.movieTitle = value;
                  },
                ),
                CustomTextField(
                  hintText: 'Enter director',
                  textEditingController: descriptionController,
                  onSave: (value) {
                    moviesModel.directorName = value;
                  },
                ),
                TextButton(
                  onPressed: () async {
                    submitMovieForm(
                      moviesModel: moviesModel,
                      isEdit: isEdit,
                      position: position,
                    );
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List colors = [
      Colors.orangeAccent,
      Colors.cyan,
      Colors.pinkAccent,
    ];
    Random random = new Random();
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, bottom: 20.0, right: 8.0),
                child: Row(
                  children: [
                    Text(
                      'Movies',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () => signOut(),
                      icon: Icon(Icons.exit_to_app),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: ListView.builder(
                    itemCount: listMovies.length,
                    itemBuilder: (context, position) {
                      MoviesModel moviesModel = listMovies[position];
                      var title = moviesModel.movieTitle;
                      var director = moviesModel.directorName;
                      return Card(
                        color: colors[random.nextInt(3)],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 100,
                                    width: 80,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Utility.imageFromBase64String(
                                        moviesModel.posterPath!,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Name: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(title!),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Director: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(director!),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          _showAddDialog(
                                            context: context,
                                            moviesModel: moviesModel,
                                            isEdit: true,
                                            position: listMovies.length -
                                                position -
                                                1,
                                          );
                                        },
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          final box =
                                              Hive.box<MoviesModel>('movie');
                                          box.deleteAt(
                                              listMovies.length - position - 1);
                                          getMovies();
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () => _showAddDialog(
            context: context,
            moviesModel: MoviesModel(
              movieTitle: '',
              directorName: '',
              posterPath: '',
            ),
            isEdit: false,
            position: 0,
          ),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
