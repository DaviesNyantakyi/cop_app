import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cop_belgium_app/models/user_model.dart';
import 'package:cop_belgium_app/services/fire_storage.dart';
import 'package:cop_belgium_app/utilities/connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CloudFire {
  final _firebaseFirestore = FirebaseFirestore.instance;
  final _firebaseUser = FirebaseAuth.instance.currentUser;

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

  Stream<UserModel?>? userStream() {
    if (_firebaseUser?.uid != null) {
      final docSnap = _firebaseFirestore
          .collection('users')
          .doc(_firebaseUser?.uid)
          .snapshots();

      return docSnap.map((doc) {
        if (doc.data() != null) {
          return UserModel.fromMap(map: doc.data()!);
        }

        return null;
      });
    }
    return null;
  }

  Future<void> updatePhotoURL({required String? photoURL}) async {
    try {
      final hasConnection = await _connectionChecker.checkConnection();

      if (hasConnection) {
        if (_firebaseUser?.uid != null) {
          await _firebaseFirestore
              .collection('users')
              .doc(_firebaseUser?.uid)
              .update({
            'photoURL': photoURL,
          });
          await _firebaseUser?.updatePhotoURL(photoURL);
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

  Future<void> updateUsername(
      {required String firstName, required String lastName}) async {
    try {
      final hasConnection = await _connectionChecker.checkConnection();

      if (hasConnection) {
        if (_firebaseUser?.uid != null) {
          await _firebaseFirestore
              .collection('users')
              .doc(_firebaseUser?.uid)
              .update({
            'firstName': firstName,
            'lastName': lastName,
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
        if (_firebaseUser?.uid != null) {
          await _firebaseFirestore
              .collection('users')
              .doc(_firebaseUser?.uid)
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

  Future<void> updateUserGender({required String gender}) async {
    try {
      final hasConnection = await _connectionChecker.checkConnection();

      if (hasConnection) {
        if (_firebaseUser?.uid != null) {
          await _firebaseFirestore
              .collection('users')
              .doc(_firebaseUser?.uid)
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

  Future<void> updateBio({required String? bio}) async {
    try {
      final hasConnection = await _connectionChecker.checkConnection();

      if (hasConnection) {
        if (_firebaseUser?.uid != null) {
          await _firebaseFirestore
              .collection('users')
              .doc(_firebaseUser?.uid)
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
        if (_firebaseUser?.uid != null) {
          await _firebaseFirestore
              .collection('users')
              .doc(_firebaseUser?.uid)
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
}
