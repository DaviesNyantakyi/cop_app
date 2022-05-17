import 'package:cloud_firestore/cloud_firestore.dart';

class TestimonyModel {
  String? id;
  final String userId;
  String title;
  final String? displayName;
  String testimony;
  final Timestamp date;
  final Timestamp? lastUpdate;

  TestimonyModel({
    this.id,
    required this.userId,
    required this.title,
    required this.displayName,
    required this.testimony,
    required this.date,
    this.lastUpdate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'title': title,
      'displayName': displayName,
      'testimony': testimony,
      'date': date,
      'lastUpdate': lastUpdate,
    };
  }

  factory TestimonyModel.fromMap(Map<String, dynamic> map) {
    return TestimonyModel(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      displayName: map['displayName'],
      testimony: map['testimony'],
      date: map['date'],
      lastUpdate: map['lastUpdate'],
    );
  }

  @override
  String toString() {
    return 'TestimonyModel(id: $id, userId: $userId, title: $title, displayName: $displayName, testimony: $testimony, date: $date, lastUpdate: $lastUpdate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TestimonyModel &&
        other.id == id &&
        other.userId == userId &&
        other.title == title &&
        other.displayName == displayName &&
        other.testimony == testimony &&
        other.date == date &&
        other.lastUpdate == lastUpdate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        title.hashCode ^
        displayName.hashCode ^
        testimony.hashCode ^
        date.hashCode ^
        lastUpdate.hashCode;
  }

  TestimonyModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? displayName,
    String? testimony,
    Timestamp? date,
    Timestamp? lastUpdate,
  }) {
    return TestimonyModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      displayName: displayName ?? this.displayName,
      testimony: testimony ?? this.testimony,
      date: date ?? this.date,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}
