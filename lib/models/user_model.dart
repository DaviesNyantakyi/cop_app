// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? photoURL;
  String? firstName;
  String? displayName;
  String? lastName;
  String? email;
  String? gender;
  Map<String, dynamic>? church;
  DateTime? dateOfBirth;

  UserModel({
    this.id,
    this.photoURL,
    required this.firstName,
    required this.lastName,
    required this.displayName,
    this.dateOfBirth,
    required this.email,
    this.church,
    this.gender,
  });

  static UserModel fromMap({required Map<String, dynamic> map}) {
    final birthDate = (map['dateOfBirth'] as Timestamp).millisecondsSinceEpoch;
    return UserModel(
      id: map['id'],
      photoURL: map['photoURL'],
      dateOfBirth: DateTime.fromMillisecondsSinceEpoch(birthDate),
      firstName: map['firstName'],
      lastName: map['lastName'],
      displayName: map['displayName'],
      email: map['email'],
      church: map['church'],
      gender: map['gender'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'photoURL': photoURL,
      'firstName': firstName,
      'lastName': lastName,
      'displayName': displayName,
      'dateOfBirth': dateOfBirth,
      'email': email,
      'gender': gender,
      'church': church
    };
  }

  UserModel copyWith({
    String? id,
    String? photoURL,
    String? firstName,
    String? displayName,
    String? lastName,
    String? email,
    String? gender,
    Map<String, dynamic>? church,
    DateTime? dateOfBirth,
  }) {
    return UserModel(
      id: id ?? this.id,
      photoURL: photoURL ?? this.photoURL,
      firstName: firstName ?? this.firstName,
      displayName: displayName ?? this.displayName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      church: church ?? this.church,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, photoURL: $photoURL, firstName: $firstName, displayName: $displayName, lastName: $lastName, email: $email, gender: $gender, church: $church, dateOfBirth: $dateOfBirth)';
  }
}
