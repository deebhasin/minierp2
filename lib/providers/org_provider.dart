import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../model/organization.dart';
import '../utils/localDB_repo.dart';

class OrgProvider with ChangeNotifier {

  Organization _org = Organization();

  Organization get getOrg{
    return _org;
  }

  Future<void> cacheOrg() async{
    _org = await getOrganization();
  }


  Future<Organization> getOrganization() async {
    late Organization org;
    try {
      print("Gettin new org from DB**********");
      List<Map<String, dynamic>> queryResult =
          await LocalDBRepo().db.query('ORGANIZATION');
      List<Organization> orgList = queryResult.map((e) => Organization.fromMap(e)).toList();
      org = orgList.isNotEmpty? orgList[0] : Organization();
    } on Exception catch (e, s) {
      handleException("Error while fetching Organization $e", e, s);
    }
    print("Organization WIth Id : ${org.id}");
    return org;
  }

  Future<void> saveOrganization(Organization organization) async{
    organization.id ==0? await createOrganization(organization) : await editOganization(organization);
  }

  Future<int> createOrganization(Organization organization) async {
    int id = 0;
    print("In Organization Provider Create Organization Start");
    try {
      id = await LocalDBRepo().db.insert("ORGANIZATION", organization.toMap());
      print("Creating Organization with Id: $id in Organization Provider}");
      await cacheOrg();
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Creating Organization $e", e, s);
    }
    return id;
  }

  Future<void> editOganization(Organization organization) async {
    int id = 0;
    print("In Organization Provider Edit Organization Start");
    try {
      id = await LocalDBRepo().db.update("ORGANIZATION", organization.toMap(), where: "id = ?", whereArgs: [organization.id]);
      print("Editing Organization with Id: $id in Organization Provider}");
      await cacheOrg();
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Editing Organization $e", e, s);
    }
  }

  void handleException(String message, Exception exception, StackTrace st) {
    print("Error $message $exception $st");
  }
}
