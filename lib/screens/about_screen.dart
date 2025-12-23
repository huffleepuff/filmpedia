import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ======================
              // APP LOGO / TITLE
              // ======================
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary,
                            colorScheme.primary.withOpacity(0.6),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.4),
                            blurRadius: 30,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: const Icon(
                        Icons.movie_filter_rounded,
                        size: 64,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'FILMPEDIA',
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Luxury Movie Catalog App',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.hintColor),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // ======================
              // DARK MODE TOGGLE
              // ======================
              _card(
                context,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Dark Mode',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Switch(
                      value: themeProvider.isDark,
                      onChanged: (_) {
                        themeProvider.toggle();
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ======================
              // APP DESCRIPTION
              // ======================
              _card(
                context,
                title: 'About Application',
                content:
                    'Filmpedia adalah aplikasi katalog film modern yang dirancang '
                    'untuk memberikan pengalaman eksplorasi film secara elegan, '
                    'cepat, dan informatif. Aplikasi ini memanfaatkan TMDB API '
                    'sebagai sumber data utama serta Firebase untuk autentikasi '
                    'dan manajemen akun pengguna.',
              ),

              const SizedBox(height: 20),

              // ======================
              // FEATURES
              // ======================
              _card(
                context,
                title: 'Main Features',
                content:
                    '• Autentikasi pengguna (Login & Register)\n'
                    '• Katalog film dari TMDB API\n'
                    '• Detail film & trailer on-demand\n'
                    '• Manajemen favorit & profil\n'
                    '• Dark & Light Mode\n'
                    '• Firebase Authentication & Firestore',
              ),

              const SizedBox(height: 20),

              // ======================
              // DEVELOPER INFO
              // ======================
              _card(
                context,
                title: 'Developer',
                content:
                    'Nama   : Rizqi Akbar Hernawan\n'
                    'NPM    : 5231011016\n'
                    'Prodi  : Teknik Komputer\n\n'
                    'Aplikasi ini dikembangkan sebagai bagian dari proyek '
                    'akhir workshop Flutter dengan fokus pada integrasi '
                    'API, Firebase, dan desain antarmuka modern.',
              ),

              const SizedBox(height: 40),

              // ======================
              // FOOTER
              // ======================
              Center(
                child: Column(
                  children: [
                    Divider(color: theme.dividerColor),
                    const SizedBox(height: 12),
                    Text(
                      '© 2025 Filmpedia',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Built with Flutter & Firebase',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.hintColor),
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

  // ======================
  // REUSABLE CARD
  // ======================
  Widget _card(
    BuildContext context, {
    String? title,
    String? content,
    Widget? child,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              title,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          if (title != null && content != null)
            const SizedBox(height: 12),
          if (content != null)
            Text(
              content,
              textAlign: TextAlign.justify, // ✅ RATA KANAN–KIRI
              style: theme.textTheme.bodyMedium
                  ?.copyWith(height: 1.6),
            ),
          if (child != null) child,
        ],
      ),
    );
  }
}
