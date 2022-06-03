import 'package:erpapp/model/challan_product.dart';
import 'package:erpapp/model/invoice.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/challan.dart';
import '../model/invoice_product.dart';
import '../utils/localDB_repo.dart';
import '../providers/challan_provider.dart';
import '../utils/logfile.dart';

class InvoiceProvider with ChangeNotifier {

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


  Future<List<Invoice>> getInvoiceList() async {
    late List<Invoice> invoiceList;
    LogFile().logEntry("In Invoice Provider GetInvoiceList Start");

    try {
      final List<Map<String, Object?>> queryResult =
          await LocalDBRepo().db.query('INVOICE');
      invoiceList = queryResult.map((e) => Invoice.fromMap(e)).toList();
      LogFile().logEntry("Invoice List Length: ${invoiceList.length}");
    } on Exception catch (e, s) {
      handleException("Error while fetching Invoice List $e", e, s);
      invoiceList = [];
    }
    ChallanProvider challanProvider = ChallanProvider();

    for(Invoice invoice in invoiceList){
      invoice.challanList = await challanProvider.getChallanListByParameters(invoiceNo: invoice.invoiceNo);
    }
    return invoiceList;
  }

  Future<Invoice> getInvoiceById(int id) async {
    late Invoice invoice;
    LogFile().logEntry("In Invoice Provider GetInvoiceById Start");

    try {
      final List<Map<String, Object?>> queryResult = await LocalDBRepo()
          .db
          .query('INVOICE', where: "id = ?", whereArgs: [id]);
      invoice = queryResult.map((e) => Invoice.fromMap(e)).toList()[0];
      LogFile().logEntry("getting Invoice with Id: $id in Invoice Provider}");
    } on Exception catch (e, s) {
      handleException("Error while fetching Invoice with Id $id $e", e, s);
    }
    return invoice;
  }

  Future<Invoice> getInvoiceByInvoiceNo(String invoiceNo) async {
    late Invoice invoice;
    LogFile().logEntry("In Invoice Provider getInvoiceByInvoiceNo Start");

    try {
      final List<Map<String, Object?>> queryResult = await LocalDBRepo()
          .db
          .query('INVOICE', where: "invoice_no = ?", whereArgs: [invoiceNo]);
      invoice = queryResult.map((e) => Invoice.fromMap(e)).toList()[0];
      LogFile().logEntry("getting Invoice with Invoice Number: $invoiceNo in Invoice Provider}");
    } on Exception catch (e, s) {
      handleException("Error while fetching Invoice with Invoice Number $invoiceNo $e", e, s);
    }
    ChallanProvider challanProvider = ChallanProvider();
      invoice.challanList = await challanProvider.getChallanListByParameters(invoiceNo: invoice.invoiceNo);
    return invoice;
  }

  Future<List<InvoiceProduct>> getInvoiceProductList(int invoiceId) async{
    List<InvoiceProduct> invoiceProductList = [];

    LogFile().logEntry("In Invoice Provider getInvoiceProductList Start");

    try {
      final List<Map<String, Object?>> queryResult = await LocalDBRepo()
          .db
          .query('INVOICE_PRODUCT', where: "invoice_id = ?", whereArgs: [invoiceId]);
      invoiceProductList = queryResult.map((e) => InvoiceProduct.fromMap(e)).toList();
      LogFile().logEntry("getting getInvoiceProductList with Invoice Id: $invoiceId in Invoice Provider}");
    } on Exception catch (e, s) {
      handleException("Error while fetching getInvoiceProductList with Invoice Id $invoiceId $e", e, s);
    }
    return invoiceProductList;
  }


  Future<void> saveInvoice(Invoice invoice) async {
    invoice.id == 0 ? createInvoice(invoice) : updateInvoice(invoice);
  }

  Future<int> createInvoice(Invoice invoice) async {
    int id = 0;
    List<InvoiceProduct> invoiceProductListTemp = [];

    LogFile().logEntry("In Invoice Provider Create Invoice Start");
    try {
      id = await LocalDBRepo().db.insert("INVOICE", invoice.toMap());
      LogFile().logEntry("Creating Invoice with Id: $id in Invoice Provider}");

      LogFile().logEntry("CHallanlist Length in CInvoice Create: ${invoice.challanList.length}");

      invoice.challanList.forEach((challan){
        challan.challanProductList.forEach((challanProduct) async{
          InvoiceProduct ip = await _createInvoiceProduct(invoice.id, challanProduct);
          if(invoiceProductListTemp.contains(ip)){
            InvoiceProduct iptemp = invoiceProductListTemp.firstWhere((ipt) => ipt.productName == ip.productName);
            _incrementInvoiceProduct(iptemp, challanProduct);
          }
          else{
            invoiceProductListTemp.add(ip);
          }
        });
      });
      LogFile().logEntry("invoiceProductListTemp Length in Invoice Create: ${invoiceProductListTemp.length}");
      await updateInvoiceNumberInChallan(invoice.challanList, invoice.invoiceNo);
      await _deleteInvoiceProduct(invoice.id);
      await _createInvoiceProductInDB(invoiceProductListTemp, id);
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Creating Invoice $e", e, s);
    }
    return id;
  }

  InvoiceProduct _createInvoiceProduct(int invoiceId, ChallanProduct cp){
    return  InvoiceProduct(
      invoiceId: invoiceId,
      productName: cp.productName,
      hsnCode: cp.hsnCode,
      gstPercent: cp.gstPercent,
      pricePerUnit: cp.pricePerUnit,
      productUnit: cp.productUnit,
      quantity: cp.quantity,
      isActive: cp.isActive,
    );
  }

  Future<void> _createInvoiceProductInDB(List<InvoiceProduct> invoiceProductList, int id)async{

    LogFile().logEntry("In Invoice Product Provider Create INvoice Product Start");
    try {

      invoiceProductList.forEach((invoiceProduct) async{
        invoiceProduct.invoiceId = id;
        await LocalDBRepo()
            .db
            .insert("INVOICE_PRODUCT", invoiceProduct.toMap());
      });
      LogFile().logEntry(
          "Creating Invoice Product with invoiceProductList LEngth: ${invoiceProductList.length} in Invoice Product Provider}");
    } on Exception catch (e, s) {
      handleException("Error while Creating Invoice Product $e", e, s);
    }
  }

  void _incrementInvoiceProduct(InvoiceProduct ip, ChallanProduct cp){
    ip.quantity += cp.quantity;
  }
  Future<void> _deleteInvoiceProduct(int invoiceId)async{
    LogFile().logEntry("In Invoice Provider Delete Invoice Product Start");
    try {
      await LocalDBRepo()
          .db
          .delete("INVOICE_PRODUCT", where: "invoice_id = ?", whereArgs: [invoiceId]);
      LogFile().logEntry("Deleting Invoice Product with Id: $invoiceId in Invoice Provider}");
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Deleting Invoice $e", e, s);
    }
  }


  Future<void> updateInvoice(Invoice invoice) async {
    List<InvoiceProduct> invoiceProductListTemp = [];

    LogFile().logEntry("In Invoice Provider Update Invoice Start");
    try {
      await LocalDBRepo().db.update("INVOICE", invoice.toMap(),
          where: "id = ?", whereArgs: [invoice.id]);
      LogFile().logEntry("Updating Invoice with Id: ${invoice.id} in Invoice Provider}");

      invoice.challanList.forEach((challan){
        challan.challanProductList.forEach((challanProduct) async{
          InvoiceProduct ip = await _createInvoiceProduct(invoice.id, challanProduct);
          if(invoiceProductListTemp.contains(ip)){
            InvoiceProduct iptemp = invoiceProductListTemp.firstWhere((ipt) => ipt.productName == ip.productName);
            _incrementInvoiceProduct(iptemp, challanProduct);
          }
          else{
            invoiceProductListTemp.add(ip);
          }
        });
      });
      await updateInvoiceNumberInChallan(invoice.challanList, invoice.invoiceNo);
      await _deleteInvoiceProduct(invoice.id);
      await _createInvoiceProductInDB(invoiceProductListTemp, invoice.id);
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Updating Invoice $e", e, s);
    }
  }

  Future<void> updateInvoiceNumberInChallan(
      List<Challan> challanList, String invoiceNumber) async {
    removeInvoiceNumberInChallan(invoiceNumber);


    LogFile().logEntry(
        "In Update of invoice in Challan in Challan Provider Update Challan Start");
    try {
      challanList.forEach((challan) async {
        challan.invoiceNo = invoiceNumber;
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

  Future<void> deleteInvoice(int id) async {
    LogFile().logEntry("In Invoice Provider Delete Invoice Start");
    Invoice invoice = await getInvoiceById(id);
    try {
      await LocalDBRepo()
          .db
          .delete("INVOICE", where: "id = ?", whereArgs: [id]);
      LogFile().logEntry("Deleting Invoice with Id: $id in Invoice Provider}");
      _deleteInvoiceProduct(id);
      removeInvoiceNumberInChallan(invoice.invoiceNo);
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Deleting Invoice $e", e, s);
    }
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

  Future<bool> checkInvoiceNumber(String invoiceNo) async {
    bool _isInvoiceNo = false;
    LogFile().logEntry("In Invoice Provider checkInvoiceNumber Start");

    try {
      final List<Map<String, Object?>> queryResult = await LocalDBRepo()
          .db
          .query('INVOICE', where: "invoice_no = ?", whereArgs: [invoiceNo]);
      List<Invoice> _invoiceList =
      queryResult.map((e) => Invoice.fromMap(e)).toList();
      LogFile().logEntry(
          "getting Invoice List with Invoice No: $invoiceNo in Invoice Provider}");

      _isInvoiceNo = _invoiceList.length > 0 ? true : false;

      LogFile().logEntry("IN Invoice PRovider _isInvoiceNo: $_isInvoiceNo");
    } on Exception catch (e, s) {
      handleException(
          "Error while fetching Invoice with InvoiceNo $invoiceNo $e", e, s);
    }
    return _isInvoiceNo;
  }

  void handleException(String message, Exception exception, StackTrace st) {
    LogFile().logEntry("Error $message $exception $st");
  }

  void reset() {
    // customer = null;
  }

  void invoiceTest(InvoiceProvider invoiceProvider) async {
    Invoice invoice = Invoice();

    int id = await invoiceProvider.createInvoice(invoice);
    List<Invoice> invoiceList = await invoiceProvider.getInvoiceList();
    invoice = await invoiceProvider.getInvoiceById(id);
    invoice.customerName = "Khisco";
    await invoiceProvider.updateInvoice(invoice);
    await invoiceProvider.deleteInvoice(id);
  }
}
