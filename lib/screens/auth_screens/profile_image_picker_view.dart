import 'package:cached_network_image/cached_network_image.dart';
import 'package:cop_belgium_app/providers/signup_notifier.dart';
import 'package:cop_belgium_app/services/fire_storage.dart';
import 'package:cop_belgium_app/utilities/connection_checker.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/image_picker.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class ProfileImagePickerView extends StatefulWidget {
  const ProfileImagePickerView({Key? key}) : super(key: key);

  @override
  State<ProfileImagePickerView> createState() => _ProfileImagePickerViewState();
}

class _ProfileImagePickerViewState extends State<ProfileImagePickerView> {
  final _firebaseAuth = FirebaseAuth.instance;
  final MyImagePicker myImagePicker = MyImagePicker();

  Future<void> uploadImage() async {
    try {
      EasyLoading.show();

      await FireStorage().uploadProfileImage(
        image: myImagePicker.image,
        // delete: false,
      );
      await _firebaseAuth.currentUser?.reload();
    } on FirebaseException catch (e) {
      kShowSnackbar(
        context: context,
        type: SnackBarType.error,
        message: e.message ?? '',
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
      await FireStorage().deleteProfileImage();
      await _firebaseAuth.currentUser?.reload();
    } on FirebaseException catch (e) {
      kShowSnackbar(
        context: context,
        type: SnackBarType.error,
        message: e.message ?? '',
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      EasyLoading.dismiss();
      setState(() {});
    }
  }

  Future<void> pickImage() async {
    final delete = await myImagePicker.showBottomSheet(context: context);
    if (myImagePicker.image != null && delete == false) {
      await uploadImage();
      myImagePicker.image = null;
      setState(() {});
    }
    if (delete == true) {
      deleteImage();
    }
  }

  Future<void> _previousPage() async {
    await Provider.of<PageController>(context, listen: false).previousPage(
      duration: kPagViewDuration,
      curve: kPagViewCurve,
    );
  }

  Future<void> submit() async {
    bool hasConnection = await ConnectionChecker().checkConnection();

    if (hasConnection) {
      await Provider.of<PageController>(context, listen: false).nextPage(
        duration: kPagViewDuration,
        curve: kPagViewCurve,
      );
    } else {
      kShowSnackbar(
        context: context,
        type: SnackBarType.error,
        message: ConnectionChecker.connectionException.message ?? '',
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _previousPage();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: CustomBackButton(onPressed: _previousPage),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: kContentSpacing16,
              vertical: kContentSpacing24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _headerText(),
                const SizedBox(height: kContentSpacing32),
                _buildAvatar(),
                const SizedBox(height: kContentSpacing32),
                _continueButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text _headerText() {
    return const Text(
      'Add profile image',
      style: kFontH5,
    );
  }

  Widget _buildAvatar() {
    ImageProvider? image;
    Widget icon = const Icon(
      Icons.person_outline_rounded,
      color: Colors.black45,
      size: 50,
    );

    if (_firebaseAuth.currentUser?.photoURL != null) {
      image = CachedNetworkImageProvider(
        _firebaseAuth.currentUser!.photoURL!,
      );
      icon = Container();
    }

    return GestureDetector(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 80,
            backgroundColor: kGreyLight,
            backgroundImage: image,
            child: icon,
          ),
          const Positioned(
            bottom: 8,
            right: 8,
            child: CircleAvatar(
              backgroundColor: kBlue,
              child: Icon(Icons.edit, color: kWhite),
            ),
          )
        ],
      ),
      onTap: pickImage,
    );
  }

  Widget _continueButton() {
    return Consumer<SignUpNotifier>(
      builder: (context, signUpNotifier, _) {
        return CustomElevatedButton(
          width: double.infinity,
          backgroundColor: kBlue,
          child: Text(
            'Continue',
            style: kFontBody.copyWith(color: kWhite),
          ),
          onPressed: submit,
        );
      },
    );
  }
}
