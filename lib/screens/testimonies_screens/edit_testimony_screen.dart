import 'package:cop_belgium_app/models/testimony_model.dart';
import 'package:cop_belgium_app/services/cloud_fire.dart';

import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/responsive.dart';
import 'package:cop_belgium_app/utilities/validators.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:cop_belgium_app/widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:responsive_builder/responsive_builder.dart';

class EditTestimonyScreen extends StatefulWidget {
  final TestimonyModel testimonyModel;
  const EditTestimonyScreen({
    Key? key,
    required this.testimonyModel,
  }) : super(key: key);

  @override
  State<EditTestimonyScreen> createState() => _EditTestimonyScreenState();
}

class _EditTestimonyScreenState extends State<EditTestimonyScreen> {
  TextEditingController? titleCntlr;
  TextEditingController? testimonyCntlr;

  final titleKey = GlobalKey<FormState>();
  final testimonyKey = GlobalKey<FormState>();

  final user = FirebaseAuth.instance.currentUser;

  Future<void> updateTestimony() async {
    try {
      if (widget.testimonyModel.title.trim() == titleCntlr?.text.trim() &&
          widget.testimonyModel.testimony.trim() ==
              testimonyCntlr?.text.trim()) {
        Navigator.pop(context);
        return;
      }
      final validTitleForm = titleKey.currentState?.validate();
      final validTestimonyForm = testimonyKey.currentState?.validate();

      if (validTitleForm == true && validTestimonyForm == true) {
        TestimonyModel testimonyModel = widget.testimonyModel.copyWith(
          title: titleCntlr!.text.trim(),
          testimony: testimonyCntlr!.text.trim(),
        );

        EasyLoading.show();
        await CloudFire().updateTestimony(
          testimony: testimonyModel,
        );

        Navigator.pop(context);
      }
    } on FirebaseException catch (e) {
      showCustomSnackBar(
        context: context,
        type: SnackBarType.error,
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
    titleCntlr = TextEditingController(
      text: widget.testimonyModel.title,
    );
    testimonyCntlr = TextEditingController(
      text: widget.testimonyModel.testimony,
    );

    if (mounted) {
      setState(() {});
    }
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
                    focusedBorder: InputBorder.none,
                    validator: Validators.textValidator,
                    style: kFontH6.copyWith(fontWeight: kFontWeightMedium),
                    hintStyle: kFontH6.copyWith(
                      fontWeight: kFontWeightMedium,
                      color: kGrey,
                    ),
                  ),
                ),
                Form(
                  key: testimonyKey,
                  child: CustomTextFormField(
                    controller: testimonyCntlr,
                    hintText: 'What\'s your story?',
                    validator: Validators.textValidator,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
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
          child: const Text(
            'Update',
            style: kFontBody,
          ),
          onPressed: updateTestimony,
        )
      ],
    );
  }
}
