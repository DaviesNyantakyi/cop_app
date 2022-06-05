import 'package:cop_belgium_app/screens/video_player_screen/video_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({Key? key}) : super(key: key);

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  final PageController pageController = PageController();

  List<String> videos = [];

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenInfo) {
        return SafeArea(
          child: Scaffold(
            body: PageView.builder(
              itemCount: videos.length,
              scrollDirection: Axis.vertical,
              controller: pageController,
              itemBuilder: (context, index) {
                return VideoPlayerScreen(
                  videoURL: videos[index],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
