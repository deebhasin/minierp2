class MasterOrganization {
  int id;
  String orgName;
  bool isActive;

  MasterOrganization({
    this.id = 0,
    this.orgName = "",
    this.isActive = true,
  });

  MasterOrganization.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        orgName = res["org_name"],
        isActive = res["active"] == 1 ? true : false;

  Map<String, Object?> toMap() {
    return {
      //'id':id,
      'org_name': orgName,
      'active': isActive == true ? 1 : 0,
    };
  }
}
