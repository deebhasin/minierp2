class InvoiceProduct {
  int id;
  int invoiceId;
  String productName;
  String hsnCode;
  double gstPercent;
  double pricePerUnit;
  String productUnit;
  double quantity;
  bool isActive;

  InvoiceProduct({
    this.id = 0,
    this.invoiceId = 0,
    this.productName = "",
    this.hsnCode = "",
    this.gstPercent = 0,
    this.pricePerUnit = 0,
    this.productUnit = "",
    this.quantity = 0,
    this.isActive = true,
  });

  InvoiceProduct.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        invoiceId = res["invoice_id"],
        productName = res["product_name"],
        hsnCode = res["hsn"],
        gstPercent = res["gst_percent"],
        pricePerUnit = res["price_per_unit"],
        productUnit = res["product_unit"],
        quantity = res["quantity"],
        isActive = res["active"] == 1 ? true : false;

  Map<String, Object?> toMap() {
    return {
      'invoice_id': invoiceId,
      'product_name': productName,
      'hsn': hsnCode,
      'gst_percent': gstPercent,
      'price_per_unit': pricePerUnit,
      'product_unit': productUnit,
      'quantity': quantity,
      "product_total": totalBeforeTax,
      "product_tax": taxAmount,
      "product_amount": totalAmount,
      'active': isActive == true ? 1 : 0,
    };
  }

  double get totalBeforeTax {
    return pricePerUnit == 0 || quantity == 0 ? 0 : pricePerUnit * quantity;
  }

  double get taxAmount {
    return totalBeforeTax * gstPercent / 100;
  }

  double get totalAmount {
    return totalBeforeTax + taxAmount;
  }

  @override
  bool operator ==(Object other) =>
      other is InvoiceProduct &&
      other.runtimeType == runtimeType &&
      other.productName == productName;

  @override
  int get hashCode => productName.hashCode;
}
