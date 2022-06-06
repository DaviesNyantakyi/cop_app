import 'package:cop_belgium_app/models/question_answer_model.dart';

import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/responsive.dart';
import 'package:cop_belgium_app/utilities/validators.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class EditQuestionAnswerScreen extends StatefulWidget {
  final QuestionAnswerModel questionModel;
  const EditQuestionAnswerScreen({
    Key? key,
    required this.questionModel,
  }) : super(key: key);

  @override
  State<EditQuestionAnswerScreen> createState() =>
      _EditQuestionAnswerScreenState();
}

class _EditQuestionAnswerScreenState extends State<EditQuestionAnswerScreen> {
  TextEditingController? titleCntlr;
  TextEditingController? testimonyCntlr;

  final titleKey = GlobalKey<FormState>();
  final testimonyKey = GlobalKey<FormState>();

  final user = FirebaseAuth.instance.currentUser;

  // Future<void> updateTestimony() async {
  //   try {
  //     if (widget.questionModel.title.trim() == titleCntlr?.text.trim() &&
  //         widget.questionModel.testimony.trim() ==
  //             testimonyCntlr?.text.trim()) {
  //       Navigator.pop(context);
  //       return;
  //     }
  //     final validTitleForm = titleKey.currentState?.validate();
  //     final validTestimonyForm = testimonyKey.currentState?.validate();

  //     if (validTitleForm == true && validTestimonyForm == true) {
  //       TestimonyModel testimonyModel = widget.questionModel.copyWith(
  //         title: titleCntlr!.text.trim(),
  //         testimony: testimonyCntlr!.text.trim(),
  //       );

  //       EasyLoading.show();
  //       await CloudFire().updateTestimony(
  //         testimony: testimonyModel,
  //       );

  //       Navigator.pop(context);
  //     }
  //   } on FirebaseException catch (e) {
  //     kShowSnackbar(
  //       context: context,
  //       type: SnackBarType.error,
  //       message: e.message ?? '',
  //     );
  //     debugPrint(e.toString());
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   } finally {
  //     EasyLoading.dismiss();
  //   }
  // }

  @override
  void initState() {
    titleCntlr = TextEditingController(
      text: widget.questionModel.title,
    );
    testimonyCntlr = TextEditingController(
      text: widget.questionModel.question,
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
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontWeight: kFontWeightMedium),
                    hintStyle: Theme.of(context).textTheme.headline6?.copyWith(
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
          child: Text(
            'Update',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          onPressed: () {},
        )
      ],
    );
  }
}
