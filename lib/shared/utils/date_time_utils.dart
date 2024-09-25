class DateTimeUtils {
  static String parseDateTimeToRelativeTime(DateTime? dateTime, {DateTime? currentDateTime}) {
    if (dateTime == null) {
      return '---';
    }
    Duration difference = (currentDateTime ?? DateTime.now()).difference(dateTime);
    int yearsAgo = difference.inDays ~/ 365;
    int monthsAgo = difference.inDays ~/ 30;
    int daysAgo = difference.inDays;
    int hoursAgo = difference.inHours;
    int minutesAgo = difference.inMinutes;

    if (yearsAgo > 0) {
      int monthsAgo = difference.inDays % 365 ~/ 30;
      return '${yearsAgo}y${monthsAgo != 0 ? ' ${monthsAgo}m' : ''}';
    } else if (monthsAgo > 0) {
      int daysAgo = difference.inDays % 30;
      return '${monthsAgo}m${daysAgo != 0 ? ' ${daysAgo}d' : ''}';
    } else if (daysAgo > 0) {
      int hoursAgo = difference.inHours % 24;
      return '${daysAgo}d${hoursAgo != 0 ? ' ${hoursAgo}h' : ''}';
    } else if (hoursAgo > 0) {
      int minutesAgo = difference.inMinutes % 60;
      return '${hoursAgo}h${minutesAgo != 0 ? ' ${minutesAgo}m' : ''}';
    } else if (minutesAgo > 0) {
      return '${minutesAgo}m';
    } else {
      return 'Now';
    }
  }
}
