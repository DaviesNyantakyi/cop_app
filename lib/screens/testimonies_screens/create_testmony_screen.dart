import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cop_belgium_app/models/testimony_model.dart';
import 'package:cop_belgium_app/services/cloud_fire.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/responsive.dart';
import 'package:cop_belgium_app/utilities/validators.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:cop_belgium_app/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CreateTestimonyScreen extends StatefulWidget {
  const CreateTestimonyScreen({Key? key}) : super(key: key);

  @override
  State<CreateTestimonyScreen> createState() => _CreateTestimonyScreenState();
}

class _CreateTestimonyScreenState extends State<CreateTestimonyScreen> {
  TextEditingController titleCntlr = TextEditingController();
  TextEditingController descriptionCntlr = TextEditingController();

  final titleKey = GlobalKey<FormState>();
  final descriptionKey = GlobalKey<FormState>();

  final user = FirebaseAuth.instance.currentUser;

  Future<void> createTestimony() async {
    try {
      final validTitleForm = titleKey.currentState?.validate();
      final validTestimonyForm = descriptionKey.currentState?.validate();

      if (validTitleForm == true &&
          validTestimonyForm == true &&
          titleCntlr.text.isNotEmpty &&
          descriptionCntlr.text.isNotEmpty &&
          user != null &&
          user?.uid != null) {
        TestimonyModel testimonyModel = TestimonyModel(
          userId: user!.uid,
          title: titleCntlr.text,
          description: descriptionCntlr.text,
          displayName: user?.displayName,
          createdAt: Timestamp.fromDate(DateTime.now()),
        );

        EasyLoading.show();
        final result = await CloudFire().createTestimony(
          testimony: testimonyModel,
        );
        if (result == true) {
          Navigator.pop(context);
        }
      }
    } on FirebaseException catch (e) {
      showCustomSnackBar(
        context: context,
        type: CustomSnackBarType.error,
        message: e.message ?? '',
      );
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, screenInfo) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: screenInfo.screenSize.width >= kScreenSizeTablet
                  ? kContentSpacing24
                  : kContentSpacing16,
              vertical: kContentSpacing24,
            ),
            child: Column(
              children: [
                Form(
                  key: titleKey,
                  child: CustomTextFormField(
                    controller: titleCntlr,
                    hintText: 'Title',
                    border: InputBorder.none,
                    maxLines: 1,
                    focusedBorder: InputBorder.none,
                    validator: Validators.textValidator,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontWeight: FontWeight.w500),
                    hintStyle: Theme.of(context).textTheme.headline6?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: kGrey,
                        ),
                  ),
                ),
                Form(
                  key: descriptionKey,
                  child: CustomTextFormField(
                    controller: descriptionCntlr,
                    hintText: 'What\'s your story?',
                    validator: Validators.textValidator,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    onSubmitted: (value) {},
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: const CustomBackButton(),
      actions: [
        CustomElevatedButton(
          child: Text(
            'Create',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          onPressed: createTestimony,
        )
      ],
    );
  }
}
