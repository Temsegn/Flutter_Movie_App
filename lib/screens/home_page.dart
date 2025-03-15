import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider.dart';
import'favorite_page.dart';
import 'movie_detail.dart';class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController _scrollController = ScrollController();
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    // Fetch the first page of movies
    Provider.of<MovieProvider>(context, listen: false).fetchMovies(page: 1);

    // Listen to scroll position to load more movies when reaching the bottom
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge &&
          _scrollController.position.pixels != 0) {
        // Load more when at the bottom
        Provider.of<MovieProvider>(context, listen: false)
            .fetchMovies(page: Provider.of<MovieProvider>(context, listen: false).currentPage + 1);
      }
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final movies = Provider.of<MovieProvider>(context).movies;
    final favoriteMovies = Provider.of<MovieProvider>(context).favoriteMovies;

    return Scaffold(
      appBar: AppBar(
        title: Text("Movies App"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                _searchController.clear();
                _searchQuery = "";
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_isSearching)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => _onSearchChanged(value),
                  decoration: InputDecoration(
                    labelText: 'Search movies...',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            Expanded(
              child: GridView.builder(
                controller: _scrollController,
                padding: EdgeInsets.only(top: 10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2 / 3,
                ),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  if (_searchQuery.isNotEmpty &&
                      !movie.title.toLowerCase().contains(_searchQuery.toLowerCase())) {
                    return SizedBox.shrink();
                  }
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailScreen(movie: movie),
                        ),
                      );
                    },
                    child: GridTile(
                      child: Image.network(movie.imageUrl, fit: BoxFit.cover),
                      footer: GridTileBar(
                        backgroundColor: Colors.black54,
                        title: Text(movie.title, textAlign: TextAlign.center),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: Provider.of<MovieProvider>(context).isFavorite(movie.id)
                                ? Colors.red
                                : Colors.white,
                          ),
                          onPressed: () {
                            Provider.of<MovieProvider>(context, listen: false)
                                .toggleFavorite(movie);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
