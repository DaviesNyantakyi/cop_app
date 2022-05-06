import 'dart:io';

import 'package:cop_belgium_app/services/cloud_fire.dart';
import 'package:cop_belgium_app/utilities/connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

const userProfilePath = 'images/profile_images';

class FireStorage {
  final _firebaseAuth = FirebaseAuth.instance;
  final _fireStore = FirebaseStorage.instance;
  final _cloudFire = CloudFire();

  // User

  Future<void> uploadProfileImage({
    required File? image,
    // required bool delete,
  }) async {
    try {
      // Delete profile image if the user has not seletecd a image and delete is true.
      final _userId = _firebaseAuth.currentUser?.uid;

      final result = await InternetConnectionChecker().hasConnection;

      if (result) {
        // if (image == null && delete) {
        //   await deleteProfileImage();
        //   await _cloudFire.updatePhotoURL(photoUrl: null);
        //   await _user?.updatePhotoURL(null);
        //   return;
        // }

        if (image != null && _userId != null) {
          final ref = await _fireStore
              .ref()
              .child('users/$_userId/images/$_userId')
              .putFile(image);
          final url = await getPhotoUrl(fileRef: ref.ref.fullPath);
          await _firebaseAuth.currentUser?.updatePhotoURL(url);
          await _cloudFire.updatePhotoURL(photoURL: url);
        }
      } else {
        throw ConnectionNotifier.connectionException;
      }
    } on FirebaseStorage catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<String> getPhotoUrl({required String fileRef}) async {
    return await _fireStore.ref(fileRef).getDownloadURL();
  }

  Future<void> deleteProfileImage() async {
    try {
      final userId = _firebaseAuth.currentUser?.uid;
      if (userId != null) {
        await _fireStore.ref('users/$userId/images/$userId').delete();
        await _cloudFire.updatePhotoURL(photoURL: null);
        await _firebaseAuth.currentUser?.updatePhotoURL(null);
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> deleteUser() async {
    final _userId = _firebaseAuth.currentUser?.uid;
    try {
      if (_userId != null) {
        await _fireStore.ref('users/$_userId').delete();
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<String?> uploadFile({
    required String? id,
    required String storagePath,
    File? file,
  }) async {
    try {
      if (file != null) {
        final ref = await _fireStore.ref('$storagePath/$id').putFile(file);
        return await getPhotoUrl(fileRef: ref.ref.fullPath);
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
    return null;
  }
}
