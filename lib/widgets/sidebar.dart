import 'package:flutter/material.dart';

import '../kwidgets/ksidebar_row.dart';
import '../screens/challancreate.dart';


class Sidebar extends StatefulWidget {
  final int sidebarWidth;
  final Function setDisplayPage;
  const Sidebar({Key? key,
    this.sidebarWidth = 50,
    required this.setDisplayPage}) : super(key: key);

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  late bool dashboardSelected;
  late bool challanSelected;
  late bool invoiceSelected;
  late bool paymentsSelected;
  late bool customersSelected;
  late bool productsSelected;
  late bool organizationSelected;
  late bool reportsSelected;


  menuSelected(String selectionText){
    widget.setDisplayPage(selectionText);
    setState(() {
      switch(selectionText){
        case "Dashboard":
          {
            dashboardSelected = true;
            challanSelected = false;
            invoiceSelected = false;
            paymentsSelected = false;
            customersSelected = false;
            productsSelected = false;
            organizationSelected = false;
            reportsSelected = false;
          }
          break;
        case "Challan":
          {
            dashboardSelected = false;
            challanSelected = true;
            invoiceSelected = false;
            paymentsSelected = false;
            customersSelected = false;
            productsSelected = false;
            organizationSelected = false;
            reportsSelected = false;
          }
          break;
        case "Invoice":
          {
            dashboardSelected = false;
            challanSelected = false;
            invoiceSelected = true;
            paymentsSelected = false;
            customersSelected = false;
            productsSelected = false;
            organizationSelected = false;
            reportsSelected = false;
          }
          break;
        case "Payments":
          {
            dashboardSelected = false;
            challanSelected = false;
            invoiceSelected = false;
            paymentsSelected = true;
            customersSelected = false;
            productsSelected = false;
            organizationSelected = false;
            reportsSelected = false;
          }
          break;
        case "Customers":
          {
            dashboardSelected = false;
            challanSelected = false;
            invoiceSelected = false;
            paymentsSelected = false;
            customersSelected = true;
            productsSelected = false;
            organizationSelected = false;
            reportsSelected = false;
          }
          break;
        case "Products":
          {
            dashboardSelected = false;
            challanSelected = false;
            invoiceSelected = false;
            paymentsSelected = false;
            customersSelected = false;
            productsSelected = true;
            organizationSelected = false;
            reportsSelected = false;
          }
          break;
        case "Organization":
          {
            dashboardSelected = false;
            challanSelected = false;
            invoiceSelected = false;
            paymentsSelected = false;
            customersSelected = false;
            productsSelected = false;
            organizationSelected = true;
            reportsSelected = false;
          }
          break;
        case "Reports":
          {
            dashboardSelected = false;
            challanSelected = false;
            invoiceSelected = false;
            paymentsSelected = false;
            customersSelected = false;
            productsSelected = false;
            organizationSelected = false;
            reportsSelected = true;
          }
          break;
      // default: ;
      }
    });

    // print("Dashboard: $dashboardSelected");
    // print("Challan: $challanSelected");
    // print("Invoice: $invoiceSelected");
    // print("Payments: $paymentsSelected");
    // print("Customer: $customersSelected");
    // print("Products: $productsSelected");
    // print("Organization: $organizationSelected");
    // print("Reports: $reportsSelected");

  }

  void popup(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return const CreateChallan();
        }
    );
  }

  @override
  void initState() {
    dashboardSelected = true;
    challanSelected = false;
    invoiceSelected = false;
    paymentsSelected = false;
    customersSelected = false;
    productsSelected = false;
    organizationSelected = false;
    reportsSelected = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      width: widget.sidebarWidth.toDouble(),
      height: MediaQuery.of(context).size.height,
      color: const Color.fromRGBO(63, 64, 66, 1),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                  "asset/images/minierp_logo.png",
                fit: BoxFit.fill,
                // width: 100,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 150,
                height: 40,
                child: ElevatedButton(
                    onPressed: popup,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add),
                        Text(
                          "New",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    side: const BorderSide(
                      width: 2,
                        color: Colors.white,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () => menuSelected("Dashboard"),
                child: KSidebarRow(text: "Dashboard", isSelected: dashboardSelected,),
            ),
            InkWell(
              onTap: () => menuSelected("Challan"),
                child: KSidebarRow(text: "Challan", isSelected: challanSelected,),
            ),
            InkWell(
              onTap: () => menuSelected("Invoice"),
              child: KSidebarRow(text: "Invoice", isSelected: invoiceSelected,),
            ),
            InkWell(
              onTap: () => menuSelected("Payments"),
              child: KSidebarRow(text: "Payments", isSelected: paymentsSelected,),
            ),
            InkWell(
              onTap: () => menuSelected("Customers"),
              child: KSidebarRow(text: "Customers", isSelected: customersSelected,),
            ),
            InkWell(
              onTap: () => menuSelected("Products"),
              child: KSidebarRow(text: "Products", isSelected: productsSelected,),
            ),
            InkWell(
              onTap: () => menuSelected("Organization"),
              child: KSidebarRow(text: "Organization", isSelected: organizationSelected,),
            ),
            InkWell(
              onTap: () => menuSelected("Reports"),
              child: KSidebarRow(text: "Reports", isSelected: reportsSelected,),
            ),
          ],
          ),
      ),
    );
  }
}
