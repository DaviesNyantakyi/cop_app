import 'package:audio_service/audio_service.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cop_belgium_app/utilities/hive_boxes.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/adapters.dart';

import '../../models/episode_model.dart';
import '../../providers/audio_provider.dart';
import '../../utilities/constant.dart';
import '../../widgets/back_button.dart';
import '../../widgets/episode_tile.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({Key? key}) : super(key: key);

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: ValueListenableBuilder<Box<EpisodeModel>>(
        valueListenable: HiveBoxes().getDownloads().listenable(),
        builder: (context, box, _) {
          final downloadBox = box.values.toList();

          if (downloadBox.isEmpty) {
            return _buildNoSubscriptionsText();
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: kContentSpacing16),
            shrinkWrap: true,
            itemCount: downloadBox.length,
            separatorBuilder: (conext, index) {
              return const Divider();
            },
            itemBuilder: (conext, index) {
              if (downloadBox.isEmpty) {
                return _buildNoSubscriptionsText();
              }
              return EpisodeTile(
                showImage: true,
                episode: downloadBox[index],
                onPressed: () => showPlayer(
                  context: conext,
                  mediaItem: MediaItem(
                    id: downloadBox[index].id,
                    title: downloadBox[index].title ?? '',
                    artist: downloadBox[index].author,
                    duration: Duration(
                      seconds: downloadBox[index].duration ?? 0,
                    ),
                    displayDescription: downloadBox[index].description,
                    artUri: downloadBox[index].image != null
                        ? Uri.parse(downloadBox[index].image!)
                        : null,
                    extras: {
                      'audio': downloadBox[index].audio,
                      'downloadPath': downloadBox[index].downloadPath,
                      'pubDate': downloadBox[index].pubDate,
                      'pageLink': downloadBox[index].pageLink
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  dynamic _buildAppBar() {
    return AppBar(
      leading: const CustomBackButton(),
      title: Text(
        'Downloads',
        style: Theme.of(context).textTheme.headline6?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildNoSubscriptionsText() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            BootstrapIcons.arrow_down_circle,
            size: 64,
          ),
          const SizedBox(height: kContentSpacing12),
          Text(
            'No downloaded episode',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            'Tap the download button on any episode ',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(),
          ),
          Text(
            'to see new episodes at a glance',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(),
          ),
        ],
      ),
    );
  }
}
