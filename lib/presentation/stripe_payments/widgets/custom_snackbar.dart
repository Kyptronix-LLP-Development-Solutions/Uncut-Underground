import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> customSnackBar(
    ScaffoldMessengerState scaffoldMessenger, message, color, textColor) {
  return scaffoldMessenger.showSnackBar(
    SnackBar(
      content: Text('data'), // create a text widget according to your UI design
      backgroundColor: color,
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: textColor,
        onPressed: () {
          scaffoldMessenger.hideCurrentSnackBar();
        },
      ),
    ),
  );
}
