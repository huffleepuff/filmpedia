# FILMPEDIA

FILMPEDIA is a Flutter-based mobile application designed as a digital movie catalog.  
The application integrates data from The Movie Database (TMDB) API to display movie information dynamically.

This project is developed as part of an academic assignment and focuses on structured application architecture, API integration, and user authentication.

---

## Features

- User authentication using Firebase Authentication
- Movie listing from TMDB API
- Movie categories (Popular, Top Rated, Upcoming, Now Playing)
- Search and filtering functionality
- Favorite movie management per user
- Movie detail page with trailer support
- User profile management

---

## Tech Stack

- Flutter
- Dart
- Firebase Authentication
- Firebase Firestore
- TMDB API
- Provider (State Management)

---

## Project Purpose

This project aims to:
- Implement REST API integration in a Flutter application
- Apply state management using Provider
- Practice Firebase-based authentication and data storage
- Build a structured and maintainable mobile application

---

## Project Structure 

lib/
├── core/
│ ├── constants.dart
│ └── theme.dart
├── providers/
│ ├── favorite_provider.dart
│ └── theme_provider.dart
├── services/
│ ├── auth_service.dart
│ └── tmdb_service.dart
├── screens/
│ ├── about_screen.dart
│ ├── detail_screen.dart
│ ├── favorite_screen.dart
│ ├── home_screen.dart
│ ├── login_screen.dart
│ ├── main_screen.dart
│ ├── profile_screen.dart
│ ├── register_screen.dart
│ └── user_settings_screen.dart
├── widgets/
│ └── movie_card.dart
└── main.dart

---

## How to Run

1. Ensure Flutter is installed
2. Clone the repository
   ```bash
   git clone https://github.com/huffleepuff/filmpedia.git
Navigate to the project directory

bash
Copy code
cd filmpedia
Install dependencies

bash
Copy code
flutter pub get
Run the application

bash
Copy code
flutter run
## Notes
- TMDB API key is used for learning purposes
- Firebase rules are applied to restrict user-specific data access
- This project is intended for academic and educational use

## Developer
**Name:** Rizqi Akbar Hernawan  
**Field of Study:** Computer Engineering  
**Platform:** Flutter (Android)


## License
- This project is developed for academic and learning purposes only.
- Not intended for commercial use.
