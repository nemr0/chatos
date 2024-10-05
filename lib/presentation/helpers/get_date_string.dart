import 'package:intl/intl.dart';

String getDateString(DateTime date) {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime yesterday = today.subtract(const Duration(days: 1));

  if (date.isAfter(today)) {
    // If the date is today, return the time in 12-hour format
    return DateFormat.jm().format(date);
  } else if (date.isAfter(yesterday)) {
    // If the date is yesterday, return 'yesterday'
    return 'yesterday';
  } else {
    // Otherwise, return the date itself in a readable format
    return DateFormat.yMMMd().format(date);
  }
}