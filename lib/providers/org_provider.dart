import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../model/organization.dart';
import '../model/master_organization.dart';

import '../utils/localDB_repo.dart';
import '../utils/logfile.dart';

class OrgProvider with ChangeNotifier {

  Organization _org = Organization();
  List<Organization> _orgList = [];
  List<MasterOrganization> _masterOrgList=  [];

  Organization get getOrg{
    return _org;
  }

  Future<void> cacheOrg() async{
    _org = await getOrganization();
  }

  List<Organization> get getOrgList{
    return _orgList;
  }

  Future<void> cacheOrgList() async{
    _orgList = await getOrganizationList();
  }

  List<MasterOrganization> get getMasterOrgList{
    return _masterOrgList;
  }

  Future<void> cacheMasterOrg() async{
    _masterOrgList = await getMasterOrganization();
  }

  Future <List<MasterOrganization>> getMasterOrganization() async{
    List<MasterOrganization> _masterOrgList = [];
    try {
      LogFile().logEntry("Gettin Org List getOrganizationList from DB**********");
      List<Map<String, dynamic>> queryResult =
      await LocalDBRepo().masterDB.query('ORGANIZATION');
      _masterOrgList = queryResult.map((e) => MasterOrganization.fromMap(e)).toList();
    } on Exception catch (e, s) {
      handleException("Error while fetching Organization List in getOrganizationList $e", e, s);
      _masterOrgList = [];
    }
    LogFile().logEntry("Organization List Length from getOrganizationList : ${_masterOrgList.length}");
    return _masterOrgList;
  }


  Future<Organization> getOrganization() async {
    late Organization org;
    try {
      LogFile().logEntry("Gettin new org from DB**********");
      List<Map<String, dynamic>> queryResult =
          await LocalDBRepo().db.query('ORGANIZATION');
      List<Organization> orgList = queryResult.map((e) => Organization.fromMap(e)).toList();
      org = orgList.isNotEmpty? orgList[0] : Organization();
    } on Exception catch (e, s) {
      handleException("Error while fetching Organization $e", e, s);
    }
    LogFile().logEntry("Organization WIth Id : ${org.id}");
    return org;
  }

  Future<List<Organization>> getOrganizationList() async {
    late List<Organization> orgList;
    try {
      LogFile().logEntry("Gettin Org List getOrganizationList from DB**********");
      List<Map<String, dynamic>> queryResult =
      await LocalDBRepo().db.query('ORGANIZATION');
      orgList = queryResult.map((e) => Organization.fromMap(e)).toList();
    } on Exception catch (e, s) {
      handleException("Error while fetching Organization List in getOrganizationList $e", e, s);
      orgList = [];
    }
    LogFile().logEntry("Organization List Length from getOrganizationList : ${orgList.length}");
    return orgList;
  }

  Future<bool> createInMaster(String name) async{
    MasterOrganization masterOrganization = MasterOrganization();
    masterOrganization.orgName = name;

    bool newIsert = false;
    int id = 0;
    if(!_masterOrgList.any((element) => element.orgName == name)){
      try {
        id = await LocalDBRepo().masterDB.insert("ORGANIZATION", masterOrganization.toMap());
        LogFile().logEntry("Inserting in Organization with Id: $id in Mini ERP MasterOrganization Provider}");
        await cacheMasterOrg();
        notifyListeners();
      } on Exception catch (e, s) {
        handleException("Error while Creating Organization $e", e, s);
      }
    }
    newIsert = id == 0? false : true;
    return newIsert;
  }

  Future<int> saveOrganization(Organization organization) async{
    return organization.id ==0? await createOrganization(organization) : await editOganization(organization);
  }

  Future<int> createOrganization(Organization organization) async {
    int id = 0;
    LogFile().logEntry("In Organization Provider Create Organization Start");
    try {
      id = await LocalDBRepo().db.insert("ORGANIZATION", organization.toMap());
      LogFile().logEntry("Creating Organization with Id: $id in Organization Provider}");
      await cacheOrg();
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Creating Organization $e", e, s);
    }
    return id;
  }

  Future<int> editOganization(Organization organization) async {
    int id = 0;
    LogFile().logEntry("In Organization Provider Edit Organization Start");
    try {
      id = await LocalDBRepo().db.update("ORGANIZATION", organization.toMap(), where: "id = ?", whereArgs: [organization.id]);
      LogFile().logEntry("Editing Organization with Id: $id in Organization Provider}");
      await cacheOrg();
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while Editing Organization $e", e, s);
    }
    return id;
  }

  void handleException(String message, Exception exception, StackTrace st) {
    LogFile().logEntry("Error $message $exception $st");
  }
}
