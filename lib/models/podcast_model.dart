// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';

import 'package:cop_belgium_app/models/episodes_model.dart';

class PodcastModel {
  final String id;
  final String imageURL;
  final String pageURL;
  final String title;
  final String description;
  final String author;
  final List<EpisodeModel>? episodes;

  PodcastModel({
    required this.id,
    required this.imageURL,
    required this.pageURL,
    required this.title,
    required this.description,
    required this.author,
    required this.episodes,
  });

  @override
  String toString() {
    return 'PodcastModel(id: $id, imageURL: $imageURL, pageURL: $pageURL, title: $title, description: $description, author: $author, episodes: $episodes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PodcastModel &&
        other.id == id &&
        other.imageURL == imageURL &&
        other.pageURL == pageURL &&
        other.title == title &&
        other.description == description &&
        other.author == author &&
        listEquals(other.episodes, episodes);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        imageURL.hashCode ^
        pageURL.hashCode ^
        title.hashCode ^
        description.hashCode ^
        author.hashCode ^
        episodes.hashCode;
  }

  PodcastModel copyWith({
    String? id,
    String? imageURL,
    String? pageURL,
    String? title,
    String? description,
    String? author,
    List<EpisodeModel>? episodes,
  }) {
    return PodcastModel(
      id: id ?? this.id,
      imageURL: imageURL ?? this.imageURL,
      pageURL: pageURL ?? this.pageURL,
      title: title ?? this.title,
      description: description ?? this.description,
      author: author ?? this.author,
      episodes: episodes ?? this.episodes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'imageURL': imageURL,
      'pageURL': pageURL,
      'title': title,
      'description': description,
      'author': author,
      'episodes': episodes,
    };
  }

  factory PodcastModel.fromMap(Map<String, dynamic> map) {
    return PodcastModel(
      id: map['id'],
      imageURL: map['imageURL'],
      pageURL: map['pageURL'],
      title: map['title'],
      description: map['description'],
      author: map['author'],
      episodes: map['episodes'],
    );
  }
}



//  Podcast createPodcast({required RssFeed rssFeed}) {
//     // creates a podcast using the rss info and also adds all the episodes

//     List<Episode> episodes = rssFeed.items!.map((rssItem) {
//       return Episode(
//         title: rssItem.itunes?.title ?? rssItem.title ?? '',
//         author:
//             rssItem.itunes?.author ?? rssItem.author ?? rssFeed.author ?? '',
//         image: rssFeed.itunes?.image?.href ?? rssFeed.image?.url ?? '',
//         duration: rssItem.itunes?.duration?.inMilliseconds ?? 0,
//         date: rssItem.pubDate ?? DateTime.now(),
//         audio: rssItem.enclosure?.url ?? '',
//         description: RssHelper.getDescription(item: rssItem), // remove p tag
//       );
//     }).toList();

//     return Podcast(
//       pageLink: rssFeed.link ?? '',
//       imageUrl: rssFeed.image?.url ?? rssFeed.itunes?.image?.href ?? ' ',
//       title: rssFeed.itunes?.title ?? rssFeed.title ?? ' ',
//       description: rssFeed.description ?? rssFeed.itunes?.summary ?? '',
//       author: rssFeed.itunes?.author ?? rssFeed.author ?? '',
//       episodes: episodes,
//       totalEpisodes: rssFeed.items?.length ?? 0,
//     );
//   }