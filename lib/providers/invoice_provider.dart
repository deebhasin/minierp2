import 'package:erpapp/model/invoice.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils/localDB_repo.dart';
import '../providers/challan_provider.dart';

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
    print("In Invoice Provider GetInvoiceList Start");

    try {
      final List<Map<String, Object?>> queryResult =
          await LocalDBRepo().db.query('INVOICE');
      invoiceList = queryResult.map((e) => Invoice.fromMap(e)).toList();
      print("Invoice List Length: ${invoiceList.length}");
    } on Exception catch (e, s) {
      handleException("Error while fetching Invoice List $e", e, s);
      invoiceList = [];
    }
    ChallanProvider challanProvider = ChallanProvider();
    invoiceList.forEach((invoice) async{
      invoice.challanList = await challanProvider.getChallanListByParameters(invoiceNo: invoice.invoiceNo);
    });

    return invoiceList;
  }

  Future<Invoice> getInvoiceById(int id) async {
    late Invoice invoice;
    print("In Invoice Provider GetInvoiceById Start");

    try {
      final List<Map<String, Object?>> queryResult = await LocalDBRepo()
          .db
          .query('INVOICE', where: "id = ?", whereArgs: [id]);
      invoice = queryResult.map((e) => Invoice.fromMap(e)).toList()[0];
      print("getting Invoice with Id: $id in Invoice Provider}");
    } on Exception catch (e, s) {
      handleException("Error while fetching Invoice with Id $id $e", e, s);
    }
    return invoice;
  }

  Future<void> saveInvoice(Invoice invoice) async {
    invoice.id == 0 ? createInvoice(invoice) : updateInvoice(invoice);
  }

  Future<int> createInvoice(Invoice invoice) async {
    int id = 0;
    print("In Invoice Provider Create Invoice Start");
    try {
      id = await LocalDBRepo().db.insert("INVOICE", invoice.toMap());
      print("Creating Invoice with Id: $id in Invoice Provider}");
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Creating Invoice $e", e, s);
    }
    return id;
  }

  Future<void> updateInvoice(Invoice invoice) async {
    print("In Invoice Provider Update Invoice Start");
    try {
      await LocalDBRepo().db.update("INVOICE", invoice.toMap(),
          where: "id = ?", whereArgs: [invoice.id]);
      print("Updating Invoice with Id: ${invoice.id} in Invoice Provider}");
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Updating Invoice $e", e, s);
    }
  }

  Future<void> deleteInvoice(int id) async {
    print("In Invoice Provider Delete Invoice Start");
    try {
      await LocalDBRepo()
          .db
          .delete("INVOICE", where: "id = ?", whereArgs: [id]);
      print("Deleting Invoice with Id: $id in Invoice Provider}");
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Deleting Invoice $e", e, s);
    }
  }

  Future<bool> checkInvoiceNumber(String invoiceNo) async {
    bool _isInvoiceNo = false;
    print("In Invoice Provider checkInvoiceNumber Start");

    try {
      final List<Map<String, Object?>> queryResult = await LocalDBRepo()
          .db
          .query('INVOICE', where: "invoice_no = ?", whereArgs: [invoiceNo]);
      List<Invoice> _invoiceList =
      queryResult.map((e) => Invoice.fromMap(e)).toList();
      print(
          "getting Invoice List with Invoice No: $invoiceNo in Invoice Provider}");

      _isInvoiceNo = _invoiceList.length > 0 ? true : false;

      print("IN Invoice PRovider _isInvoiceNo: $_isInvoiceNo");
    } on Exception catch (e, s) {
      handleException(
          "Error while fetching Invoice with InvoiceNo $invoiceNo $e", e, s);
    }
    return _isInvoiceNo;
  }

  void handleException(String message, Exception exception, StackTrace st) {
    print("Error $message $exception $st");
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
