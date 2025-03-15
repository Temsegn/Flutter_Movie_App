import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoriteMovies = Provider.of<MovieProvider>(context).favoriteMovies;

    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
      ),
      body: favoriteMovies.isEmpty
          ? Center(child: Text("No favorite movies added yet."))
          : ListView.builder(
              itemCount: favoriteMovies.length,
              itemBuilder: (context, index) {
                final movie = favoriteMovies[index];
                return ListTile(
                  leading: Image.network(movie.imageUrl, width: 50, height: 75, fit: BoxFit.cover),
                  title: Text(movie.title),
                  subtitle: Text(movie.date),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      Provider.of<MovieProvider>(context, listen: false)
                          .toggleFavorite(movie);
                    },
                  ),
                );
              },
            ),
    );
  }
}
