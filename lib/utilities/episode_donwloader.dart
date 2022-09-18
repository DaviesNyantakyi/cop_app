import 'dart:io';

import 'package:cop_belgium_app/utilities/connection_checker.dart';
import 'package:cop_belgium_app/utilities/hive_boxes.dart';
import 'package:cop_belgium_app/utilities/path_provider.dart';
import 'package:dio/dio.dart';

import '../models/episode_model.dart';

class EpisodeDownloader {
  final Dio _dio = Dio();
  final _hiveBoxes = HiveBoxes();

  final connectionChecker = ConnectionNotifier();

  final _customDeviceDirectory = CustomDeviceDirectory();

  Future<void> downloadEpisode({
    required EpisodeModel episode,
    Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final hasConnection = await connectionChecker.checkConnection();

      // Check the connection
      if (hasConnection == true) {
        // Delete downloads
        final downloadsDir =
            await _customDeviceDirectory.getEpisodesDownloadsDirectory();

        final downloadBox = _hiveBoxes.getDownloads();
        final file = await _customDeviceDirectory.getFile(
          path: '${downloadsDir.path}/${episode.title}.mp3',
        );
        final downloadedEpisodes = _hiveBoxes.getDownloads().values.toList();
        for (var ep in downloadedEpisodes) {
          if (episode.id == ep.id) {
            await downloadBox.delete(episode.id);
            file?.deleteSync();
            return;
          }
        }

        if (episode.audio != null) {
          // Downloading

          final response = await _download(
            episode: episode,
            onReceiveProgress: onReceiveProgress,
          );

          // Saving download
          if (response?.statusCode == 200) {
            File file = File('${downloadsDir.path}/${episode.title}.mp3');
            final randFile = file.openSync(mode: FileMode.write);

            randFile.writeFromSync(response?.data);
            randFile.close();
            episode.downloadPath = file.path;
            await downloadBox.put(episode.id, episode);
          }
        }
      } else {
        throw ConnectionNotifier.connectionException;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> _download({
    required EpisodeModel episode,
    required Function(int, int)? onReceiveProgress,
  }) async {
    try {
      return await _dio.get(
        episode.audio!,
        options: Options(
          responseType: ResponseType.bytes,
        ),
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      rethrow;
    }
  }
}
