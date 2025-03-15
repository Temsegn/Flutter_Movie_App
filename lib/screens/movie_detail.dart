import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie_model.dart';
import 'provider.dart';  // Import MovieProvider

class MovieDetailScreen extends StatelessWidget {
  final MovieModel movie;

  MovieDetailScreen({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        backgroundColor: Colors.transparent,  // Make AppBar transparent
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white), // White back arrow
      ),
      extendBodyBehindAppBar: true,  // Extend body to make appbar transparent
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Movie Image centered horizontally and fully visible
            Center(
              child: Container(
                width: double.infinity,
                height: 200, // Set the height of the image container
                child: Image.network(
                  movie.imageUrl,
                  fit: BoxFit.contain, 
                  width: double.infinity, // Ensures the entire image is visible
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    movie.title,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10),
                  // Release Date
                  Text(
                    'Release Date: ${movie.date}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 10),
                  // Rating with stars
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 24,
                      ),
                      SizedBox(width: 5),
                      Text(
                        '${movie.rate}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Description
                  Text(
                    movie.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Add to Favorites Button
                      ElevatedButton.icon(
                        onPressed: () {
                          // Add favorite logic here
                        },
                        icon: Icon(Icons.favorite_border),
                        label: Text('Add to Favorites'),
                        style: ElevatedButton.styleFrom(
                          iconColor: Colors.red,
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      // Watch Now Button
                      ElevatedButton.icon(
                        onPressed: () {
                          // Watch now logic here
                        },
                        icon: Icon(Icons.play_circle_fill),
                        label: Text('Watch Now'),
                        style: ElevatedButton.styleFrom(
                          iconColor: Colors.green,
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Related Movies
                 Consumer<MovieProvider>(
  builder: (context, movieProvider, _) {
    // Fetch related movies using the movie's ID
    return FutureBuilder<List<MovieModel>>(
      future: movieProvider.fetchRelatedMovies(movie.id),  // Pass movie.id instead of movie.title
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error fetching related movies');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No related movies available');
        } else {
          final relatedMovies = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Related Movies',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              // Display related movies in a horizontal list
              Container(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: relatedMovies.length,
                  itemBuilder: (context, index) {
                    final relatedMovie = relatedMovies[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailScreen(
                              movie: relatedMovie,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 16),
                        width: 120,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Image.network(
                                relatedMovie.imageUrl,
                                width: 120,
                                height: 180,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              relatedMovie.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  },
),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
