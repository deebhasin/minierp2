import 'package:intl/intl.dart';

class Challan {
  int id;
  String challanNo;
  DateTime? challanDate;
  String customerName;
  int productId;
  String productName;
  double pricePerUnit;
  String productUnit;
  double quantity;
  double totalAmount;
  String invoiceNo;
  int active;

  Challan({
    this.id = 0,
    this.challanNo = "",
    this.challanDate ,
    this.customerName = "",
    this.productId = 0,
    this.productName = "",
    this.pricePerUnit = 0,
    this.productUnit = "",
    this.quantity = 0,
    this.totalAmount = 0,
    this.invoiceNo = "",
    this.active = 1,
}){
    this.totalAmount = this.pricePerUnit * this.quantity;
    this.challanDate = DateTime.now();
  }

  Challan.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        challanNo = res["challan_no"],
        challanDate = DateFormat("d-M-y").parse(res["challan_date"]),
        customerName = res["customer_name"],
        productId = res["product_id"],
        productName = res["product_name"],
        pricePerUnit = res["price_per_unit"],
        productUnit = res["product_unit"],
        quantity = res["quantity"],
        totalAmount = res["total_amount"],
        invoiceNo = res["invoice_number"],
        active = res["active"];

  Map<String, Object?> toMap() {
    return {
      // 'id':id,
      'challan_no': challanNo,
      'challan_date': DateFormat("d-M-y").format(challanDate!),
      'customer_name': customerName,
      'product_id': productId,
      'product_name': productName,
      'price_per_unit': pricePerUnit,
      "product_unit": productUnit,
      'quantity': quantity,
      'total_amount': totalAmount,
      'invoice_number': invoiceNo,
      'active': active,
    };
  }
}