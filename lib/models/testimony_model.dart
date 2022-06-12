import 'package:cloud_firestore/cloud_firestore.dart';

class TestimonyModel {
  String? id;
  final String userId;
  String title;
  final String? displayName;
  String description;
  final Timestamp createdAt;
  final Timestamp? updatedAt;

  TestimonyModel({
    this.id,
    required this.userId,
    required this.title,
    required this.displayName,
    required this.description,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'title': title,
      'displayName': displayName,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory TestimonyModel.fromMap({required Map<String, dynamic> map}) {
    return TestimonyModel(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      displayName: map['displayName'],
      description: map['description'],
      createdAt: map['createdAt'],
      updatedAt: map['lastUpdate'],
    );
  }

  @override
  String toString() {
    return 'TestimonyModel(id: $id, userId: $userId, title: $title, displayName: $displayName, description: $description, createdAt: $createdAt, lastUpdate: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TestimonyModel &&
        other.id == id &&
        other.userId == userId &&
        other.title == title &&
        other.displayName == displayName &&
        other.description == description &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        title.hashCode ^
        displayName.hashCode ^
        description.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  TestimonyModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? displayName,
    String? description,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return TestimonyModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
