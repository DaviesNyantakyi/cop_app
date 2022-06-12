import 'package:cop_belgium_app/models/question_answer_model.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadQuestionAnswerScreen extends StatefulWidget {
  const ReadQuestionAnswerScreen({Key? key}) : super(key: key);

  @override
  State<ReadQuestionAnswerScreen> createState() =>
      _ReadQuestionAnswerScreenState();
}

class _ReadQuestionAnswerScreenState extends State<ReadQuestionAnswerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: kContentSpacing16,
          vertical: kContentSpacing24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTestimonyCard(),
            const SizedBox(height: kContentSpacing20),
            Text(
              'Comments',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: const CustomBackButton(),
    );
  }

  Widget _buildTestimonyCard() {
    return Consumer<QuestionAnswerModel>(
      builder: (context, qandAModel, _) {
        return const Text('Change to tesimony card');
      },
    );
  }
}
