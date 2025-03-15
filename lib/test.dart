import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('favorites');
  await Hive.openBox('theme'); // Open box for theme
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('theme').listenable(),
      builder: (context, Box box, _) {
        bool isDarkMode = box.get('isDarkMode', defaultValue: false);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
          home: HomeScreen(),
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List movies = [];
  int page = 1;
  bool isLoading = false;
  Box? favoritesBox;
  Box? themeBox;

  static const String _apiKey =
      "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwOWU4ZWJlMTdmNWM0MTFmOGU5MzA3OWQ0YTY0Yzg0NCIsIm5iZiI6MTc0MTk1NjcyOS40ODg5OTk4LCJzdWIiOiI2N2Q0MjY3OWEyYjE4ZGJlZGQ2NGY0YTgiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.YkOg6Rk-7rwdBAjLw_bPYaPa_UYyuVSKgMBetUuQORM";
  static const String _baseUrl = "https://api.themoviedb.org/3";

  // Fetch Movies
  Future<void> fetchMovies() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    final url = "$_baseUrl/discover/movie?page=$page";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $_apiKey",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        movies.addAll(data['results']);
        page++;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      throw Exception("Failed to load movies");
    }
  }

  @override
  void initState() {
    super.initState();
    favoritesBox = Hive.box('favorites'); 
    themeBox = Hive.box('theme'); 
    fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Movies"),
        actions: [
          // Theme Switcher
          IconButton(
            icon: Icon(Icons.nightlight_round),
            onPressed: () {
              setState(() {
                bool isDarkMode = themeBox!.get('isDarkMode', defaultValue: false);
                themeBox!.put('isDarkMode', !isDarkMode);
              });
            },
          ),
          // Navigate to Favorite Movies List
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoriteMoviesScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: movies.length + 1, // +1 for the Load More button
        itemBuilder: (context, index) {
          if (index == movies.length) {
            return Center(
              child: ElevatedButton(
                onPressed: fetchMovies,
                child: isLoading
                    ? CircularProgressIndicator()
                    : Text("Load More"),
              ),
            );
          }

          final movie = movies[index]; 
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailScreen(movie: movie),
                ),
              );
            },
            child: MovieCard(movie: movie, favoritesBox: favoritesBox!),
          );
        },
      ),
    );
  }
} 


class MovieCard extends StatelessWidget {
  final dynamic movie;
  final Box favoritesBox;

  MovieCard({required this.movie, required this.favoritesBox});

  @override
  Widget build(BuildContext context) {
    List<dynamic> genres = movie['genre_ids'];

    bool isFavorite = favoritesBox.get(movie['id'], defaultValue: false);

    return ValueListenableBuilder(
      valueListenable: favoritesBox.listenable(),
      builder: (context, Box box, _) {
        // Ensure the favorite status is up-to-date
        bool isFavorite = box.get(movie['id'], defaultValue: false);

        return Card(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Left: Movie Poster
                Container(
                  width: 100,
                  height: 150,
                  child: Image.network(
                    "https://image.tmdb.org/t/p/w200${movie['poster_path']}",
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10),

                // Right: Movie Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        movie['title'] ?? 'Unknown Title',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),

                      // Rating
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 18),
                          SizedBox(width: 5),
                          Text(
                            "${movie['vote_average'] ?? 'N/A'}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),

                      // Genres (Placeholder)
                      Text(
                        genres.isNotEmpty
                            ? genres.join(", ")
                            : 'Genres not available',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),

                      // Bottom Row: Released date & Favorite Icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Release date
                          Text(
                            movie['release_date'] ?? 'Release Date: N/A',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),

                          // Favorite Icon
                          IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                            ),
                            onPressed: () {
                              if (isFavorite) {
                                favoritesBox.delete(movie['id']);
                              } else {
                                favoritesBox.put(movie['id'], true);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


class MovieDetailScreen extends StatelessWidget {
  final dynamic movie;

  MovieDetailScreen({required this.movie});

  @override
  Widget build(BuildContext context) {
    List<dynamic> genres = movie['genre_ids'];
    String description = movie['overview'] ?? 'No description available';

    return Scaffold(
      appBar: AppBar(
        title: Text(movie['title'] ?? 'Movie Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster
            Center(
              child: Image.network(
                "https://image.tmdb.org/t/p/w500${movie['poster_path']}",
                fit: BoxFit.cover,
                height: 300,
              ),
            ),
            SizedBox(height: 20),

            // Title
            Text(
              movie['title'] ?? 'Unknown Title',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Rating
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 20),
                SizedBox(width: 5),
                Text(
                  "${movie['vote_average'] ?? 'N/A'}",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Release Date
            Text(
              "Release Date: ${movie['release_date'] ?? 'N/A'}",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),

            // Genres
            Text(
              "Genres: ${genres.isNotEmpty ? genres.join(", ") : 'Not available'}",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),

            // Description
            Text(
              "Description:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteMoviesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoritesBox = Hive.box('favorites');

    List<int> favoriteMovieIds = favoritesBox.keys.cast<int>().toList();
    List<Map<String, dynamic>> favoriteMovies = [];

    favoriteMovieIds.forEach((id) {
      favoriteMovies.add({
        'id': id,
        'title': "Favorite Movie $id",
        'poster_path': "/path/to/poster", // Mocking the data, you would fetch details based on ID
      });
    });

    return Scaffold(
      appBar: AppBar(title: Text("Favorite Movies")),
      body: ListView.builder(
        itemCount: favoriteMovies.length,
        itemBuilder: (context, index) {
          final movie = favoriteMovies[index];
          return ListTile(
            title: Text(movie['title']),
            leading: Image.network(
              "https://image.tmdb.org/t/p/w200${movie['poster_path']}",
              width: 50,
              height: 75,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}

