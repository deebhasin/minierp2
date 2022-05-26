import 'package:erpapp/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/loadscreen.dart';
import './screens/home_screen.dart';
import './screens/startup_screen.dart';

void main() {
  runApp(
      MultiProvider(
          providers: AppProvider.get(),
          child: const MyApp(),
      ),


  );
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
        '/': (ctx) => StartupScreen(),
        // '/': (ctx) => _loadFlag ? const LoadScreen(): const ViewScreen(),
        // 'viewscreen': (ctx) => const ViewScreen(),
      },

      // home: loadFlag ? const LoadScreen(): const ViewScreen(),
      // home: LoadScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}




