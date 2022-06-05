import 'package:cop_belgium_app/models/testimony_model.dart';

import 'package:cop_belgium_app/screens/testimonies_screens/create_testmony_screen.dart';
import 'package:cop_belgium_app/services/cloud_fire.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/custom_error_widget.dart';
import 'package:cop_belgium_app/widgets/custom_screen_placeholder.dart';
import 'package:cop_belgium_app/widgets/progress_indicator.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuestionAnswerScreen extends StatefulWidget {
  const QuestionAnswerScreen({Key? key}) : super(key: key);

  @override
  State<QuestionAnswerScreen> createState() => _QuestionAnswerScreenState();
}

class _QuestionAnswerScreenState extends State<QuestionAnswerScreen> {
  final testimoniesStream = CloudFire().getTestimonies();
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
            return _buildBody();
          }

          return const Center(
            child: CustomCircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(context: context),
    );
  }

  SafeArea _buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: kContentSpacing16,
          vertical: kContentSpacing24,
        ),
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 100,
          shrinkWrap: true,
          separatorBuilder: (context, index) => const SizedBox(
            height: kContentSpacing8,
          ),
          itemBuilder: (context, index) {
            return const Text('Change to tesimony card');
          },
        ),
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
            builder: (context) => const CreateTestimonyScreen(),
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
