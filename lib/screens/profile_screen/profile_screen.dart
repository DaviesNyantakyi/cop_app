import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cop_belgium_app/providers/signup_provider.dart';
import 'package:cop_belgium_app/screens/profile_screen/edit_church.dart';
import 'package:cop_belgium_app/screens/profile_screen/edit_date_screen.dart';
import 'package:cop_belgium_app/screens/profile_screen/edit_email_screen.dart';
import 'package:cop_belgium_app/screens/profile_screen/edit_gender_screen.dart';
import 'package:cop_belgium_app/screens/profile_screen/edit_name_screen.dart';
import 'package:cop_belgium_app/services/fire_storage.dart';
import 'package:cop_belgium_app/utilities/connection_checker.dart';
import 'package:cop_belgium_app/utilities/firebase_error_codes.dart';
import 'package:cop_belgium_app/utilities/formal_dates.dart';
import 'package:cop_belgium_app/utilities/image_picker.dart';
import 'package:cop_belgium_app/widgets/avatar.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:cop_belgium_app/widgets/text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../services/cloud_fire.dart';
import '../../services/fire_auth.dart';
import '../../utilities/constant.dart';
import '../../widgets/back_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final firebaseAuth = FirebaseAuth.instance;
  final fireAuth = FireAuth();
  final cloudFire = CloudFire();
  final fireStorage = FireStorage();

  final customImagePicker = CustomImagePicker();
  final providerId =
      FirebaseAuth.instance.currentUser?.providerData[0].providerId;

  TextEditingController passwordCntrl = TextEditingController();
  final passwordKey = GlobalKey<FormState>();

  late final userStream = CloudFire().getUserStream(
    uid: FirebaseAuth.instance.currentUser!.uid,
  );

  Future<void> navigateToScreen({required Widget screen}) async {
    try {
      bool hasConnection = await ConnectionNotifier().checkConnection();

      if (hasConnection == true) {
        await Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => screen,
          ),
        );
      }
    } on FirebaseException catch (e) {
      showCustomSnackBar(
        context: context,
        type: CustomSnackBarType.error,
        message: e.message ?? ' ',
      );

      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() {});
  }

  Future<void> resetPassword() async {
    try {
      EasyLoading.show();
      bool sent = await fireAuth.sendPasswordResetEmail(
        email: firebaseAuth.currentUser?.email,
      );
      if (sent) {
        showCustomSnackBar(
          context: context,
          type: CustomSnackBarType.success,
          message:
              'Password recovery instructions has been sent to ${firebaseAuth.currentUser?.email}',
        );
      }
    } on FirebaseException catch (e) {
      showCustomSnackBar(
        context: context,
        message: e.message ?? '',
        type: CustomSnackBarType.error,
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      EasyLoading.dismiss();
      setState(() {});
    }
  }

  Future<void> uploadImage() async {
    try {
      EasyLoading.show();

      await fireStorage.uploadProfileImage(
        image: customImagePicker.selectedImage,
      );
      await firebaseAuth.currentUser?.reload();
    } on FirebaseException catch (e) {
      showCustomSnackBar(
        context: context,
        message: FirebaseErrorCodes().firebaseMessages(e: e),
        type: CustomSnackBarType.error,
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      EasyLoading.dismiss();
      setState(() {});
    }
  }

  Future<void> deleteImage() async {
    try {
      EasyLoading.show();
      await fireStorage.deleteProfileImage();
      await firebaseAuth.currentUser?.reload();
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        await cloudFire.updatePhotoURL(photoURL: null);
        await firebaseAuth.currentUser?.updatePhotoURL(null);
        return;
      }
      showCustomSnackBar(
        context: context,
        message: e.message ?? '',
        type: CustomSnackBarType.error,
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      EasyLoading.dismiss();
      setState(() {});
    }
  }

  Future<void> pickImage() async {
    final delete = await customImagePicker.showBottomSheet(context: context);
    if (customImagePicker.selectedImage != null && delete == false) {
      await uploadImage();
      customImagePicker.selectedImage = null;
      setState(() {});
    }
    if (delete == true) {
      deleteImage();
    }
  }

  @override
  void initState() {
    initUser();
    super.initState();
  }

  Future<void> initUser() async {
    // When the user resets the email via link it's only updated in firebaseAuth.
    // Update the firestore email if it's not the same as the firebaseAuth email
    try {
      final email = firebaseAuth.currentUser?.email;
      final user = await cloudFire.getUser(id: firebaseAuth.currentUser?.uid);

      if (user?.email != email) {
        await cloudFire.updateUserEmail(email: email);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    const editIcon = Icon(
      BootstrapIcons.pencil_square,
      color: kGrey,
    );
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(kContentSpacing16),
          child: Center(
            child: StreamBuilder<UserModel?>(
                stream: userStream,
                builder: (context, snapshot) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAvatar(),
                      const SizedBox(height: kContentSpacing32),
                      _buildTextFormField(
                        suffixIcon: editIcon,
                        hintText: snapshot.data?.displayName ??
                            firebaseAuth.currentUser?.displayName ??
                            '',
                        onTap: () async {
                          await navigateToScreen(
                            screen: const EditNameScreen(),
                          );
                        },
                      ),
                      const SizedBox(height: kContentSpacing8),
                      _buildTextFormField(
                        suffixIcon: providerId == fireAuth.providerIdGoogle
                            ? null
                            : editIcon,
                        hintText: firebaseAuth.currentUser?.email ?? '',
                        onTap: () async {
                          if (providerId == fireAuth.providerIdGoogle) {
                            return;
                          }

                          await navigateToScreen(
                            screen: const EditEmailScreen(),
                          );
                        },
                      ),
                      const SizedBox(height: kContentSpacing8),
                      _buildTextFormField(
                        suffixIcon: editIcon,
                        hintText: FormalDates.formatDmyyyy(
                                date: snapshot.data?.dateOfBirth?.toDate()) ??
                            '',
                        onTap: () async {
                          final signUpProvider = Provider.of<SignUpProvider>(
                            context,
                            listen: false,
                          );
                          await navigateToScreen(
                            screen:
                                ChangeNotifierProvider<SignUpProvider>.value(
                              value: signUpProvider,
                              child: const EditDateScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: kContentSpacing8),
                      _buildTextFormField(
                        suffixIcon: editIcon,
                        hintText: snapshot.data?.gender ?? '',
                        onTap: () async {
                          final signUpProvider = Provider.of<SignUpProvider>(
                            context,
                            listen: false,
                          );
                          await navigateToScreen(
                            screen:
                                ChangeNotifierProvider<SignUpProvider>.value(
                              value: signUpProvider,
                              child: const EditGenderScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: kContentSpacing8),
                      _buildTextFormField(
                        suffixIcon: editIcon,
                        hintText: snapshot.data?.church!['churchName'] ?? '',
                        onTap: () async {
                          final signUpProvider = Provider.of<SignUpProvider>(
                            context,
                            listen: false,
                          );
                          await navigateToScreen(
                            screen:
                                ChangeNotifierProvider<SignUpProvider>.value(
                              value: signUpProvider,
                              child: const EditChurch(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: kContentSpacing24),
                      _buildButton(
                        text: 'Reset password',
                        onPressed: resetPassword,
                      ),
                      const SizedBox(height: kContentSpacing8),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }

  dynamic _buildAppBar() {
    return AppBar(
      leading: const CustomBackButton(),
      title: Text(
        'Profile',
        style: Theme.of(context)
            .textTheme
            .headline6
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildAvatar() {
    return Center(
      child: GestureDetector(
        onTap: pickImage,
        child: Stack(
          children: [
            const CustomAvatar(radius: 72, iconSize: 42),
            Positioned(
              bottom: 10,
              right: 2,
              child: SizedBox(
                width: 42,
                height: 42,
                child: FloatingActionButton(
                  elevation: 0,
                  onPressed: pickImage,
                  child: IconButton(
                    iconSize: 20,
                    onPressed: pickImage,
                    icon: const Icon(BootstrapIcons.camera_fill),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String hintText,
    VoidCallback? onTap,
    Widget? suffixIcon,
  }) {
    return CustomTextFormField(
      hintStyle: Theme.of(context)
          .textTheme
          .bodyText1
          ?.copyWith(color: Colors.grey.shade600),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(width: kBoderWidth, color: kGrey),
      ),
      readOnly: true,
      onTap: onTap,
      hintText: hintText,
      suffixIcon: suffixIcon,
    );
  }

  Widget _buildButton({
    required String text,
    Color? textColor,
    VoidCallback? onPressed,
  }) {
    return GestureDetector(
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyText1?.copyWith(
              color: textColor,
            ),
      ),
      onTap: onPressed,
    );
  }
}
