import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class EpisodeModel {
  final String id;
  final String imageURL;
  final String title;
  final String description;
  final String audioURL;
  final String author;
  final Duration duration;
  final DateTime date;
  EpisodeModel({
    required this.id,
    required this.imageURL,
    required this.title,
    required this.description,
    required this.audioURL,
    required this.author,
    required this.duration,
    required this.date,
  });

  EpisodeModel copyWith({
    String? id,
    String? imageURL,
    String? title,
    String? description,
    String? audioURL,
    String? author,
    Duration? duration,
    DateTime? date,
  }) {
    return EpisodeModel(
      id: id ?? this.id,
      imageURL: imageURL ?? this.imageURL,
      title: title ?? this.title,
      description: description ?? this.description,
      audioURL: audioURL ?? this.audioURL,
      author: author ?? this.author,
      duration: duration ?? this.duration,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'imageURL': imageURL,
      'title': title,
      'description': description,
      'audioURL': audioURL,
      'author': author,
      'duration': duration,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory EpisodeModel.fromMap(Map<String, dynamic> map) {
    return EpisodeModel(
      id: map['id'],
      imageURL: map['imageURL'],
      title: map['title'],
      description: map['description'],
      audioURL: map['audioURL'],
      author: map['author'],
      duration: map['duration'],
      date: map['date'],
    );
  }

  String toJson() => json.encode(toMap());

  factory EpisodeModel.fromJson(String source) =>
      EpisodeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EpisodeModel(id: $id, imageURL: $imageURL, title: $title, description: $description, audioURL: $audioURL, author: $author, duration: $duration, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EpisodeModel &&
        other.id == id &&
        other.imageURL == imageURL &&
        other.title == title &&
        other.description == description &&
        other.audioURL == audioURL &&
        other.author == author &&
        other.duration == duration &&
        other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        imageURL.hashCode ^
        title.hashCode ^
        description.hashCode ^
        audioURL.hashCode ^
        author.hashCode ^
        duration.hashCode ^
        date.hashCode;
  }
}
