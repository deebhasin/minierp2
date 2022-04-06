import 'package:intl/intl.dart';

import '../model/challan_product.dart';

class Challan {
  int id;
  String challanNo;
  DateTime? challanDate;
  String customerName;
  double total;
  double taxAmount;
  double challanAmount;
  String invoiceNo;
  List<ChallanProduct> challanProductList = [];
  bool isActive;

  Challan({
    this.id = 0,
    this.challanNo = "",
    this.challanDate ,
    this.customerName = "",
    this.total = 0,
    this.taxAmount = 0,
    this.challanAmount = 0,
    this.invoiceNo = "",
    // this.challanProductList,
    this.isActive = true,
}){
    this.challanDate = DateTime.now();
    // challanProductList = [];
  }

  Challan.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        challanNo = res["challan_no"],
        challanDate = DateFormat("yyyy-MM-dd").parse(res["challan_date"]),
        customerName = res["customer_name"],
        total = res["total"],
        taxAmount = res["tax_amount"],
        challanAmount = res["challan_amount"],
        invoiceNo = res["invoice_number"],
        challanProductList = [],
        isActive = res["active"] == 1? true : false;

  Map<String, Object?> toMap() {
    return {
      // 'id':id,
      'challan_no': challanNo,
      'challan_date': DateFormat("yyyy-MM-dd").format(challanDate!),
      'customer_name': customerName,
      'total': total,
      'tax_amount': taxAmount,
      'challan_amount': challanAmount,
      'invoice_number': invoiceNo,
      'active': isActive == true? 1 : 0,
    };
  }
}