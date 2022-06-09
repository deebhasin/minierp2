import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class DashboardBarchartChallanYtdData {
  String month;
  int totalChallans;
  charts.Color barColor = charts.ColorUtil.fromDartColor(Colors.green);

  DashboardBarchartChallanYtdData({
    this.month = "",
    this.totalChallans = 0,
    // this.barColor,
  });

  DashboardBarchartChallanYtdData.fromMap(Map<String, dynamic> res)
      : month = res["month"],
        totalChallans = int.parse(res["totalChallans"].toString()),
        barColor = charts.ColorUtil.fromDartColor(Colors.green);
}
