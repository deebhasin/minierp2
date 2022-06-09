import 'package:erpapp/model/dashboard_barchart_challan_ytd_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/dashboard_barchart_challan_Mtd_data.dart';
import '../model/dashboard_challan_data.dart';
import '../utils/localDB_repo.dart';
import '../utils/logfile.dart';

class DashboardProvider with ChangeNotifier {
  bool _isMtd = true;

  bool get isMtd {
    return _isMtd;
  }

  void set isMtd(bool status) {
    _isMtd = status;
    print("Inside Dashboard Provider _isMTD: $_isMtd");
    notifyListeners();
  }

  String _mtdFrom =
      "${DateFormat('yyyy').format(DateTime.now())}-${DateFormat('MM').format(DateTime.now())}-01";
  String _ytdFrom = "${DateFormat('yyyy').format(DateTime.now())}-04-01";
  // _mtdFrom = "2022-05-01";
  String _mtdTo =
      "${DateFormat('yyyy').format(DateTime.now())}-${DateFormat('MM').format(DateTime.now())}-31";
  String _ytdTo =
      "${int.parse(DateFormat('yyyy').format(DateTime.now())) + 1}-03-31";

  Future<DashboardChallanData> getDashboardChallanData() async {
    DashboardChallanData dashboardChallanData = DashboardChallanData();
    String _mtdFrom =
        "${DateFormat('yyyy').format(DateTime.now())}-${DateFormat('MM').format(DateTime.now())}-01";
    String _ytdFrom = "${DateFormat('yyyy').format(DateTime.now())}-04-01";
    // _mtdFrom = "2022-05-01";
    String _mtdTo =
        "${DateFormat('yyyy').format(DateTime.now())}-${DateFormat('MM').format(DateTime.now())}-31";
    String _ytdTo =
        "${int.parse(DateFormat('yyyy').format(DateTime.now())) + 1}-03-31";
    // _mtdTo = "2022-06-31";
    print("YTD From: $_ytdFrom");
    LogFile().logEntry("In Dashboard Provider getChallanData Start");
    try {
      List<Map<String, Object?>> queryResult = await LocalDBRepo().db.rawQuery(
          "SELECT count(id) totalChallans, sum(challan_amount) totalChallanAmount from CHALLAN where challan_date between '${_mtdFrom}' and '${_mtdTo}';");
      dashboardChallanData.mtdTotalChallans =
          int.parse(queryResult[0]["totalChallans"].toString());
      dashboardChallanData.mtdTotalChallanAmount =
          queryResult[0]["totalChallanAmount"] == null
              ? 0
              : double.parse(queryResult[0]["totalChallanAmount"].toString());

      queryResult = await LocalDBRepo().db.rawQuery(
          "SELECT count(id) totalPendingChallans, sum(challan_amount) totalPendingChallanAmount from CHALLAN where invoice_number = '' and challan_date between '${_mtdFrom}' and '${_mtdTo}';");
      dashboardChallanData.mtdTotalPendingChallans =
          int.parse(queryResult[0]["totalPendingChallans"].toString());
      dashboardChallanData.mtdTotalPendingChallanAmount =
          queryResult[0]["totalPendingChallanAmount"] == null
              ? 0
              : double.parse(
                  queryResult[0]["totalPendingChallanAmount"].toString());

      queryResult = await LocalDBRepo().db.rawQuery(
          "SELECT count(id) totalInvoices, sum(invoice_total) totalInvoiceAmount from INVOICE where invoice_date between '${_mtdFrom}' and '${_mtdTo}';");
      dashboardChallanData.mtdTotalInvoices =
          int.parse(queryResult[0]["totalInvoices"].toString());
      dashboardChallanData.mtdTotalInvoiceAmount =
          queryResult[0]["totalInvoiceAmount"] == null
              ? 0
              : double.parse(queryResult[0]["totalInvoiceAmount"].toString());

      queryResult = await LocalDBRepo().db.rawQuery(
          "SELECT count(id) totalChallans, sum(challan_amount) totalChallanAmount from CHALLAN where challan_date >= '${_ytdFrom}' and  challan_date <= '${_ytdTo}';");
      dashboardChallanData.ytdTotalChallans =
          int.parse(queryResult[0]["totalChallans"].toString());
      dashboardChallanData.ytdTotalChallanAmount =
          queryResult[0]["totalChallanAmount"] == null
              ? 0
              : double.parse(queryResult[0]["totalChallanAmount"].toString());

      queryResult = await LocalDBRepo().db.rawQuery(
          "SELECT count(id) totalPendingChallans, sum(challan_amount) totalPendingChallanAmount from CHALLAN where invoice_number = '' and challan_date between '${_ytdFrom}' and '${_ytdTo}';");
      dashboardChallanData.ytdTotalPendingChallans =
          int.parse(queryResult[0]["totalPendingChallans"].toString());
      dashboardChallanData.ytdTotalPendingChallanAmount =
          queryResult[0]["totalPendingChallanAmount"] == null
              ? 0
              : double.parse(
                  queryResult[0]["totalPendingChallanAmount"].toString());

      queryResult = await LocalDBRepo().db.rawQuery(
          "SELECT count(id) totalInvoices, sum(invoice_total) totalInvoiceAmount from INVOICE where invoice_date between '${_ytdFrom}' and '${_ytdTo}';");
      dashboardChallanData.ytdTotalInvoices =
          int.parse(queryResult[0]["totalInvoices"].toString());
      dashboardChallanData.ytdTotalInvoiceAmount =
          queryResult[0]["totalInvoiceAmount"] == null
              ? 0
              : double.parse(queryResult[0]["totalInvoiceAmount"].toString());

      print(
          "ytdTotalPendingChallans: ${dashboardChallanData.ytdTotalPendingChallans} for dates between $_ytdFrom and $_ytdTo");

      LogFile().logEntry(
          "getting Dashbaord Challan Data getChallanData in Dashboard Provider");
    } on Exception catch (e, s) {
      handleException(
          "Error while fetching Dashboard Challan Data getChallanData $e",
          e,
          s);
    }
    return dashboardChallanData;
  }

  Future<List<DashboardBarchartChallanMtdData>>
      getDashboardBarchartChallanMtdData() async {
    List<DashboardBarchartChallanMtdData> challanMtdDataList = [];
    LogFile().logEntry(
        "In Dashboard Provider getDashboardBarchartChallanMtdData Start");

    try {
      List<Map<String, Object?>> queryResult = await LocalDBRepo().db.rawQuery(
          "SELECT count(id) totalChallans, strftime('%d', challan_date) day from CHALLAN where challan_date between '${_mtdFrom}' and '${_mtdTo}' group by strftime('%d', challan_date);");

      int daysOfMonth = 31;
      int currentMonth = int.parse(DateFormat("MM").format(DateTime.now()));
      if (currentMonth == 04 ||
          currentMonth == 06 ||
          currentMonth == 09 ||
          currentMonth == 11) {
        daysOfMonth = 30;
      } else if (currentMonth == 02) {
        daysOfMonth = 28;
        if (int.parse(DateFormat("yyyy").format(DateTime.now())) / 4 == 0) {
          daysOfMonth = 29;
        }
      }

      challanMtdDataList = queryResult
          .map((e) => DashboardBarchartChallanMtdData.fromMap(e))
          .toList();

      List<DashboardBarchartChallanMtdData> tempList = [];
      late DashboardBarchartChallanMtdData tempData;
      for (int i = 1; i <= daysOfMonth; i++) {
        tempData = DashboardBarchartChallanMtdData(day: i);
        if (challanMtdDataList
            .any((challanMtdData) => challanMtdData.day == i)) {
          tempData = challanMtdDataList
              .firstWhere((challanMtdData) => challanMtdData.day == i);
        }
        tempList.add(tempData);
      }
      challanMtdDataList = tempList;

      LogFile()
          .logEntry("challanMtdDataList Length: ${challanMtdDataList.length}");
      challanMtdDataList.forEach((challanMtdData) =>
          print("${challanMtdData.day}: ${challanMtdData.totalChallans}"));
      print(challanMtdDataList);
    } on Exception catch (e, s) {
      handleException(
          "Error while fetching challanMtdDataList in getDashboardBarchartChallanMtdData in Dashboard Provider $e",
          e,
          s);
    }

    return challanMtdDataList;
  }

  Future<List<DashboardBarchartChallanYtdData>>
      getDashboardBarchartChallanYtdData() async {
    List<DashboardBarchartChallanYtdData> challanYtdDataList = [];
    LogFile().logEntry(
        "In Dashboard Provider getDashboardBarchartchallanYtdData Start");

    try {
      List<Map<String, Object?>> queryResult = await LocalDBRepo().db.rawQuery(
          "SELECT count(id) totalChallans, strftime('%m', challan_date) month from CHALLAN where challan_date between '${_ytdFrom}' and '${_ytdTo}' group by strftime('%m', challan_date);");

      challanYtdDataList = queryResult
          .map((e) => DashboardBarchartChallanYtdData.fromMap(e))
          .toList();

      List<DashboardBarchartChallanYtdData> tempList = [];
      late DashboardBarchartChallanYtdData tempData;

      for (int i = 4; i <= 15; i++) {
        tempData = DashboardBarchartChallanYtdData(month: i.toString());
        // if(i > 12) tempData.month = (i - 12).toString();
        if (challanYtdDataList
            .any((challanYtdData) => int.parse(challanYtdData.month) == i)) {
          tempData = challanYtdDataList.firstWhere(
              (challanYtdData) => int.parse(challanYtdData.month) == i);
          print("TempData: ${tempData.totalChallans}");
        }

        if (int.parse(tempData.month) > 12) {
          tempData.month = (int.parse(tempData.month) - 12).toString();
        }
        else{
          tempData.month = int.parse(tempData.month).toString();
        }
        tempList.add(tempData);
      }
      challanYtdDataList = tempList;

      challanYtdDataList.forEach((tempData) {
        switch (tempData.month) {
            case "1":
              tempData.month = "Jan";
              break;
            case "2":
              tempData.month = "Feb";
              break;
            case "3":
              tempData.month = "Mar";
              break;
            case "4":
              tempData.month = "Apr";
              break;
            case "5":
              tempData.month = "May";
              break;
            case "6":
              tempData.month = "Jun";
              break;
            case "7":
              tempData.month = "Jul";
              break;
            case "8":
              tempData.month = "Aug";
              break;
            case "9":
              tempData.month = "Sep";
              break;
            case "10":
              tempData.month = "Oct";
              break;
            case "11":
              tempData.month = "Nov";
              break;
            case "12":
              tempData.month = "Dec";
              break;
          }
      });

      LogFile()
          .logEntry("challanYtdDataList Length: ${challanYtdDataList.length}");
      challanYtdDataList.forEach((challanYtdData) =>
          print("${challanYtdData.month}: ${challanYtdData.totalChallans}"));
      print(challanYtdDataList);
    } on Exception catch (e, s) {
      handleException(
          "Error while fetching challanYtdDataList in getDashboardBarchartchallanYtdData in Dashboard Provider $e",
          e,
          s);
    }

    return challanYtdDataList;
  }

  void handleException(String message, Exception exception, StackTrace st) {
    LogFile().logEntry("Error $message $exception $st");
  }
}
