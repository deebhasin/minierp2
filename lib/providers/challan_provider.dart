import 'package:erpapp/model/challan.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/localDB_repo.dart';


class ChallanProvider with ChangeNotifier{

  Future<List<Challan>> getChallanList() async{
    late List<Challan> challanList;
    print("In Challan Provider GetChallanList Start");

    try {
      final List<Map<String, Object?>> queryResult = await LocalDBRepo().db.query('CHALLAN');
      challanList = queryResult.map((e) => Challan.fromMap(e)).toList();
      print("Challan List Length: ${challanList.length}");
    } on Exception catch (e, s) {
      handleException("Error while fetching Challan List $e", e, s);
      challanList = [];
    }
    return challanList;
  }

  Future<Challan> getChallanById(int id) async{
    late Challan challan;
    print("In Challan Provider GetChallanById Start");

    try {
      final List<Map<String, Object?>> queryResult = await LocalDBRepo().db.query('CHALLAN',where: "id = ?",whereArgs: [id]);
      challan = queryResult.map((e) => Challan.fromMap(e)).toList()[0];
      print("getting Challan with Id: $id in Challan Provider}");
    } on Exception catch (e, s) {
      handleException("Error while fetching Challan with Id $id $e", e, s);
    }
    return challan;
  }

  Future<int> createChallan(Challan challan) async{
    int id = 0;
    print("In Challan Provider Create Challan Start");
    try {
      id = await LocalDBRepo().db.insert("CHALLAN", challan.toMap());
      print("Creating Challan with Id: $id in Challan Provider}");
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Creating Challan $e", e, s);
    }
    return id;
  }

  Future<void> updateChallan(Challan challan) async{
    print("In Challan Provider Update Challan Start");
    try {
      await LocalDBRepo().db.update("CHALLAN", challan.toMap(), where: "id = ?", whereArgs: [challan.id]);
      print("Updating Challan with Id: ${challan.id} in Challan Provider}");
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Updating Challan $e", e, s);
    }
  }
  
  Future<void> deleteChallan(int id) async{
    print("In Challan Provider Delete Challan Start");
    try {
      await LocalDBRepo().db.delete("CHALLAN", where: "id = ?", whereArgs: [id]);
      print("Deleting Challan with Id: $id in Challan Provider}");
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Deleting Challan $e", e, s);
    }
  }

  void handleException(String message, Exception exception, StackTrace st) {
    print("Error $message $exception $st");
  }

  void reset() {
    // customer = null;
  }

  void challanTest(ChallanProvider challanProvider) async{

    Challan challan = Challan(
        challanNo: "12as",
        challanDate: DateTime.now(),
        customerName: "Disco",
        productId: 12,
        productName: "Mineral Water",
        pricePerUnit: 10,
        quantity: 10,
        totalAmount: 100,
    );

    int id = await challanProvider.createChallan(challan);
    // List<Challan> challanList = await challanProvider.getChallanList();
    // challan = await challanProvider.getChallanById(id);
    // challan.customerName = "Khisco";
    // await challanProvider.updateChallan(challan);
    // await challanProvider.deleteChallan(id);
  }
}