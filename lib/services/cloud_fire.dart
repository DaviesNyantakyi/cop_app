import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cop_belgium_app/models/testimony_model.dart';
import 'package:cop_belgium_app/models/user_model.dart';
import 'package:cop_belgium_app/services/fire_storage.dart';
import 'package:cop_belgium_app/utilities/connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class CloudFire {
  final _firebaseFirestore = FirebaseFirestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;

  final _connectionChecker = ConnectionChecker();

  // User
  Future<void> createUserDoc({required UserModel user}) async {
    try {
      if (user.id != null &&
          user.lastName.isNotEmpty &&
          user.firstName.isNotEmpty &&
          user.email.isNotEmpty) {
        await _firebaseFirestore
            .collection('users')
            .doc(user.id)
            .set(user.toMap());
      }
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> updatePhotoURL({required String? photoUrl}) async {
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser?.uid)
          .update({
        'photoURL': photoUrl,
      });
      await _firebaseAuth.currentUser?.updatePhotoURL(photoUrl);
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
      final uid = _firebaseAuth.currentUser?.uid;
      if (uid != null) {
        await _firebaseFirestore.collection('users').doc(uid).update({
          'firstName': firstName,
          'lastName': lastName,
        });
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
      final uid = _firebaseAuth.currentUser?.uid;
      if (uid != null) {
        await _firebaseFirestore.collection('users').doc(uid).update({
          'email': email,
        });
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
      final uid = _firebaseAuth.currentUser?.uid;

      if (uid != null) {
        await _firebaseFirestore.collection('users').doc(uid).update({
          'gender': gender,
        });
      }
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      rethrow;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> updateUserInfo({
    required String firstName,
    required String lastName,
    required String email,
    required String gender,
  }) async {
    try {
      bool hasConnection = await ConnectionChecker().checkConnection();
      if (hasConnection) {
        String? displayName = '$firstName $lastName';

        await _firebaseAuth.currentUser?.updateDisplayName(displayName);
        await _firebaseAuth.currentUser?.updateEmail(email);
        await updateUsername(firstName: firstName, lastName: lastName);
        await updateUserEmail(email: email);
        await updateUserGender(gender: gender);
      } else {
        throw ConnectionChecker.connectionException;
      }
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      rethrow;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<UserModel?> getUser({required String? id}) async {
    try {
      final result = await InternetConnectionChecker().hasConnection;
      if (result) {
        final doc = await _firebaseFirestore.collection('users').doc(id).get();
        if (doc.exists) {
          return UserModel.fromMap(map: doc.data()!);
        }
        return null;
      } else {
        throw ConnectionChecker.connectionException;
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> deleteUserInfo() async {
    try {
      final uid = _firebaseAuth.currentUser?.uid;
      if (uid != null) {
        var collection = FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('savedPodcasts');
        var snapshots = await collection.get();
        for (var doc in snapshots.docs) {
          await doc.reference.delete();
        }
        await _firebaseFirestore.collection('users').doc(uid).delete();
        await FireStorage().deleteUser();
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
        final docRef = await _firebaseFirestore
            .collection('testimonies')
            .add(TestimonyModel.toMap(map: testimony));
        docRef.update({'id': docRef.id});
      } else {
        throw ConnectionChecker.connectionException;
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> updateTestimonyInfo({required TestimonyModel tInfo}) async {
    try {
      bool hasConnection = await _connectionChecker.checkConnection();

      if (hasConnection) {
        await _firebaseFirestore.collection('testimonies').doc(tInfo.id).update(
              TestimonyModel.toMap(map: tInfo),
            );
      } else {
        throw ConnectionChecker.connectionException;
      }
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> deleteTestimony({required TestimonyModel? testimony}) async {
    try {
      bool hasConnection = await _connectionChecker.checkConnection();

      if (hasConnection) {
        // delete likers collection first otherwise the doc will still remain
        final collection = _firebaseFirestore
            .collection('testimonies')
            .doc(testimony!.id)
            .collection('likers');
        final snapshots = await collection.get();
        for (var doc in snapshots.docs) {
          await doc.reference.delete();
        }

        // delete doc
        await _firebaseFirestore
            .collection('testimonies')
            .doc(testimony.id)
            .delete();
      } else {
        throw ConnectionChecker.connectionException;
      }
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      rethrow;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> likeDislikeTestimony({required TestimonyModel tInfo}) async {
    try {
      bool hasConnection = await _connectionChecker.checkConnection();
      if (hasConnection) {
        // Create a uniek document id  basen on the testimonyInfo id and the userId.
        // (this can also be done with the .where() where filter and get only the doc with the tInfo.id and userId)
        String docRef = tInfo.id.toString() + _firebaseAuth.currentUser!.uid;

        // Try to get the document in the likes collection.
        final docSnap =
            await _getTestimonyLikeDoc(tInfo: tInfo, docRef: docRef);

        // the user has clicked on the like button:
        // If the doc does not exits in the Testimony likers collection.
        // Then it means that the user has not liked the testimony.
        if (docSnap.exists == false) {
          // Like

          //  document is created with a uniek id in the likes collection.
          await createTestimonyLikeDoc(tInfo: tInfo, docRef: docRef);
        } else {
          // Dislike
          // If doc exist then it means the user has disliked.
          // So we delete the document in the likers collection.
          deleteTestimonyLikeDoc(tInfo: tInfo, docRef: docRef);
        }
      } else {
        throw ConnectionChecker.connectionException;
      }
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> deleteTestimonyLikeDoc(
      {required TestimonyModel tInfo, required String docRef}) async {
    try {
      // delete the doc with the liker info in the likers collection.
      await _firebaseFirestore
          .collection('testimonies')
          .doc(tInfo.id)
          .collection('likers')
          .doc(docRef)
          .delete();
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> createTestimonyLikeDoc({
    required TestimonyModel tInfo,
    required String docRef,
  }) async {
    final currenDate = DateTime.now();
    try {
      // This method allows us to soo who liked the post.
      // Upload a document with a unqiek id to the specific testimony doc likers collection.
      await _firebaseFirestore
          .collection('testimonies')
          .doc(tInfo.id)
          .collection('likers')
          .doc(docRef)
          .set(({
            'id': docRef,
            'testimonyId': tInfo.id,
            'userId': _firebaseAuth.currentUser!.uid,
            'date': currenDate
          }));

      // update testimony info like count
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _getTestimonyLikeDoc({
    required TestimonyModel tInfo,
    required String docRef,
  }) async {
    // This gets the document with the uniek ref in the likes collection.
    return await FirebaseFirestore.instance
        .collection('testimonies')
        .doc(tInfo.id)
        .collection('likers')
        .doc(docRef)
        .get();
  }
}
