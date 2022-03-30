import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/challan_product.dart';
import '../utils/localDB_repo.dart';
import '../model/challan.dart';

class ChallanProvider with ChangeNotifier {
  int active = 1;
  Future<List<Challan>> getChallanList() async {
    late List<Challan> challanList;
    print("In Challan Provider GetChallanList Start");

    try {
      final List<Map<String, Object?>> queryResult =
          await LocalDBRepo().db.query(
                'CHALLAN',
              );
      challanList = queryResult.map((e) => Challan.fromMap(e)).toList();
      print("Challan List Length: ${challanList.length}");
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

    print("In Challan Provider GetChallanListTest Start");
    print("Where: $whereClause");
    print("Where Args: $whereArgs");

    try {
      final List<Map<String, Object?>> queryResult =
          await LocalDBRepo().db.query(
                'CHALLAN',
                where: whereClause,
                whereArgs: whereArgs,
              );
      challanList = queryResult.map((e) => Challan.fromMap(e)).toList();
      print("Challan List Length: ${challanList.length}");
    } on Exception catch (e, s) {
      handleException("Error while fetching Challan List $e", e, s);
      challanList = [];
    }
    return challanList;
  }

  Future<List<String>> getChallanListwithGSTbyCompanyName(
      String customerName) async {
    late List<String> gstList;
    print("In Challan Provider getChallanListwithGSTbyCompanyName Start");

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

      print("Challan List GST Length: ${gstList.length}");
    } on Exception catch (e, s) {
      handleException("Error while fetching Challan List $e", e, s);
      gstList = [];
    }
    return gstList;
  }

  Future<Challan> getChallanById(int id) async {
    late Challan challan;
    print("In Challan Provider GetChallanById Start");

    try {
      final List<Map<String, Object?>> queryResult = await LocalDBRepo()
          .db
          .query('CHALLAN', where: "id = ?", whereArgs: [id]);
      challan = queryResult.map((e) => Challan.fromMap(e)).toList()[0];
      print("getting Challan with Id: $id in Challan Provider}");
      List<ChallanProduct> challanProductList =
          await _getChallanProductListByChallanId(id);
      challan.challanProductList = challanProductList;
    } on Exception catch (e, s) {
      handleException("Error while fetching Challan with Id $id $e", e, s);
    }
    return challan;
  }

  Future<List<ChallanProduct>> _getChallanProductListByChallanId(
      int challanId) async {
    List<ChallanProduct> challanProductList = [];
    print("In Challan Product getChallanProductListByChallanNumber");

    try {
      final List<Map<String, Object?>> queryResult =
          await LocalDBRepo().db.query(
        'CHALLAN_PRODUCT',
        where: "challan_id = ?",
        whereArgs: [challanId],
      );
      challanProductList =
          queryResult.map((e) => ChallanProduct.fromMap(e)).toList();
      print(
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

  void challanSave(Challan challan) {
    challan.id == 0 ? createChallan(challan) : updateChallan(challan);
  }


  Future<int> createChallan(Challan challan) async {
    int id = 0;
    print("In Challan Provider Create Challan Start");
    try {
      id = await LocalDBRepo().db.insert("CHALLAN", challan.toMap());
      print("Creating Challan with Id: $id in Challan Provider}");

      challan.challanProductList!.every((_challanProduct){
        if(_challanProduct.productName != "") {
          _challanProduct.challanId = id;
          print(
              "Challan Id in CreateChallan for Challan Product ${_challanProduct.challanId}");
          createChallanProduct(_challanProduct);
        }
        return true;
      });

      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Creating Challan $e", e, s);
    }
    return id;
  }

  Future<int> createChallanProduct(ChallanProduct challanProduct) async {
    int id = 0;
    print("In Challan Product Provider Create Challan Product Start");
    try {
      id = await LocalDBRepo()
          .db
          .insert("CHALLAN_PRODUCT", challanProduct.toMap());
      print(
          "Creating Challan Product with Id: $id in Challan Product Provider}");
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Creating Challan Product $e", e, s);
    }
    return id;
  }

  Future<void> updateChallan(Challan challan) async {
    print("In Challan Provider Update Challan Start");
    try {
      await LocalDBRepo().db.update("CHALLAN", challan.toMap(),
          where: "id = ?", whereArgs: [challan.id]);
      print("Updating Challan with Id: ${challan.id} in Challan Provider}");

      print("Challan Update Challan Product Length: ${challan.challanProductList!.length}");
      deleteChallanProductbyChallanId(challan.id);
      print("Challan Update Challan Product Length after Delete: ${challan.challanProductList!.length}");

      challan.challanProductList!.every((_challanProduct){
        if(_challanProduct.productName != "") {
          _challanProduct.challanId = challan.id;
          print(
              "Challan Id in CreateChallan for Challan Product ${_challanProduct.challanId}");
          createChallanProduct(_challanProduct);
        }
        return true;
      });

      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Updating Challan $e", e, s);
    }
  }

  Future<void> updateInvoiceNumberInChallan(
      List<int> idList, String invoiceNumber) async {
    var invoiceMap = Map();
    String whereArgs = "";
    for (int i = 0; i < idList.length; i++) {
      whereArgs += idList[i].toString();
      if (i != idList.length - 1) {
        whereArgs += ",";
      }
    }
    invoiceMap = {"invoice_number": invoiceNumber};
    print(
        "In Update of invoice in Challan in Challan Provider Update Challan Start");
    try {
      await LocalDBRepo().db.rawQuery(
          "UPDATE CHALLAN SET invoice_number = '$invoiceNumber' where id in ($whereArgs);");
      // await LocalDBRepo().db.update("CHALLAN",invoiceMap,
      //     where: "id in (?)", whereArgs: idList);
      print(
          "Updating Invoice Number in Challan with Id: $whereArgs Challan Provider}");
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Updating Challan $e", e, s);
    }
  }

  Future<void> deleteChallan(int id) async {
    print("In Challan Provider Delete Challan Start");
    try {
      await LocalDBRepo()
          .db
          .delete("CHALLAN", where: "id = ?", whereArgs: [id]);
      print("Deleting Challan with Id: $id in Challan Provider}");
      deleteChallanProductbyChallanId(id);
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Deleting Challan $e", e, s);
    }
  }

  Future<void> deleteChallanProductbyChallanId(int id) async {
    print("In Challan Product Provider deleteChallanProductbyChallanId Start");
    try {
      await LocalDBRepo()
          .db
          .delete("CHALLAN_PRODUCT", where: "challan_id = ?", whereArgs: [id]);
      print(
          "Deleting Challan Product in deleteChallanProductbyChallanId with Id: $id in Challan Product Provider}");
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Deleting Challan Product $e", e, s);
    }
  }

  Future<ChallanProduct> getChallanProductById(int id) async {
    late ChallanProduct challanProduct;
    print("In Challan Product Provider GetChallanById Start");

    try {
      final List<Map<String, Object?>> queryResult = await LocalDBRepo()
          .db
          .query('CHALLAN_PRODUCT', where: "id = ?", whereArgs: [id]);
      challanProduct =
      queryResult.map((e) => ChallanProduct.fromMap(e)).toList()[0];
      print(
          "getting Challan Product with Id: $id in Challan Product Provider}");
    } on Exception catch (e, s) {
      handleException(
          "Error while fetching Challan Product with Id $id $e", e, s);
    }
    return challanProduct;
  }

  Future<void> updateChallanProduct(ChallanProduct challanProduct) async {
    print("In Challan Product Provider Update Challan Product Start");
    try {
      await LocalDBRepo().db.update("CHALLAN_PRODUCT", challanProduct.toMap(),
          where: "id = ?", whereArgs: [challanProduct.id]);
      print(
          "Updating Challan Product with Id: ${challanProduct.id} in Challan Product Provider}");
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Updating Challan Product $e", e, s);
    }
  }

  Future<void> deleteChallanProduct(int id) async {
    print("In Challan Product Provider Delete Challan Product Start");
    try {
      await LocalDBRepo()
          .db
          .delete("CHALLAN_PRODUCT", where: "id = ?", whereArgs: [id]);
      print(
          "Deleting Challan Product with Id: $id in Challan Product Provider}");
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Deleting Challan Product $e", e, s);
    }
  }

  Future<void> deleteChallanProductNotInList(List<ChallanProduct> _challanProductList, int _challanId) async {
    print("In Challan Product Provider Delete Challan Product Start");

    String _notInCheck = "";

    for(int i = 0; i < _challanProductList.length; i++){
      _notInCheck += _challanProductList[i].id.toString();
      _notInCheck += i < (_challanProductList.length - 1)? "," : "";
    }

    try {
      await LocalDBRepo()
          .db
          .rawQuery("DELETE FROM CHALLAN_PRODUCT WHERE challan_id = $_challanId AND id not in (${_notInCheck});");
      // .query("CHALLAN_PRODUCT", where: "challan_id = ? AND id not in (?)", whereArgs: [_challanId, _notInCheck]);
      print(
          "Deleting Challan Product with Id: $_challanProductList in Challan Product Provider}");
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Deleting Challan Product $e", e, s);
    }
  }

  void handleException(String message, Exception exception, StackTrace st) {
    print("Error $message $exception $st");
  }

  void reset() {
    // customer = null;
  }

  void challanTest(ChallanProvider challanProvider) async {
    Challan challan = Challan(
      challanNo: "12as",
      challanDate: DateTime.now(),
      customerName: "Disco",
      total: 5000,
      taxAmount: 900,
      challanAmount: 5900,
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
