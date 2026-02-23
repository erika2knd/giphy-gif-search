import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/gif_model.dart';
import '../controllers/gifs_controller.dart';

class GifGridItem extends ConsumerWidget {
  final GifModel gif;
  const GifGridItem({super.key, required this.gif});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(gifsControllerProvider.notifier);

    final isFav = ref.watch(
      gifsControllerProvider.select((s) => s.favoritesById.containsKey(gif.id)),
    );

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.pushNamed('details', extra: gif),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: gif.id,
                  child: CachedNetworkImage(
                    imageUrl: gif.previewUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Center(child: Icon(Icons.broken_image)),
                  ),
                ),

                Positioned(
                  top: 6,
                  right: 6,
                  child: Material(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: const CircleBorder(),
                    child: IconButton(
                      iconSize: 20,
                      tooltip: isFav
                          ? 'Remove from favorites'
                          : 'Add to favorites',
                      onPressed: () => notifier.toggleFavorite(gif),
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav
                            ? const Color(0xFFE91E63)
                            : Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
