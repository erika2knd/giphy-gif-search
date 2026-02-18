import 'package:go_router/go_router.dart';
import 'package:giphy_gif_search/features/search/presentation/search_page.dart';

final appRouter = GoRouter(
  routes: [GoRoute(path: '/', builder: (context, state) => const SearchPage())],
);
