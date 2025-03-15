import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

class MovieProvider extends ChangeNotifier {
  static const String _apiKey =
      "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwOWU4ZWJlMTdmNWM0MTFmOGU5MzA3OWQ0YTY0Yzg0NCIsIm5iZiI6MTc0MTk1NjcyOS40ODg5OTk4LCJzdWIiOiI2N2Q0MjY3OWEyYjE4ZGJlZGQ2NGY0YTgiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.YkOg6Rk-7rwdBAjLw_bPYaPa_UYyuVSKgMBetUuQORM";
  static const String _baseUrl = "https://api.themoviedb.org/3";

  List<MovieModel> _movies = [];
  List<MovieModel> get movies => _movies;

  final Box<MovieModel> _favoritesBox = Hive.box<MovieModel>('favoritesBox');

  int currentPage = 1; // Current page number for pagination
  bool _isFetching = false; // To prevent multiple simultaneous fetches

  // Inside MovieProvider
void loadMoreMovies() {
  if (!_isFetching) {
    _isFetching = true;
    fetchMovies(page: currentPage + 1);
  }
}

Future<void> fetchMovies({int page = 1}) async {
  if (_isFetching) return;
  _isFetching = true;

  try {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey&page=$page'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['results'] as List;
      final List<MovieModel> fetchedMovies = data.map((movie) {
        return MovieModel(
          id: movie['id'],
          title: movie['title'],
          rate: movie['vote_average'],
          date: movie['release_date'],
          imageUrl: 'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
          description: movie['overview'],
        );
      }).toList();

      if (page == 1) {
        _movies = fetchedMovies;
      } else {
        _movies.addAll(fetchedMovies);
      }
      currentPage = page;
    } else {
      throw Exception('Failed to load movies');
    }
  } catch (e) {
    print('Error fetching movies: $e');
    // Handle error, maybe show a snackbar or dialog
  } finally {
    _isFetching = false;
    notifyListeners();
  }
}

  Future<List<MovieModel>> fetchRelatedMovies(int movieId) async {
  final response = await http.get(
    Uri.parse('$_baseUrl/movie/$movieId/similar?api_key=$_apiKey'),
    headers: {
      "Authorization": "Bearer $_apiKey",
      "Content-Type": "application/json",
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body)['results'] as List;
    final List<MovieModel> relatedMovies = data
        .map((movie) => MovieModel(
              id: movie['id'],
              title: movie['title'],
              rate: movie['vote_average'],
              date: movie['release_date'],
              imageUrl:
                  'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
              description: movie['overview'],
            ))
        .toList();
    return relatedMovies;
  } else {
    throw Exception('Failed to load related movies');
  }
}

  // Manage Favorites
  List<MovieModel> get favoriteMovies => _favoritesBox.values.toList();

  void toggleFavorite(MovieModel movie) {
    if (_favoritesBox.containsKey(movie.id)) {
      _favoritesBox.delete(movie.id);
    } else {
      _favoritesBox.put(movie.id, movie);
    }
    notifyListeners();
  }

  bool isFavorite(int id) => _favoritesBox.containsKey(id);
}
