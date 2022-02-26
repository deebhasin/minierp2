import 'package:erpapp/domain/customer.dart';
import 'package:erpapp/utils/localDB_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class CustomerProvider with ChangeNotifier {
  Customer? customer;
  late List<Customer> customerList;

  Future<Customer?> getCustomer(int id) async {
    if (customer != null) {
      return customer;
    }

    try {
      // customer = fetch query here

    } on Exception catch (e, s) {
      handleException("Error while fetching customer $e", e, s);
    }

    return customer;
  }

  Future<int> createCustomer(Customer customer) async {
    int id = 0;
    try {
      id = await LocalDBRepo().db.insert('CUSTOMER',
          {'name': customer.name,
            "contact": customer.contact,
            'address': customer.address,
            'PIN': customer.pin,
            'city': customer.city,
            'state': customer.state,
            'state_cd': customer.stateCode,
            'GST': customer.gst,
            'credit_period': customer.creditPeriod,
            'active': customer.isActive,
          },
          conflictAlgorithm: ConflictAlgorithm.replace);

      print("Inserted new customer with id $id and name ${customer.name}");

    } on Exception catch (e, s) {
      handleException("Error while fetching customer $e", e, s);
    }

    return id;
  }

  Future<List<Customer>> getCustomerList() async {
    if (customerList != null) {
      return customerList;
    }

    try {
      // Query here

    } on Exception catch (e, s) {
      handleException("Error while fetching customer $e", e, s);
    }

    return customerList;
  }

  void handleException(String message, Exception exception, StackTrace st) {
    print("Error $message $exception $st");
  }

  void reset() {
    customer = null;
  }
}
