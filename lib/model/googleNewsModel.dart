class GoogleNewsModel {
  final String title;
  final String snippet;
  final String publisher;
  // final int? timestamp;
  final String? newsUrl;
  final Images? images;
  // final bool? hasSubnews;
  // final List<Subnews>? subnews;

  GoogleNewsModel({
    required this.title,
    required this.snippet,
    required this.publisher,
    // this.timestamp,
    this.newsUrl,
    this.images,
    // this.hasSubnews,
    // this.subnews,
  });

  factory GoogleNewsModel.fromJson(Map<String, dynamic> json) {
    return GoogleNewsModel(
      title: json['title'],
      snippet: json['snippet'] ?? '',
      publisher: json['publisher'],
      // timestamp: json['timestamp'] != null ? json['timestamp'] : null,
      newsUrl: json['newsUrl'],
      images: json['images'] != null ? Images.fromJson(json['images']) : null,
      // hasSubnews: json['hasSubnews'],
      // subnews: json['subnews'] != null
      //     ? (json['subnews'] as List)
      //         .map((subnewsJson) => Subnews.fromJson(subnewsJson))
      //         .toList()
      //     : null,
    );
  }
}

class Images {
  final String thumbnail;
  final String thumbnailProxied;

  Images({
    required this.thumbnail,
    required this.thumbnailProxied,
  });

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      thumbnail: json['thumbnail'],
      thumbnailProxied: json['thumbnailProxied'],
    );
  }
}

class Subnews {
  final String title;
  final String snippet;
  final String publisher;
  final int timestamp;
  final String newsUrl;
  final Images images;

  Subnews({
    required this.title,
    required this.snippet,
    required this.publisher,
    required this.timestamp,
    required this.newsUrl,
    required this.images,
  });

  factory Subnews.fromJson(Map<String, dynamic> json) {
    return Subnews(
      title: json['title'],
      snippet: json['snippet'],
      publisher: json['publisher'],
      timestamp: json['timestamp'],
      newsUrl: json['newsUrl'],
      images: Images.fromJson(json['images']),
    );
  }
}
