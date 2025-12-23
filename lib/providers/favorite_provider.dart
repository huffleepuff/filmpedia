import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<Map<String, dynamic>> _favorites = [];
  List<Map<String, dynamic>> get favorites => _favorites;

  FavoriteProvider() {
    _listenAuth();
  }

  // ======================
  // LISTEN AUTH STATE
  // ======================
  void _listenAuth() {
    _auth.authStateChanges().listen((user) {
      _favorites.clear();

      if (user != null) {
        _loadFavorites(user.uid);
      }

      notifyListeners();
    });
  }

  // ======================
  // LOAD FAVORITES FROM FIREBASE
  // ======================
  Future<void> _loadFavorites(String uid) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .get();

    _favorites
      ..clear()
      ..addAll(
        snapshot.docs.map(
          (d) => Map<String, dynamic>.from(d.data()),
        ),
      );

    notifyListeners();
  }

  // ======================
  // CHECK FAVORITE
  // ======================
  bool isFavorite(int id) {
    return _favorites.any((m) => m['id'] == id);
  }

  // ======================
  // TOGGLE FAVORITE (LOCAL + FIREBASE)
  // ======================
  Future<void> toggleFavorite(Map<String, dynamic> movie) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final ref = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(movie['id'].toString());

    if (isFavorite(movie['id'])) {
      // REMOVE
      _favorites.removeWhere((m) => m['id'] == movie['id']);
      await ref.delete();
    } else {
      // ADD
      _favorites.add(movie);
      await ref.set(movie);
    }

    notifyListeners();
  }
}
