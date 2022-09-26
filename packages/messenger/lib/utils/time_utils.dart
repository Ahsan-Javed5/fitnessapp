import 'dart:math';

import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class TimeUtils {
  static int get nowMillis => DateTime.now().millisecondsSinceEpoch;

  static int get nowSeconds => (nowMillis * .001).round();

  static String getAgoTimeShort(double firebaseServerTimestamp) {
    int date = firebaseServerTimestamp.toInt();

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    final difference = DateTime.now().difference(dateTime);

    return timeago.format(DateTime.now().subtract(difference),
        locale: 'en_short');
  }

  static String getAgoTimeLong(double firebaseServerTimestamp) {
    int date = firebaseServerTimestamp.toInt();
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    final difference = DateTime.now().difference(dateTime);
    return timeago.format(DateTime.now().subtract(difference));
  }

  static String getTimeInHHMM(double firebaseServerTimestamp) {
    int date = firebaseServerTimestamp.toInt();
    final f = DateFormat('hh:mm');

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    return f.format(dateTime);
  }

  static String getTimeInddMMMyyHHMM(double firebaseServerTimestamp) {
    int date = firebaseServerTimestamp.toInt();
    final f = DateFormat('dd MMM yy hh:mm');

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    return f.format(dateTime);
  }

  static T getRandomElement<T>(List<T> list) {
    final random = Random();
    var i = random.nextInt(list.length);
    return list[i];
  }
}
