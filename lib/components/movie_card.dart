import 'package:flutter/material.dart';



class MovieCard extends StatelessWidget {
  final dynamic movie;
 
  MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    List<dynamic> genres = movie['genre_ids'];

 
    return  Card(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Left: Movie Poster
                Container(
                  width: 150,
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

                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Text(
                            movie['release_date'] ?? 'Release Date: N/A',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),

                          // Favorite Icon
                          IconButton(
                            icon: Icon(
                                  Icons.favorite,
                               color:   Colors.red,
                            ),
                            onPressed: () {
                              
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
  }}