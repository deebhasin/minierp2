class Organization {
  int id;
  String name;
  String tagLine;
  String contactPerson;
  String address;
  int pin;
  String city;
  String state;
  String phone;
  String mobile;
  String gst;
  String pan;
  String logo;
  String termsAndConditions;
  String bankAccountName;
  String bankAccountNumber;
  String bankName;
  String bankIfscCode;
  String bankBranch;

  // int creditPeriod;  // NUMBER OF DAYS
  // bool active;
  Organization({
    this.id = 0,
    this.name = "",
    this.tagLine = "",
    this.contactPerson = "",
    this.address = "",
    this.pin = 0,
    this.city = "",
    this.state = "",
    this.phone = "",
    this.mobile = "",
    this.gst = "",
    this.pan = "",
    this.logo = "",
    this.termsAndConditions = "",
    this.bankAccountName = "",
    this.bankAccountNumber = "",
    this.bankName = "",
    this.bankIfscCode = "",
    this.bankBranch = "",
  });

  Organization.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        tagLine = res["tag_line"],
        contactPerson = res["contact_person"],
        address = res["address"],
        pin = res["pin"],
        city = res["city"],
        state = res["state"],
        phone = res["phone"],
        mobile = res["mobile"],
        gst = res["gst"],
        pan = res["pan"],
        logo = res["logo"],
        termsAndConditions = res["terms_and_conditions"],
        bankAccountName = res["bank_account_name"],
        bankAccountNumber = res["bank_account_no"],
        bankName = res["bank_name"],
        bankIfscCode = res["bank_ifsc_code"],
        bankBranch = res["bank_branch"];

  Map<String, Object> toMap() {
    return {
      // "id": id,
      "name": name,
      "tag_line": tagLine,
      "contact_person": contactPerson,
      "address": address,
      "pin": pin,
      "city": city,
      "state": state,
      "phone": phone,
      "mobile": mobile,
      "gst": gst,
      "pan": pan,
      "logo": logo,
      "terms_and_conditions": termsAndConditions,
      "bank_account_name": bankAccountName,
      "bank_account_no": bankAccountNumber,
      "bank_name": bankName,
      "bank_ifsc_code": bankIfscCode,
      "bank_branch": bankBranch,
    };
  }
}
