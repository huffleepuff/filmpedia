import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'core/theme.dart';

// ======================
// SCREENS
// ======================
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/main_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/about_screen.dart';
import 'screens/user_settings_screen.dart';

// ======================
// PROVIDERS
// ======================
import 'providers/favorite_provider.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AppRoot());
}

/// ======================
/// ROOT APP
/// ======================
class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    );
  }
}

/// ======================
/// MAIN APP
/// ======================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // ======================
      // THEME
      // ======================
      theme: theme.isDark ? AppTheme.dark : AppTheme.light,

      // ======================
      // AUTH GATE (AUTO LOGIN)
      // ======================
      home: const AuthGate(),

      // ======================
      // STATIC ROUTES
      // ======================
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/main': (_) => const MainScreen(),
        '/about': (_) => const AboutScreen(),
        '/user-settings': (_) => const UserSettingsScreen(),
      },

      // ======================
      // DYNAMIC ROUTE (DETAIL)
      // ======================
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final movie = settings.arguments as Map;
          return MaterialPageRoute(
            builder: (_) => DetailScreen(movie: movie),
          );
        }
        return null;
      },
    );
  }
}

/// ======================
/// AUTH GATE
/// ======================
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // LOADING
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // USER LOGIN
        if (snapshot.hasData) {
          return const MainScreen();
        }

        // USER LOGOUT
        return const LoginScreen();
      },
    );
  }
}
