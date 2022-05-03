import 'package:dart_date/dart_date.dart';

// •
class FormalDates {
  static String formatEDmyyyyHm({required DateTime? date}) {
    // Wed, 1 Jan, 2023 • 14:00
    return date!.format('E, dd MMM, yyyy • hh:mm');
  }

  static String formatEDmyyyy({required DateTime? date}) {
    // Wed, 1 Jan, 2023
    return date!.format('E, dd MMM, yyyy');
  }

  // Date of birth text.
  static String formatDmyyyy({required DateTime? date}) {
    // 11 Jan 2023
    return date!.format('dd MMM yyyy');
  }

  static String formatHm({required DateTime? date}) {
    // 14:00
    return date!.format('HH:mm');
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
