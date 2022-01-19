import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';

import '../widgets/sidebar.dart';

class ViewScreen extends StatelessWidget {
  const ViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _setDesktopFullScreen();
    return Column(
      children: const [
      //   Divider(
      //     thickness: 1,
      //     color: Colors.black45,
      //   ),
        Sidebar(sidebarWidth: 200),
      ],
    );
  }

  _setDesktopFullScreen() {
     DesktopWindow.setFullScreen(true);
  }
}
