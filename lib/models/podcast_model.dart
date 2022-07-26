// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import 'package:cop_belgium_app/models/episode_model.dart';

part 'podcast_model.g.dart';

@HiveType(typeId: 0)
class PodcastModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String? image;
  @HiveField(2)
  final String? title;
  @HiveField(3)
  final String? description;
  @HiveField(4)
  final String? author;
  @HiveField(5)
  final String? pageLink;
  @HiveField(6)
  final String? rss;
  @HiveField(7)
  List<EpisodeModel>? episodes;

  PodcastModel({
    required this.id,
    this.image,
    this.title,
    this.description,
    this.author,
    this.pageLink,
    this.rss,
    this.episodes,
  });

  PodcastModel copyWith({
    String? id,
    String? image,
    String? title,
    String? description,
    String? author,
    String? pageLink,
    String? rss,
    List<EpisodeModel>? episodes,
  }) {
    return PodcastModel(
      id: id ?? this.id,
      image: image ?? this.image,
      title: title ?? this.title,
      description: description ?? this.description,
      author: author ?? this.author,
      pageLink: pageLink ?? this.pageLink,
      rss: rss ?? this.rss,
      episodes: episodes ?? this.episodes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'image': image,
      'title': title,
      'description': description,
      'author': author,
      'pageLink': pageLink,
      'rss': rss,
      'episodes': episodes,
    };
  }

  factory PodcastModel.fromMap({required Map<String, dynamic> map}) {
    return PodcastModel(
      id: map['id'] as String,
      image: map['image'],
      title: map['title'],
      description: map['description'],
      author: map['author'],
      pageLink: map['pageLink'],
      rss: map['rss'],
      episodes: map['episodes'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PodcastModel.fromJson(String source) => PodcastModel.fromMap(
        map: json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() {
    return 'PodcastModel(id: $id, image: $image, title: $title, description: $description, author: $author, pageLink: $pageLink, rss: $rss, episodes: $episodes)';
  }

  @override
  bool operator ==(covariant PodcastModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.image == image &&
        other.title == title &&
        other.description == description &&
        other.author == author &&
        other.pageLink == pageLink &&
        other.rss == rss &&
        listEquals(other.episodes, episodes);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        image.hashCode ^
        title.hashCode ^
        description.hashCode ^
        author.hashCode ^
        pageLink.hashCode ^
        rss.hashCode ^
        episodes.hashCode;
  }
}
