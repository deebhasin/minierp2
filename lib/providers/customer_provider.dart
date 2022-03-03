import 'package:erpapp/domain/customer.dart';
import 'package:erpapp/utils/localDB_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class CustomerProvider with ChangeNotifier {
  Customer? customer;
  late List<Customer> customerList;
  late List<Map<String, Object?>> customerListFetched;

  //

  Future<List<Customer>> getCustomer() async {
     late List<Customer> cust;
     print("Disco");
    // if(customer  == null) {
      try {
        final List<Map<String, Object?>> queryResult = await LocalDBRepo().db.query('CUSTOMER');
        cust = queryResult.map((e) => Customer.fromMap(e)).toList();
        print("Cust Length: ${cust.length}");
        if(cust == null){
          cust = [Customer(
              company_name: "",
          )];
        }


        print("Gettin new Cust from DB**********");
        // List<Map<String, dynamic>> dataMap = await LocalDBRepo().db.query('CUSTOMER');
        //
        // String id = "";
        // String company_name = "";
        // String contact_person =  "";
        // String contact_phone =  "";
        // String address = "";
        // String pin = "0";
        // String city = "";
        // String state = "";
        // String stateCode = "";
        // String gst = "";
        // String creditPeriod = "0";
        // String isActive = "0";
        //
        // if(dataMap[0]["id"] != null){
        //   id = dataMap[0]["id"].toString();
        // }
        // if(dataMap[0]["company_name"] != null){
        //   company_name = dataMap[0]["company_name"];
        // }
        // if(dataMap[0]["contact_person"] != null){
        //   contact_person = dataMap[0]["contact_person"];
        // }
        // if(dataMap[0]["contact_phone"] != null){
        //   contact_phone = dataMap[0]["contact_phone"];
        // }
        // if(dataMap[0]["address"] != null){
        //   address = dataMap[0]["address"];
        // }
        // if(dataMap[0]["pin"] != null){
        //   pin = dataMap[0]["pin"].toString();
        // }
        // if(dataMap[0]["city"] != null){
        //   city = dataMap[0]["city"];
        // }
        // if(dataMap[0]["state"] != null){
        //   state = dataMap[0]["state"];
        // }
        // if(dataMap[0]["stateCode"] != null){
        //   stateCode = dataMap[0]["stateCode"];
        // }
        // if(dataMap[0]["gst"] != null){
        //   gst = dataMap[0]["gst"];
        // }
        // if(dataMap[0]["creditPeriod"] != null){
        //   creditPeriod = dataMap[0]["creditPeriod"].toString();
        // }
        // if(dataMap[0]["isActive"] != null){
        //   isActive = dataMap[0]["isActive"].toString();
        // }
        //
        // if(dataMap != null){
        //   cust =
        //       Customer(
        //         id: int.parse(id),
        //         company_name: company_name,
        //         contact_person: contact_person,
        //         contact_phone: contact_phone,
        //         address: address,
        //         pin: int.parse(pin),
        //         city: city,
        //         state: state,
        //         stateCode: stateCode,
        //         gst: gst,
        //         creditPeriod: int.parse(creditPeriod),
        //         isActive: int.parse(isActive),
        //       );
          // customer = cust;
        // }
      } on Exception catch (e, s) {
        handleException("Error while fetching cust $e", e, s);

      }
    // }
    print("Comapny Name: ${cust[0].company_name}");
    return cust;
    }

  Future<int> createCustomer(Customer customer) async {
    int id = 0;
    try {
      // id = await LocalDBRepo().db.insert('CUSTOMER',
      //     {'company_name': customer.company_name,
      //       "contact_person": customer.contact_person,
      //       "contact_phone": customer.contact_phone,
      //       'address': customer.address,
      //       'PIN': customer.pin,
      //       'city': customer.city,
      //       'state': customer.state,
      //       'state_cd': customer.stateCode,
      //       'GST': customer.gst,
      //       'credit_period': customer.creditPeriod,
      //       'active': customer.isActive,
      //     },
      //     conflictAlgorithm: ConflictAlgorithm.replace);

      id = await LocalDBRepo().db.insert(
          'CUSTOMER',
          customer.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace
      );

      print("Inserted new customer with id $id and name ${customer.company_name}");
      notifyListeners();

    } on Exception catch (e, s) {
      handleException("Error while fetching customer $e", e, s);
    }

    return id;
  }

  // Future<List<Customer>> getCustomerList() async {

  // Future<List<Customer>> getCustomerList() async {
  //   // if (customerList != null) {
  //   //   return customerList;
  //   // }
  //
  //   try {
  //     customerListFetched = await LocalDBRepo().db.query("CUSTOMER");
  //     customerListFetched.forEach((row) {
  //       // print(row["name"]);
  //       customerList.add(
  //         Customer(
  //           id: int.parse(row["id"].toString()),
  //           name: row["name"].toString(),
  //           contact: row["contact"].toString(),
  //           address: row["address"].toString(),
  //           pin: int.parse(row["PIN"].toString()),
  //           city: row["city"].toString(),
  //           state: row["state"].toString(),
  //           stateCode: row["state_cd"].toString(),
  //           gst: row["GST"].toString(),
  //           creditPeriod: int.parse(row["credit_period"].toString()),
  //           isActive: int.parse(row["active"].toString()),
  //         )
  //       );
  //     });
  //   } on Exception catch (e, s) {
  //     handleException("Error while fetching customer $e", e, s);
  //   }
  //   customerList = customerList.toList();
  //   return customerList;
  // }

  void handleException(String message, Exception exception, StackTrace st) {
    print("Error $message $exception $st");
  }

  void reset() {
    // customer = null;
  }
}
