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
    final original =
        (images['original'] as Map?)?.cast<String, dynamic>() ?? {};

    return GifModel(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      username: (json['username'] ?? '').toString(),
      previewUrl: (fixed['url'] ?? '').toString(),
      originalUrl: (original['url'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toFavoriteJson() => {
    'id': id,
    'title': title,
    'username': username,
    'url': previewUrl,
  };

  factory GifModel.fromFavoriteJson(Map<String, dynamic> json) {
    return GifModel(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      username: (json['username'] ?? '').toString(),
      previewUrl: (json['url'] ?? '').toString(),
      originalUrl: (json['url'] ?? '').toString(),
    );
  }
}
