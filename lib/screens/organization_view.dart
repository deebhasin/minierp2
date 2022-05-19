import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../kwidgets/kcreatebutton.dart';
import '../model/organization.dart';
import '../providers/org_provider.dart';
import '../widgets/alertdialognav.dart';
import 'customercreate.dart';
import '../model/customer.dart';
import '../providers/customer_provider.dart';
import 'organization_create.dart';

class OrganizationView extends StatefulWidget {
  final double width;
  late double containerWidth;
  late Function reFresh;

  OrganizationView({
    Key? key,
    required this.width,
    required this.reFresh,
  }) : super(key: key) {
    containerWidth = width * 0.95;
  }

  @override
  State<OrganizationView> createState() => _OrganizationViewState();
}

class _OrganizationViewState extends State<OrganizationView> {
  late Organization _org;

  void createOrganization(BuildContext context) {
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
    return Consumer<OrgProvider>(builder: (ctx, provider, child) {
      return FutureBuilder(
        future: provider.getOrganization(),
        builder: (context, AsyncSnapshot<Organization> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasError) {
              return Center(child: Text("An error occured.\n$snapshot"));
              // return noData(context);
            } else if (snapshot.hasData) {
              _org = snapshot.data!;
              return _createOrg();
            } else
              return noData(context, "An Error has Occured");
          }
        },
      );
    });
  }

  Widget noData(BuildContext context, String snapshotError) {
    return Column(
      children: [
        KCreateButton(
          callFunction: createOrganization,
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
              "some Erro has Occured",
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

  Widget _createOrg() {
    return Column(
      children: [
        KCreateButton(
          callFunction: _createOrgPopup,
          label: "Edit",
        ),
        OrganizationCreate(
          org: _org,
          reFresh: widget.reFresh,
          isDisabled: true,
        ),
      ],
    );
  }

  void _createOrgPopup(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            // backgroundColor: Color.fromRGBO(242,243,247,1),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(242, 243, 247, 1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.zero,
                        bottomRight: Radius.zero),
                  ),
                  // width: ,
                  // height: containerHeight,
                  child: AlertDialogNav(),
                ),
                OrganizationCreate(
                  org: _org,
                  reFresh: widget.reFresh,
                ),
              ],
            ),
          );
        });
  }
}
