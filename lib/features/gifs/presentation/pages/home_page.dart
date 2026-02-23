import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:giphy_gif_search/core/network/conectivity_provider.dart';
import '../controllers/gifs_controller.dart';
import '../widgets/gifs_grid.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final TextEditingController _controller;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final pos = _scrollController.position;
    if (pos.maxScrollExtent <= 0) return;

    const threshold = 200.0;
    final nearBottom = pos.pixels >= pos.maxScrollExtent - threshold;

    if (nearBottom) {
      ref.read(gifsControllerProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gifsControllerProvider);
    final notifier = ref.read(gifsControllerProvider.notifier);

    if (_controller.text != state.query) {
      _controller.value = _controller.value.copyWith(
        text: state.query,
        selection: TextSelection.collapsed(offset: state.query.length),
        composing: TextRange.empty,
      );
    }

    final connectivity = ref.watch(connectivityProvider);
    final hasInternet = connectivity.maybeWhen(
      data: (result) => result != ConnectivityResult.none,
      orElse: () => true,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giphy GIF Search'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => context.pushNamed('favorites'),
            tooltip: 'Favorites',
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF9C27B0), Color(0xFFE040FB)],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              onChanged: notifier.onQueryChanged,
              decoration: InputDecoration(
                hintText: 'Search cute gifs...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: state.query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _controller.clear();
                          notifier.setQuery('');
                        },
                        tooltip: 'Clear',
                      ),
              ),
            ),
          ),

          if (!hasInternet)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE0E0),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFFFB3B3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.wifi_off, color: Colors.red),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'No internet connection',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),

          if (state.isLoading) const LinearProgressIndicator(),

          if (state.error != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      state.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  TextButton(
                    onPressed: notifier.retry,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),

          Expanded(
            child: GifsGrid(
              scrollController: _scrollController,
              items: state.items,
              isLoadingMore: state.isLoadingMore,
            ),
          ),
        ],
      ),
    );
  }
}
