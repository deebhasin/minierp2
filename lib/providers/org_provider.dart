import 'package:erpapp/domain/customer.dart';
import 'package:erpapp/domain/organization.dart';
import 'package:erpapp/utils/localDB_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class OrgProvider with ChangeNotifier {
    Organization? _organization;


  Future<Organization> getOrganization() async {
    late Organization org;
    if(_organization  == null) {
      try {
        print("Gettin new org from DB**********");
        List<Map<String, dynamic>> dataMap = await LocalDBRepo().db.query('ORGANIZATION');
        org =
            Organization(id: dataMap[0]['id'], name: dataMap[0]['name'], logo: dataMap[0]['logo'],);
        _organization = org;
      } on Exception catch (e, s) {
        handleException("Error while fetching customer $e", e, s);
      }
    }

    return _organization ?? org;
  }

  Future<int> insertOrganization() async {
    Organization organization = Organization(id:1, name: "iTuple Technologiede", address: "Unitech CP", pin: 122001, city: "GGN", logo: "asset/images/company_logo.jpg");
      int code = -1;
    try {
      print("Inserting new org in DB");
      code = await LocalDBRepo().db.insert('ORGANIZATION',
          {'id': organization.id ,'name': organization.name, 'address': organization.address, 'PIN': organization.pin, 'city': organization.city, 'logo': organization.logo},
          conflictAlgorithm: ConflictAlgorithm.replace);
    } on Exception catch (e, s) {
      handleException("Error while fetching customer $e", e, s);
    }
    return code;
  }

  void handleException(String message, Exception exception, StackTrace st) {
    print("Error $message $exception $st");
  }
}
