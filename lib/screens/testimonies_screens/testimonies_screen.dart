import 'package:cop_belgium_app/models/testimony_model.dart';

import 'package:cop_belgium_app/screens/testimonies_screens/create_testmony_screen.dart';
import 'package:cop_belgium_app/screens/testimonies_screens/edit_testimony_screen.dart';
import 'package:cop_belgium_app/screens/testimonies_screens/widgets/testimony_content.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/dialog.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:cop_belgium_app/widgets/social_card.dart';
import 'package:cop_belgium_app/services/cloud_fire.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/widgets/custom_error_widget.dart';
import 'package:cop_belgium_app/widgets/custom_screen_placeholder.dart';
import 'package:cop_belgium_app/widgets/progress_indicator.dart';
import 'package:cop_belgium_app/widgets/social_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TestimoniesScreen extends StatefulWidget {
  const TestimoniesScreen({Key? key}) : super(key: key);

  @override
  State<TestimoniesScreen> createState() => _TestimoniesScreenState();
}

class _TestimoniesScreenState extends State<TestimoniesScreen> {
  final testimoniesStream = CloudFire().getTestimonies();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> deleteTestimony({required TestimonyModel testimonyModel}) async {
    try {
      Navigator.pop(context);
      EasyLoading.show();
      await CloudFire().deleteTestimony(
        testimonyModel: testimonyModel,
      );
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
    }
  }

  Future<void> showDeleteDialog({
    required TestimonyModel testimonyModel,
  }) async {
    showCustomDialog(
      context: context,
      title: Text(
        'Delete testimony?',
        style: Theme.of(context)
            .textTheme
            .bodyText1
            ?.copyWith(fontWeight: kFontWeightMedium),
      ),
      actions: [
        CustomElevatedButton(
          padding: EdgeInsets.zero,
          child: Text(
            'Cancel',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CustomElevatedButton(
          child: Text(
            'Delete',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(color: kRed),
          ),
          onPressed: () => deleteTestimony(testimonyModel: testimonyModel),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: StreamBuilder<List<TestimonyModel>>(
        stream: testimoniesStream,
        builder: (context, snapshot) {
          List<TestimonyModel>? testimonies = snapshot.data;
          if (snapshot.hasError) {
            return CustomErrorWidget(
              onPressed: () {
                // just reload the screen when there is an error.
                setState(() {});
              },
            );
          }

          if (snapshot.data != null && testimonies!.isEmpty) {
            return const CustomScreenPlaceholder();
          }

          if (snapshot.hasData) {
            return _buildBody(testimonies: testimonies);
          }

          return const Center(
            child: CustomCircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(context: context),
    );
  }

  SafeArea _buildBody({List<TestimonyModel>? testimonies}) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: kContentSpacing16,
          vertical: kContentSpacing24,
        ),
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: testimonies?.length ?? 0,
          shrinkWrap: true,
          separatorBuilder: (context, index) => const SizedBox(
            height: kContentSpacing8,
          ),
          itemBuilder: (context, index) {
            return _buildSocialCard(
              testimonyModel: testimonies![index],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSocialCard({required TestimonyModel testimonyModel}) {
    return SocialCard(
      socialAvatar: SocialAvatar(
        createdAt: testimonyModel.createdAt,
        uid: testimonyModel.uid,
        displayName: testimonyModel.displayName ?? '',
      ),
      content: TestimonyContent(testimony: testimonyModel),
      menuItems: testimonyModel.uid != _firebaseAuth.currentUser?.uid
          ? null
          : [
              PopupMenuItem(
                value: 'edit',
                child: Text(
                  'Edit',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Text(
                  'Delete',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: kRed),
                ),
              )
            ],
      onPressedCard: () {},
      onSelectMenuItem: (selectedItem) {
        if (selectedItem == 'delete') {
          showDeleteDialog(testimonyModel: testimonyModel);
        }
        if (selectedItem == 'edit') {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => EditTestimonyScreen(
                testimonyModel: testimonyModel,
              ),
            ),
          );
        }
      },
    );
  }

  FloatingActionButton _buildFloatingActionButton({
    required BuildContext context,
  }) {
    return FloatingActionButton(
      tooltip: 'Create testimony',
      backgroundColor: kBlue,
      child: const Icon(
        Icons.add,
      ),
      onPressed: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => const CreateTestimonyScreen(),
          ),
        );
      },
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    return AppBar(
      leading: const CustomBackButton(),
      title: Text(
        'Testimonies',
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }
}
