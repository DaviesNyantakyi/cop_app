import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cop_belgium_app/models/podcast_info_model.dart';
import 'package:cop_belgium_app/services/cloud_fire.dart';
import 'package:cop_belgium_app/utilities/connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:webfeed/domain/rss_feed.dart';

import '../models/episode_model.dart';
import '../models/podcast_model.dart';
import '../utilities/hive_boxes.dart';
import '../utilities/parse_html.dart';

class PodcastService {
  final _dio = Dio();
  final _cloudFire = CloudFire();
  final _hiveBoxes = HiveBoxes();

  Future<void> getPodcast({
    required BuildContext context,
    required bool reload,
  }) async {
    try {
      final podBox = _hiveBoxes.getPodcasts();

      if (reload) {
        await podBox.clear();
      }

      final podcastsInfoCloudFire = await _cloudFire.getPodcastsFireStore();

      // Make http call for each podcast in the list.
      for (var podcastInfo in podcastsInfoCloudFire) {
        final response = await _dio.getUri(Uri.parse(podcastInfo.rss));
        if (response.statusCode == 200) {
          final rssFeed = RssFeed.parse(response.data);

          // Create a podcastModel
          final podcast = _createPodcastModel(
            podcastInfo: podcastInfo,
            rssFeed: rssFeed,
          );
          await podBox.put(podcast.id, podcast);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PodcastModel>> fetchSubScribptionCloudFire() async {
    try {
      // Get the subscription box
      final subBox = _hiveBoxes.getSubScriptions();
      // Get the Firstore podcastInfo
      final podInfoCloudFire =
          await _cloudFire.getPodcastsSubscriptionsFireStore();

      // Create list
      final subBoxList = subBox.values.cast<PodcastModel>().toList();
      final podList = podInfoCloudFire.toList();

      // if subscriptions box is empty add the subscribed podcast from firebase.
      if (subBoxList.isEmpty) {
        for (var podInfo in podList) {
          final response = await _dio.getUri(Uri.parse(podInfo.rss));

          if (response.statusCode == 200) {
            final rssFeed = RssFeed.parse(response.data);

            // Create a podcastModel
            final podcast = _createPodcastModel(
              podcastInfo: podInfo,
              rssFeed: rssFeed,
            );
            await subBox.put(podcast.id, podcast);
          }
        }
      }

      // Add missing subscription from firstore to the subscription box
      for (var podcast in subBoxList) {
        for (var podInfo in podList) {
          if (podInfo.id != podcast.id) {
            final response = await _dio.getUri(Uri.parse(podInfo.rss));

            if (response.statusCode == 200) {
              final rssFeed = RssFeed.parse(response.data);

              // Create a podcastModel
              final podcast = _createPodcastModel(
                podcastInfo: podInfo,
                rssFeed: rssFeed,
              );
              await subBox.put(podcast.id, podcast);
            }
          }
        }
      }
      return subBoxList;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> savePodcast(
      {required PodcastModel podcast, required BuildContext context}) async {
    try {
      final hasConnection = await ConnectionNotifier().checkConnection();
      if (hasConnection == true) {
        final subBox = _hiveBoxes.getSubScriptions();
        bool subScribed = false;

        // Check if podcast is stored in the subscription box
        final storedPodcasts = subBox.values.cast<PodcastModel>();
        for (var podcast in storedPodcasts) {
          if (podcast.id == podcast.id) {
            subScribed = true;
          }
        }

        if (subScribed) {
          // If subscribed delete from subscription box
          subBox.delete(podcast.id);

          // If subscribed delete from firetore subscriptions
          final subCollection = FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection('subscriptions');
          await subCollection.doc(podcast.id).delete();
        } else {
          // New model is created because of HiveError: same instance of object cannot be saved
          PodcastModel podModel = PodcastModel(
            id: podcast.id,
            image: podcast.image,
            title: podcast.title,
            description: podcast.description,
            author: podcast.author,
            pageLink: podcast.pageLink,
            rss: podcast.rss,
            episodes: podcast.episodes,
          );

          final podInfoModel = PodcastInfoModel(
            id: podcast.id,
            title: podcast.title ?? '',
            rss: podcast.rss ?? '',
            pageLink: podcast.pageLink ?? '',
          );

          final subCollection = FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection('subscriptions');

          await subCollection.doc(podcast.id).set(podInfoModel.toMap());
          await subBox.put(podModel.id, podModel);
        }
      } else {
        throw ConnectionNotifier.connectionException;
      }
    } catch (e) {
      rethrow;
    }
  }

  PodcastModel _createPodcastModel({
    required RssFeed rssFeed,
    required PodcastInfoModel podcastInfo,
  }) {
    // Go through each rssitem and create a episodeModel
    List<EpisodeModel> episodes = rssFeed.items!.map((rssItem) {
      return EpisodeModel(
        id: rssItem.enclosure!.url!,
        title: rssItem.itunes?.title ?? rssItem.title ?? '',
        author: rssFeed.author ?? rssFeed.itunes?.author ?? '',
        image: rssFeed.itunes?.image?.href ?? rssFeed.image?.url ?? '',
        duration: rssItem.itunes?.duration?.inSeconds,
        pubDate: rssItem.pubDate ?? DateTime.now(),
        audio: rssItem.enclosure?.url ?? '',
        description: parseHtml(item: rssItem.description ?? ''),
      );
    }).toList();

    return PodcastModel(
      id: podcastInfo.id,
      pageLink: rssFeed.link ?? '',
      rss: podcastInfo.rss,
      image: rssFeed.image?.url ?? rssFeed.itunes?.image?.href ?? 'S',
      title: rssFeed.itunes?.title ?? rssFeed.title ?? '',
      description:
          parseHtml(item: rssFeed.description ?? rssFeed.itunes?.summary ?? ''),
      author: rssFeed.author ?? rssFeed.itunes?.author ?? '',
      episodes: episodes,
    );
  }
}
