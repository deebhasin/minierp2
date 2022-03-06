class Product{
  int id;
  String name;
  String unit;
  double? price_per_unit;
  String HSN;
  String GST;
  int isActive;

  Product({
    this.id = 0,
    required this.name,
    this.unit = "",
    this.price_per_unit,
    this.HSN = "",
    this.GST = "",
    this.isActive = 1,
});

  Product.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        unit = res["unit"],
        price_per_unit = res["price_per_unit"],
        HSN = res["HSN"],
        GST = res["GST"],
        isActive = res["ACTIVE"];


  Map<String, Object?> toMap() {
    return {
      // 'id':id,
      'name': name,
      'unit': unit,
      'price_per_unit': price_per_unit,
      'HSN': HSN,
      'GST': GST,
      'Active': isActive,
    };
  }
}