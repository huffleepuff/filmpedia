import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../services/tmdb_service.dart';
import '../widgets/movie_card.dart';

enum MovieCategory {
  popular,
  topRated,
  upcoming,
  nowPlaying,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final TMDBService _tmdb = TMDBService();

  List movies = [];
  List genres = [];

  bool loading = true;
  bool loadingMore = false;
  bool searching = false;
  bool hasMore = true;
  bool showScrollTop = false;

  int page = 1;
  MovieCategory category = MovieCategory.popular;
  int? selectedGenreId;

  @override
  void initState() {
    super.initState();
    _init();

    _scrollCtrl.addListener(() {
      // Infinite scroll
      if (_scrollCtrl.position.pixels >=
              _scrollCtrl.position.maxScrollExtent - 300 &&
          !loadingMore &&
          hasMore &&
          !searching) {
        _loadMoreMovies();
      }

      // Scroll-to-top FAB
      if (_scrollCtrl.offset > 600 && !showScrollTop) {
        setState(() => showScrollTop = true);
      } else if (_scrollCtrl.offset <= 600 && showScrollTop) {
        setState(() => showScrollTop = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    await _loadGenres();
    await _loadMovies(reset: true);
  }

  // ======================
  // LOAD GENRES
  // ======================
  Future<void> _loadGenres() async {
    try {
      genres = await _tmdb.fetchGenres();
    } catch (_) {
      genres = [];
    }
  }

  // ======================
  // LOAD MOVIES
  // ======================
  Future<void> _loadMovies({bool reset = false}) async {
    if (reset) {
      page = 1;
      hasMore = true;
      movies.clear();
    }

    setState(() {
      loading = true;
      searching = false;
    });

    try {
      final result = await _fetchByCategory(page);
      movies = result;
      hasMore = result.isNotEmpty;
    } catch (_) {
      movies = [];
    }

    setState(() => loading = false);
  }

  // ======================
  // LOAD MORE (INFINITE)
  // ======================
  Future<void> _loadMoreMovies() async {
    if (!hasMore) return;

    setState(() => loadingMore = true);
    page++;

    try {
      final result = await _fetchByCategory(page);
      if (result.isEmpty) {
        hasMore = false;
      } else {
        movies.addAll(result);
      }
    } catch (_) {}

    setState(() => loadingMore = false);
  }

  // ======================
  // 🔥 FETCH BY CATEGORY (BENAR SESUAI TMDB)
  // ======================
  Future<List> _fetchByCategory(int page) {
    switch (category) {
      case MovieCategory.upcoming:
        return _tmdb.fetchUpcomingMovies(page: page);

      case MovieCategory.nowPlaying:
        return _tmdb.fetchNowPlayingMovies(page: page);

      case MovieCategory.topRated:
        return _tmdb.fetchDiscoverMovies(
          sortBy: 'vote_average.desc',
          genreId: selectedGenreId,
          page: page,
        );

      default:
        return _tmdb.fetchDiscoverMovies(
          sortBy: 'popularity.desc',
          genreId: selectedGenreId,
          page: page,
        );
    }
  }

  // ======================
  // SEARCH
  // ======================
  Future<void> _searchMovies(String query) async {
    if (query.isEmpty) {
      _loadMovies(reset: true);
      return;
    }

    setState(() {
      loading = true;
      searching = true;
    });

    try {
      movies = await _tmdb.searchMovies(query);
    } catch (_) {
      movies = [];
    }

    setState(() => loading = false);
  }

  // ======================
  // SHIMMER
  // ======================
  Widget _shimmerCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.shade900,
      ),
    );
  }

  // ======================
  // UI
  // ======================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FILMPEDIA'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => Navigator.pushNamed(context, '/about'),
          ),
        ],
      ),

      floatingActionButton: showScrollTop
          ? FloatingActionButton(
              onPressed: () {
                _scrollCtrl.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                );
              },
              child: const Icon(Icons.arrow_upward),
            )
          : null,

      body: SafeArea(
        child: Column(
          children: [
            // SEARCH
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: TextField(
                controller: _searchCtrl,
                onChanged: _searchMovies,
                decoration: const InputDecoration(
                  hintText: 'Search movie...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),

            // FILTER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<MovieCategory>(
                      initialValue: category,
                      decoration:
                          const InputDecoration(labelText: 'Sort'),
                      items: const [
                        DropdownMenuItem(
                            value: MovieCategory.popular,
                            child: Text('Popular')),
                        DropdownMenuItem(
                            value: MovieCategory.topRated,
                            child: Text('Top Rated')),
                        DropdownMenuItem(
                            value: MovieCategory.upcoming,
                            child: Text('Upcoming')),
                        DropdownMenuItem(
                            value: MovieCategory.nowPlaying,
                            child: Text('Now Playing')),
                      ],
                      onChanged: (val) {
                        if (val == null) return;

                        setState(() {
                          category = val;

                          // Genre tidak berlaku untuk Upcoming / Now Playing
                          if (val == MovieCategory.upcoming ||
                              val == MovieCategory.nowPlaying) {
                            selectedGenreId = null;
                          }
                        });

                        _loadMovies(reset: true);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      initialValue: selectedGenreId,
                      decoration:
                          const InputDecoration(labelText: 'Genre'),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('All'),
                        ),
                        ...genres.map(
                          (g) => DropdownMenuItem(
                            value: g['id'],
                            child: Text(g['name']),
                          ),
                        ),
                      ],
                      onChanged: (val) {
                        setState(() => selectedGenreId = val);
                        _loadMovies(reset: true);
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // LIST
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _loadMovies(reset: true),
                child: loading
                    ? ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: 6,
                        itemBuilder: (_, __) => Shimmer.fromColors(
                          baseColor: Colors.grey.shade900,
                          highlightColor: Colors.grey.shade700,
                          child: _shimmerCard(),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollCtrl,
                        padding: const EdgeInsets.all(20),
                        itemCount:
                            movies.length + (loadingMore ? 1 : 0),
                        itemBuilder: (_, i) {
                          if (i < movies.length) {
                            return MovieCard(movie: movies[i]);
                          }
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
