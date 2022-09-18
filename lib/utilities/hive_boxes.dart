import 'package:hive/hive.dart';

import '../models/episode_model.dart';
import '../models/podcast_model.dart';

class HiveBoxes {
  Box<PodcastModel> getPodcasts() => Hive.box<PodcastModel>('podcasts');
  Box<PodcastModel> getSubScriptions() => Hive.box<PodcastModel>(
        'podcastSubscriptions',
      );
  Box<EpisodeModel> getDownloads() => Hive.box<EpisodeModel>(
        'episodeDownloads',
      );

  Future<void> deleteBoxes() async {
    final subbOX = HiveBoxes().getSubScriptions();
    final subBoxKeys = subbOX.keys;
    await subbOX.deleteAll(subBoxKeys);

    final downBox = HiveBoxes().getDownloads();
    final downBoxKeys = downBox.keys;
    await downBox.deleteAll(downBoxKeys);

    final podBox = HiveBoxes().getPodcasts();
    final podBoxKeys = podBox.keys;
    await podBox.deleteAll(podBoxKeys);
  }
}
