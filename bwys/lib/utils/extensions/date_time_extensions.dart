
import 'package:intl/intl.dart';

extension DateTimeStringExtensions on String {
  /// This function converts the date into UTC date.
  String convertDateToUTC() {
    DateTime _date = DateTime.parse(this);

    /// Return the date by removing the milliseconds from the date
    return _date.toUtc().toString();
  }
}

extension DateTimeExtensions on DateTime {
  /// This function converts the [DateTime] object into formatted date time text
  String formatDateTime() {
    DateFormat dateFormat = DateFormat('yyyy/MM/dd hh:mm:ss aa');
    return dateFormat.format(this);
  }

  /// This function converts the [DateTime] object into formatted date with month
  /// text
  /// Ex: Dec 25
  String formatDateTimeToDateMonth() {
    DateFormat dateFormat = DateFormat('MMM d');
    return dateFormat.format(this);
  }

  /// This function removes time from [DateTime] object to set time to 12 am
  /// for that date
  DateTime removeTimeFromDateTime() {
    return subtract(Duration(
      milliseconds: millisecond,
      seconds: second,
      minutes: minute,
      hours: hour,
    ));
  }
}
