# Movie App

A Flutter-based mobile application that allows users to explore a wide selection of movies. The app features a grid view of movies, search functionality, a favorite system, a detailed movie view, dark/light mode toggle, and related movies on the detailed movie page.

## Features

- **Movie Grid View**: Display a grid of movies that users can scroll through, view movie posters, and click to get more information.
- **Search Functionality**: Users can search for movies by title or genre.
- **Favorites**: Users can mark movies as favorites, and the app will store these favorites using Hive for local storage.
- **Movie Detail View**: When a user clicks on a movie, they are directed to a detailed view that includes:
  - Movie description
  - Release date
  - Genre
  - Rating
  - Cast and crew information
- **Dark/Light Mode**: The app supports both dark and light themes. Users can toggle between the two for a personalized experience.
- **Related Movies**: On the movie detail page, users can view a list of related movies based on the selected movie’s genre, theme, or cast.

## Installation

1. Clone the repository:
    ```bash
    git clone <repository-url>
    cd movie-app
    ```

2. Install dependencies:
    ```bash
    flutter pub get
    ```

3. Run the app:
    ```bash
    flutter run
    ```

## Dependencies

- **Flutter**: The framework used to build the app.
- **Provider**: For state management (e.g., managing the user's favorite movies and theme).
- **Hive**: For storing favorite movies locally.
- **Dio**: For making HTTP requests to the movie API.
- **Shared Preferences**: For saving the user's theme preference (dark/light mode).

## File Structure


## How It Works

### Movie Grid View

The app fetches a list of movies using an API (e.g., TMDB API) and displays them in a grid view. Each movie is displayed with a poster image, title, and release date.

### Search Functionality

A search bar at the top of the grid view allows users to search for movies. The app will filter the movies based on the search query and update the grid view with matching results.

### Movie Detail Page

When a user clicks on a movie, they are redirected to the detail page where more detailed information about the movie is shown, including:

- Description
- Release date
- Genre
- Rating
- Cast

At the bottom of the page, related movies are shown based on the genre and theme of the selected movie.

### Dark/Light Mode

The app supports both dark and light modes, which can be toggled through the settings or a button in the app bar.

### Favorites

Users can mark movies as their favorites. These favorites are saved locally in Hive, and users can view them on a separate screen dedicated to favorites.

### Related Movies

On the movie detail page, related movies are fetched from the API based on the genre or actors in the movie, and displayed in a horizontal scrollable list.

## Usage

- Tap a movie in the grid view to view its details.
- Use the search bar to find specific movies.
- Toggle between dark and light modes by changing the settings.
- Mark movies as favorites by clicking the heart icon, and they will be saved in your favorites list.
- View related movies on the detail page.

## Screenshots

Include some images or GIFs of the app here to give a visual idea of the app’s layout and functionality.

## Contributing

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/your-feature`).
3. Commit your changes (`git commit -am 'Add your feature'`).
4. Push to the branch (`git push origin feature/your-feature`).
5. Open a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Feel free to reach out if you need any help or have any questions. Happy coding! 🚀
