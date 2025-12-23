import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorite_provider.dart';
import '../widgets/movie_card.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fav = context.watch<FavoriteProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: fav.favorites.isEmpty
            ? const Center(
                child: Text(
                  'Belum ada film favorit.',
                  style: TextStyle(color: Colors.white70),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: fav.favorites.length,
                itemBuilder: (context, index) {
                  return MovieCard(movie: fav.favorites[index]);
                },
              ),
      ),
    );
  }
}
