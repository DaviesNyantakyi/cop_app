import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cop_belgium_app/providers/signup_provider.dart';
import 'package:cop_belgium_app/screens/profile_screen/edit_church.dart';
import 'package:cop_belgium_app/screens/profile_screen/edit_date_screen.dart';
import 'package:cop_belgium_app/screens/profile_screen/edit_email_screen.dart';
import 'package:cop_belgium_app/screens/profile_screen/edit_gender_screen.dart';
import 'package:cop_belgium_app/screens/profile_screen/edit_name_screen.dart';
import 'package:cop_belgium_app/utilities/formal_dates.dart';
import 'package:cop_belgium_app/widgets/avatar.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:cop_belgium_app/widgets/text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../services/cloud_fire.dart';
import '../../services/fire_auth.dart';
import '../../services/fire_storage.dart';
import '../../utilities/constant.dart';
import '../../utilities/validators.dart';
import '../../widgets/back_button.dart';
import '../../widgets/dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final firebaseAuth = FirebaseAuth.instance;
  final fireAuth = FireAuth();
  final providerId =
      FirebaseAuth.instance.currentUser?.providerData[0].providerId;

  TextEditingController passwordCntrl = TextEditingController();
  final passwordKey = GlobalKey<FormState>();

  late final userStream = CloudFire().getUserStream(
    uid: FirebaseAuth.instance.currentUser!.uid,
  );

  Future<void> navigateToScreen({required Widget screen}) async {
    // Go to the welcome screen if the user is anonymous
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => screen,
      ),
    );
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

  Future<void> deleteAccount() async {
    try {
      Navigator.pop(context);
      EasyLoading.show();

      final validPassword = passwordKey.currentState?.validate();

      if (validPassword == true && passwordCntrl.text.isNotEmpty) {
        await FireAuth().deleteAccount(password: passwordCntrl.text);

        // Pop dialog and and current screen.
        if (mounted) {
          Navigator.of(context).pop();
        }
      }

      if (providerId == 'google.com') {
        await FireAuth().deleteAccount(password: passwordCntrl.text);
        // Pop dialog and and current screen.
        if (mounted) {
          Navigator.of(context).pop();
        }
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

  Future<void> showDeleteDialog() async {
    passwordCntrl.clear();
    passwordKey.currentState?.reset();
    showCustomDialog(
      context: context,
      title: const Text(
        'Delete account?',
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'This action cannot be undone and all content will be lost.',
          ),
          const SizedBox(height: kContentSpacing8),
          _buildPasswordField(),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          onPressed: deleteAccount,
          child: const Text(
            'Delete',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final providerId = firebaseAuth.currentUser?.providerData[0].providerId;
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
                        hintText: snapshot.data?.email ??
                            firebaseAuth.currentUser?.email ??
                            '',
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
                      _buildButton(
                        text: 'Delete account',
                        textColor: kRed,
                        onPressed: showDeleteDialog,
                      ),
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
        child: Stack(
          children: [
            const CustomAvatar(radius: 80, iconSize: 42),
            Positioned(
              bottom: 10,
              right: 2,
              child: SizedBox(
                width: 48,
                height: 48,
                child: FloatingActionButton(
                  elevation: 0,
                  onPressed: () {},
                  child: IconButton(
                    iconSize: 24,
                    onPressed: () {},
                    icon: const Icon(BootstrapIcons.camera_fill),
                  ),
                ),
              ),
            )
          ],
        ),
        onTap: () {},
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
    return CustomElevatedButton(
      padding: EdgeInsets.zero,
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyText1?.copyWith(
              color: textColor,
            ),
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildPasswordField() {
    if (providerId == 'google.com') {
      return Container();
    }
    return Form(
      key: passwordKey,
      child: CustomTextFormField(
        controller: passwordCntrl,
        maxLines: 1,
        hintText: 'Password',
        obscureText: true,
        validator: Validators.passwordValidator,
      ),
    );
  }
}
