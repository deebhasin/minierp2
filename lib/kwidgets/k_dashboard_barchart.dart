import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../model/dashboard_barchart_challan_ytd_data.dart';
import '../providers/dashboard_provider.dart';
import '../model/dashboard_barchart_challan_Mtd_data.dart';

class KDashboardBarchart extends StatelessWidget {
  double width;

  KDashboardBarchart({
    Key? key,
    this.width = 500,
  }) : super(key: key);

  late bool isMtd;
  List<DashboardBarchartChallanMtdData> challanMtdDataList = [];
  List<DashboardBarchartChallanYtdData> challanYtdDataList = [];

  @override
  Widget build(BuildContext context) {
    isMtd = Provider.of<DashboardProvider>(context).isMtd;
    print("In KDashboardBarchart isMtd: $isMtd");
    return Consumer<DashboardProvider>(builder: (ctx, provider, child) {
      return isMtd
          ? FutureBuilder(
              future: provider.getDashboardBarchartChallanMtdData(),
              builder: (context,
                  AsyncSnapshot<List<DashboardBarchartChallanMtdData>>
                      snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  if (snapshot.hasError) {
                    return Center(child: Text("An error occured.\n$snapshot"));
                    // return noData(context);
                  } else if (snapshot.hasData) {
                    challanMtdDataList = snapshot.data!;
                  }
                }
                return publishData();
              },
            )
          : FutureBuilder(
              future: provider.getDashboardBarchartChallanYtdData(),
              builder: (context,
                  AsyncSnapshot<List<DashboardBarchartChallanYtdData>>
                      snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  if (snapshot.hasError) {
                    return Center(child: Text("An error occured.\n$snapshot"));
                    // return noData(context);
                  } else if (snapshot.hasData) {
                    challanYtdDataList = snapshot.data!;
                  }
                }
                return publishData();
              },
            );
    });
  }

  Widget publishData() {
    List<charts.Series<DashboardBarchartChallanMtdData, String>> seriesMtd = [
      charts.Series(
          id: "Total Challans",
          data: challanMtdDataList,
          domainFn:
              (DashboardBarchartChallanMtdData dashboardBarchartChallanMtdData,
                      _) =>
                  dashboardBarchartChallanMtdData.day.toString(),
          measureFn:
              (DashboardBarchartChallanMtdData dashboardBarchartChallanMtdData,
                      _) =>
                  dashboardBarchartChallanMtdData.totalChallans,
          colorFn:
              (DashboardBarchartChallanMtdData dashboardBarchartChallanMtdData,
                      _) =>
                  dashboardBarchartChallanMtdData.barColor)
    ];

    List<charts.Series<DashboardBarchartChallanYtdData, String>> seriesYtd = [
      charts.Series(
          id: "Total Challans",
          data: challanYtdDataList,
          domainFn:
              (DashboardBarchartChallanYtdData dashboardBarchartChallanYtdData,
                      _) =>
                  dashboardBarchartChallanYtdData.month,
          measureFn:
              (DashboardBarchartChallanYtdData dashboardBarchartChallanYtdData,
                      _) =>
                  dashboardBarchartChallanYtdData.totalChallans,
          colorFn:
              (DashboardBarchartChallanYtdData dashboardBarchartChallanYtdData,
                      _) =>
                  dashboardBarchartChallanYtdData.barColor)
    ];

    return Column(
      children: [
        Text(
          isMtd? "Total Challans MTD ${DateFormat("MMMM").format(DateTime.now())}" : "Total Challans YTD ${DateFormat("yyyy").format(DateTime.now())}",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          width: 1000,
          height: 300,
          // color: Colors.red,
          child: isMtd
              ? charts.BarChart(seriesMtd, animate: true)
              : charts.BarChart(seriesYtd, animate: true),
          // child: charts.BarChart(seriesYtd, animate: true),
        ),
      ],
    );
  }
}
