import 'package:erpapp/kwidgets/ktabbar.dart';
import 'package:flutter/material.dart';

class SecondTabRowContainer extends StatelessWidget {
  final Widget child;
  const SecondTabRowContainer({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      width: KTabBar.sizedBoxWidth * 0.3,
      height: KTabBar.sizedBoxWidth * 0.3,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: child,
        ),
      ),
    );
  }
}
