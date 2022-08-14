import 'dart:io';

import 'package:cop_belgium_app/services/cloud_fire.dart';
import 'package:cop_belgium_app/utilities/connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

const userProfilePath = 'images/profile_images';

class FireStorage {
  final _firebaseAuth = FirebaseAuth.instance;
  final _fireStorage = FirebaseStorage.instance;
  final _cloudFire = CloudFire();

  final ConnectionNotifier _connectionNotifier = ConnectionNotifier();

  Future<String> getPhotoUrl({required String fileRef}) async {
    try {
      return await _fireStorage.ref(fileRef).getDownloadURL();
    } on FirebaseStorage catch (e) {
      debugPrint(e.toString());
      rethrow;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> uploadProfileImage({required File? image}) async {
    try {
      final _userId = _firebaseAuth.currentUser?.uid;

      final hasConnection = await _connectionNotifier.checkConnection();

      if (hasConnection) {
        if (image != null && _userId != null) {
          final ref = await _fireStorage
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
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> deleteProfileImage() async {
    try {
      final hasConnection = await _connectionNotifier.checkConnection();

      if (hasConnection) {
        final userId = _firebaseAuth.currentUser?.uid;
        final user = await _cloudFire.getUser(id: userId);

        // A photo has been uploaded to the storage
        if (user?.photoURL != null && userId != null) {
          final url =
              await getPhotoUrl(fileRef: 'users/$userId/images/$userId');
          await FirebaseStorage.instance.refFromURL(url).delete();

          await _cloudFire.updatePhotoURL(photoURL: null);
          await _firebaseAuth.currentUser?.updatePhotoURL(null);
        }
      } else {
        throw ConnectionNotifier.connectionException;
      }
    } on FirebaseStorage catch (e) {
      debugPrint(e.toString());
      rethrow;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // Future<void> deleteUser() async {
  //   final _userId = _firebaseAuth.currentUser?.uid;
  //   try {
  //     if (_userId != null) {
  //       await _fireStorage.ref('users/$_userId').delete();
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     rethrow;
  //   }
  // }

  // Future<String?> uploadFile({
  //   required String? id,
  //   required String storagePath,
  //   File? file,
  // }) async {
  //   try {
  //     if (file != null) {
  //       final ref = await _fireStorage.ref('$storagePath/$id').putFile(file);
  //       return await getPhotoUrl(fileRef: ref.ref.fullPath);
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     rethrow;
  //   }
  //   return null;
  // }
}
