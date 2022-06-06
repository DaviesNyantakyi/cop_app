import 'package:cached_network_image/cached_network_image.dart';
import 'package:cop_belgium_app/models/episodes_model.dart';
import 'package:cop_belgium_app/models/podcast_info_model.dart';
import 'package:cop_belgium_app/models/podcast_model.dart';
import 'package:cop_belgium_app/services/cloud_fire.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:html/parser.dart' show parse;
import 'package:uuid/uuid.dart';
import 'package:webfeed/domain/rss_feed.dart';

class PodcastService {
  final CloudFire cloudFire = CloudFire();

  final List<PodcastModel> _podcasts = [];

  List<PodcastModel> get podcasts => _podcasts;
  final _uuid = const Uuid();

  Future<PodcastModel?> getPodcasts({required BuildContext context}) async {
    try {
      // Get podcasts with rssLinks from firestore
      List<PodcastInfoModel> podcastInfoModel =
          await cloudFire.getPodcastsFireStore();

      // Make http call for and create podcast and add it to the list.
      for (var podcastInfo in podcastInfoModel) {
        final response = await Dio().getUri(Uri.parse(podcastInfo.rssFeed));
        if (response.statusCode == 200) {
          final rssFeed = RssFeed.parse(response.data);

          // Create a podcastModel
          final podcast = createPodcast(rssFeed: rssFeed, context: context);
          _podcasts.add(podcast);
        }
      }
      return null;
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      rethrow;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  PodcastModel createPodcast({
    required RssFeed rssFeed,
    required BuildContext context,
  }) {
    // Precache the podcast images
    if (rssFeed.image?.url != null) {
      precacheImage(
        CachedNetworkImageProvider(rssFeed.image!.url!),
        context,
      );
    }

    // Go through each rssitem and create a episodeModel
    List<EpisodeModel> episodes = rssFeed.items!.map((rssItem) {
      //  Precache the episode images
      if (rssItem.itunes?.image?.href != null) {
        precacheImage(
          CachedNetworkImageProvider(rssFeed.itunes!.image!.href!),
          context,
        );
      }
      return EpisodeModel(
        id: rssItem.enclosure!.url!,
        title: rssItem.itunes?.title ?? rssItem.title ?? '',
        author: rssFeed.author ?? rssFeed.itunes?.author ?? '',
        imageURL: rssFeed.itunes?.image?.href ?? rssFeed.image?.url ?? '',
        duration: Duration(seconds: rssItem.itunes?.duration?.inSeconds ?? 0),
        date: rssItem.pubDate ?? DateTime.now(),
        audioURL: rssItem.enclosure?.url ?? '',
        description: _parseHtml(item: rssItem.description ?? ''),
      );
    }).toList();

    return PodcastModel(
      id: _uuid.v4(),
      pageURL: rssFeed.link ?? '',
      imageURL: rssFeed.image?.url ?? rssFeed.itunes?.image?.href ?? 'S',
      title: rssFeed.itunes?.title ?? rssFeed.title ?? '',
      description: _parseHtml(
          item: rssFeed.description ?? rssFeed.itunes?.summary ?? ''),
      author: rssFeed.author ?? rssFeed.itunes?.author ?? '',
      episodes: episodes,
    );
  }

  static String _parseHtml({required String item}) {
    //Returns a rss description without the p tag.

    final doc = parse(item);
    String newText = doc.body!.text;

    return newText;
  }
}
