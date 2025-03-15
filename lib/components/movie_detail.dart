import 'package:flutter/material.dart';


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
