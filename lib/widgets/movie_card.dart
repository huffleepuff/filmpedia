import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorite_provider.dart';

class MovieCard extends StatelessWidget {
  final Map movie;
  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final fav = context.watch<FavoriteProvider>();

    final posterPath =
        movie['backdrop_path'] ?? movie['poster_path'];
    final poster = posterPath != null
        ? 'https://image.tmdb.org/t/p/w780$posterPath'
        : null;

    // ======================
    // YEAR EXTRACTION (AMAN)
    // ======================
    final year =
        movie['release_date']?.toString().split('-')[0] ?? '-';

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/detail',
          arguments: movie,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black12,
          image: poster != null
              ? DecorationImage(
                  image: NetworkImage(poster),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // ======================
              // GRADIENT OVERLAY
              // ======================
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black87,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              // ======================
              // FAVORITE ICON
              // ======================
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () {
                    fav.toggleFavorite(
  Map<String, dynamic>.from(movie),
);

                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.black54,
                    child: Icon(
                      fav.isFavorite(movie['id'])
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.redAccent,
                      size: 18,
                    ),
                  ),
                ),
              ),

              // ======================
              // MOVIE INFO
              // ======================
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie['title'] ?? '-',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        // YEAR
                        Text(
                          year,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // RATING
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          movie['vote_average'] != null
                              ? movie['vote_average']
                                  .toStringAsFixed(1)
                              : '-',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
