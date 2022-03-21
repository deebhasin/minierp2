class ChallanProduct{
  int id;
  int challanId;
  String productName;
  String hsnCode;
  double gstPercent;
  double pricePerUnit;
  String productUnit;
  double quantity;
  int active;

  ChallanProduct({
    this.id = 0,
    this.challanId = 0,
    this.productName = "",
    this.hsnCode = "",
    this.gstPercent = 0,
    this.pricePerUnit = 0,
    this.productUnit = "",
    this.quantity = 0,
    this.active = 1,
});

  ChallanProduct.fromMap(Map<String, dynamic> res)
  : id = res["id"],
  challanId = res["challan_id"],
  productName = res["product_name"],
  hsnCode = res["hsn"],
  gstPercent = res["gst_percent"],
  pricePerUnit = res["price_per_unit"],
  productUnit = res["product_unit"],
  quantity = res["quantity"],
  active = res["active"];

  Map<String, Object?> toMap() {
    return {
      'challan_id': challanId,
      'product_name': productName,
      'hsn': hsnCode,
      'gst_percent': gstPercent,
      'price_per_unit': pricePerUnit,
      'product_unit': productUnit,
      'quantity': quantity,
      'active': active,
    };
  }


  double get totalBeforeTax{

    return pricePerUnit == 0 || quantity == 0 ? 0 : pricePerUnit * quantity;
  }

  double get taxAmount{
    return  totalBeforeTax * gstPercent/100;
  }

  double get totalAmount{
    return totalBeforeTax + taxAmount;
  }

}