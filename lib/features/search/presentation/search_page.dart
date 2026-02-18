import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giphy GIF Search')),
      body: const Center(child: Text('Search screen (next step)')),
    );
  }
}
