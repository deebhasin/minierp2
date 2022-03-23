import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../model/challan_product.dart';
import '../utils/localDB_repo.dart';

class ChallanProductProvider with ChangeNotifier {
  Future<List<ChallanProduct>> getChallanProductList() async {
    List<ChallanProduct> challanProductList = [];
    print("In Challan Product getChallanProductList");

    try {
      final List<Map<String, Object?>> queryResult =
          await LocalDBRepo().db.query(
                'CHALLAN_PRODUCTS',
              );
      challanProductList =
          queryResult.map((e) => ChallanProduct.fromMap(e)).toList();
      print("Challan List Length: ${challanProductList.length}");
    } on Exception catch (e, s) {
      handleException("Error while fetching Challan Product List $e", e, s);
      challanProductList = [];
    }
    return challanProductList;
  }

  Future<List<ChallanProduct>> getChallanProductListByChallanId(
      int challanId) async {
    List<ChallanProduct> challanProductList = [];
    print("In Challan Product getChallanProductListByChallanNumber");

    try {
      final List<Map<String, Object?>> queryResult =
          await LocalDBRepo().db.query(
        'CHALLAN_PRODUCTS',
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

  Future<ChallanProduct> getChallanProductById(int id) async {
    late ChallanProduct challanProduct;
    print("In Challan Product Provider GetChallanById Start");

    try {
      final List<Map<String, Object?>> queryResult = await LocalDBRepo()
          .db
          .query('CHALLAN_PRODUCTS', where: "id = ?", whereArgs: [id]);
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

  Future<int> createChallanProduct(ChallanProduct challanProduct) async {
    int id = 0;
    print("In Challan Product Provider Create Challan Product Start");
    try {
      id = await LocalDBRepo()
          .db
          .insert("CHALLAN_PRODUCTS", challanProduct.toMap());
      print(
          "Creating Challan Product with Id: $id in Challan Product Provider}");
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Creating Challan Product $e", e, s);
    }
    return id;
  }

  Future<void> updateChallanProduct(ChallanProduct challanProduct) async {
    print("In Challan Product Provider Update Challan Product Start");
    try {
      await LocalDBRepo().db.update("CHALLAN_PRODUCTS", challanProduct.toMap(),
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
          .delete("CHALLAN_PRODUCTS", where: "id = ?", whereArgs: [id]);
      print(
          "Deleting Challan Product with Id: $id in Challan Product Provider}");
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Deleting Challan Product $e", e, s);
    }
  }

  Future<void> deleteChallanProductbyChallanId(int id) async {
    print("In Challan Product Provider deleteChallanProductbyChallanId Start");
    try {
      await LocalDBRepo()
          .db
          .delete("CHALLAN_PRODUCTS", where: "challan_id = ?", whereArgs: [id]);
      print(
          "Deleting Challan Product in deleteChallanProductbyChallanId with Id: $id in Challan Product Provider}");
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
          .rawQuery("DELETE FROM CHALLAN_PRODUCTS WHERE challan_id = $_challanId AND id not in (${_notInCheck});");
      // .query("CHALLAN_PRODUCTS", where: "challan_id = ? AND id not in (?)", whereArgs: [_challanId, _notInCheck]);
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
}
