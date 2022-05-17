import 'package:cop_belgium_app/models/testimony_model.dart';
import 'package:cop_belgium_app/models/user_model.dart';
import 'package:cop_belgium_app/screens/podcast_screens/podcast_player_screen.dart';
import 'package:cop_belgium_app/screens/podcast_screens/podcast_screen.dart';
import 'package:cop_belgium_app/screens/testimonies_screens/create_testmony_screen.dart';
import 'package:cop_belgium_app/screens/testimonies_screens/widgets/testimony_card.dart';
import 'package:cop_belgium_app/services/cloud_fire.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/formal_date_format.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:cop_belgium_app/widgets/custom_error_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestimoniesScreen extends StatefulWidget {
  const TestimoniesScreen({Key? key}) : super(key: key);

  @override
  State<TestimoniesScreen> createState() => _TestimoniesScreenState();
}

class _TestimoniesScreenState extends State<TestimoniesScreen> {
  final testimoniesStream = CloudFire().getTestimonies();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: StreamBuilder<List<TestimonyModel>>(
        stream: testimoniesStream,
        builder: (context, snapshot) {
          List<TestimonyModel>? testmonies = snapshot.data;
          if (snapshot.hasError) {
            return CustomErrorWidget(
              onPressed: () {},
            );
          }

          if (snapshot.data != null && testmonies!.isEmpty) {
            return const Center(
              child: SingleChildScrollView(
                child: Text(
                  'Share your testimony',
                  style: kFontH6,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (snapshot.hasData) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: kContentSpacing16,
                  vertical: kContentSpacing24,
                ),
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: testmonies?.length ?? 0,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const SizedBox(
                    height: kContentSpacing8,
                  ),
                  itemBuilder: (context, index) {
                    return TestimonyCard(
                      testimony: testmonies![index],
                    );
                  },
                ),
              ),
            );
          }

          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
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
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    return AppBar(
      leading: CustomBackButton(
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text(
        'Testimonies',
        style: kFontH6,
      ),
    );
  }
}
