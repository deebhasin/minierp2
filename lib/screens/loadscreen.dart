import 'package:flutter/material.dart';

class LoadScreen extends StatelessWidget {
  const LoadScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 1000,
        width: 1000,
        child: Image.asset(
          "asset/images/main_load_image.png",
          // fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
