import 'dart:convert';

class PodcastInfoModel {
  final String id;
  final String rssFeed;
  final String pageURL;
  final String title;
  PodcastInfoModel({
    required this.id,
    required this.rssFeed,
    required this.pageURL,
    required this.title,
  });

  PodcastInfoModel copyWith({
    String? id,
    String? rssFeed,
    String? pageURL,
    String? title,
  }) {
    return PodcastInfoModel(
      id: id ?? this.id,
      rssFeed: rssFeed ?? this.rssFeed,
      pageURL: pageURL ?? this.pageURL,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'rssFeed': rssFeed,
      'pageURL': pageURL,
      'title': title,
    };
  }

  factory PodcastInfoModel.fromMap({required Map<String, dynamic> map}) {
    return PodcastInfoModel(
      id: map['id'],
      rssFeed: map['rssFeed'],
      pageURL: map['pageURL'],
      title: map['title'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PodcastInfoModel.fromJson({required String source}) =>
      PodcastInfoModel.fromMap(map: json.decode(source));

  @override
  String toString() {
    return 'PodcastRssInfo(id: $id, rssFeed: $rssFeed, pageURL: $pageURL, title: $title)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PodcastInfoModel &&
        other.id == id &&
        other.rssFeed == rssFeed &&
        other.pageURL == pageURL &&
        other.title == title;
  }

  @override
  int get hashCode {
    return id.hashCode ^ rssFeed.hashCode ^ pageURL.hashCode ^ title.hashCode;
  }
}
