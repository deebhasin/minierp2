import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class DashboardBarchartChallanMtdData {
  int day;
  int totalChallans;
  charts.Color barColor = charts.ColorUtil.fromDartColor(Colors.green);

  DashboardBarchartChallanMtdData({
    this.day = 0,
    this.totalChallans = 0,
    // this.barColor,
  });

  DashboardBarchartChallanMtdData.fromMap(Map<String, dynamic> res)
      : day = int.parse(res["day"].toString()),
        totalChallans = int.parse(res["totalChallans"].toString()),
        barColor = charts.ColorUtil.fromDartColor(Colors.green);
}
