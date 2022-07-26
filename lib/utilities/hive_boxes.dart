import 'package:hive/hive.dart';

import '../models/episode_model.dart';
import '../models/podcast_model.dart';

class HiveBoxes {
  Box<PodcastModel> getPodcasts() => Hive.box<PodcastModel>('podcasts');
  Box<EpisodeModel> getDownloads() => Hive.box<EpisodeModel>('downloads');
  Box<PodcastModel> getSubScriptions() => Hive.box<PodcastModel>(
        'subscriptions',
      );
}
