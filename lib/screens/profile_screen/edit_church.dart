import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../providers/signup_provider.dart';
import '../../services/cloud_fire.dart';
import '../../utilities/connection_checker.dart';
import '../../widgets/back_button.dart';
import '../../widgets/snackbar.dart';
import '../church_selection_screen/church_selection_screen.dart';

class EditChurch extends StatefulWidget {
  const EditChurch({Key? key}) : super(key: key);

  @override
  State<EditChurch> createState() => _EditChurchState();
}

class _EditChurchState extends State<EditChurch> {
  final _cloudFire = CloudFire();
  final firebaseAuth = FirebaseAuth.instance;
  late SignUpProvider signUpProvider;
  UserModel? user;

  @override
  void initState() {
    signUpProvider = Provider.of<SignUpProvider>(context, listen: false);

    init();

    super.initState();
  }

  @override
  void dispose() {
    signUpProvider.close();
    super.dispose();
  }

  Future<void> init() async {
    user = await CloudFire().getUser(id: firebaseAuth.currentUser?.uid);

    setState(() {});
  }

  Future<void> update() async {
    try {
      bool hasConnection = await ConnectionNotifier().checkConnection();

      if (hasConnection) {
        if (signUpProvider.selectedChurch?.id != user?.church!['id']) {
          EasyLoading.show();

          await _cloudFire.updateUserChurch(
            id: signUpProvider.selectedChurch!.id!,
            churchName: signUpProvider.selectedChurch!.churchName,
          );
        }
      } else {
        throw ConnectionNotifier.connectionException;
      }
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      debugPrint(e.toString());

      showCustomSnackBar(
        context: context,
        type: CustomSnackBarType.error,
        message: e.message ?? '',
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChurchSelectionScreen(
      appBar: _buildAppBar(),
      onTap: (selectedChurch) async {
        if (selectedChurch != null) {
          signUpProvider.setSelectedChurch(value: selectedChurch);
          await update();
        }
      },
    );
  }

  dynamic _buildAppBar() {
    return AppBar(
      leading: const CustomBackButton(),
      title: Text('Church',
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(fontWeight: FontWeight.bold)),
    );
  }
}
