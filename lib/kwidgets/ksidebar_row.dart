import 'package:flutter/material.dart';

import './ktext.dart';



class KSidebarRow extends StatelessWidget {
  final String text;
  const KSidebarRow({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: (){},
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
