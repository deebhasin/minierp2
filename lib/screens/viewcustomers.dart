import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../kwidgets/kcreatebutton.dart';
import '../kwidgets/ktablecellheader.dart';
import '../widgets/createcustomer.dart';
import '../domain/customer.dart';
import '../providers/customer_provider.dart';


class ViewCustomers extends StatefulWidget {
  final double width;
  late double containerWidth;

  ViewCustomers({Key? key,
    required this.width}) : super(key: key){
    containerWidth = width * 0.95;
  }

  @override
  State<ViewCustomers> createState() => _ViewCustomersState();
}

class _ViewCustomersState extends State<ViewCustomers> {
  late List<Customer> customer;

  void createCustomer(BuildContext context){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return CreateCustomer(Customer(company_name: ""));
        }
    );
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
              customer = snapshot.data!;
              // customer.forEach((row) => print(row));
              // return displayCustomer(context);
              return _displayCustomer(context);
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
              for(var i=0; i< customer.length; i++)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    KTableCellHeader(header: customer[i].id.toString(),
                      context: context,
                      cellWidth: widget.containerWidth * .03,),
                    KTableCellHeader(header: customer[i].company_name,
                      context: context,
                      cellWidth: widget.containerWidth * 0.18,),
                    KTableCellHeader(header: customer[i].contact_person,
                      context: context,
                      cellWidth: widget.containerWidth * 0.14,),
                    KTableCellHeader(header: customer[i].contact_phone,
                      context: context,
                      cellWidth: widget.containerWidth * 0.1,),
                    KTableCellHeader(header: customer[i].address,
                      context: context,
                      cellWidth: widget.containerWidth * 0.14,),
                    // KTableCellHeader(header: "Pin", context: context, cellWidth: containerWidth * 0.05,),
                    KTableCellHeader(header: customer[i].pin.toString(),
                      context: context,
                      cellWidth: widget.containerWidth * .1,),
                    KTableCellHeader(header: customer[i].state,
                      context: context,
                      cellWidth: widget.containerWidth * 0.1,),
                    // KTableCellHeader(header: "State Code", context: context, cellWidth: containerWidth * 0.05,),
                    KTableCellHeader(header: customer[i].gst,
                      context: context,
                      cellWidth: widget.containerWidth * 0.1,),
                    KTableCellHeader(header: customer[i].creditPeriod.toString(),
                      context: context,
                      cellWidth: widget.containerWidth * .08,),
                    KTableCellHeader(header: "",
                      context: context,
                      cellWidth: widget.containerWidth * .07,
                      isLastPos: true,
                      id: customer[i].id,
                    ),
                //   ],
                // ),
            ],
          ),
        ],
      );
    }
}
