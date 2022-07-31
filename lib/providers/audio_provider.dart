import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

import '../screens/player_screen/player_screen.dart';
import '../utilities/constant.dart';
import '../utilities/formal_dates.dart';
import '../widgets/bottomsheet.dart';

const seekDuration = Duration(seconds: 30);
Future<void> initAudioSerivce() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.copbelgium.app.channel.audio',
    androidNotificationChannelName: 'COP Belgium',
    androidNotificationOngoing: true,
    fastForwardInterval: seekDuration,
    rewindInterval: seekDuration,
  );
}

class AudioProvider with ChangeNotifier {
  final AudioPlayer _justAudio = AudioPlayer();

  PlayerState? _playerState;
  Duration _currentPostion = Duration.zero;
  Duration _totalDuration = Duration.zero;
  AudioServiceRepeatMode _repeatMode = AudioServiceRepeatMode.none;
  MediaItem? _currentMediaItem;

  PlayerState? get playerState => _playerState;
  Duration get currentPostion => _currentPostion;
  Duration get totalDuration => _totalDuration;
  AudioServiceRepeatMode get repeatMode => _repeatMode;
  MediaItem? get currentMediaItem => _currentMediaItem;

  AudioProvider() {
    _postionStream();
    _totalDurationStream();
    playingStateStream();
  }

  final _playlist = ConcatenatingAudioSource(children: []);

  Future<void> initPlayer({required MediaItem mediaItem}) async {
    if (mediaItem.extras?['downloadPath'] != null) {
      // Offline
      final file = File(mediaItem.extras?['downloadPath']);
      await _playlist.clear();
      await _playlist.add(AudioSource.uri(
        file.uri,
        tag: MediaItem(
          id: mediaItem.id,
          title: mediaItem.title,
          artUri: mediaItem.artUri,
          artist: mediaItem.artist,
          duration: mediaItem.duration,
        ),
      ));

      await _justAudio.setAudioSource(_playlist);
    } else {
      // Online
      if (mediaItem.extras?['audio'] != null) {
        await _playlist.clear();
        await _playlist.add(
          AudioSource.uri(
            Uri.parse(
              mediaItem.extras!['audio'],
            ),
            tag: MediaItem(
              id: mediaItem.id,
              title: mediaItem.title,
              artUri: mediaItem.artUri,
              artist: mediaItem.artist,
              duration: mediaItem.duration,
            ),
          ),
        );
        await _justAudio.setAudioSource(_playlist);
      }
    }
    _currentMediaItem = mediaItem;
    notifyListeners();

    await play();
  }

  Future<void> play() async {
    if (_justAudio.processingState == ProcessingState.completed) {
      await seek(Duration.zero);
    }
    await _justAudio.play();
  }

  Future<void> stop() async {
    await _justAudio.stop();
  }

  Future<void> pause() async {
    await _justAudio.pause();
  }

  Future<void> seek(Duration position) async {
    await _justAudio.seek(position);
  }

  Future<void> rewind() async {
    Duration newPostion = _currentPostion - seekDuration;
    if (newPostion < Duration.zero) {
      newPostion = Duration.zero;
    }
    await seek(newPostion);
  }

  Future<void> fastForward() async {
    Duration newPostion = _currentPostion + seekDuration;
    if (newPostion > totalDuration) {
      newPostion = totalDuration;
    }
    await seek(newPostion);
  }

  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    _repeatMode = repeatMode;

    if (repeatMode == AudioServiceRepeatMode.none) {
      await _justAudio.setLoopMode(LoopMode.off);
    } else {
      await _justAudio.setLoopMode(LoopMode.one);
    }

    notifyListeners();
  }

  void playingStateStream() {
    // The state of the player.
    // You can listen for changes in both the processing state and the playing state from the audio player’s playerStateStream.
    // This stream provides the current PlayerState, which includes a Boolean playing property and a processingState property.
    _justAudio.playerStateStream.listen((state) {
      _playerState = state;

      notifyListeners();
    });
  }

  void _postionStream() {
    // Gets the current audio (slider) postion.
    _justAudio.positionStream.listen((position) {
      _currentPostion = position;
      notifyListeners();
    });
  }

  void _totalDurationStream() {
    // Gets the current audio (slider) postion.
    _justAudio.durationStream.listen((duration) {
      _totalDuration = duration ?? Duration.zero;

      notifyListeners();
    });
  }

  Future<void> close() async {
    await stop();
    _playerState = null;
    _currentMediaItem = null;
    _currentPostion = Duration.zero;
    _totalDuration = Duration.zero;
    _repeatMode = AudioServiceRepeatMode.none;
  }
}

Future<void> showPlayer({
  required BuildContext context,
  required MediaItem mediaItem,
}) async {
  final audioProvider = Provider.of<AudioProvider>(context, listen: false);
  showCustomBottomSheet(
    backgroundColor: kWhite,
    context: context,
    height: MediaQuery.of(context).size.height * 0.90,
    header: AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text(
        'Now Playing',
        style: Theme.of(context).textTheme.bodyText2,
      ),
      centerTitle: true,
      leading: IconButton(
        tooltip: 'Close',
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(BootstrapIcons.chevron_down),
      ),
      actions: [
        IconButton(
          tooltip: 'About',
          onPressed: () => showDescription(
            context: context,
            mediaItem: mediaItem,
          ),
          icon: const Icon(BootstrapIcons.info_circle),
        ),
      ],
    ),
    child: ChangeNotifierProvider<AudioProvider>.value(
      value: audioProvider,
      child: PlayerScreen(
        mediaItem: mediaItem,
      ),
    ),
  );
}

Future<void> showDescription(
    {required BuildContext context, required MediaItem mediaItem}) async {
  final audioProvider = Provider.of<AudioProvider>(context, listen: false);

  showCustomBottomSheet(
    context: context,
    backgroundColor: kWhite,
    height: MediaQuery.of(context).size.height * 0.90,
    header: AppBar(
      elevation: 0,
      backgroundColor: kWhite,
      automaticallyImplyLeading: false,
      title: Text(
        'Description',
        style: Theme.of(context).textTheme.bodyText2,
      ),
      centerTitle: true,
      leading: IconButton(
        tooltip: 'Close',
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(BootstrapIcons.chevron_down),
      ),
    ),
    child: ChangeNotifierProvider.value(
      value: audioProvider,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mediaItem.title,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            'by ${mediaItem.artist ?? ''} • ${FormalDates.timeAgo(date: mediaItem.extras?['pubDate'])}',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          const SizedBox(height: kContentSpacing8),
          Text(
            mediaItem.displayDescription ?? '',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    ),
  );
}
