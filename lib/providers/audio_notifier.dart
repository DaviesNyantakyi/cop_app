import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';

import 'package:flutter/foundation.dart';

// TODO: Audio Service setup IOS
// https://suragch.medium.com/background-audio-in-flutter-with-audio-service-and-just-audio-3cce17b4a7d#:~:text=media%20button%20input.-,ios,-Open%20Info.plist

Future<AudioPlayerNotifier> initAudioSerivce() async {
  return await AudioService.init(
    builder: () => AudioPlayerNotifier(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.copbelgium.copbelgiumapp',
      androidNotificationChannelName: 'Cop Belgium',
      fastForwardInterval: Duration(seconds: 30),
      rewindInterval: Duration(seconds: 30),
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
}

class AudioPlayerNotifier extends BaseAudioHandler with ChangeNotifier {
  final _justAudio = AudioPlayer();
  bool _isPlaying = false;
  // The State of the notifcation player
  ProcessingState? _playState;

  MediaItem? _curreMediaItem;

  Duration _totalDuration = Duration.zero;
  Duration _currentPosition = Duration.zero;

  final Duration _skipDuration = const Duration(seconds: 3);

  bool get isPlaying => _isPlaying;
  MediaItem? get currentMediaItem => _curreMediaItem;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  Duration get skipDuration => _skipDuration;
  ProcessingState? get playState => _playState;

  Future<void> init({required MediaItem item}) async {
    try {
      // Show notification audio is loading.

      playbackState.add(PlaybackState(
        processingState: AudioProcessingState.loading,
        systemActions: {
          MediaAction.seek,
        },
      ));

      await _setMediaItem(item: item);

      _getCurrentPosition();
      _audioState();

      await play();

      //Show notifcation audio is ready.
      playbackState.add(PlaybackState(
        playing: false,
        controls: [
          MediaControl.rewind,
          MediaControl.play,
          MediaControl.fastForward
        ],
        processingState: AudioProcessingState.ready,
        systemActions: {
          MediaAction.seek,
        },
      ));
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }

    notifyListeners();
  }

  // Set the audio url, duration and add the epsiode details to the notication.
  Future<void> _setMediaItem({required MediaItem item}) async {
    try {
      _totalDuration = (await _justAudio.setUrl(item.id)) ?? item.duration!;

      // add the episode details to the notifcation
      mediaItem.add(item);
      _curreMediaItem = item;
    } catch (e) {
      debugPrint(e.toString());

      rethrow;
    }
    notifyListeners();
  }

  @override
  Future<void> stop() async {
    await _justAudio.stop();
    await super.stop();
  }

  @override
  Future<void> play() async {
    playbackState.add(PlaybackState(
      playing: true,
      processingState: AudioProcessingState.ready,
      controls: [
        MediaControl.rewind,
        MediaControl.pause,
        MediaControl.fastForward,
      ],
      systemActions: {
        MediaAction.seek,
      },
    ));
    if (_playState == ProcessingState.completed && _isPlaying == false) {
      await seek(Duration.zero);
      await play();
      _isPlaying = true;
    } else {
      await _justAudio.play();
      await super.play();
      _isPlaying = true;
    }
    notifyListeners();
  }

  @override
  Future<void> pause() async {
    playbackState.add(PlaybackState(
      playing: false,
      processingState: AudioProcessingState.ready,
      controls: [
        MediaControl.rewind,
        MediaControl.play,
        MediaControl.fastForward,
      ],
      systemActions: {
        MediaAction.seek,
      },
    ));
    await _justAudio.pause();
    await super.pause();
    _isPlaying = false;
    notifyListeners();
  }

  @override
  Future<void> seek(Duration position) async {
    playbackState.add(PlaybackState(
      playing: true,
      processingState: AudioProcessingState.ready,
      controls: [
        MediaControl.rewind,
        MediaControl.pause,
        MediaControl.fastForward,
      ],
      systemActions: {
        MediaAction.seek,
      },
    ));
    await _justAudio.seek(position);
    await super.seek(position);
  }

  @override
  Future<void> fastForward() async {
    Duration newPosition = _currentPosition + _skipDuration;

    if (newPosition >= _totalDuration) {
      newPosition = _totalDuration;
    }

    _justAudio.seek(newPosition);
    super.seek(newPosition);
  }

  // rewind 30 sec.
  @override
  Future<void> rewind() async {
    // get the disired position
    Duration newPosition = currentPosition - _skipDuration;
    if (newPosition <= Duration.zero) {
      newPosition = Duration.zero;
    }
    await _justAudio.seek(newPosition);
    await super.seek(newPosition);
  }

  //Listen to the just_audio player stream and update the Ui and notication.
  void _audioState() {
    _justAudio.playerStateStream.listen((state) {
      // playerStateStream listens to the current state of the button and the audio.

      // Listen to the state of the button when pressed this is either true or false.

      // Also listen to the current state of the audio (ProcessingState).
      // This can be idle, loading, buffering, ready, completed.

      _isPlaying = state.playing; // Change the play and pause icon.
      _playState = state.processingState; // Change the processing state.

      // When the audio is complete.
      if (state.processingState == ProcessingState.completed) {
        // Change the icon to pause when the audio is complete.
        _isPlaying = false;

        // Upate the notifcation that the audi is complete.
        playbackState.add(PlaybackState(
          playing: false,
          processingState: AudioProcessingState.ready,
          controls: [
            MediaControl.rewind,
            MediaControl.play,
            MediaControl.fastForward,
          ],
          systemActions: {
            MediaAction.seek,
          },
        ));
      }

      notifyListeners();
    });
  }

  // Listen to the audio position and set he current postistion.
  void _getCurrentPosition() {
    _justAudio.positionStream.listen((Duration duration) {
      _currentPosition = duration;

      notifyListeners();
    });
  }
}
