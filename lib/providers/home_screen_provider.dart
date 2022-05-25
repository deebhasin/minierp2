import 'package:flutter/material.dart';

class HomeScreenProvider with ChangeNotifier {
  Map _displayMap = {
    "dispayPage": "All",
    "customerName": "All",
    "isChallanReport": false,
  };

  String _displayPage = "Reports";

  String get getDisplayPage {
    return _displayPage;
  }

  void set setDisplayPage(String display) {
    _displayPage = display;
    notifyListeners();
  }

  Map get getdisplayMap {
    return _displayMap;
  }

  void set setDisplayMap(Map selectionMap) {
    _displayMap = selectionMap;
  }
}
