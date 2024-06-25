import 'package:flutter/material.dart';

import 'text_widget.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> customSnackBar(
    ScaffoldMessengerState scaffoldMessenger, message, color, textColor) {
  return scaffoldMessenger.showSnackBar(
    SnackBar(
      content: CustomTextWidget01(
          text: message,
          fontSize: 14.0,
          color: textColor), // create a text widget according to your UI design
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
