import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';

class ViewScreen extends StatelessWidget {
  const ViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _setDesktopFullScreen();
    return const Center(
      child: Text(
        "Welcome To View Screen",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      ),
    );
  }

  _setDesktopFullScreen() {
     DesktopWindow.setFullScreen(true);
  }
}
