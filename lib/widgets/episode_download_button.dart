import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/hive_boxes.dart';
import 'package:cop_belgium_app/widgets/bottomsheet.dart';
import 'package:cop_belgium_app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../models/episode_model.dart';
import '../utilities/episode_donwloader.dart';

class EpisodeDownloadButton extends StatefulWidget {
  final double? iconSize;
  final EpisodeModel episode;
  const EpisodeDownloadButton(
      {Key? key, required this.episode, this.iconSize = 24})
      : super(key: key);

  @override
  State<EpisodeDownloadButton> createState() => _EpisodeDownloadButtonState();
}

class _EpisodeDownloadButtonState extends State<EpisodeDownloadButton> {
  EpisodeDownloader downloadService = EpisodeDownloader();
  double percentage = 0.0;
  bool downloading = false;

  Future<void> downloadEpisode() async {
    try {
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
    } on FirebaseException catch (e) {
      showCustomSnackBar(
        context: context,
        type: CustomSnackBarType.error,
        message: e.message ?? '',
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> showButtomSheet({Box? episodeBox, bool? downloaded}) async {
    // Show the bottomsheet if the epside has been donwloaded.
    if (downloaded == false && downloading == false) {
      // Don't show the bottomsheet and directly dowload the episode if the episode hase not been downloaded or is not being downloaded.
      await downloadEpisode();
    } else {
      await showCustomBottomSheet(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        context: context,
        child: Column(
          children: [
            // Only show the delete button is the episdoe has been dowloaded.
            downloaded == false
                ? Container()
                : _buildTile(
                    leadingIcon: Icon(
                      BootstrapIcons.trash,
                      color: downloaded == true ? kBlue : kBlack,
                    ),
                    title: 'Delete',
                    onTap: () async {
                      await episodeBox?.delete(widget.episode.id);
                      Navigator.pop(context);
                    },
                  ),

            downloading == true
                ? _buildTile(
                    leadingIcon: Icon(
                      BootstrapIcons.x_circle,
                      color: downloaded == true ? kBlue : kBlack,
                    ),
                    title: 'Cancel',
                    onTap: () {},
                  )
                : Container(),
          ],
        ),
      );
    }
  }

  ListTile _buildTile({
    Widget? leadingIcon,
    required String title,
    Widget? trailingIcon,
    VoidCallback? onTap,
  }) {
    return ListTile(
      horizontalTitleGap: 0,
      leading: leadingIcon,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      trailing: trailingIcon,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen to the hivebox and check if the episode had been added.

    return ValueListenableBuilder<Box<EpisodeModel>>(
      valueListenable: HiveBoxes().getDownloads().listenable(),
      builder: (context, box, _) {
        bool downloaded = false;

        // The epsiode has been downloaded if the donwloadsBox contains the id.
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
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    value: percentage,
                    strokeWidth: 3,
                  ),
                )
              : Icon(
                  BootstrapIcons.arrow_down_circle,
                  color: downloaded ? kBlue : kBlack,
                ),
          onPressed: () => showButtomSheet(
            downloaded: downloaded,
            episodeBox: box,
          ),
        );
      },
    );
  }
}
