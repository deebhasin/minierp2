import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../model/customer.dart';
import '../utils/localDB_repo.dart';

class CustomerProvider with ChangeNotifier {

  Future<List<Customer>> getCustomerList() async {
     late List<Customer> customerList;
     print("In Customer Provider GetCustomer Start");

      try {
        final List<Map<String, Object?>> queryResult = await LocalDBRepo().db.query('CUSTOMER');
        customerList = queryResult.map((e) => Customer.fromMap(e)).toList();
        print("Customer List Length: ${customerList.length}");
      } on Exception catch (e, s) {
        handleException("Error while fetching cust $e", e, s);
        customerList = [];
      }
    return customerList;
    }

  Future<Customer> getCustomerWithId(int id) async {
    late Customer customer;
    print("In Customer Provider GetCustomer with Id $id Start");

    try {
      final List<Map<String, Object?>> queryResult = await LocalDBRepo().db.query('CUSTOMER',where: "id = ?", whereArgs: [id]);
      customer = queryResult.map((e) => Customer.fromMap(e)).toList()[0];
      print("Getting Customer with id $id");
    } on Exception catch (e, s) {
      handleException("Error while fetching customer $e", e, s);
    }
    return customer;
  }

  Future<int> saveCustomer(Customer customer) async {
    return customer.id == 0? createCustomer(customer) : updateCustomer(customer);
  }

  Future<int> createCustomer(Customer customer) async {
    int id = 0;
    try {
      print("Creating New Customer in Customer Provider");
      id = await LocalDBRepo().db.insert(
          'CUSTOMER',
          customer.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace
      );

      print("Inserted new customer with id $id and name ${customer.company_name}");
      notifyListeners();

    } on Exception catch (e, s) {
      handleException("Error while creating customer $e", e, s);
    }

    return id;
  }

  void handleException(String message, Exception exception, StackTrace st) {
    print("Error $message $exception $st");
  }

  void reset() {
    // customer = null;
  }

  Future<void> deleteCustomer(int id) async {
    print("Deleting  Customer with id $id in Customer Provider");
    try {
      await LocalDBRepo().db.delete(
        'CUSTOMER',
        where: "id = ?",
        whereArgs: [id],
      );
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while deleting customer $e", e, s);
    }
  }

    Future<int> updateCustomer(Customer customer) async {
      print("Updating Customer with id ${customer.id} in Customer Provider");
      try {
        await LocalDBRepo().db.update(
          'CUSTOMER',
          customer.toMap(),
          where: "id = ?",
          whereArgs: [customer.id],
        );
        notifyListeners();
      } on Exception catch (e,s) {
        handleException("Error while updating customer $e", e, s);
      }
    return -1;
  }



}


