import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cop_belgium_app/main.dart';
import 'package:cop_belgium_app/models/question_answer_model.dart';
import 'package:cop_belgium_app/screens/question_answer_screen/create_question_answer_screen.dart';
import 'package:cop_belgium_app/screens/question_answer_screen/edit_question_answer_screen.dart';

import 'package:cop_belgium_app/services/cloud_fire.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/formal_date_format.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/custom_error_widget.dart';
import 'package:cop_belgium_app/widgets/dialog.dart';
import 'package:cop_belgium_app/widgets/progress_indicator.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:cop_belgium_app/widgets/social_avatar.dart';
import 'package:cop_belgium_app/widgets/social_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class QuestionAnswerScreen extends StatefulWidget {
  const QuestionAnswerScreen({Key? key}) : super(key: key);

  @override
  State<QuestionAnswerScreen> createState() => _QuestionAnswerScreenState();
}

class _QuestionAnswerScreenState extends State<QuestionAnswerScreen> {
  final testimoniesStream = CloudFire().getQuestionAnswersStream();

  Future<void> deleteQuestion({
    required QuestionAnswerModel questionAnswerModel,
  }) async {
    try {
      Navigator.pop(context);
      EasyLoading.show();
      await CloudFire().deleteQuestion(
        questionAnswerModel: questionAnswerModel,
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
    required QuestionAnswerModel questionAnswerModel,
  }) async {
    showCustomDialog(
      context: context,
      title: Text(
        'Delete testimony?',
        style: Theme.of(context)
            .textTheme
            .bodyText1
            ?.copyWith(fontWeight: FontWeight.w500),
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
          onPressed: () => deleteQuestion(
            questionAnswerModel: questionAnswerModel,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: StreamBuilder<List<QuestionAnswerModel>>(
        stream: testimoniesStream,
        builder: (context, snapshot) {
          List<QuestionAnswerModel>? questionAnswers = snapshot.data;
          if (snapshot.hasError) {
            return CustomErrorWidget(
              onPressed: () {
                setState(() {});
              },
            );
          }

          if (snapshot.data != null && questionAnswers!.isEmpty) {
            return Center(
              child: SingleChildScrollView(
                child: Text(
                  'Ask a question',
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (snapshot.hasData) {
            return _buildBody(questionAnswers: questionAnswers);
          }

          return const Center(
            child: CustomCircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(context: context),
    );
  }

  SafeArea _buildBody({List<QuestionAnswerModel>? questionAnswers}) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: kContentSpacing16,
          vertical: kContentSpacing24,
        ),
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: questionAnswers?.length ?? 0,
          shrinkWrap: true,
          separatorBuilder: (context, index) => const SizedBox(
            height: kContentSpacing8,
          ),
          itemBuilder: (context, index) {
            return SocialCard(
              avatar: SocialAvatar(
                imageURL: unsplash,
                headerText: Text(
                  'Davies Nayntakyi',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                subheaderText: Text(
                  FormalDates.timeAgo(
                        date: DateTime.now(),
                      ) ??
                      '',
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    questionAnswers?[index].title ?? '',
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: kContentSpacing4),
                  Text(
                    questionAnswers?[index].description ?? '',
                    maxLines: 4,
                    style: Theme.of(context).textTheme.bodyText1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              footer: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('question_answers')
                        .doc(questionAnswers?[index].id)
                        .collection('likes')
                        .snapshots(),
                    builder: (context, snaphot) {
                      final docs = snaphot.data?.docs ?? [];
                      int likes = docs.length;
                      bool liked = false;
                      for (var doc in docs) {
                        if (doc.data()['id'] ==
                            FirebaseAuth.instance.currentUser?.uid) {
                          liked = true;
                        }
                      }

                      return _buildIconButton(
                        icon: liked ? Icons.favorite : Icons.favorite_outline,
                        text: '$likes',
                        iconColor: liked ? kRed : kBlack,
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('question_answers')
                              .doc(questionAnswers?[index].id)
                              .collection('likes')
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .set({
                            'id': FirebaseAuth.instance.currentUser?.uid,
                            'date': DateTime.now().toUtc()
                          });
                        },
                      );
                    },
                  ),
                  const SizedBox(width: kContentSpacing12),
                  _buildIconButton(
                    icon: Icons.comment,
                    text: '200',
                    onPressed: () {},
                    iconColor: kBlack,
                  ),
                ],
              ),
              menuItems: [
                PopupMenuItem<String>(
                  value: 'edit',
                  child: Text(
                    'Edit',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Text(
                    'Delete',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(color: kRed),
                  ),
                )
              ],
              onPressed: () {},
              onSelectMenuItem: (value) {
                if (value == 'edit') {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => EditQuestionAnswerScreen(
                        questionModel: questionAnswers![index],
                      ),
                    ),
                  );
                }
                if (value == 'delete') {
                  showDeleteDialog(
                    questionAnswerModel: questionAnswers![index],
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    Color? iconColor,
    required String text,
    VoidCallback? onPressed,
  }) {
    return CustomElevatedButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: iconColor ?? kBlack,
            size: 20,
          ),
          const SizedBox(width: kContentSpacing4),
          Text(
            text,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
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
            builder: (context) => const CreateQuestionAnswerScreen(),
          ),
        );
      },
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    return AppBar(
      title: Text(
        'Q&A',
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }
}
