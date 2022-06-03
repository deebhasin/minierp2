import 'package:erpapp/model/dashboard_challan_data.dart';
import 'package:erpapp/model/report_open_challan.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/challan_product.dart';
import '../utils/localDB_repo.dart';
import '../model/challan.dart';
import '../utils/logfile.dart';

class ChallanProvider with ChangeNotifier {
  String _sortType = "";
  bool _isAscending = true;

  set setSortType(String val) {
    _sortType = val;
  }

  set setIsAscending(bool val) {
    _isAscending = val;
  }

  String get getSortType {
    return _sortType;
  }

  bool get getIsAscending {
    return _isAscending;
  }

  int active = 1;
  Future<List<Challan>> getChallanList() async {
    late List<Challan> challanList;
    LogFile().logEntry("In Challan Provider GetChallanList Start");

    try {
      final List<Map<String, Object?>> queryResult =
          await LocalDBRepo().db.query(
                'CHALLAN',
              );
      challanList = queryResult.map((e) => Challan.fromMap(e)).toList();
      challanList.forEach((challan) async {
        challan.challanProductList =
            await getChallanProductListByChallanId(challan.id);
      });
      LogFile().logEntry("Challan List Length: ${challanList.length}");
    } on Exception catch (e, s) {
      handleException("Error while fetching Challan List $e", e, s);
      challanList = [];
    }
    return challanList;
  }

  Future<List<Challan>> getChallanListByParameters({
    String challanNo = "",
    DateTime? fromDate,
    DateTime? toDate,
    String customerName = "",
    int productId = 0,
    String productName = "",
    double pricePerUnit = 0,
    String productUnit = "",
    double quantity = 0,
    double totalAmount = 0,
    String invoiceNo = "",
    int active = 10,
  }) async {
    late List<Challan> challanList;
    String whereClause = "";
    List whereArgs = [];
    bool argsFlag = false;

    if (challanNo != "") {
      whereClause += "challan_no = ?";
      whereArgs.add(challanNo);
      argsFlag = true;
    }

    if (customerName != "") {
      if (argsFlag) {
        whereClause += " and ";
      }
      whereClause += "customer_name = ?";
      whereArgs.add(customerName);
      argsFlag = true;
    }

    if (invoiceNo == "Not Assigned") {
      if (argsFlag) {
        whereClause += " and ";
      }
      whereClause += "invoice_number = ?";
      whereArgs.add("");
      argsFlag = true;
    } else if (invoiceNo.contains("*or")) {
      if (argsFlag) {
        whereClause += " and ";
      }
      var split = invoiceNo.split("*");
      invoiceNo = split[0];
      LogFile().logEntry(":InvoiceNo Contains * $invoiceNo");
      whereClause += "invoice_number in (?, ?)";
      whereArgs.add(invoiceNo);
      whereArgs.add("");
      argsFlag = true;
    } else if (invoiceNo != "" && invoiceNo != "Not Assigned") {
      if (argsFlag) {
        whereClause += " and ";
      }
      whereClause += "invoice_number = ?";
      whereArgs.add(invoiceNo);
      argsFlag = true;
    }

    if (active != 10) {
      if (argsFlag) {
        whereClause += " and ";
      }
      whereClause += "active = ?";
      whereArgs.add(active);
      argsFlag = true;
    }

    if (fromDate == null) {
      fromDate = DateTime(2000);
    }
    if (toDate == null) {
      toDate = DateTime.now();
    }

    if (argsFlag) {
      whereClause += " and ";
    }
    whereClause += "challan_date between ? and ?";
    whereArgs.add(DateFormat("yyyy-MM-dd").format(fromDate));
    whereArgs.add(DateFormat("yyyy-MM-dd").format(toDate));
    argsFlag = true;

    LogFile().logEntry("In Challan Provider GetChallanListTest Start");
    LogFile().logEntry("Where: $whereClause");
    LogFile().logEntry("Where Args: $whereArgs");

    try {
      final List<Map<String, Object?>> queryResult =
          await LocalDBRepo().db.query(
                'CHALLAN',
                where: whereClause,
                whereArgs: whereArgs,
              );
      challanList = queryResult.map((e) => Challan.fromMap(e)).toList();
      LogFile().logEntry("Challan List Length: ${challanList.length}");
    } on Exception catch (e, s) {
      handleException("Error while fetching Challan List $e", e, s);
      challanList = [];
    }

    for (Challan challan in challanList) {
      challan.challanProductList =
          await getChallanProductListByChallanId(challan.id);
    }
    return challanList;
  }

  Future<List<String>> getChallanListwithGSTbyCompanyName(
      String customerName) async {
    late List<String> gstList;
    LogFile().logEntry("In Challan Provider getChallanListwithGSTbyCompanyName Start");

    try {
      final List<
          Map<String,
              Object?>> queryResult = await LocalDBRepo().db.rawQuery(
          'select a.*,  b.GST from CHALLAN a, PRODUCT b WHERE a.customer_name = "$customerName" AND a.product_name = b.name;');
      //   final List<String> queryResult = await LocalDBRepo().db.rawQuery(
      // 'select a.*,  b.GST from CHALLAN a, PRODUCT b WHERE a.customer_name = "$customerName" AND a.product_name = b.name;'
      // );
      gstList = queryResult.map((e) => e["GST"].toString()).toList();
      // gstList = queryResult;

      LogFile().logEntry("Challan List GST Length: ${gstList.length}");
    } on Exception catch (e, s) {
      handleException("Error while fetching Challan List $e", e, s);
      gstList = [];
    }
    return gstList;
  }

  Future<Challan> getChallanById(int id) async {
    late Challan challan;
    LogFile().logEntry("In Challan Provider GetChallanById Start");

    try {
      final List<Map<String, Object?>> queryResult = await LocalDBRepo()
          .db
          .query('CHALLAN', where: "id = ?", whereArgs: [id]);
      challan = queryResult.map((e) => Challan.fromMap(e)).toList()[0];
      LogFile().logEntry("getting Challan with Id: $id in Challan Provider}");
      List<ChallanProduct> challanProductList =
          await getChallanProductListByChallanId(id);
      challan.challanProductList = challanProductList;
    } on Exception catch (e, s) {
      handleException("Error while fetching Challan with Id $id $e", e, s);
    }
    return challan;
  }

  Future<DashboardChallanData> getDashboardChallanData() async{
    DashboardChallanData dashboardChallanData = DashboardChallanData();
    String _mtdFrom = "${DateFormat('yyyy').format(DateTime.now())}-${DateFormat('MM').format(DateTime.now())}-01";
    String _ytdFrom = "${DateFormat('yyyy').format(DateTime.now())}-04-01";
    // _mtdFrom = "2022-05-01";
    String _mtdTo = "${DateFormat('yyyy').format(DateTime.now())}-${DateFormat('MM').format(DateTime.now())}-31";
    String _ytdTo = "${int.parse(DateFormat('yyyy').format(DateTime.now()))+1}-03-31";
    // _mtdTo = "2022-06-31";
    print ("YTD From: $_ytdFrom");
    LogFile().logEntry("In Challan Provider getChallanData Start");
    try {
      List<Map<String, Object?>> queryResult = await LocalDBRepo()
          .db
          .rawQuery("SELECT count(id) totalChallans, sum(challan_amount) totalChallanAmount from CHALLAN where challan_date between '${_mtdFrom}' and '${_mtdTo}';");
      dashboardChallanData.mtdTotalChallans = int.parse(queryResult[0]["totalChallans"].toString());
      dashboardChallanData.mtdTotalChallanAmount = queryResult[0]["totalChallanAmount"] == null? 0 : double.parse(queryResult[0]["totalChallanAmount"].toString());

      queryResult = await LocalDBRepo()
          .db
          .rawQuery("SELECT count(id) totalPendingChallans, sum(challan_amount) totalPendingChallanAmount from CHALLAN where invoice_number = '' and challan_date between '${_mtdFrom}' and '${_mtdTo}';");
      dashboardChallanData.mtdTotalPendingChallans = int.parse(queryResult[0]["totalPendingChallans"].toString());
      dashboardChallanData.mtdTotalPendingChallanAmount = queryResult[0]["totalPendingChallanAmount"] == null? 0 : double.parse(queryResult[0]["totalPendingChallanAmount"].toString());

      queryResult = await LocalDBRepo()
          .db
          .rawQuery("SELECT count(id) totalInvoices, sum(invoice_total) totalInvoiceAmount from INVOICE where invoice_date between '${_mtdFrom}' and '${_mtdTo}';");
      dashboardChallanData.mtdTotalInvoices = int.parse(queryResult[0]["totalInvoices"].toString());
      dashboardChallanData.mtdTotalInvoiceAmount = queryResult[0]["totalInvoiceAmount"] == null? 0: double.parse(queryResult[0]["totalInvoiceAmount"].toString());


      queryResult = await LocalDBRepo()
          .db
          .rawQuery("SELECT count(id) totalChallans, sum(challan_amount) totalChallanAmount from CHALLAN where challan_date >= '${_ytdFrom}' and  challan_date <= '${_ytdTo}';");
      dashboardChallanData.ytdTotalChallans = int.parse(queryResult[0]["totalChallans"].toString());
      dashboardChallanData.ytdTotalChallanAmount = queryResult[0]["totalChallanAmount"] == null? 0 : double.parse(queryResult[0]["totalChallanAmount"].toString());

      queryResult = await LocalDBRepo()
          .db
          .rawQuery("SELECT count(id) totalPendingChallans, sum(challan_amount) totalPendingChallanAmount from CHALLAN where invoice_number = '' and challan_date between '${_ytdFrom}' and '${_ytdTo}';");
      dashboardChallanData.ytdTotalPendingChallans = int.parse(queryResult[0]["totalPendingChallans"].toString());
      dashboardChallanData.ytdTotalPendingChallanAmount = queryResult[0]["totalPendingChallanAmount"] == null? 0 : double.parse(queryResult[0]["totalPendingChallanAmount"].toString());

      queryResult = await LocalDBRepo()
          .db
          .rawQuery("SELECT count(id) totalInvoices, sum(invoice_total) totalInvoiceAmount from INVOICE where invoice_date between '${_ytdFrom}' and '${_ytdTo}';");
      dashboardChallanData.ytdTotalInvoices = int.parse(queryResult[0]["totalInvoices"].toString());
      dashboardChallanData.ytdTotalInvoiceAmount = queryResult[0]["totalInvoiceAmount"] == null? 0: double.parse(queryResult[0]["totalInvoiceAmount"].toString());

      print("ytdTotalPendingChallans: ${dashboardChallanData.ytdTotalPendingChallans} for dates between $_ytdFrom and $_ytdTo");

      LogFile().logEntry("getting Dashbaord Challan Data getChallanData in Challan Provider}");

    } on Exception catch (e, s) {
      handleException("Error while fetching Dashboard Challan Data getChallanData $e", e, s);
    }
    return dashboardChallanData;

  }

  Future<List<ChallanProduct>> getChallanProductListByChallanId(
      int challanId) async {
    List<ChallanProduct> challanProductList = [];
    LogFile().logEntry("In Challan Product getChallanProductListByChallanNumber");

    try {
      final List<Map<String, Object?>> queryResult =
          await LocalDBRepo().db.query(
        'CHALLAN_PRODUCT',
        where: "challan_id = ?",
        whereArgs: [challanId],
      );
      challanProductList =
          queryResult.map((e) => ChallanProduct.fromMap(e)).toList();
      LogFile().logEntry(
          "Challan Product List Length in getChallanProductListByChallanNumber: ${challanProductList.length}");
    } on Exception catch (e, s) {
      handleException(
          "Error while fetching Challan Product List in getChallanProductListByChallanNumber $e",
          e,
          s);
      challanProductList = [];
    }
    return challanProductList;
  }

  Future<bool> checkChallanNumber(String challanNo) async {
    bool _isChallanNo = false;
    LogFile().logEntry("In Challan Provider checkChallanNumber Start");

    try {
      final List<Map<String, Object?>> queryResult = await LocalDBRepo()
          .db
          .query('CHALLAN', where: "challan_no = ?", whereArgs: [challanNo]);
      List<Challan> _challanList =
          queryResult.map((e) => Challan.fromMap(e)).toList();
      LogFile().logEntry(
          "getting Challan List with Challan No: $challanNo in Challan Provider}");

      _isChallanNo = _challanList.length > 0 ? true : false;

      LogFile().logEntry("IN Challan PRovider _isChallan: $_isChallanNo");
    } on Exception catch (e, s) {
      handleException(
          "Error while fetching Challan with ChallanNo $challanNo $e", e, s);
    }
    return _isChallanNo;
  }

  void challanSave(Challan challan) {
    challan.id == 0 ? _createChallan(challan) : _updateChallan(challan);
  }

  Future<List<ReportOpenChallan>> getOpenChallanReportChallanList() async {
    List<ReportOpenChallan> reportOpenChallanList = [];
    LogFile().logEntry("In Challan Provider getOpenChallanReportChallanList Start");

    try {
      final List<
          Map<String,
              Object?>> queryResult = await LocalDBRepo().db.rawQuery(
          "select customer_name, count(id) challan_count, sum(total) sum_total, sum(tax_amount) sum_tax_amount, sum(challan_amount) sum_challan_amount from CHALLAN  where invoice_number = '' group by customer_name;");
      reportOpenChallanList =
          queryResult.map((e) => ReportOpenChallan.fromMap(e)).toList();
      LogFile().logEntry(
          "getOpenChallanReportChallanList Length: ${reportOpenChallanList.length}");
    } on Exception catch (e, s) {
      handleException(
          "Error while fetching getOpenChallanReportChallanList $e", e, s);
    }
    return reportOpenChallanList;
  }

  Future<int> _createChallan(Challan challan) async {
    int id = 0;
    LogFile().logEntry("In Challan Provider Create Challan Start");
    try {
      id = await LocalDBRepo().db.insert("CHALLAN", challan.toMap());
      LogFile().logEntry("Creating Challan with Id: $id in Challan Provider}");

      await _createChallanProduct(id, challan.challanProductList);
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Creating Challan $e", e, s);
    }
    return id;
  }

  Future<int> _createChallanProduct(
      int challanId, List<ChallanProduct> challanProductList) async {
    int id = 0;

    LogFile().logEntry("In Challan Product Provider Create Challan Product Start");
    try {
      challanProductList.forEach((challanProduct) async {
        if (challanProduct.productName != "") {
          challanProduct.challanId = challanId;
          id = await LocalDBRepo()
              .db
              .insert("CHALLAN_PRODUCT", challanProduct.toMap());
        }
      });

      LogFile().logEntry(
          "Creating Challan Product with Id: $id in Challan Product Provider}");
    } on Exception catch (e, s) {
      handleException("Error while Creating Challan Product $e", e, s);
    }
    return id;
  }

  Future<void> _updateChallan(Challan challan) async {
    LogFile().logEntry("In Challan Provider Update Challan Start");
    try {
      await LocalDBRepo().db.update("CHALLAN", challan.toMap(),
          where: "id = ?", whereArgs: [challan.id]);
      LogFile().logEntry("Updating Challan with Id: ${challan.id} in Challan Provider}");

      LogFile().logEntry(
          "Challan Update Challan Product Length: ${challan.challanProductList.length}");
      LogFile().logEntry(
          "Challan Update Challan Product Length after Delete: ${challan.challanProductList.length}");

      _updateChallanProduct(challan.id, challan.challanProductList);
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Updating Challan $e", e, s);
    }
  }

  Future<void> _updateChallanProduct(
      int challanId, List<ChallanProduct> challanProductList) async {
    await _deleteChallanProductbyChallanId(challanId);
    await _createChallanProduct(challanId, challanProductList);
  }

  Future<void> removeInvoiceNumberInChallan(String invoiceNumber) async {
    LogFile().logEntry(
        "In Update of invoice in Challan in Challan Provider Update Challan Start");
    try {
      await LocalDBRepo().db.rawQuery(
          "UPDATE CHALLAN SET invoice_number = '' where invoice_number = '$invoiceNumber';");
      LogFile().logEntry(
          "Updating Invoice Number in Challan with InvoiceNo: $invoiceNumber Challan Provider}");
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Updating Challan $e", e, s);
    }
  }

  Future<void> updateInvoiceNumberInChallan(
      List<Challan> challanList, String invoiceNumber) async {
    removeInvoiceNumberInChallan(invoiceNumber);

    LogFile().logEntry(
        "In Update of invoice in Challan in Challan Provider Update Challan Start");
    try {
      challanList.forEach((challan) async {
        await LocalDBRepo().db.update("CHALLAN", challan.toMap(),
            where: "id = ?", whereArgs: [challan.id]);
      });
      // await LocalDBRepo().db.rawQuery(
      //     "UPDATE CHALLAN SET invoice_number = '$invoiceNumber' where id in ($whereArgs);");
      // await LocalDBRepo().db.update("CHALLAN",invoiceMap,
      //     where: "id in (?)", whereArgs: idList);
      LogFile().logEntry(
          "Updating Invoice Number in Challan with Invoice No: $invoiceNumber Challan Provider}");
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Updating Challan $e", e, s);
    }
  }

  Future<void> deleteChallan(int id) async {
    LogFile().logEntry("In Challan Provider Delete Challan Start");
    try {
      await LocalDBRepo()
          .db
          .delete("CHALLAN", where: "id = ?", whereArgs: [id]);
      LogFile().logEntry("Deleting Challan with Id: $id in Challan Provider}");
      await _deleteChallanProductbyChallanId(id);
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Deleting Challan $e", e, s);
    }
  }

  Future<void> _deleteChallanProductbyChallanId(int id) async {
    LogFile().logEntry("In Challan Product Provider deleteChallanProductbyChallanId Start");
    try {
      await LocalDBRepo()
          .db
          .delete("CHALLAN_PRODUCT", where: "challan_id = ?", whereArgs: [id]);
      LogFile().logEntry(
          "Deleting Challan Product in deleteChallanProductbyChallanId with Id: $id in Challan Product Provider}");
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Deleting Challan Product $e", e, s);
    }
  }

  Future<ChallanProduct> getChallanProductById(int id) async {
    late ChallanProduct challanProduct;
    LogFile().logEntry("In Challan Product Provider GetChallanById Start");

    try {
      final List<Map<String, Object?>> queryResult = await LocalDBRepo()
          .db
          .query('CHALLAN_PRODUCT', where: "id = ?", whereArgs: [id]);
      challanProduct =
          queryResult.map((e) => ChallanProduct.fromMap(e)).toList()[0];
      LogFile().logEntry(
          "getting Challan Product with Id: $id in Challan Product Provider}");
    } on Exception catch (e, s) {
      handleException(
          "Error while fetching Challan Product with Id $id $e", e, s);
    }
    return challanProduct;
  }

  Future<void> updateChallanProduct(ChallanProduct challanProduct) async {
    LogFile().logEntry("In Challan Product Provider Update Challan Product Start");
    try {
      await LocalDBRepo().db.update("CHALLAN_PRODUCT", challanProduct.toMap(),
          where: "id = ?", whereArgs: [challanProduct.id]);
      LogFile().logEntry(
          "Updating Challan Product with Id: ${challanProduct.id} in Challan Product Provider}");
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Updating Challan Product $e", e, s);
    }
  }

  Future<void> deleteChallanProduct(int id) async {
    LogFile().logEntry("In Challan Product Provider Delete Challan Product Start");
    try {
      await LocalDBRepo()
          .db
          .delete("CHALLAN_PRODUCT", where: "id = ?", whereArgs: [id]);
      LogFile().logEntry(
          "Deleting Challan Product with Id: $id in Challan Product Provider}");
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Deleting Challan Product $e", e, s);
    }
  }

  Future<void> deleteChallanProductNotInList(
      List<ChallanProduct> _challanProductList, int _challanId) async {
    LogFile().logEntry("In Challan Product Provider Delete Challan Product Start");

    String _notInCheck = "";

    for (int i = 0; i < _challanProductList.length; i++) {
      _notInCheck += _challanProductList[i].id.toString();
      _notInCheck += i < (_challanProductList.length - 1) ? "," : "";
    }

    try {
      await LocalDBRepo().db.rawQuery(
          "DELETE FROM CHALLAN_PRODUCT WHERE challan_id = $_challanId AND id not in (${_notInCheck});");
      // .query("CHALLAN_PRODUCT", where: "challan_id = ? AND id not in (?)", whereArgs: [_challanId, _notInCheck]);
      LogFile().logEntry(
          "Deleting Challan Product with Id: $_challanProductList in Challan Product Provider}");
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Deleting Challan Product $e", e, s);
    }
  }

  void handleException(String message, Exception exception, StackTrace st) {
    LogFile().logEntry("Error $message $exception $st");
  }

  void reset() {
    // customer = null;
  }

  void challanTest(ChallanProvider challanProvider) async {
    Challan challan = Challan(
      challanNo: "12as",
      challanDate: DateTime.now(),
      customerName: "Disco",
    );

    // int id = await challanProvider.createChallan(challan);
    // List<Challan> challanList = await challanProvider.getChallanList();
    List<Challan> challanList =
        await challanProvider.getChallanListByParameters(active: 1);

    // challan = await challanProvider.getChallanById(id);
    // challan.customerName = "Khisco";
    // await challanProvider.updateChallan(challan);
    // await challanProvider.deleteChallan(id);
  }
}
