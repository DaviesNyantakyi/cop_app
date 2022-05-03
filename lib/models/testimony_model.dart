class TestimonyModel {
  String? id;
  final String userId;
  String title;
  final String? userName;
  String description;
  int? likes;
  final DateTime? date;

  TestimonyModel({
    required this.id,
    required this.userName,
    required this.userId,
    required this.title,
    required this.description,
    this.likes,
    required this.date,
  });

  static Map<String, dynamic> toMap({required TestimonyModel map}) {
    return {
      'id': map.id,
      'userName': map.userName,
      'userId': map.userId,
      'title': map.title,
      'description': map.description,
      'likes': map.likes,
      'date': map.date,
    };
  }

  static TestimonyModel fromMap({required Map<String, dynamic> map}) {
    return TestimonyModel(
      id: map['id'],
      userName: map['userName'],
      userId: map['userId'],
      title: map['title'],
      description: map['description'],
      date: map['date'].toDate(),
      likes: map['likes'],
    );
  }
}
