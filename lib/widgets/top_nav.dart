import 'package:flutter/material.dart';


class TopNavBar extends StatelessWidget {
  final int sidebar;
  const TopNavBar({
    Key? key,
    required this.sidebar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0,0,20,0),
      width: (MediaQuery.of(context).size.width - sidebar),

      // decoration: BoxDecoration(
      //   border: Border.all(color: Colors.red),
      // ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,

        children: const [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Icon(Icons.search),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Icon(Icons.notifications),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
