import 'package:cop_belgium_app/models/user_model.dart';
import 'package:cop_belgium_app/services/cloud_fire.dart';
import 'package:cop_belgium_app/services/fire_storage.dart';
import 'package:cop_belgium_app/utilities/connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:internet_connection_checker/internet_connection_checker.dart';

class FireAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final CloudFire _cloudFire = CloudFire();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> createUserEmailPassword(
      {required UserModel user, required String password}) async {
    try {
      final hasConnection = await ConnectionNotifier().checkConnection();
      if (hasConnection == true) {
        if (user.firstName != null &&
            user.lastName != null &&
            user.gender != null &&
            user.email != null &&
            password.isNotEmpty &&
            user.church != null) {
          // Delete anon user if he desides to signup.
          if (_firebaseAuth.currentUser?.isAnonymous == true) {
            await _firebaseAuth.currentUser?.delete();
          }

          await _firebaseAuth.createUserWithEmailAndPassword(
            email: user.email!,
            password: password,
          );
          await _firebaseAuth.currentUser?.updateDisplayName(user.displayName);

          final updatedUser = user.copyWith(id: _firebaseAuth.currentUser?.uid);

          await _cloudFire.createUserDoc(user: updatedUser);
          user.id = _firebaseAuth.currentUser?.uid;

          await _firebaseAuth.currentUser?.reload();
          return _firebaseAuth.currentUser;
        } else {
          return null;
        }
      } else {
        throw ConnectionNotifier.connectionException;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());

      rethrow;
    }
  }

  Future<UserCredential?> loginEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final hasConnection = await InternetConnectionChecker().hasConnection;

      if (hasConnection) {
        if (email.isNotEmpty && password.isNotEmpty) {
          // Delete anon user if he desides to signup.
          if (_firebaseAuth.currentUser?.isAnonymous == true) {
            await _firebaseAuth.currentUser?.delete();
          }
          final user = await _firebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          return user;
        }

        // return null if authentication fails.
        return null;
      } else {
        throw ConnectionNotifier.connectionException;
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<User?> loginAnonymous() async {
    try {
      final hasConnection = await InternetConnectionChecker().hasConnection;

      if (hasConnection) {
        await _firebaseAuth.signInAnonymously();
        return _firebaseAuth.currentUser;
      } else {
        throw ConnectionNotifier.connectionException;
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> deleteAccount({String? password}) async {
    try {
      if (password != null && password.isNotEmpty) {
        final email = _firebaseAuth.currentUser?.email;
        if (email != null) {
          final credential =
              EmailAuthProvider.credential(email: email, password: password);
          await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(
            credential,
          );
          await _firebaseAuth.currentUser?.reload();
          await FireStorage().deleteProfileImage();
          await _cloudFire.deleteUserInfo();
          await _firebaseAuth.currentUser?.delete();
        }
      }
    } catch (e) {
      debugPrint(e.toString());

      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      // When a anon user singOut and login again a new anon user gets created.
      // So when the user logs out we delete the account.
      if (_firebaseAuth.currentUser?.isAnonymous == true) {
        await _firebaseAuth.currentUser?.delete();
      }
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<UserCredential?> loginGoogle() async {
    try {
      final hasConnection = await InternetConnectionChecker().hasConnection;

      if (hasConnection) {
        // Show the authentication flow (dialog).
        final googleUser = await _googleSignIn.signIn();

        if (googleUser != null) {
          final googelUser = await googleUser.authentication;
          final cred = GoogleAuthProvider.credential(
            idToken: googelUser.idToken,
            accessToken: googelUser.accessToken,
          );
          final userCred = await _firebaseAuth.signInWithCredential(cred);

          // Create create user document if it does not exist.
          // Try to get the user
          final userDoc =
              await _cloudFire.getUser(id: _firebaseAuth.currentUser!.uid);

          // Create a user if in firestore if it does not exists.
          if (userDoc == null) {
            final user = UserModel(
              id: _firebaseAuth.currentUser?.uid,
              photoURL: _firebaseAuth.currentUser?.photoURL,
              firstName: null,
              dateOfBirth: null,
              lastName: null,
              displayName: _firebaseAuth.currentUser?.displayName,
              email: _firebaseAuth.currentUser?.email,
            );
            await _cloudFire.createUserDoc(user: user);
          }
          return userCred;
        }
      } else {
        throw ConnectionNotifier.connectionException;
      }

      // Return null if the authentication flow fails.
      return null;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
    // return null if authentication fails.
  }

  Future<User?> loginApple() async {
    try {
      final hasConnection = await InternetConnectionChecker().hasConnection;

      if (hasConnection) {
        // TODO: Implement login with Apple:
        // https://firebase.flutter.dev/docs/auth/social/#:~:text=see%20this%20issue.-,apple
      } else {
        throw ConnectionNotifier.connectionException;
      }

      // Return null if the authentication flow fails.
      return null;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
    // return null if authentication fails.
  }

  // Send email verifaction.
  Future<void> sendEmailVerfication() async {
    try {
      final hasConnection = await InternetConnectionChecker().hasConnection;

      if (hasConnection) {
        // Reload the current user info.
        await _firebaseAuth.currentUser?.reload();

        // Check if the user id verifed.
        final verfied = _firebaseAuth.currentUser?.emailVerified;

        // Send verfication mail if the user is not verified.
        if (verfied == false) {
          await _firebaseAuth.currentUser?.sendEmailVerification();
        }
      } else {
        throw ConnectionNotifier.connectionException;
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
    // return null if authentication fails.
  }

  // Update the user display name.
  Future<void> updateDisplayName(
      {required String firstName, required String lastName}) async {
    try {
      final hasConnection = await InternetConnectionChecker().hasConnection;

      if (hasConnection) {
        final displayName = '$firstName $lastName';
        if (firstName.isNotEmpty) {
          await _firebaseAuth.currentUser?.updateDisplayName(displayName);
          await _cloudFire.updateUsername(
            firstName: displayName,
            lastName: lastName,
          );
        }
      } else {
        throw ConnectionNotifier.connectionException;
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // Send email verifcation before changing the email.
  Future<bool> updateEmail({
    required String email,
    required String password,
  }) async {
    try {
      final hasConnection = await InternetConnectionChecker().hasConnection;
      if (hasConnection) {
        if (_firebaseAuth.currentUser?.email != null &&
            email.isNotEmpty &&
            password.isNotEmpty) {
          // Reauthenticat the user. This is necessary for changing email.
          final cred = EmailAuthProvider.credential(
            email: _firebaseAuth.currentUser!.email!,
            password: password,
          );

          await _firebaseAuth.currentUser?.reauthenticateWithCredential(cred);
          await _firebaseAuth.currentUser?.reload();

          // Send email verifaction to the new email.
          await _firebaseAuth.currentUser?.updateEmail(email.trim());
          await _firebaseAuth.currentUser?.reload();
          await _cloudFire.updateUserEmail(email: email);
          await _firebaseAuth.currentUser?.sendEmailVerification();

          await logout();
          return true;
        }
      } else {
        throw ConnectionNotifier.connectionException;
      }
      return false;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<bool> sendPasswordReset() async {
    try {
      final hasConnection = await InternetConnectionChecker().hasConnection;
      if (hasConnection) {
        final email = _firebaseAuth.currentUser?.email;
        if (email != null) {
          await _firebaseAuth.sendPasswordResetEmail(email: email);
          return true;
        }
      } else {
        throw ConnectionNotifier.connectionException;
      }
      return false;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
