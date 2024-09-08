class GoogleNewsModel {
  final String title;
  final String snippet;
  final String publisher;
  final int? timestamp;
  final String? newsUrl;
  final Images? images;
  final bool? hasSubnews;
  final List<Subnews>? subnews;
  bool? isFavorite;

  GoogleNewsModel({
    required this.title,
    required this.snippet,
    required this.publisher,
    this.timestamp,
    this.newsUrl,
    this.images,
    this.hasSubnews,
    this.subnews,
    this.isFavorite = false,
  });

  factory GoogleNewsModel.fromJson(Map<String, dynamic> json) {
    return GoogleNewsModel(
      title: json['title'],
      snippet: json['snippet'] ?? '',
      publisher: json['publisher'],
      timestamp: json['timestamp'] != null
          ? int.tryParse(json['timestamp'].toString())
          : null,
      newsUrl: json['newsUrl'],
      images: json['images'] != null ? Images.fromJson(json['images']) : null,
      hasSubnews: json['hasSubnews'],
      subnews: json['subnews'] != null
          ? (json['subnews'] as List)
              .map((subnewsJson) => Subnews.fromJson(subnewsJson))
              .toList()
          : null,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'snippet': snippet,
      'publisher': publisher,
      'timestamp': timestamp,
      'newsUrl': newsUrl,
      'images': images?.toJson(),
      'hasSubnews': hasSubnews,
      'subnews': subnews?.map((subnews) => subnews.toJson()).toList(),
      'isFavorite': isFavorite,
    };
  }
}

class Images {
  final String thumbnail;

  Images({required this.thumbnail});

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      thumbnail: json['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'thumbnail': thumbnail,
    };
  }
}

class Subnews {
  final String title;
  final String snippet;

  Subnews({required this.title, required this.snippet});

  factory Subnews.fromJson(Map<String, dynamic> json) {
    return Subnews(
      title: json['title'],
      snippet: json['snippet'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'snippet': snippet,
    };
  }
}
