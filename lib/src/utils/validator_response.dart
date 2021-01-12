import 'package:flutter/material.dart';

class ValidatorResponse {

  int code;
  bool status;
  dynamic data;
  String message;

  ValidatorResponse({@required this.status, this.data, this.message, @required this.code});

  static IconData iconData(int code) {
    switch (code) {
      case 1:
        return Icons.check_circle_outline;
      case 2:
        return Icons.sentiment_very_satisfied;
      case 3:
        return Icons.sentiment_very_dissatisfied;
      case 4:
        return Icons.error_outline;
      case 5:
        return Icons.wifi_off;
      default:
        return Icons.sentiment_very_dissatisfied;
    }
  }

}