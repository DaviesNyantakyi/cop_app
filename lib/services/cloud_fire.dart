import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cop_belgium_app/models/podcast_info_model.dart';
import 'package:cop_belgium_app/models/testimony_model.dart';
import 'package:cop_belgium_app/models/user_model.dart';
import 'package:cop_belgium_app/services/fire_storage.dart';
import 'package:cop_belgium_app/utilities/connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CloudFire {
  final _firebaseFirestore = FirebaseFirestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;

  final _connectionChecker = ConnectionNotifier();

  // User
  Future<void> createUserDoc({required UserModel user}) async {
    try {
      final hasConnection = await _connectionChecker.checkConnection();

      if (hasConnection) {
        if (user.uid != null && user.email != null) {
          await _firebaseFirestore
              .collection('users')
              .doc(user.uid)
              .set(user.toMap());
        }
      } else {
        throw ConnectionNotifier.connectionException;
      }
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<UserModel?> getUser({required String? id}) async {
    try {
      final hasConnection = await _connectionChecker.checkConnection();
      if (hasConnection) {
        if (id != null) {
          final doc =
              await _firebaseFirestore.collection('users').doc(id).get();
          if (doc.exists) {
            return UserModel.fromMap(map: doc.data()!);
          }
        }
        return null;
      } else {
        throw ConnectionNotifier.connectionException;
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Stream<UserModel?>? getUserStream() {
    try {
      final docSnap = _firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser?.uid)
          .snapshots();

      return docSnap.map((doc) {
        if (doc.data() != null) {
          return UserModel.fromMap(map: doc.data()!);
        }
        return null;
      });
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<void> updatePhotoURL({required String? photoURL}) async {
    try {
      final hasConnection = await _connectionChecker.checkConnection();

      if (hasConnection) {
        if (_firebaseAuth.currentUser?.uid != null) {
          await _firebaseFirestore
              .collection('users')
              .doc(_firebaseAuth.currentUser?.uid)
              .update({
            'photoURL': photoURL,
          });
          await _firebaseAuth.currentUser?.updatePhotoURL(photoURL);
        }
      } else {
        throw ConnectionNotifier.connectionException;
      }
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      rethrow;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> updateUsername({
    required String firstName,
    required String lastName,
  }) async {
    try {
      final hasConnection = await _connectionChecker.checkConnection();

      if (hasConnection) {
        // print(_firebaseUser?.uid);
        if (_firebaseAuth.currentUser?.uid != null &&
            firstName.isNotEmpty &&
            lastName.isNotEmpty) {
          final displayName = '${firstName.trim()} ${lastName.trim()}';
          await _firebaseFirestore
              .collection('users')
              .doc(_firebaseAuth.currentUser?.uid)
              .update({
            'firstName': firstName.trim(),
            'lastName': lastName.trim(),
            'displayName': displayName
          });
        }
      } else {
        throw ConnectionNotifier.connectionException;
      }
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      rethrow;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> updateUserEmail({required String email}) async {
    try {
      final hasConnection = await _connectionChecker.checkConnection();

      if (hasConnection) {
        if (_firebaseAuth.currentUser?.uid != null) {
          await _firebaseFirestore
              .collection('users')
              .doc(_firebaseAuth.currentUser?.uid)
              .update({
            'email': email,
          });
        }
      } else {
        throw ConnectionNotifier.connectionException;
      }
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      rethrow;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> updateUserChurch({
    required String id,
    required String churchName,
  }) async {
    try {
      final hasConnection = await _connectionChecker.checkConnection();

      if (hasConnection) {
        if (_firebaseAuth.currentUser?.uid != null) {
          await _firebaseFirestore
              .collection('users')
              .doc(_firebaseAuth.currentUser?.uid)
              .update({
            'church': {
              'id': id,
              'churchName': churchName,
            },
          });
        }
      } else {
        throw ConnectionNotifier.connectionException;
      }
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      rethrow;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> updateUserGender({required String gender}) async {
    try {
      final hasConnection = await _connectionChecker.checkConnection();

      if (hasConnection) {
        if (_firebaseAuth.currentUser?.uid != null && gender.isNotEmpty) {
          await _firebaseFirestore
              .collection('users')
              .doc(_firebaseAuth.currentUser?.uid)
              .update({
            'gender': gender,
          });
        }
      } else {
        throw ConnectionNotifier.connectionException;
      }
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      rethrow;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> updateUserDateOfBirth({required Timestamp? dateOfBirth}) async {
    try {
      final hasConnection = await _connectionChecker.checkConnection();

      if (hasConnection) {
        if (_firebaseAuth.currentUser?.uid != null && dateOfBirth != null) {
          await _firebaseFirestore
              .collection('users')
              .doc(_firebaseAuth.currentUser?.uid)
              .update({
            'dateOfBirth': dateOfBirth,
          });
        }
      } else {
        throw ConnectionNotifier.connectionException;
      }
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      rethrow;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> updateBio({required String? bio}) async {
    try {
      final hasConnection = await _connectionChecker.checkConnection();

      if (hasConnection) {
        if (_firebaseAuth.currentUser?.uid != null) {
          await _firebaseFirestore
              .collection('users')
              .doc(_firebaseAuth.currentUser?.uid)
              .update({
            'bio': bio,
          });
        }
      } else {
        throw ConnectionNotifier.connectionException;
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> deleteUserInfo() async {
    try {
      final hasConnection = await _connectionChecker.checkConnection();
      if (hasConnection) {
        if (_firebaseAuth.currentUser?.uid != null) {
          await _firebaseFirestore
              .collection('users')
              .doc(_firebaseAuth.currentUser?.uid)
              .delete();
          await FireStorage().deleteUser();
        }
      } else {
        throw ConnectionNotifier.connectionException;
      }
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      rethrow;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // Testimonies
  Future<void> createTestimony({required TestimonyModel testimony}) async {
    try {
      bool hasConnection = await _connectionChecker.checkConnection();

      if (hasConnection) {
        final docRef = await _firebaseFirestore.collection('testimonies').add(
              testimony.toMap(),
            );
        docRef.update({'id': docRef.id});
      } else {
        throw ConnectionNotifier.connectionException;
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Stream<List<TestimonyModel>> getTestimonies() {
    try {
      final qSnap = _firebaseFirestore.collection('testimonies').snapshots();

      return qSnap.map((qSnap) {
        return qSnap.docs.map((e) {
          return TestimonyModel.fromMap(e.data());
        }).toList();
      });
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> updateTestimony({required TestimonyModel testimony}) async {
    try {
      bool hasConnection = await _connectionChecker.checkConnection();

      if (hasConnection) {
        await _firebaseFirestore
            .collection('testimonies')
            .doc(testimony.id)
            .update(
              testimony.toMap(),
            );
        await _firebaseFirestore
            .collection('testimonies')
            .doc(testimony.id)
            .update({
          'updatedAt': DateTime.now(),
        });
      } else {
        throw ConnectionNotifier.connectionException;
      }
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<bool?> deleteTestimony(
      {required TestimonyModel testimonyModel}) async {
    try {
      bool hasConnection = await _connectionChecker.checkConnection();

      if (hasConnection) {
        // delete doc
        await _firebaseFirestore
            .collection('testimonies')
            .doc(testimonyModel.id)
            .delete();
        return true;
      } else {
        throw ConnectionNotifier.connectionException;
      }
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      rethrow;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // Podcasts
  Future<List<PodcastInfoModel>> getPodcastsFireStore() async {
    // get the podcast rss link and page link from firestore.
    try {
      final hasConnection = await _connectionChecker.checkConnection();
      if (hasConnection) {
        QuerySnapshot<Map<String, dynamic>>? qSnap;

        qSnap = await FirebaseFirestore.instance.collection('podcasts').get();

        final listQDocSnap = qSnap.docs;

        List<PodcastInfoModel> listPodRssInfo = listQDocSnap.map((doc) {
          return PodcastInfoModel.fromMap(map: doc.data());
        }).toList();

        return listPodRssInfo;
      } else {
        throw ConnectionNotifier.connectionException;
      }
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      rethrow;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
