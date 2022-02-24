class Customer{
  int id;
  String name;
  String contact;
  String address;
  int pin;
  String city;
  String state;
  String stateCode;
  String gst;
  int creditPeriod;  // NUMBER OF DAYS
  bool active;
  Customer({
    required this.id,
    required this.name,
    this.contact = "",
    this.address = "",
    this.pin = 0,
    this.city = "",
    this.state = "",
    this.stateCode = "",
    this.gst = "",
    this.creditPeriod = 0,
    this.active = true,
  });
}