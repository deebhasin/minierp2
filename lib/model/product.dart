// enum Status{
//   inActive,
//   active,
// }

class Product{
  int id;
  String name;
  String unit;
  double pricePerUnit;
  String HSN;
  String GST;
  bool isActive;

  Product({
    this.id = 0,
    this.name = "",
    this.unit = "",
    this.pricePerUnit = 0,
    this.HSN = "",
    this.GST = "",
    this.isActive = true,
});

  Product.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        unit = res["unit"],
        pricePerUnit = res["price_per_unit"],
        HSN = res["hsn"],
        GST = res["gst"],
        isActive = res["active"] == 1? true : false;


  Map<String, Object?> toMap() {
    return {
      // 'id':id,
      'name': name,
      'unit': unit,
      'price_per_unit': pricePerUnit,
      'hsn': HSN,
      'gst': GST,
      'active': isActive == true? 1 : 0,
    };
  }
}