import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../kwidgets/kcreatebutton.dart';
import '../kwidgets/ktablecellheader.dart';
import '../widgets/createcustomer.dart';
import '../domain/customer.dart';
import '../providers/customer_provider.dart';


class ViewCustomers extends StatelessWidget {
  final double width;
  late double containerWidth;
  late Customer customer;
  ViewCustomers({Key? key,
    required this.width}) : super(key: key){
    containerWidth = width * 0.95;
  }

  void createCustomer(BuildContext context){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return const CreateCustomer();
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerProvider>(builder: (ctx, provider, child) {
      return FutureBuilder(
        future: provider.getCustomer(),
        builder: (context, AsyncSnapshot<Customer> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasError) {
//                  if (snapshot.error is ConnectivityError) {
//                    return NoConnectionScreen();
//                  }
              return Center(child: Text("An error occured. $snapshot"));
            } else if (snapshot.hasData) {
              customer = snapshot.data!;
              // customer.forEach((row) => print(row));
              // return displayCustomer(context);
              return displayCustomer(context);
            } else
              return Container();
          }
        },
      );
    });
  }
    Widget displayCustomer(BuildContext context) {
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
                cellWidth: containerWidth * .03,),
              KTableCellHeader(header: "Company Name",
                context: context,
                cellWidth: containerWidth * 0.18,),
              KTableCellHeader(header: "Contact Person",
                context: context,
                cellWidth: containerWidth * 0.14,),
              KTableCellHeader(header: "Mobile",
                context: context,
                cellWidth: containerWidth * 0.1,),
              KTableCellHeader(header: "Address",
                context: context,
                cellWidth: containerWidth * 0.14,),
              // KTableCellHeader(header: "Pin", context: context, cellWidth: containerWidth * 0.05,),
              KTableCellHeader(header: "City",
                context: context,
                cellWidth: containerWidth * .1,),
              KTableCellHeader(header: "State",
                context: context,
                cellWidth: containerWidth * 0.1,),
              // KTableCellHeader(header: "State Code", context: context, cellWidth: containerWidth * 0.05,),
              KTableCellHeader(header: "GST Number",
                context: context,
                cellWidth: containerWidth * 0.1,),
              KTableCellHeader(header: "Credit Period",
                context: context,
                cellWidth: containerWidth * .1,),
              KTableCellHeader(header: "Status",
                context: context,
                cellWidth: containerWidth * .05,
                isLastPos: true,),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              KTableCellHeader(header: customer.id.toString(),
                context: context,
                cellWidth: containerWidth * .03,),
              KTableCellHeader(header: customer.name,
                context: context,
                cellWidth: containerWidth * 0.18,),
              KTableCellHeader(header: customer.contact,
                context: context,
                cellWidth: containerWidth * 0.14,),
              KTableCellHeader(header: customer.address,
                context: context,
                cellWidth: containerWidth * 0.1,),
              KTableCellHeader(header: customer.pin.toString(),
                context: context,
                cellWidth: containerWidth * 0.14,),
              // KTableCellHeader(header: "Pin", context: context, cellWidth: containerWidth * 0.05,),
              KTableCellHeader(header: customer.city,
                context: context,
                cellWidth: containerWidth * .1,),
              KTableCellHeader(header: customer.state,
                context: context,
                cellWidth: containerWidth * 0.1,),
              // KTableCellHeader(header: "State Code", context: context, cellWidth: containerWidth * 0.05,),
              KTableCellHeader(header: customer.stateCode,
                context: context,
                cellWidth: containerWidth * 0.1,),
              KTableCellHeader(header: customer.gst,
                context: context,
                cellWidth: containerWidth * .1,),
              KTableCellHeader(header: customer.creditPeriod.toString(),
                context: context,
                cellWidth: containerWidth * .05,
                isLastPos: true,),
            ],
          ),
        ],
      );
    }
  }
