import 'package:erpapp/domain/customer.dart';
import 'package:erpapp/widgets/createcustomer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'kvariables.dart';
import '../providers/customer_provider.dart';

class KTableCellHeader extends StatelessWidget {
  String header = "";
  final BuildContext context;
  final CrossAxisAlignment crossAxisAlignment;
  final double cellWidth;
  final bool isLastPos;
  double width = 100;
  double height;
  final int? id;

  KTableCellHeader({Key? key,
    required this.header,
    required this.context,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.cellWidth = 100,
    this.isLastPos = false,
    this.height = 25,
    this.id = 0
  }) : super(key: key) {
    width = (MediaQuery.of(context).size.width - KVariables.sidebarWidth) * 0.95;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cellWidth * 0.95,
      // height: height,
      decoration: BoxDecoration(
        border: Border(
          left: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
          right: BorderSide(color: isLastPos? Colors.transparent : Colors.grey),
          bottom: const BorderSide(color: Colors.grey),
        ),
      ),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: (isLastPos && id !=0)? showIcons(id!, context) : showText(header),
            ),
        ],
      ),
    );
  }
}


Widget showText(String header){
  return Text(
    header,
    style: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget showIcons(int id, BuildContext context){


  return Row(
    children: [
      InkWell(
        onTap: (){
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context){
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
                          return CreateCustomer(customer);
                        } else
                          return Container();
                      }
                    },
                  );
                });
              }
          );
        },
        child: Icon(
          Icons.edit,
          size: 16,
          color: Colors.grey,
        ),
      ),
      const SizedBox(width: 8,),
      InkWell(
        onTap: (){Provider.of<CustomerProvider>(context, listen: false).deleteCustomer(id);},
        child: Icon(
          Icons.delete,
          size: 16,
          color: Colors.red,
        ),
      ),
    ],
  );

  _getCustomer() {

  }


}