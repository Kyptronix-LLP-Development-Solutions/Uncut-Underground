import 'package:flutter/material.dart';

class CustomPopupBox {
  static void show(
    BuildContext context,
    Widget title,
    Widget message,
    Widget okBtn,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog.adaptive(
          title: title,
          content: message,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: okBtn,
            ),
          ],
        );
      },
    );
  }
}
