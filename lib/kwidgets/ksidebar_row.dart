import 'package:flutter/material.dart';

import './ktext.dart';

class KSidebarRow extends StatelessWidget {
  final String text;
  final bool isSelected;
  const KSidebarRow({Key? key,
    required this.text,
    this.isSelected = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print("Selection: $text. Status: $isSelected");
    return Container(
      decoration: BoxDecoration(
        color: isSelected? Colors.brown: Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            KText(text: text),
            const KText(text: ">"),
          ],
        ),
      ),
    );
  }
}
