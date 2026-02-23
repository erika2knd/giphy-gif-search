class GifModel {
  final String id;
  final String title;
  final String username;
  final String previewUrl;
  final String originalUrl;

  const GifModel({
    required this.id,
    required this.title,
    required this.username,
    required this.previewUrl,
    required this.originalUrl,
  });

  factory GifModel.fromJson(Map<String, dynamic> json) {
    final images = (json['images'] as Map?)?.cast<String, dynamic>() ?? {};

    final fixed =
        (images['fixed_height'] as Map?)?.cast<String, dynamic>() ?? {};
    final downsized =
        (images['downsized'] as Map?)?.cast<String, dynamic>() ?? {};
    final original =
        (images['original'] as Map?)?.cast<String, dynamic>() ?? {};

    final preview = (fixed['url'] ?? downsized['url'] ?? original['url'] ?? '')
        .toString();

    final originalUrl = (original['url'] ?? downsized['url'] ?? preview)
        .toString();

    final username = (json['username'] ?? '').toString();

    return GifModel(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      username: username.isEmpty ? 'Unknown' : username,
      previewUrl: preview,
      originalUrl: originalUrl,
    );
  }

  Map<String, dynamic> toFavoriteJson() => {
    'id': id,
    'title': title,
    'username': username,
    'url': previewUrl,
  };

  factory GifModel.fromFavoriteJson(Map<String, dynamic> json) {
    final url = (json['url'] ?? '').toString();

    return GifModel(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      username: (json['username'] ?? 'Unknown').toString(),
      previewUrl: url,
      originalUrl: url,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GifModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
