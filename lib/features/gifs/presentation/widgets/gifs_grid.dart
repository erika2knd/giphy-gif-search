import 'package:flutter/material.dart';
import '../../data/models/gif_model.dart';
import 'gif_grid_item.dart';

class GifsGrid extends StatelessWidget {
  final ScrollController scrollController;
  final List<GifModel> items;
  final bool isLoadingMore;

  const GifsGrid({
    super.key,
    required this.scrollController,
    required this.items,
    required this.isLoadingMore,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text("No results"));
    }

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final crossAxisCount = isLandscape ? 4 : 2;

    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: items.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= items.length) {
          return const Center(child: CircularProgressIndicator());
        }
        return GifGridItem(gif: items[index]);
      },
    );
  }
}
