import 'package:dart_date/dart_date.dart';

// •
class FormalDates {
  static String? formatEDmyyyyHm({required DateTime? date}) {
    // Wed, 1 Jan, 2023 • 14:00
    if (date != null) {
      return date.format('E, dd MMM, yyyy • hh:mm');
    }
    return null;
  }

  static String? formatEDmyyyy({required DateTime? date}) {
    // Wed, 1 Jan, 2023
    if (date != null) {
      return date.format('E, dd MMM, yyyy');
    }
    return null;
  }

  // Date of birth text.
  static String? formatDmyyyy({required DateTime? date}) {
    // 11 Jan 2023
    if (date != null) {
      return date.format('dd MMM yyyy');
    }
    return null;
  }

  static String? formatHm({required DateTime? date}) {
    // 14:00
    if (date != null) {
      return date.format('HH:mm');
    }
    return null;
  }

  // Podcast episode
  static String getEpisodeDuration({required Duration duration}) {
    // formats the episode duration in hh:mm:ss
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    // return mm:ss if the duration is less then one hour

    if (duration.inHours < 1) {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
