class TimeFormatUtil {
  static String formatMillisDayDuration(int millis) {
    return (millis / 86400000).toStringAsFixed(0);
  }
}
