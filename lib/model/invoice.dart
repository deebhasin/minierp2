import 'package:intl/intl.dart';

import 'challan.dart';

class Invoice{
  int id;
  String invoiceNo;
  late DateTime? invoiceDate;
  String customerName;
  String customerAddress;
  String pdfFileLocation;
  int active;
  List<Challan> challanList = [];

  Invoice({
   this.id = 0,
   this.invoiceNo = "",
   this.invoiceDate,
    this.customerName = "",
    this.customerAddress = "",
    this.pdfFileLocation = "",
    this.active = 1,
}){
    this.invoiceDate = DateTime.now();
  }

  Invoice.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        invoiceNo = res["invoice_no"],
        invoiceDate = DateFormat("yyyy-MM-dd").parse(res["invoice_date"]),
        customerName = res["customer_name"],
        customerAddress = res["customer_address"],
        pdfFileLocation = res["pdf_file_path"],
        active = res["active"];

  Map<String, Object> toMap(){
    return {
      // "id": id,
      "invoice_no": invoiceNo,
      "invoice_date": DateFormat("yyyy-MM-dd").format(invoiceDate!),
      "customer_name": customerName,
      "customer_address": customerAddress,
      "invoice_amount": totalBeforeTax,
      "invoice_tax": taxAmount,
      "invoice_total": invoiceAmount,
      "pdf_file_path": pdfFileLocation,
      "active": active,
    };
  }

  void addChallan(Challan challan){
    removeChallan(challan);
    challanList.add(challan);
  }

  void removeChallan(Challan challan){
    challanList.removeWhere((element) => element.id == challan.id);
  }

  double get totalBeforeTax{
    double val = 0;
    print("InvoiceDart ChallanList Length: ${challanList.length}");
    challanList.forEach((challan) {
      val += challan.total;
    });
    // print("Invoice Dart TotalBeforeTax Challan List Length: ${challanList.length} Total: ${challanList[0].total}");
    print("Total Before Tax Value = $val");
    return val;
  }

  double get taxAmount{
    double val = 0;
    challanList.forEach((challan) {
      val += challan.taxAmount;
    });
    return val;
  }

  double get invoiceAmount{
    double val = 0;
    challanList.forEach((challan) {
      val += challan.challanAmount;
    });
    return val;
  }


}