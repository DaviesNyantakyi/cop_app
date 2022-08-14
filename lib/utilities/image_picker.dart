import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:cop_belgium_app/utilities/constant.dart';

import 'package:cop_belgium_app/widgets/bottomsheet.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    String? title = 'EDIT PHOTO';
    return await ImageCropper().cropImage(
      sourcePath: file!.path,
      androidUiSettings: AndroidUiSettings(
        toolbarColor: kGreyLight,
        toolbarTitle: title,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
        hideBottomControls: true,
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

      if (source == ImageSource.gallery) {
        // pick image from storage if permission granted.
        var status = await Permission.storage.request();
        if (status == PermissionStatus.granted) {
          image = await _picker.pickImage(
            source: source,
          );
        }
        // If the permission permanlty denied showdialog
        if (status == PermissionStatus.permanentlyDenied) {
          await _showPermissionDialog(
            headerWidget: const Icon(
              Icons.folder,
              color: Colors.white,
              size: 32,
            ),
            context: context,
            instructions:
                'Tap Settings > Permissions and turn on Media Permissions.',
          );
        }
        return image;
      }

      // pick image from storage and camera if permission granted.
      if (source == ImageSource.camera) {
        //Request camera and storage permission.
        var statusCamera = await Permission.camera.request();
        var statusStorage = await Permission.storage.request();

        //pick image if the permission is granted.
        if (statusStorage == PermissionStatus.granted &&
            statusCamera == PermissionStatus.granted) {
          image = await _picker.pickImage(
            source: source,
          );
        }

        // Ask to enable permission if permanlty denied.
        if (statusStorage == PermissionStatus.permanentlyDenied ||
            statusCamera == PermissionStatus.permanentlyDenied) {
          await _showPermissionDialog(
            headerWidget: Row(
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
            context: context,
            instructions:
                'Tap Settings > Permissions and turn on Camera and Media Permissions.',
          );
        }
        return image;
      }
      return null;
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<bool?> showBottomSheet({
    required BuildContext context,
  }) async {
    bool? deleteImage = await showCustomBottomSheet(
      context: context,
      child: Material(
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
                    selectedImage = await _imageCropper(
                      file: File(pickedFile!.path),
                    );
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
                    selectedImage = await _imageCropper(
                      file: File(pickedFile!.path),
                    );
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

  Widget _selectionTile(
      {required VoidCallback onPressed,
      required BuildContext context,
      required IconData icon,
      required String text,
      Color? color}) {
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

  Future<String?> _showPermissionDialog({
    required BuildContext context,
    required String instructions,
    required Widget headerWidget,
  }) async {
    return showCustomDialog(
      barrierDismissible: true,
      context: context,
      title: Column(
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
            child: headerWidget,
          ),
          Text(
            'Give COP Belgium access to your device\'s camera and media files.',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            instructions,
            style: Theme.of(context).textTheme.bodyText1,
          )
        ],
      ),
      actions: Row(children: <Widget>[
        CustomElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Not now', style: Theme.of(context).textTheme.bodyText1),
        ),
        CustomElevatedButton(
          onPressed: () async {
            Navigator.pop(context);
            await AppSettings.openAppSettings();
          },
          child: Text('Settings', style: Theme.of(context).textTheme.bodyText1),
        ),
      ]),
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
