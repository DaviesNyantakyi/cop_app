import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:cop_belgium_app/utilities/constant.dart';

import 'package:cop_belgium_app/widgets/bottomsheet.dart';
import 'package:cop_belgium_app/widgets/dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CustomImagePicker {
  File? selectedImage;
  bool _delete = false;

  final FirebaseAuth? _firebaseAuth = FirebaseAuth.instance;

  final ImagePicker _picker = ImagePicker();

  // Cropp the image using the file path
  Future<File?> _imageCropper({File? file}) async {
    String? title = 'Edit photo';
    return await ImageCropper().cropImage(
      sourcePath: file!.path,
      androidUiSettings: AndroidUiSettings(
        toolbarColor: kGreyLight,
        toolbarTitle: title,
        initAspectRatio: CropAspectRatioPreset.square,
        showCropGrid: true,
        hideBottomControls: false,
      ),
      iosUiSettings: IOSUiSettings(
        title: title,
        minimumAspectRatio: 1.0,
      ),
    );
  }

  Future<XFile?> _pickImage({
    required BuildContext context,
    required ImageSource source,
  }) async {
    try {
      XFile? image;
      PermissionStatus? _status;

      if (source == ImageSource.gallery) {
        //Request access to photos
        _status = await Permission.photos.request();

        //Pick image
        if (_status == PermissionStatus.granted) {
          image = await _picker.pickImage(
            source: source,
          );
        }
      }

      // pick image from camera
      if (source == ImageSource.camera) {
        //Request access to camera
        _status = await Permission.camera.request();

        //Pick image
        if (_status == PermissionStatus.granted) {
          image = await _picker.pickImage(
            source: source,
          );
        }
      }

      // Ask to enable permissions
      if (_status == PermissionStatus.denied ||
          _status == PermissionStatus.permanentlyDenied ||
          _status == PermissionStatus.limited ||
          _status == PermissionStatus.restricted) {
        await _showPermissionDialog(context: context);
      }
      return image;
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<bool?> showBottomSheet({
    required BuildContext context,
  }) async {
    bool? deleteImage = await showCustomBottomSheet(
      backgroundColor: kWhite,
      padding: EdgeInsets.zero,
      context: context,
      child: Material(
        color: kWhite,
        child: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _selectionTile(
                context: context,
                icon: Icons.photo_camera_outlined,
                text: 'Camera',
                onPressed: () async {
                  final pickedFile = await _pickImage(
                    context: context,
                    source: ImageSource.camera,
                  );
                  if (pickedFile?.path != null) {
                    final croppedImage = await _imageCropper(
                      file: File(pickedFile!.path),
                    );

                    if (croppedImage != null) {
                      selectedImage = await _compresImage(
                        file: croppedImage,
                        targetPath: croppedImage.path,
                      );
                    }
                  }
                  _delete = false;
                  Navigator.pop(context, _delete);
                },
              ),
              _selectionTile(
                context: context,
                icon: Icons.collections_outlined,
                text: 'Gallery',
                onPressed: () async {
                  final pickedFile = await _pickImage(
                    context: context,
                    source: ImageSource.gallery,
                  );
                  if (pickedFile?.path != null) {
                    final croppedImage = await _imageCropper(
                      file: File(pickedFile!.path),
                    );

                    if (croppedImage != null) {
                      selectedImage = await _compresImage(
                        file: croppedImage,
                        targetPath: croppedImage.path,
                      );
                    }
                  }
                  _delete = false;
                  Navigator.pop(context, _delete);
                },
              ),
              showDeleteButton(context: context)
            ],
          ),
        ),
      ),
    );
    return deleteImage;
  }

  // If image url is not null, show delete button.
  // if the delete button is clicked

  Widget _selectionTile({
    required VoidCallback onPressed,
    required BuildContext context,
    required IconData icon,
    required String text,
    Color? color,
  }) {
    return ListTile(
      onTap: onPressed,
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        text,
        style: TextStyle(color: color),
      ),
    );
  }

  Future<File?> _compresImage({
    required File file,
    required String targetPath,
  }) async {
    File? compressedImage;
    try {
      debugPrint('original image size:${file.lengthSync()}');
      compressedImage = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath + 'compressed.jpg',
        quality: 10,
      );
      debugPrint('compressed image size:${compressedImage?.lengthSync()}');
    } on UnsupportedError catch (e) {
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
    return compressedImage;
  }

  Future<void> _showPermissionDialog({required BuildContext context}) async {
    return showCustomDialog(
      barrierDismissible: true,
      context: context,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 100,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: kBlue,
              borderRadius: BorderRadius.all(
                Radius.circular(kRadius),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.photo_camera_outlined,
                  color: Colors.white,
                  size: 32,
                ),
                Icon(
                  Icons.add_outlined,
                  color: Colors.white,
                  size: 32,
                ),
                Icon(
                  Icons.folder_outlined,
                  color: Colors.white,
                  size: 32,
                ),
              ],
            ),
          ),
          const SizedBox(height: kContentSpacing12),
          Text(
            'Give COP Belgium access to your device\'s Camera and Media files.',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
      actions: <Widget>[
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: SizedBox(
            height: double.infinity,
            child: Center(
              child: Text(
                'Not now',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            Navigator.pop(context);
            await AppSettings.openAppSettings();
          },
          child: SizedBox(
            height: double.infinity,
            child: Center(
              child: Text(
                'Settings',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget showDeleteButton({required BuildContext context}) {
    // Show the delete button if firbase photourl is not null
    if (_firebaseAuth?.currentUser?.photoURL != null) {
      return _selectionTile(
        context: context,
        icon: Icons.delete_outline,
        color: Colors.red,
        text: 'Delete',
        onPressed: () async {
          _delete = true;
          Navigator.pop(context, _delete);
        },
      );
    }

    // Show no delete button because the firebase photoURL is null.
    return Container();
  }
}
