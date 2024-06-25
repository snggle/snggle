import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/date_time_utils.dart';

void main() {
  group('Tests of DateTimeUtils.parseDateTimeToRelativeTime()', () {
    DateTime actualCurrentTime = DateTime.parse('2024-07-05 15:45:30.000');

    test('Should [return relative time] for a date [earlier than 60 seconds ago]', () {
      DateTime actualComparedTime = DateTime.parse('2024-07-05 15:45:00.000');

      String actualRelativeTime = DateTimeUtils.parseDateTimeToRelativeTime(actualComparedTime, currentDateTime: actualCurrentTime);
      String expectedRelativeTime = 'Now';

      expect(actualRelativeTime, expectedRelativeTime);
    });

    test('Should [return relative time] for a date from [even 10 minutes ago]', () {
      DateTime actualComparedTime = DateTime.parse('2024-07-05 15:35:30.000');

      String actualRelativeTime = DateTimeUtils.parseDateTimeToRelativeTime(actualComparedTime, currentDateTime: actualCurrentTime);
      String expectedRelativeTime = '10m';

      expect(actualRelativeTime, expectedRelativeTime);
    });

    test('Should [return relative time] for a date from [even 2 hours ago]', () {
      DateTime actualComparedTime = DateTime.parse('2024-07-05 13:45:30.000');

      String actualRelativeTime = DateTimeUtils.parseDateTimeToRelativeTime(actualComparedTime, currentDateTime: actualCurrentTime);
      String expectedRelativeTime = '2h';

      expect(actualRelativeTime, expectedRelativeTime);
    });

    test('Should [return relative time] for a date from [2 hours and 30 minutes ago]', () {
      DateTime actualComparedTime = DateTime.parse('2024-07-05 13:15:30.000');

      String actualRelativeTime = DateTimeUtils.parseDateTimeToRelativeTime(actualComparedTime, currentDateTime: actualCurrentTime);
      String expectedRelativeTime = '2h 30m';

      expect(actualRelativeTime, expectedRelativeTime);
    });

    test('Should [return relative time] for a date from [even 3 days ago]', () {
      DateTime actualComparedTime = DateTime.parse('2024-07-02 15:45:30.000');

      String actualRelativeTime = DateTimeUtils.parseDateTimeToRelativeTime(actualComparedTime, currentDateTime: actualCurrentTime);
      String expectedRelativeTime = '3d';

      expect(actualRelativeTime, expectedRelativeTime);
    });

    test('Should [return relative time] for a date from [3 days and 5 hours ago]', () {
      DateTime actualComparedTime = DateTime.parse('2024-07-02 10:45:30.000');

      String actualRelativeTime = DateTimeUtils.parseDateTimeToRelativeTime(actualComparedTime, currentDateTime: actualCurrentTime);
      String expectedRelativeTime = '3d 5h';

      expect(actualRelativeTime, expectedRelativeTime);
    });

    test('Should [return relative time] for a date from [even 1 month ago]', () {
      DateTime actualComparedTime = DateTime.parse('2024-06-05 15:45:30.000');

      String actualRelativeTime = DateTimeUtils.parseDateTimeToRelativeTime(actualComparedTime, currentDateTime: actualCurrentTime);
      String expectedRelativeTime = '1m';

      expect(actualRelativeTime, expectedRelativeTime);
    });

    test('Should [return relative time] for a date from [1 month and 5 days ago]', () {
      DateTime actualComparedTime = DateTime.parse('2024-05-31 15:45:30.000');

      String actualRelativeTime = DateTimeUtils.parseDateTimeToRelativeTime(actualComparedTime, currentDateTime: actualCurrentTime);
      String expectedRelativeTime = '1m 5d';

      expect(actualRelativeTime, expectedRelativeTime);
    });

    test('Should [return relative time] for a date from [even 1 year ago]', () {
      DateTime actualComparedTime = DateTime.parse('2023-07-06 15:45:30.000');

      String actualRelativeTime = DateTimeUtils.parseDateTimeToRelativeTime(actualComparedTime, currentDateTime: actualCurrentTime);
      String expectedRelativeTime = '1y';

      expect(actualRelativeTime, expectedRelativeTime);
    });

    test('Should [return relative time] for a date from [1 year and 1 month ago]', () {
      DateTime actualComparedTime = DateTime.parse('2023-06-06 15:45:30.000');

      String actualRelativeTime = DateTimeUtils.parseDateTimeToRelativeTime(actualComparedTime, currentDateTime: actualCurrentTime);
      String expectedRelativeTime = '1y 1m';

      expect(actualRelativeTime, expectedRelativeTime);
    });
  });
}
