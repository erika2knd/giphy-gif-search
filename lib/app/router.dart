import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:giphy_gif_search/features/gifs/data/models/gif_model.dart';
import 'package:giphy_gif_search/features/gifs/presentation/pages/favorites_page.dart';
import 'package:giphy_gif_search/features/gifs/presentation/pages/gif_details_page.dart';
import 'package:giphy_gif_search/features/gifs/presentation/pages/home_page.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          name: 'favorites',
          path: 'favorites',
          builder: (context, state) => const FavoritesPage(),
        ),
        GoRoute(
          name: 'details',
          path: 'details',
          builder: (context, state) {
            final extra = state.extra;

            if (extra is! GifModel) {
              return const _InvalidRoutePage(
                title: 'Invalid navigation',
                message: 'No GIF data was provided for the details screen.',
              );
            }

            return GifDetailsPage(gif: extra);
          },
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => _InvalidRoutePage(
    title: 'Page not found',
    message: state.error?.toString() ?? 'Unknown routing error',
  ),
);

class _InvalidRoutePage extends StatelessWidget {
  final String title;
  final String message;

  const _InvalidRoutePage({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(child: Text(message, textAlign: TextAlign.center)),
      ),
    );
  }
}
