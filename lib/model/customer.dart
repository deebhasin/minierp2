class Customer{
  int id;
  String company_name;
  String shortCompanyName;
  String contact_person;
  String contact_phone;
  String address;
  int pin;
  String city;
  String state;
  String stateCode;
  String gst;
  int creditPeriod;  // NUMBER OF DAYS
  int isActive;
  Customer({
    this.id = 0,
    required this.company_name,
    this.shortCompanyName = "",
    this.contact_person = "",
    this.contact_phone = "",
    this.address = "",
    this.pin = 0,
    this.city = "",
    this.state = "",
    this.stateCode = "",
    this.gst = "",
    this.creditPeriod = 30,
    this.isActive = 1,

  });





  Customer.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        company_name = res["company_name"],
        contact_person = res["contact_person"],
        shortCompanyName = res["short_company_name"],
        contact_phone = res["contact_phone"],
        address = res["address"],
        pin = res["PIN"],
        city = res["city"],
        state = res["state"],
        stateCode = res["state_code"],
        gst = res["GST"],
        creditPeriod = res["credit_period"],
        isActive = res["active"];


    Map<String, Object?> toMap() {
      return {
        // 'id':id,
        'company_name': company_name,
        'contact_person': contact_person,
        'short_company_name': shortCompanyName,
        'contact_phone': contact_phone,
        'address': address,
        'PIN': pin,
        'city': city,
        'state': state,
        'state_code': stateCode,
        'GST': gst,
        'credit_period': creditPeriod,
        'active': isActive,
      };
    }

}