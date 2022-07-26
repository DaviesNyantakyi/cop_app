import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../models/episode_model.dart';
import '../utilities/donwloader.dart';

class DownloadButton extends StatefulWidget {
  final double? iconSize;
  final EpisodeModel episode;
  const DownloadButton({Key? key, required this.episode, this.iconSize = 24})
      : super(key: key);

  @override
  State<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  Downloader downloadService = Downloader();
  double percentage = 0.0;
  bool downloading = false;

  Future<void> downloadEpisode() async {
    await downloadService.downloadEpisode(
      episode: widget.episode,
      onReceiveProgress: (recieved, total) {
        percentage = recieved / total;
        if (percentage < 1) {
          downloading = true;
        } else {
          downloading = false;
        }
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<EpisodeModel>>(
      valueListenable: Hive.box<EpisodeModel>('downloads').listenable(),
      builder: (context, box, _) {
        bool downloaded = false;
        final episodes = box.values.toList();

        for (var episode in episodes) {
          if (widget.episode.id == episode.id) {
            downloaded = true;
          }
        }
        return IconButton(
          iconSize: widget.iconSize,
          tooltip: 'Download',
          icon: downloading
              ? const CircularProgressIndicator()
              : Icon(
                  BootstrapIcons.arrow_down_circle,
                  color: downloaded ? kBlue : kBlack,
                ),
          onPressed: downloadEpisode,
        );
      },
    );
  }
}
