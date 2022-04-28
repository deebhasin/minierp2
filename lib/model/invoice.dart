import 'package:intl/intl.dart';

import 'challan.dart';

class Invoice {
  int id;
  String invoiceNo;
  late DateTime? invoiceDate;
  late DateTime? dueDate;
  String customerName;
  String customerAddress;
  String gst;
  String pdfFileLocation;
  String transportMode;
  String vehicleNumber;
  String taxPayableOnReverseCharges;
  String termsAndConditions;
  int active;
  List<Challan> challanList = [];

  Invoice({
    this.id = 0,
    this.invoiceNo = "",
    this.invoiceDate,
    this.dueDate,
    this.customerName = "",
    this.customerAddress = "",
    this.gst = "",
    this.pdfFileLocation = "",
    this.transportMode = "",
    this.vehicleNumber = "",
    this.taxPayableOnReverseCharges = "",
    this.termsAndConditions = "",
    this.active = 1,
  }) {
    this.invoiceDate = DateTime.now();
  }

  Invoice.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        invoiceNo = res["invoice_no"],
        invoiceDate = DateFormat("yyyy-MM-dd").parse(res["invoice_date"]),
        dueDate = DateFormat("yyyy-MM-dd").parse(res["due_date"]),
        customerName = res["customer_name"],
        customerAddress = res["customer_address"],
        gst = res["gst"],
        pdfFileLocation = res["pdf_file_path"],
        transportMode = res["transport_mode"],
        vehicleNumber = res["vehicle_number"],
        taxPayableOnReverseCharges = res["tax_payable_on_reverse_charges"],
        termsAndConditions = res["terms_and_conditions"],
        active = res["active"];

  Map<String, Object> toMap() {
    return {
      // "id": id,
      "invoice_no": invoiceNo,
      "invoice_date": DateFormat("yyyy-MM-dd").format(invoiceDate!),
      "due_date": DateFormat("yyyy-MM-dd").format(dueDate!),
      "customer_name": customerName,
      "customer_address": customerAddress,
      "gst": gst,
      "invoice_amount": totalBeforeTax,
      "invoice_tax": taxAmount,
      "invoice_total": invoiceAmount,
      "pdf_file_path": pdfFileLocation,
      "transport_mode": transportMode,
      "vehicle_number": vehicleNumber,
      "tax_payable_on_reverse_charges": taxPayableOnReverseCharges,
      "terms_and_conditions": termsAndConditions,
      "active": active,
    };
  }

  void addChallan(Challan challan) {
    removeChallan(challan);
    challanList.add(challan);
  }

  void removeChallan(Challan challan) {
    challanList.removeWhere((element) => element.id == challan.id);
  }

  double get totalBeforeTax {
    double val = 0;
    print("InvoiceDart ChallanList Length: ${challanList.length}");
    challanList.forEach((challan) {
      val += challan.total;
    });
    // print("Invoice Dart TotalBeforeTax Challan List Length: ${challanList.length} Total: ${challanList[0].total}");
    print("Total Before Tax Value = $val");
    return val;
  }

  double get taxAmount {
    double val = 0;
    challanList.forEach((challan) {
      val += challan.taxAmount;
    });
    return val;
  }

  double get invoiceAmount {
    double val = 0;
    challanList.forEach((challan) {
      val += challan.challanAmount;
    });
    return val;
  }
}
