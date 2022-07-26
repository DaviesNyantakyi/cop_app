import 'dart:convert';

class PodcastInfoModel {
  final String id;
  final String rss;
  final String pageLink;
  final String title;

  PodcastInfoModel({
    required this.id,
    required this.rss,
    required this.pageLink,
    required this.title,
  });

  PodcastInfoModel copyWith({
    String? id,
    String? rss,
    String? pageLink,
    String? title,
  }) {
    return PodcastInfoModel(
      id: id ?? this.id,
      rss: rss ?? this.rss,
      pageLink: pageLink ?? this.pageLink,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'rss': rss,
      'pageLink': pageLink,
      'title': title,
    };
  }

  factory PodcastInfoModel.fromMap({required Map<String, dynamic> map}) {
    return PodcastInfoModel(
      id: map['id'] as String,
      rss: map['rss'] as String,
      pageLink: map['pageLink'] as String,
      title: map['title'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PodcastInfoModel.fromJson(String source) => PodcastInfoModel.fromMap(
        map: json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() {
    return 'PodcastInfoModel(id: $id, rss: $rss, pageLink: $pageLink, title: $title)';
  }

  @override
  bool operator ==(covariant PodcastInfoModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.rss == rss &&
        other.pageLink == pageLink &&
        other.title == title;
  }

  @override
  int get hashCode {
    return id.hashCode ^ rss.hashCode ^ pageLink.hashCode ^ title.hashCode;
  }
}
