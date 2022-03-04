class Product{
  int? id;
  String name;
  String unit;
  String HSN;
  String GST;
  int isActive;

  Product({
    this.id = 0,
    required this.name,
    this.unit = "",
    this.HSN = "",
    this.GST = "",
    this.isActive = 1,
});

  Product.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        unit = res["unit"],
        HSN = res["HSN"],
        GST = res["GST"],
        isActive = res["ACTIVE"];


  Map<String, Object?> toMap() {
    return {
      // 'id':id,
      'name': name,
      'unit': unit,
      'HSN': HSN,
      'GST': GST,
      'Active': isActive,
    };
  }
}