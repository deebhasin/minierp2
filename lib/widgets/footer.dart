import 'package:flutter/material.dart';

class KFooter extends StatelessWidget {
  final int sidebarWidth;
  const KFooter({
    Key? key,
    required this.sidebarWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 30,
      width: (MediaQuery.of(context).size.width - sidebarWidth),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(63, 64, 66, 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: const [
            Icon(
              Icons.copyright,
              color: Colors.white,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: Text(
                "iTuple Technologies Pvt. Ltd.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
