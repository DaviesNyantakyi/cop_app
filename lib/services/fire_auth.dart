import 'package:cop_belgium_app/models/user_model.dart';
import 'package:cop_belgium_app/services/cloud_fire.dart';
import 'package:cop_belgium_app/services/fire_storage.dart';
import 'package:cop_belgium_app/utilities/connection_checker.dart';
import 'package:cop_belgium_app/utilities/hive_boxes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class FireAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final CloudFire _cloudFire = CloudFire();
  final FireStorage _fireStorage = FireStorage();
  final ConnectionNotifier _connectionNotifier = ConnectionNotifier();

  final providerIdEmail = 'password';
  final providerIdGoogle = 'google.com';
  final providerIdApple = 'apple.com';

  Future<User?> createUserEmailPassword({
    required UserModel userModel,
    required String password,
  }) async {
    try {
      final hasConnection = await _connectionNotifier.checkConnection();
      if (hasConnection == true) {
        if (userModel.firstName != null &&
            userModel.lastName != null &&
            userModel.displayName != null &&
            userModel.dateOfBirth != null &&
            userModel.gender != null &&
            userModel.email != null &&
            password.isNotEmpty &&
            userModel.church != null) {
          // Delete anon user if he desides to signup.
          if (_firebaseAuth.currentUser?.isAnonymous == true) {
            await _firebaseAuth.currentUser?.delete();
          }

          // Create a new user with email and password
          await _firebaseAuth.createUserWithEmailAndPassword(
            email: userModel.email!,
            password: password,
          );

          // Update the userModel with the uid
          final updatedUser = userModel.copyWith(
            id: _firebaseAuth.currentUser?.uid,
          );

          // Create a user document in cloud firstore
          await _cloudFire.createUserDoc(user: updatedUser);
          await updateDisplayName(
            firstName: userModel.firstName!,
            lastName: userModel.lastName!,
          );
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

  Future<UserCredential?> signInEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final hasConnection = await _connectionNotifier.checkConnection();

      if (hasConnection) {
        if (email.isNotEmpty && password.isNotEmpty) {
          // Delete anon user if he desides to signup.
          if (_firebaseAuth.currentUser?.isAnonymous == true) {
            await _firebaseAuth.currentUser?.delete();
          }
          final user = await _firebaseAuth.signInWithEmailAndPassword(
            email: email.trim(),
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

  // Returns true if succesfull
  Future<bool> sendPasswordResetEmail({required String? email}) async {
    try {
      final hasConnection = await _connectionNotifier.checkConnection();
      if (hasConnection) {
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

  // Send email verifaction.
  Future<void> sendEmailVerfication() async {
    try {
      final hasConnection = await _connectionNotifier.checkConnection();

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

  Future<void> signOut() async {
    try {
      // Delete anon user when signed out
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

  Future<OAuthCredential?> signInWithGoogle() async {
    try {
      final hasConnection = await _connectionNotifier.checkConnection();

      if (hasConnection) {
        // Show the authentication flow (dialog).
        final googleSignInAccount = await _googleSignIn.signIn();

        if (googleSignInAccount != null) {
          final googelUser = await googleSignInAccount.authentication;
          final authCredentiel = GoogleAuthProvider.credential(
            idToken: googelUser.idToken,
            accessToken: googelUser.accessToken,
          );
          await _firebaseAuth.signInWithCredential(authCredentiel);

          // Create create user document if it does not exist.
          // Try to get the user
          final userDoc =
              await _cloudFire.getUser(id: _firebaseAuth.currentUser!.uid);

          // Create a user if in firestore if it does not exists.
          if (userDoc == null) {
            final user = UserModel(
              id: _firebaseAuth.currentUser?.uid,
              firstName: null,
              dateOfBirth: null,
              lastName: null,
              displayName: _firebaseAuth.currentUser?.displayName,
              email: _firebaseAuth.currentUser?.email,
            );
            await _cloudFire.createUserDoc(user: user);
            await _firebaseAuth.currentUser?.updatePhotoURL(null);
          }
          return authCredentiel;
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

  Future<OAuthCredential?> signInWithApple() async {
    try {
      final hasConnection = await _connectionNotifier.checkConnection();

      if (hasConnection) {
        final isAvailable = await TheAppleSignIn.isAvailable();

        if (isAvailable) {
          // 1. perform the sign-in request

          final result = await TheAppleSignIn.performRequests([
            const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
          ]);

          if (result.status == AuthorizationStatus.authorized) {
            final appleIdCredential = result.credential!;
            final oAuthProvider = OAuthProvider(providerIdApple);

            final credential = oAuthProvider.credential(
              idToken: String.fromCharCodes(appleIdCredential.identityToken!),
              accessToken:
                  String.fromCharCodes(appleIdCredential.authorizationCode!),
            );

            print(appleIdCredential.fullName?.familyName);

            await _firebaseAuth.signInWithCredential(credential);
            // Create create user document if it does not exist.
            // Try to get the user
            final userDoc =
                await _cloudFire.getUser(id: _firebaseAuth.currentUser!.uid);

            // Create a user if in firestore if it does not exists.
            if (userDoc == null) {
              final user = UserModel(
                id: _firebaseAuth.currentUser?.uid,
                firstName: appleIdCredential.fullName?.givenName ?? '',
                lastName: appleIdCredential.fullName?.familyName ?? '',
                dateOfBirth: null,
                displayName: _firebaseAuth.currentUser?.displayName,
                email: _firebaseAuth.currentUser?.email,
              );
              await _cloudFire.createUserDoc(user: user);
              await _firebaseAuth.currentUser?.updatePhotoURL(null);
              return credential;
            }
          }

          if (result.status == AuthorizationStatus.cancelled) {
            throw PlatformException(
              code: 'ERROR_ABORTED_BY_USER',
              message: 'Sign in aborted by user',
            );
          }

          if (result.status == AuthorizationStatus.error) {
            throw PlatformException(
              code: 'ERROR_AUTHORIZATION_DENIED',
              message: result.error.toString(),
            );
          }
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

  Future<bool> deleteEmailAccount({
    String? email,
    String? password,
  }) async {
    try {
      final hasConnection = await _connectionNotifier.checkConnection();

      if (hasConnection) {
        if (email != null &&
            email.isNotEmpty &&
            password != null &&
            password.isNotEmpty) {
          final credential =
              EmailAuthProvider.credential(email: email, password: password);
          await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(
            credential,
          );
          await _firebaseAuth.currentUser?.reload();
          await _fireStorage.deleteProfileImage();
          await _cloudFire.deleteUserInfo();
          await _firebaseAuth.currentUser?.delete();
          await HiveBoxes().deleteBoxes();
          return true;
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
    } finally {}
    return false;
  }

  Future<bool> deleteGoogleAccount() async {
    try {
      final hasConnection = await _connectionNotifier.checkConnection();

      if (hasConnection) {
        final signInCred = await signInWithGoogle();
        if (signInCred != null) {
          final cred = GoogleAuthProvider.credential(
            idToken: signInCred.idToken,
            accessToken: signInCred.accessToken,
          );
          final userCred = await _firebaseAuth.currentUser
              ?.reauthenticateWithCredential(cred);

          if (userCred != null && userCred.credential != null) {
            await _firebaseAuth.currentUser?.reload();
            await FireStorage().deleteProfileImage();
            await _cloudFire.deleteUserInfo();
            await _firebaseAuth.currentUser?.delete();
            await HiveBoxes().deleteBoxes();
            await signOut();
            return true;
          }
        }
      } else {
        throw ConnectionNotifier.connectionException;
      }
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        await _cloudFire.deleteUserInfo();
        await _firebaseAuth.currentUser?.delete();
      }
      rethrow;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
    return false;
  }

  Future<bool> deleteAppleAccount() async {
    try {
      final hasConnection = await _connectionNotifier.checkConnection();

      if (hasConnection) {
        final cred = await signInWithApple();

        print(cred);
      } else {
        throw ConnectionNotifier.connectionException;
      }
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        await _cloudFire.deleteUserInfo();
        await _firebaseAuth.currentUser?.delete();
      }
      rethrow;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
    return false;
  }

  // Update the user display name.
  Future<void> updateDisplayName({
    required String firstName,
    required String lastName,
  }) async {
    try {
      final hasConnection = await _connectionNotifier.checkConnection();

      if (hasConnection) {
        final displayName = '${firstName.trim()} ${lastName.trim()}';
        if (displayName.isNotEmpty && _firebaseAuth.currentUser != null) {
          await _firebaseAuth.currentUser?.updateDisplayName(displayName);
          await _cloudFire.updateUsername(
              firstName: firstName, lastName: lastName);
        }
      } else {
        throw ConnectionNotifier.connectionException;
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // Update the user email
  Future<bool> updateEmail({
    required String email,
    required String password,
  }) async {
    try {
      final hasConnection = await _connectionNotifier.checkConnection();
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

          await signOut();
          return true;
        }
      } else {
        throw ConnectionNotifier.connectionException;
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
    return false;
  }
}
