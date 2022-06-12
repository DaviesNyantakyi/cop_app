// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// Map<String, dynamic> speaker = {
//   'speaker': 'Levi Lusko',
//   'imageURL': 'https',
//   'about': 'founder of school',
//   'pageURL': ''
// };

class TeachingClipModel {
  String id;
  String title;
  String videoURL;
  String description;
  Map<String, dynamic> speaker;
  Timestamp createdAt;

  TeachingClipModel({
    required this.id,
    required this.title,
    required this.videoURL,
    required this.description,
    required this.speaker,
    required this.createdAt,
  });

  TeachingClipModel copyWith({
    String? id,
    String? title,
    String? videoURL,
    String? description,
    Map<String, dynamic>? speaker,
    Timestamp? createdAt,
  }) {
    return TeachingClipModel(
      id: id ?? this.id,
      title: title ?? this.title,
      videoURL: videoURL ?? this.videoURL,
      description: description ?? this.description,
      speaker: speaker ?? this.speaker,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'videoURL': videoURL,
      'description': description,
      'speaker': speaker,
      'createdAt': createdAt,
    };
  }

  factory TeachingClipModel.fromMap({required Map<String, dynamic> map}) {
    return TeachingClipModel(
      id: map['id'],
      title: map['title'],
      videoURL: map['videoURL'],
      description: map['description'],
      speaker: map['speaker'],
      createdAt: map['createdAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TeachingClipModel.fromJson(String source) =>
      TeachingClipModel.fromMap(
        map: json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() {
    return 'TeachingClipModel(id: $id, title: $title, videoURL: $videoURL, description: $description, speaker: $speaker, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TeachingClipModel &&
        other.id == id &&
        other.title == title &&
        other.videoURL == videoURL &&
        other.description == description &&
        mapEquals(other.speaker, speaker) &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        videoURL.hashCode ^
        description.hashCode ^
        speaker.hashCode ^
        createdAt.hashCode;
  }
}
