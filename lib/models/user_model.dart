import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? photoUrl;
  String firstName;
  String displayName;
  String lastName;
  String email;
  String gender;
  String? church;
  DateTime birthDate;
  bool isAdmin;

  UserModel({
    this.id,
    this.photoUrl,
    required this.isAdmin,
    required this.firstName,
    required this.lastName,
    required this.displayName,
    required this.birthDate,
    required this.email,
    this.church,
    required this.gender,
  });

  static UserModel fromMap({required Map<String, dynamic> map}) {
    final birthDate = (map['birthDate'] as Timestamp).millisecondsSinceEpoch;
    return UserModel(
      id: map['id'],
      photoUrl: map['photoUrl'],
      birthDate: DateTime.fromMillisecondsSinceEpoch(birthDate),
      firstName: map['firstName'],
      lastName: map['lastName'],
      displayName: map['displayName'],
      email: map['email'],
      church: map['church'],
      gender: map['gender'],
      isAdmin: map['isAdmin'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'photoUrl': photoUrl,
      'firstName': firstName,
      'lastName': lastName,
      'displayName': displayName,
      'isAdmin': isAdmin,
      'birthDate': birthDate,
      'email': email,
      'gender': gender,
      'church': church
    };
  }

  @override
  String toString() {
    return 'Church(id: $id, photoUrl:$photoUrl, churchName: $firstName, phoneNumber: $lastName, displayName: $displayName email: $email, isAdmin: $isAdmin, birthDate: $birthDate, gender: $gender, church: $church)';
  }
}
