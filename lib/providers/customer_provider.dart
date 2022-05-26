import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../model/customer.dart';
import '../utils/localDB_repo.dart';
import '../utils/logfile.dart';

class CustomerProvider with ChangeNotifier {

  List<Customer> _customerList = [];

  List<Customer> get customerList{
    return [..._customerList];
  }

  Future<void> cacheCustomer() async{
    _customerList = await getCustomerList();
  }

  Future<List<Customer>> getCustomerList() async {
     late List<Customer> customerList;
     LogFile().logEntry("In Customer Provider GetCustomer Start");

      try {
        final List<Map<String, Object?>> queryResult = await LocalDBRepo().db.query('CUSTOMER');
        customerList = queryResult.map((e) => Customer.fromMap(e)).toList();
        LogFile().logEntry("Customer List Length: ${customerList.length}");
      } on Exception catch (e, s) {
        handleException("Error while fetching cust $e", e, s);
        customerList = [];
      }
    return customerList;
    }

  Future<Customer> getCustomerWithId(int id) async {
    late Customer customer;
    LogFile().logEntry("In Customer Provider GetCustomer with Id $id Start");

    try {
      final List<Map<String, Object?>> queryResult = await LocalDBRepo().db.query('CUSTOMER',where: "id = ?", whereArgs: [id]);
      customer = queryResult.map((e) => Customer.fromMap(e)).toList()[0];
      LogFile().logEntry("Getting Customer with id $id");
    } on Exception catch (e, s) {
      handleException("Error while fetching customer $e", e, s);
    }
    return customer;
  }

  Future<int> saveCustomer(Customer customer) async {
    return customer.id == 0? _createCustomer(customer) : _updateCustomer(customer);
  }

  Future<int> _createCustomer(Customer customer) async {
    int id = 0;
    try {
      LogFile().logEntry("Creating New Customer in Customer Provider");
      id = await LocalDBRepo().db.insert(
          'CUSTOMER',
          customer.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace
      );
      LogFile().logEntry("Inserted new customer with id $id and name ${customer.company_name}");
      await cacheCustomer();
      notifyListeners();

    } on Exception catch (e, s) {
      handleException("Error while creating customer $e", e, s);
    }
    return id;
  }

  void handleException(String message, Exception exception, StackTrace st) {
    LogFile().logEntry("Error $message $exception $st");
  }

  void reset() {
    // customer = null;
  }

  Future<void> deleteCustomer(int id) async {
    LogFile().logEntry("Deleting  Customer with id $id in Customer Provider");
    try {
      await LocalDBRepo().db.delete(
        'CUSTOMER',
        where: "id = ?",
        whereArgs: [id],
      );
      await cacheCustomer();
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while deleting customer $e", e, s);
    }
  }

    Future<int> _updateCustomer(Customer customer) async {
      LogFile().logEntry("Updating Customer with id ${customer.id} in Customer Provider");
      try {
        await LocalDBRepo().db.update(
          'CUSTOMER',
          customer.toMap(),
          where: "id = ?",
          whereArgs: [customer.id],
        );
        await cacheCustomer();
        notifyListeners();
      } on Exception catch (e,s) {
        handleException("Error while updating customer $e", e, s);
      }
    return -1;
  }



}


