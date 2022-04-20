import 'package:intl/intl.dart';

import 'challan.dart';

class Invoice{
  int id;
  String invoiceNo;
  late DateTime? invoiceDate;
  String customerName;
  String customerAddress;
  double invoiceAmount;
  double invoiceTax;
  double invoiceTotal;
  String pdfFileLocation;
  int active;
  List<Challan> challanList = [];

  Invoice({
   this.id = 0,
   this.invoiceNo = "",
   this.invoiceDate,
    this.customerName = "",
    this.customerAddress = "",
    this.invoiceAmount = 0,
    this.invoiceTax = 0,
    this.invoiceTotal = 0,
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
        invoiceAmount = res["invoice_amount"],
        invoiceTax = res["invoice_tax"],
        invoiceTotal = res["invoice_total"],
        pdfFileLocation = res["pdf_file_path"],
        active = res["active"];

  Map<String, Object> toMap(){
    return {
      // "id": id,
      "invoice_no": invoiceNo,
      "invoice_date": DateFormat("yyyy-MM-dd").format(invoiceDate!),
      "customer_name": customerName,
      "customer_address": customerAddress,
      "invoice_amount": invoiceAmount,
      "invoice_tax": invoiceTax,
      "invoice_total": invoiceTotal,
      "pdf_file_path": pdfFileLocation,
      "active": active,
    };
  }



}