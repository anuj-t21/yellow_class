import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'movies_model.g.dart';

@HiveType(typeId: 0)
class MoviesModel {
  @HiveField(0)
  String? movieTitle;
  @HiveField(1)
  String? directorName;
  @HiveField(2)
  String? posterPath;
//  @HiveField(2)
//  final bool? complete;

  MoviesModel({
    @required this.movieTitle,
    @required this.directorName,
    @required this.posterPath,
  });
}
