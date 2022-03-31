import 'package:flutter/material.dart';

class MainProvider with ChangeNotifier {
  Duration getTimeDifference(DateTime dateTime) {
    DateTime now = DateTime.now();
    Duration diff = dateTime.difference(now);
    return diff;
  }
}
