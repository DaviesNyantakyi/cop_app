import 'package:cop_belgium_app/services/cloud_fire.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../models/user_model.dart';
import '../../services/fire_auth.dart';
import '../../utilities/validators.dart';
import '../../widgets/text_form_field.dart';

class EditNameScreen extends StatefulWidget {
  const EditNameScreen({Key? key}) : super(key: key);

  @override
  State<EditNameScreen> createState() => _EditNameScreenState();
}

class _EditNameScreenState extends State<EditNameScreen> {
  TextEditingController? firstNameCntlr;
  final firstNameKey = GlobalKey<FormState>();
  TextEditingController? lastNameCntlr;
  final lastNameKey = GlobalKey<FormState>();

  final fireAuth = FireAuth();
  final firebaseAuth = FirebaseAuth.instance;

  UserModel? user;

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    firstNameCntlr?.dispose();
    firstNameKey.currentState?.dispose();
    lastNameCntlr?.dispose();
    lastNameKey.currentState?.dispose();
    super.dispose();
  }

  Future<void> init() async {
    user = await CloudFire().getUser(id: firebaseAuth.currentUser?.uid);
    firstNameCntlr = TextEditingController(text: user?.firstName);
    lastNameCntlr = TextEditingController(text: user?.lastName);
    setState(() {});
  }

  Future<void> update() async {
    try {
      final displayName =
          '${firstNameCntlr?.text.trim()} ${lastNameCntlr?.text.trim()}';
      if (firstNameCntlr?.text != null &&
          lastNameCntlr?.text != null &&
          displayName != firebaseAuth.currentUser?.displayName) {
        EasyLoading.show();

        await fireAuth.updateDisplayName(
          firstName: firstNameCntlr!.text,
          lastName: lastNameCntlr!.text,
        );
      }
      if (mounted) {
        Navigator.pop(context);
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(kContentSpacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFirstNameField(),
              const SizedBox(height: kContentSpacing8),
              _buildLastNameField(),
              const SizedBox(height: kContentSpacing32),
              _buildUpdateButton(),
            ],
          ),
        ),
      ),
    );
  }

  dynamic _buildAppBar() {
    return AppBar(
      leading: const CustomBackButton(),
      title: Text(
        'Name',
        style: Theme.of(context)
            .textTheme
            .headline6
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildFirstNameField() {
    return Form(
      key: firstNameKey,
      child: CustomTextFormField(
        controller: firstNameCntlr,
        maxLines: 1,
        validator: Validators.nameValidator,
        textInputAction: TextInputAction.next,
        // validateMode: AutovalidateMode.onUserInteraction,
        onSubmitted: (value) {},
      ),
    );
  }

  Widget _buildLastNameField() {
    return Form(
      key: lastNameKey,
      child: CustomTextFormField(
        controller: lastNameCntlr,
        maxLines: 1,
        validator: Validators.nameValidator,
        textInputAction: TextInputAction.done,
        // validateMode: AutovalidateMode.onUserInteraction,
        onSubmitted: (value) async {
          await update();
        },
      ),
    );
  }

  Widget _buildUpdateButton() {
    return CustomElevatedButton(
      height: kButtonHeight,
      backgroundColor: kBlue,
      width: double.infinity,
      child: Text(
        'Update',
        style: Theme.of(context)
            .textTheme
            .bodyText1
            ?.copyWith(fontWeight: FontWeight.bold, color: kWhite),
      ),
      onPressed: update,
    );
  }
}
