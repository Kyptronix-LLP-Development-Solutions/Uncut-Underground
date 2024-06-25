import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.4), // Overlay background color
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.blue.shade800,
        ),
      ),
    );
  }
}
