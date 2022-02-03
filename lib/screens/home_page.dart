import 'package:flutter/material.dart';
import '/screens/loadscreen.dart';
import '/screens/viewscreen.dart';


class HomePage extends StatelessWidget {

  Future<Widget> getData() {
    return Future.delayed(Duration(seconds: 3), () {
      return ViewScreen();
      // throw Exception("Custom Error");
    });
  }

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: FutureBuilder<Widget>(
        future: getData(), // a previously-obtained Future<String> or null
        builder: (ctx, snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasData){
              return const ViewScreen();
            }
          }
          return LoadScreen();
        },
      ),
    );
  }
}
