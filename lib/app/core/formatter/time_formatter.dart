class TimeFormat {
  TimeFormat._();

  static String formatTimer(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$secs";
  }

  static String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    String result = '';

    if (hours > 0) {
      result += '$hours jam ';
    }
    if (minutes > 0) {
      result += '$minutes menit ';
    }
    if (seconds > 0 || result.isEmpty) {
      result += '$seconds detik';
    }

    return result.trim();
  }
}
