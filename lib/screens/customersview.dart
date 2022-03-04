import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../kwidgets/kcreatebutton.dart';
import '../kwidgets/ktablecellheader.dart';
import 'customercreate.dart';
import '../domain/customer.dart';
import '../providers/customer_provider.dart';


class CustomersView extends StatefulWidget {
  final double width;
  late double containerWidth;

  CustomersView({Key? key,
    required this.width}) : super(key: key){
    containerWidth = width * 0.95;
  }

  @override
  State<CustomersView> createState() => _CustomersViewState();
}

class _CustomersViewState extends State<CustomersView> {
  late List<Customer> customerList;

  void createCustomer(BuildContext context){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return CustomerCreate(customer: Customer(company_name: ""));
        }
    );
  }
  void deleteAction(int id){
    Provider.of<CustomerProvider>(context, listen: false).deleteCustomer(id);
  }

  Widget editAction(int id){
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
              // customer.forEach((row) => print(row));
              // return displayCustomer(context);
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
//                  if (snapshot.error is ConnectivityError) {
//                    return NoConnectionScreen();
//                  }
              return Center(child: Text("An error occured.\n$snapshot"));
            // return noData(context);
            } else if (snapshot.hasData) {
              customerList = snapshot.data!;
              if(customerList.isEmpty){
                return noData(context);
              }
              else{
                return _displayCustomer(context);
              }

            } else
              return noData(context);
          }
        },
      );
    });
  }

  Widget noData(context){
    return Column(
      children: [
        KCreateButton(callFunction: createCustomer,),
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
          KCreateButton(callFunction: createCustomer,),
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
              KTableCellHeader(header: "#",
                context: context,
                cellWidth: widget.containerWidth * .03,),
              KTableCellHeader(header: "Company Name",
                context: context,
                cellWidth: widget.containerWidth * 0.18,),
              KTableCellHeader(header: "Contact Person",
                context: context,
                cellWidth: widget.containerWidth * 0.14,),
              KTableCellHeader(header: "Mobile",
                context: context,
                cellWidth: widget.containerWidth * 0.1,),
              KTableCellHeader(header: "Address",
                context: context,
                cellWidth: widget.containerWidth * 0.14,),
              // KTableCellHeader(header: "Pin", context: context, cellWidth: containerWidth * 0.05,),
              KTableCellHeader(header: "PIN",
                context: context,
                cellWidth: widget.containerWidth * .1,),
              KTableCellHeader(header: "State",
                context: context,
                cellWidth: widget.containerWidth * 0.1,),
              // KTableCellHeader(header: "State Code", context: context, cellWidth: containerWidth * 0.05,),
              KTableCellHeader(header: "GST Number",
                context: context,
                cellWidth: widget.containerWidth * 0.1,),
              KTableCellHeader(header: "Credit Period",
                context: context,
                cellWidth: widget.containerWidth * .08,),
              KTableCellHeader(header: "",
                context: context,
                cellWidth: widget.containerWidth * .07,
                isLastPos: true,),
            ],
          ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children:[
              for(var i=0; i< customerList.length; i++)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    KTableCellHeader(header: customerList[i].id.toString(),
                      context: context,
                      cellWidth: widget.containerWidth * .03,),
                    KTableCellHeader(header: customerList[i].company_name,
                      context: context,
                      cellWidth: widget.containerWidth * 0.18,),
                    KTableCellHeader(header: customerList[i].contact_person,
                      context: context,
                      cellWidth: widget.containerWidth * 0.14,),
                    KTableCellHeader(header: customerList[i].contact_phone,
                      context: context,
                      cellWidth: widget.containerWidth * 0.1,),
                    KTableCellHeader(header: customerList[i].address,
                      context: context,
                      cellWidth: widget.containerWidth * 0.14,),
                    // KTableCellHeader(header: "Pin", context: context, cellWidth: containerWidth * 0.05,),
                    KTableCellHeader(header: customerList[i].pin.toString(),
                      context: context,
                      cellWidth: widget.containerWidth * .1,),
                    KTableCellHeader(header: customerList[i].state,
                      context: context,
                      cellWidth: widget.containerWidth * 0.1,),
                    // KTableCellHeader(header: "State Code", context: context, cellWidth: containerWidth * 0.05,),
                    KTableCellHeader(header: customerList[i].gst,
                      context: context,
                      cellWidth: widget.containerWidth * 0.1,),
                    KTableCellHeader(header: customerList[i].creditPeriod.toString(),
                      context: context,
                      cellWidth: widget.containerWidth * .08,),
                    KTableCellHeader(header: "",
                      context: context,
                      cellWidth: widget.containerWidth * .07,
                      isLastPos: true,
                      id: customerList[i].id,
                      deleteAction: deleteAction,
                      editAction: editAction,
                    ),
                //   ],
                // ),
            ],
          ),
        ],
      );
    }
}
