import 'package:go_router/go_router.dart';
import '../features/gifs/presentation/pages/home_page.dart';
import '../features/gifs/presentation/pages/favorites_page.dart';
import '../features/gifs/presentation/pages/gif_details_page.dart';
import '../features/gifs/data/models/gif_model.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'favorites',
          builder: (context, state) => const FavoritesPage(),
        ),
        GoRoute(
          path: 'details',
          builder: (context, state) {
            final gif = state.extra as GifModel;
            return GifDetailsPage(gif: gif);
          },
        ),
      ],
    ),
  ],
);
