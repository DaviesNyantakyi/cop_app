import 'package:cached_network_image/cached_network_image.dart';
import 'package:cop_belgium_app/services/fire_storage.dart';
import 'package:cop_belgium_app/utilities/connection_checker.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/image_picker.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ProfilePickerScreen extends StatefulWidget {
  final VoidCallback? onSubmit;
  final PreferredSizeWidget? appBar;

  final Future<bool> Function()? onWillPop;

  const ProfilePickerScreen({
    Key? key,
    required this.onSubmit,
    this.appBar,
    this.onWillPop,
  }) : super(key: key);

  @override
  State<ProfilePickerScreen> createState() => _ProfilePickerScreenState();
}

class _ProfilePickerScreenState extends State<ProfilePickerScreen> {
  final _firebaseAuth = FirebaseAuth.instance;
  final MyImagePicker myImagePicker = MyImagePicker();

  Future<void> uploadImage() async {
    try {
      EasyLoading.show();

      await FireStorage().uploadProfileImage(
        image: myImagePicker.selectedImage,
      );
      await _firebaseAuth.currentUser?.reload();
    } on FirebaseException catch (e) {
      showCustomSnackBar(
        context: context,
        type: CustomSnackBarType.error,
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
      showCustomSnackBar(
        context: context,
        type: CustomSnackBarType.error,
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
    try {
      final hasconnection = await ConnectionNotifier().checkConnection();
      if (hasconnection) {
        final delete = await myImagePicker.showBottomSheet(context: context);
        if (myImagePicker.selectedImage != null && delete == false) {
          await uploadImage();
          myImagePicker.selectedImage = null;
          setState(() {});
        }
        if (delete == true) {
          deleteImage();
        }
      } else {
        throw ConnectionNotifier.connectionException;
      }
    } on FirebaseException catch (e) {
      debugPrint(e.toString());

      showCustomSnackBar(
        context: context,
        type: CustomSnackBarType.error,
        message: e.message ?? '',
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: widget.onWillPop,
      child: Scaffold(
        appBar: widget.appBar,
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
                _submitButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text _headerText() {
    return Text(
      'Add profile image',
      style: Theme.of(context).textTheme.headline5,
    );
  }

  Widget _buildAvatar() {
    ImageProvider? image;
    Widget icon = const Icon(
      Icons.person_outline_rounded,
      color: kBlack,
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

  Widget _submitButton() {
    return CustomElevatedButton(
      height: kButtonHeight,
      width: double.infinity,
      backgroundColor: kBlue,
      child: Text(
        'Done',
        style: Theme.of(context).textTheme.bodyText1?.copyWith(color: kWhite),
      ),
      onPressed: widget.onSubmit,
    );
  }
}
