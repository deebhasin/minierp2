import 'package:flutter/material.dart';

class ViewChallan extends StatelessWidget {
  const ViewChallan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      // decoration: BoxDecoration(
      //   border:Border.all(color: Colors.red),
      // ),
      child: Center(
        child: Text("Disco"),
      ),
    );
  }
}
