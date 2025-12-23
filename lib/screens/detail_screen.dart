import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../providers/favorite_provider.dart';
import '../services/tmdb_service.dart';

class DetailScreen extends StatefulWidget {
  final Map movie;
  const DetailScreen({super.key, required this.movie});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final TMDBService _tmdb = TMDBService();

  YoutubePlayerController? _controller;
  bool _showTrailer = false;
  bool _loadingTrailer = false;

  // ======================
  // LOAD TRAILER
  // ======================
  Future<void> _loadTrailer() async {
    setState(() => _loadingTrailer = true);

    final key = await _tmdb.fetchTrailer(widget.movie['id']);

    if (key != null) {
      _controller = YoutubePlayerController(
        initialVideoId: key,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );
      setState(() => _showTrailer = true);
    }

    setState(() => _loadingTrailer = false);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fav = context.watch<FavoriteProvider>();

    final poster =
        'https://image.tmdb.org/t/p/w780${widget.movie['poster_path']}';

    final year =
        widget.movie['release_date']?.toString().split('-')[0] ?? '-';

    return Scaffold(
      // ======================
      // APP BAR
      // ======================
      appBar: AppBar(
        title: Text(
          widget.movie['title'],
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: Icon(
              fav.isFavorite(widget.movie['id'])
                  ? Icons.favorite
                  : Icons.favorite_border,
            ),
            onPressed: () {
              fav.toggleFavorite(
                Map<String, dynamic>.from(widget.movie),
              );
            },
          ),
        ],
      ),

      // ======================
      // BODY
      // ======================
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ======================
              // POSTER (FULL, NO CROP)
              // ======================
              Container(
                color: Colors.black,
                alignment: Alignment.center,
                child: AspectRatio(
                  aspectRatio: 2 / 3,
                  child: Image.network(
                    poster,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TITLE + YEAR
                    Text(
                      widget.movie['title'],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      year,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // RATING
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        const SizedBox(width: 6),
                        Text(
                          widget.movie['vote_average']
                              .toStringAsFixed(1),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // TRAILER
                    if (!_showTrailer)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.play_arrow),
                          label: _loadingTrailer
                              ? const Text('Loading...')
                              : const Text('Tonton Trailer'),
                          onPressed:
                              _loadingTrailer ? null : _loadTrailer,
                        ),
                      ),

                    if (_showTrailer && _controller != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: YoutubePlayer(
                          controller: _controller!,
                          showVideoProgressIndicator: true,
                        ),
                      ),

                    const SizedBox(height: 32),

                    // SINOPSIS
                    const Text(
                      'Sinopsis',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.movie['overview'],
                      textAlign: TextAlign.justify,
                      style: const TextStyle(height: 1.6),
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
