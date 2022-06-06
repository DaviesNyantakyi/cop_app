import 'package:cop_belgium_app/models/teaching_clip_model.dart';
import 'package:cop_belgium_app/screens/teaching_clips_screens/teaching_clips_player.dart';
import 'package:cop_belgium_app/services/cloud_fire.dart';
import 'package:cop_belgium_app/widgets/custom_error_widget.dart';
import 'package:cop_belgium_app/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class TeachingClipScreen extends StatefulWidget {
  const TeachingClipScreen({Key? key}) : super(key: key);

  @override
  State<TeachingClipScreen> createState() => _TeachingClipScreenState();
}

class _TeachingClipScreenState extends State<TeachingClipScreen> {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenInfo) {
        return SafeArea(
          child: Scaffold(
            body: StreamBuilder<List<TeachingClipModel>>(
              stream: CloudFire().getTeachingClips(),
              builder: (context, snapshot) {
                List<TeachingClipModel> videos = snapshot.data ?? [];

                if (snapshot.hasError) {
                  return CustomErrorWidget(
                    onPressed: () {},
                  );
                }
                if (snapshot.hasData && snapshot.data != null) {
                  return PageView.builder(
                    itemCount: videos.length,
                    scrollDirection: Axis.vertical,
                    controller: pageController,
                    itemBuilder: (context, index) {
                      return VideoPlayerScreen(
                        teachingClipModel: videos[index],
                      );
                    },
                  );
                }
                return const Center(
                  child: CustomCircularProgressIndicator(),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
