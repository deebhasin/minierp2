





import 'package:erpapp/domain/customer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';



class CustomerProvider with ChangeNotifier {

	Customer? customer;
	late List<Customer> customerList;



	Future<Customer?> getCustomer() async {
		if (customer != null ) {
			return customer;
		}

		try {
			// customer = await CustomerRepo().getProfile();


		} on Exception catch (e, s) {
			handleException("Error while fetching customer $e", e, s);

		}

		return customer;
	}


	Future<List<Customer>> getCustomerList() async {
		if (customerList != null ) {
			return customerList;
		}

		try {
			// customerList = await CustomerRepo().getProfile();


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
