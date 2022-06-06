import 'package:cloud_firestore/cloud_firestore.dart';

class TestimonyModel {
  String? id;
  final String uid;
  String title;
  final String? displayName;
  String testimony;
  final Timestamp createdAt;
  final Timestamp? updatedAt;

  TestimonyModel({
    this.id,
    required this.uid,
    required this.title,
    required this.displayName,
    required this.testimony,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'title': title,
      'displayName': displayName,
      'testimony': testimony,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory TestimonyModel.fromMap({required Map<String, dynamic> map}) {
    return TestimonyModel(
      id: map['id'],
      uid: map['uid'],
      title: map['title'],
      displayName: map['displayName'],
      testimony: map['testimony'],
      createdAt: map['createdAt'],
      updatedAt: map['lastUpdate'],
    );
  }

  @override
  String toString() {
    return 'TestimonyModel(id: $id, uid: $uid, title: $title, displayName: $displayName, testimony: $testimony, createdAt: $createdAt, lastUpdate: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TestimonyModel &&
        other.id == id &&
        other.uid == uid &&
        other.title == title &&
        other.displayName == displayName &&
        other.testimony == testimony &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uid.hashCode ^
        title.hashCode ^
        displayName.hashCode ^
        testimony.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  TestimonyModel copyWith({
    String? id,
    String? uid,
    String? title,
    String? displayName,
    String? testimony,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return TestimonyModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      displayName: displayName ?? this.displayName,
      testimony: testimony ?? this.testimony,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
