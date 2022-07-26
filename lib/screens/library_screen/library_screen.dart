import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cop_belgium_app/screens/library_screen/downloads_screen.dart';
import 'package:cop_belgium_app/screens/library_screen/subscriptions_screen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../providers/audio_provider.dart';
import '../../services/podcast_service.dart';
import '../../utilities/constant.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late final getTrending = PodcastService().fetchTrending(reload: false);

  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(builder: (context, audioProvider, _) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: SafeArea(
          child: TabBarView(
            controller: tabController,
            children: const [
              SubScriptionsScreen(),
              DownloadsScreen(),
            ],
          ),
        ),
      );
    });
  }

  dynamic _buildAppBar() {
    return AppBar(
      title: Text(
        'Library',
        style: Theme.of(context).textTheme.headline6?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      bottom: TabBar(
        controller: tabController,
        indicatorColor: kBlue,
        tabs: const [
          Tab(
            icon: Icon(
              BootstrapIcons.folder,
            ),
            text: 'Subscriptions',
          ),
          Tab(
            icon: Icon(
              BootstrapIcons.arrow_down_circle,
            ),
            text: 'Downloads',
          ),
        ],
      ),
    );
  }
}
