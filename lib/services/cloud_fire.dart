import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cop_belgium_app/models/podcast_info_model.dart';
import 'package:cop_belgium_app/models/user_model.dart';
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
        if (user.id != null && user.email != null) {
          await _firebaseFirestore
              .collection('users')
              .doc(user.id)
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

  Stream<UserModel?>? getUserStream({required String uid}) {
    try {
      final docSnap =
          _firebaseFirestore.collection('users').doc(uid).snapshots();

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

  Future<void> updateUserEmail({String? email}) async {
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
          await deletePodcastSubscriptions();
          await _firebaseFirestore
              .collection('users')
              .doc(_firebaseAuth.currentUser?.uid)
              .delete();
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

  // Podcasts
  Future<List<PodcastInfoModel>> getPodcastsSubscriptionsFireStore() async {
    // get the podcast rss link and page link from firestore.
    try {
      final hasConnection = await _connectionChecker.checkConnection();
      if (hasConnection) {
        QuerySnapshot<Map<String, dynamic>>? qSnap;

        qSnap = await FirebaseFirestore.instance
            .collection('users')
            .doc(_firebaseAuth.currentUser?.uid)
            .collection('subscriptions')
            .get();

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

  Stream<QuerySnapshot<Map<String, dynamic>>>? getPodcastStream() {
    try {
      return _firebaseFirestore.collection('podcasts').snapshots();
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<void> deletePodcastSubscriptions() async {
    try {
      final hasConnection = await _connectionChecker.checkConnection();
      if (hasConnection) {
        if (_firebaseAuth.currentUser?.uid != null) {
          final qSnap = await _firebaseFirestore
              .collection('users')
              .doc(_firebaseAuth.currentUser?.uid)
              .collection('subscriptions')
              .get();

          for (var doc in qSnap.docs) {
            final docId = doc.id;

            await _firebaseFirestore
                .collection('users')
                .doc(_firebaseAuth.currentUser?.uid)
                .collection('subscriptions')
                .doc(docId)
                .delete();
          }
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
}
