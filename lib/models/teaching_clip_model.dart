// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

// Map<String, dynamic> speaker = {
//   'speaker': 'Levi Lusko',
//   'imageURL': 'https',
//   'about': 'founder of school',
//   'pageURL': ''
// };

class TeachingClipModel {
  String? id;
  String? title;
  String? videoURL;
  String? description;
  Map<String, dynamic>? speaker;
  TeachingClipModel({
    this.id,
    this.title,
    this.videoURL,
    this.description,
    this.speaker,
  });

  TeachingClipModel copyWith({
    String? id,
    String? title,
    String? videoURL,
    String? description,
    Map<String, dynamic>? speaker,
  }) {
    return TeachingClipModel(
      id: id ?? this.id,
      title: title ?? this.title,
      videoURL: videoURL ?? this.videoURL,
      description: description ?? this.description,
      speaker: speaker ?? this.speaker,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'videoURL': videoURL,
      'description': description,
      'speaker': speaker,
    };
  }

  factory TeachingClipModel.fromMap({required Map<String, dynamic> map}) {
    return TeachingClipModel(
      id: map['id'],
      title: map['title'],
      videoURL: map['videoURL'],
      description: map['description'],
      speaker: map['speaker'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TeachingClipModel.fromJson(String source) =>
      TeachingClipModel.fromMap(
        map: json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() {
    return 'TeachingClipModel(id: $id, title: $title, videoURL: $videoURL, description: $description, speaker: $speaker)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TeachingClipModel &&
        other.id == id &&
        other.title == title &&
        other.videoURL == videoURL &&
        other.description == description &&
        mapEquals(other.speaker, speaker);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        videoURL.hashCode ^
        description.hashCode ^
        speaker.hashCode;
  }
}
