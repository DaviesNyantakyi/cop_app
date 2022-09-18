import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cop_belgium_app/screens/library_screen/downloads_screen.dart';
import 'package:cop_belgium_app/screens/library_screen/subscriptions_screen.dart';
import 'package:flutter/cupertino.dart';
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
  late final getTrending =
      PodcastService().getPodcast(reload: false, context: context);

  late TabController tabController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(builder: (context, audioProvider, _) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: kContentSpacing16),
            child: Column(children: [
              _buildTile(
                leadingIcon: BootstrapIcons.folder,
                title: 'Subscriptions',
                trailingIcon: BootstrapIcons.chevron_right,
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) =>
                          ChangeNotifierProvider<AudioProvider>.value(
                        value: audioProvider,
                        child: const SubScriptionsScreen(),
                      ),
                    ),
                  );
                },
              ),
              _buildTile(
                leadingIcon: BootstrapIcons.arrow_down_circle,
                title: 'Downloads',
                trailingIcon: BootstrapIcons.chevron_right,
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) =>
                          ChangeNotifierProvider<AudioProvider>.value(
                        value: audioProvider,
                        child: const DownloadsScreen(),
                      ),
                    ),
                  );
                },
              ),
            ]),
          ),
        ),
      );
    });
  }

  ListTile _buildTile({
    IconData? leadingIcon,
    required String title,
    IconData? trailingIcon,
    VoidCallback? onTap,
  }) {
    return ListTile(
      horizontalTitleGap: 0,
      leading: Icon(
        leadingIcon,
        color: kBlue,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      trailing: Icon(
        trailingIcon,
        color: kGrey,
      ),
      onTap: onTap,
    );
  }

  dynamic _buildAppBar() {
    return AppBar(
      title: Text(
        'Library',
        style: Theme.of(context).textTheme.headline6?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
