import 'package:intl/intl.dart';

import '../model/challan_product.dart';

class Challan {
  int id;
  String challanNo;
  DateTime? challanDate;
  String customerName;
  String invoiceNo;
  List<ChallanProduct> challanProductList = [];
  bool isActive;

  Challan({
    this.id = 0,
    this.challanNo = "",
    this.challanDate,
    this.customerName = "",
    this.invoiceNo = "",
    this.isActive = true,
  }) {
    this.challanDate = DateTime.now();
  }

  Challan.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        challanNo = res["challan_no"],
        challanDate = DateFormat("yyyy-MM-dd").parse(res["challan_date"]),
        customerName = res["customer_name"],
        challanProductList = [],
        invoiceNo = res["invoice_number"],
        isActive = res["active"] == 1 ? true : false;

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
      'active': isActive == true ? 1 : 0,
    };
  }

  double get total {
    double val = 0;
    challanProductList.forEach((challanProduct) {
      val += challanProduct.totalBeforeTax;
    });
    return val;
  }

  double get taxAmount {
    double val = 0;
    challanProductList.forEach((challanProduct) {
      val += challanProduct.taxAmount;
    });
    return val;
  }

  double get challanAmount {
    double val = 0;
    challanProductList.forEach((challanProduct) {
      val += challanProduct.totalAmount;
    });
    return val;
  }
}
