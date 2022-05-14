import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:flutter/material.dart';

class PodcastScreen extends StatefulWidget {
  const PodcastScreen({Key? key}) : super(key: key);

  @override
  State<PodcastScreen> createState() => _PodcastScreenState();
}

class _PodcastScreenState extends State<PodcastScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    return AppBar(
      title: const Text(
        'Podcasts',
        style: kFontH6,
      ),
      actions: [],
    );
  }
}
