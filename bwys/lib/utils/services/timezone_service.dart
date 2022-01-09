import 'dart:math';

import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart';

class TimezoneService {
  /// Instance of [TimezoneService]
  static TimezoneService? _instance;

  TimezoneService._internal();

  /// Timezone ID of the timezone
  int? id;

  /// Timezone name
  String? name;

  /// Days in month
  List<int> _daysInMonth = const [
    0,
    31,
    28,
    31,
    30,
    31,
    30,
    31,
    31,
    30,
    31,
    30,
    31
  ];

  /// Gettters and setters for timezone id
  int? get timezoneId => id;
  set timezoneId(int? timezoneId) => id = timezoneId;

  /// Gettters and setters for timezone name
  String? get timezoneName => name;
  set timezoneName(String? timezoneName) => name = timezoneName;

  /// Return the instance of TimezoneService
  static Future<TimezoneService?> getInstance() async {
    /// initialize the timezone database
    tz.initializeTimeZones();

    if (_instance == null) {
      _instance = TimezoneService._internal();
    }

    return _instance;
  }

  /// This function converts the UTC date into user preferred timezone.
  /// If no preferred timezone is found for the user then the UTC date will be
  /// converted into user local timezone.
  String convertUTCDate(String utcDate) {
    DateTime date = DateTime.parse(utcDate);
    if (timezoneId == null || timezoneName == null) {
      date = date.toLocal();
    } else {
      try {
        date = TZDateTime.from(date.toLocal(), getLocation(timezoneName!));
      } catch (e) {
        date = date.toLocal();
      }
    }

    DateFormat dateFormat = DateFormat('yyyy/MM/dd hh:mm:ss aa');

    return dateFormat.format(date);
  }

  /// This function converts the UTC date into user preferred timezone
  /// and return date time formatted string
  String getDateTimeFromUTC(String utcDate, {bool showSeconds = true}) {
    DateTime date = DateTime.parse(utcDate);
    if (timezoneId == null || timezoneName == null) {
      date = date.toLocal();
    } else {
      try {
        date = TZDateTime.from(date.toLocal(), getLocation(timezoneName!));
      } catch (e) {
        date = date.toLocal();
      }
    }

    DateFormat dateFormat = showSeconds
        ? DateFormat('yyyy/MM/dd hh:mm:ss aa')
        : DateFormat('yyyy/MM/dd hh:mm aa');

    return dateFormat.format(date);
  }

  /// This function converts the UTC date into user preferred timezone
  /// and return date formatted string
  String getDateFromUTC(String utcDate) {
    DateTime date = DateTime.parse(utcDate);
    if (timezoneId == null || timezoneName == null) {
      date = date.toLocal();
    } else {
      try {
        date = TZDateTime.from(date.toLocal(), getLocation(timezoneName!));
      } catch (e) {
        date = date.toLocal();
      }
    }

    DateFormat dateFormat = DateFormat('yyyy/MM/dd');

    return dateFormat.format(date);
  }

  /// This function converts the UTC date into yyyy-MM-dd
  String convertToDatePickerDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// This function converts the UTC date into user preferred timezone
  /// and return relative time formatted string
  String getRelativeTimeFromUTC(String utcDate) {
    DateTime date = DateTime.parse(utcDate);
    if (timezoneId == null || timezoneName == null) {
      date = date.toLocal();
    } else {
      try {
        date = TZDateTime.from(date.toLocal(), getLocation(timezoneName!));
      } catch (e) {
        date = date.toLocal();
      }
    }

    return timeago.format(date);
  }

  /// This function takes the seconds in [num]
  ///
  /// And return the time in [(count) days  HH:MM:SS] format
  String convertSecondsToDHMS(num seconds) {
    /// Caluclate number of days
    final int _days = (seconds / 86400).floor();

    /// Calculate hours
    final int _hours = ((seconds % 86400) / 3600).floor();
    final String _displayHours = _hours < 10 ? '0$_hours' : _hours.toString();

    /// Calculate minutes
    final int _minutes = (((seconds % 86400) % 3600) / 60).floor();
    final String _displayMinutes =
        _minutes < 10 ? '0$_minutes' : _minutes.toString();

    /// Calculate seconds
    final int _seconds = (((seconds % 86400) % 3600) % 60).floor();
    final String _displaySeconds =
        _seconds < 10 ? '0$_seconds' : _seconds.toString();

    return '$_days days  $_displayHours:$_displayMinutes:$_displaySeconds';
  }

  /// This function converts the UTC date into user preferred timezone instance
  /// of [DateTime]. If no preferred timezone is found for the user then the
  /// UTC date will be converted into user local timezone instance of [DateTime].
  DateTime convertUTCToDateTime(String utcDate) {
    DateTime date = DateTime.parse(utcDate);
    if (timezoneId == null || timezoneName == null) {
      date = date.toLocal();
    } else {
      try {
        date = TZDateTime.from(date.toLocal(), getLocation(timezoneName!));
      } catch (e) {
        date = date.toLocal();
      }
    }
    return date;
  }

  /// Check Whether the year is leap year or not
  bool isLeapYear(int value) =>
      value % 400 == 0 || (value % 4 == 0 && value % 100 != 0);

  /// Calculate the days in month
  int daysInMonth(int year, int month) {
    var result = _daysInMonth[month];
    if (month == 2 && isLeapYear(year)) result++;
    return result;
  }

  /// Add months in a given datetime
  DateTime addMonths(DateTime dt, int value) {
    var r = value % 12;
    var q = (value - r) ~/ 12;
    var newYear = dt.year + q;
    var newMonth = dt.month + r;
    if (newMonth > 12) {
      newYear++;
      newMonth -= 12;
    }
    var newDay = min(dt.day, daysInMonth(newYear, newMonth));
    if (dt.isUtc) {
      return DateTime.utc(newYear, newMonth, newDay, dt.hour, dt.minute,
          dt.second, dt.millisecond, dt.microsecond);
    } else {
      return DateTime(newYear, newMonth, newDay, dt.hour, dt.minute, dt.second,
          dt.millisecond, dt.microsecond);
    }
  }
}
