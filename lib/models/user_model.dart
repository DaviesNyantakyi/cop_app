// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? photoURL;
  String? firstName;
  String? displayName;
  String? lastName;
  String? email;
  String? bio;
  String? gender;
  Map<String, dynamic>? church;
  Timestamp? dateOfBirth;

  UserModel({
    this.uid,
    this.photoURL,
    required this.firstName,
    required this.lastName,
    required this.displayName,
    this.dateOfBirth,
    required this.email,
    this.church,
    this.bio,
    this.gender,
  });

  static UserModel fromMap({required Map<String, dynamic> map}) {
    return UserModel(
      uid: map['uid'],
      photoURL: map['photoURL'],
      dateOfBirth: map['dateOfBirth'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      displayName: map['displayName'],
      email: map['email'],
      church: map['church'],
      bio: map['bio'],
      gender: map['gender'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'photoURL': photoURL,
      'firstName': firstName,
      'lastName': lastName,
      'displayName': displayName,
      'dateOfBirth': dateOfBirth,
      'email': email,
      'gender': gender,
      'church': church,
      'bio': bio
    };
  }

  UserModel copyWith({
    String? uid,
    String? photoURL,
    String? firstName,
    String? displayName,
    String? lastName,
    String? email,
    String? bio,
    String? gender,
    Map<String, dynamic>? church,
    Timestamp? dateOfBirth,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      photoURL: photoURL ?? this.photoURL,
      firstName: firstName ?? this.firstName,
      displayName: displayName ?? this.displayName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      gender: gender ?? this.gender,
      church: church ?? this.church,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, photoURL: $photoURL, firstName: $firstName, displayName: $displayName, lastName: $lastName, email: $email, bio: $bio, gender: $gender, church: $church, dateOfBirth: $dateOfBirth)';
  }
}
