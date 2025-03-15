import 'package:hive/hive.dart';

part 'movie_model.g.dart'; // for Hive code generation

@HiveType(typeId: 0)
class MovieModel {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final double rate;
  @HiveField(3)
  final String date;
  @HiveField(4)
  final String imageUrl;
  @HiveField(5)
  final String description;

  MovieModel({
    required this.id,
    required this.title,
    required this.rate,
    required this.date,
    required this.imageUrl,
    required this.description,
  });
}
