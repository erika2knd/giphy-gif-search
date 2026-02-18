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
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      ref.read(gifsControllerProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gifsControllerProvider);
    final notifier = ref.read(gifsControllerProvider.notifier);

    final connectivity = ref.watch(connectivityProvider);
    final hasInternet = connectivity.maybeWhen(
      data: (result) => result != ConnectivityResult.none,
      orElse: () => true,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Giphy GIF Search"),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => context.push('/favorites'),
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
              onChanged: notifier.onQueryChanged, // debounce в контроллере
              decoration: const InputDecoration(
                hintText: "Search cute gifs...",
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          // Network availability banner (bonus)
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
                    child: const Text("Retry"),
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
