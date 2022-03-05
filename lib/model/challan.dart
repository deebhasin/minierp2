class Challan {
  int? id;
  String challanNo;
  String customerName;
  int productId;
  String productName;
  double pricePerUnit;
  double quantity;
  double totalAmount;
  String? invoiceNo;
  int active;

  Challan({
    this.id = 0,
    required this.challanNo,
    required this.customerName,
    required this.productId,
    required this.productName,
    required this.pricePerUnit,
    required this.quantity,
    this.totalAmount = 0,
    this.invoiceNo,
    this.active = 1,
});

}