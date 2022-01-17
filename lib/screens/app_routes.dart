
import 'package:erpapp/screens/formscreen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const testform = '/testform';


  static Map<String, Widget Function(BuildContext)> routes = {


    AppRoutes.testform: (ctx) => FormScreen(),
  };
}
