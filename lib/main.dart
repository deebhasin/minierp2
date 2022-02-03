import 'package:flutter/material.dart';

import './screens/loadscreen.dart';
import './screens/viewscreen.dart';
import './screens/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
 const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => HomePage(),
        // '/': (ctx) => _loadFlag ? const LoadScreen(): const ViewScreen(),
        'viewscreen': (ctx) => const ViewScreen(),
      },

      // home: loadFlag ? const LoadScreen(): const ViewScreen(),
      // home: LoadScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}




