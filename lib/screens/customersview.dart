import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../kwidgets/kcreatebutton.dart';
import '../widgets/customer_horizontal_data_table.dart';
import 'customercreate.dart';
import '../model/customer.dart';
import '../providers/customer_provider.dart';

class CustomersView extends StatefulWidget {
  final double width;
  late double containerWidth;

  CustomersView({Key? key, required this.width}) : super(key: key) {
    containerWidth = width * 0.95;
  }

  @override
  State<CustomersView> createState() => _CustomersViewState();
}

class _CustomersViewState extends State<CustomersView> {
  late List<Customer> _customerList;

  void createCustomer(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomerCreate(customer: Customer(company_name: ""));
        });
  }

  void deleteAction(int id) {
    Provider.of<CustomerProvider>(context, listen: false).deleteCustomer(id);
  }

  Widget editAction(int id) {
    Customer customer;
    return Consumer<CustomerProvider>(builder: (ctx, provider, child) {
      return FutureBuilder(
        future: provider.getCustomerWithId(id),
        builder: (context, AsyncSnapshot<Customer> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasError) {
              //                  if (snapshot.error is ConnectivityError) {
              //                    return NoConnectionScreen();
              //                  }
              return Center(child: Text("An error occured.\n$snapshot"));
              // return noData(context);
            } else if (snapshot.hasData) {
              customer = snapshot.data!;
              return CustomerCreate(customer: customer);
            } else
              return Container();
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerProvider>(builder: (ctx, provider, child) {
      return FutureBuilder(
        future: provider.getCustomerList(),
        builder: (context, AsyncSnapshot<List<Customer>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasError) {
              return Center(child: Text("An error occured.\n$snapshot"));
              // return noData(context);
            } else if (snapshot.hasData) {
              _customerList = snapshot.data!;
              if (_customerList.isEmpty) {
                return noData(context);
              } else {
                return _displayCustomer(context);
              }
            } else
              return noData(context);
          }
        },
      );
    });
  }

  Widget noData(context) {
    return Column(
      children: [
        KCreateButton(
          callFunction: createCustomer,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Customer",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 2,
                textBaseline: TextBaseline.alphabetic,
              ),
            ),
          ],
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Customer does Not Exist",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _displayCustomer(BuildContext context) {
    return Column(
      children: [
        KCreateButton(
          callFunction: createCustomer,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Customer",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 2,
                textBaseline: TextBaseline.alphabetic,
              ),
            ),
          ],
        ),
        const Divider(),
        CustomerHorizontalDataTable(
          leftHandSideColumnWidth: 200,
          rightHandSideColumnWidth: 1200,
          customerList: _customerList,
        ),
      ],
    );
  }
}
