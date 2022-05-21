import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionAnswerModel {
  String? id;
  final String uid;
  String title;
  final String? displayName;
  String question;
  final Timestamp createdAt;
  final Timestamp? updatedAt;

  QuestionAnswerModel({
    this.id,
    required this.uid,
    required this.title,
    required this.displayName,
    required this.question,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'title': title,
      'displayName': displayName,
      'question': question,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory QuestionAnswerModel.fromMap(Map<String, dynamic> map) {
    return QuestionAnswerModel(
      id: map['id'],
      uid: map['uid'],
      title: map['title'],
      displayName: map['displayName'],
      question: map['question'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  QuestionAnswerModel copyWith({
    String? id,
    String? uid,
    String? title,
    String? displayName,
    String? question,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return QuestionAnswerModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      displayName: displayName ?? this.displayName,
      question: question ?? this.question,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'QuestionAndAnswerModel(id: $id, uid: $uid, title: $title, displayName: $displayName, question: $question, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuestionAnswerModel &&
        other.id == id &&
        other.uid == uid &&
        other.title == title &&
        other.displayName == displayName &&
        other.question == question &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uid.hashCode ^
        title.hashCode ^
        displayName.hashCode ^
        question.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
