import 'package:desktop_window/desktop_window.dart';
import 'package:erpapp/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import './screens/formscreen.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);

  final Logger log = Logger("MINIERP2");
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    log.info("MiniERP2 app initiated: Please fasten your seatbelts");
    return OverlaySupport(
        child: MultiProvider(
        providers: AppProvider.get(),
    child: MaterialApp(

      title: 'Mini ERP 2',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => FormScreen(),
      },
    );
  }
}

