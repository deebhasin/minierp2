import 'package:flutter/material.dart';

import '../kwidgets/kcreatebutton.dart';
import '../kwidgets/ktablecellheader.dart';
import '../widgets/createcustomer.dart';


class ViewCustomers extends StatelessWidget {
  final double width;
  ViewCustomers({Key? key,
    required this.width}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    double containerWidth = width * 0.95;

    void createCustomer(){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context){
            return const CreateCustomer();
          }
      );
    }

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
              KTableCellHeader(header: "#", context: context, cellWidth: containerWidth *.03,),
              KTableCellHeader(header: "Company Name", context: context, cellWidth: containerWidth * 0.18,),
              KTableCellHeader(header: "Contact Person", context: context, cellWidth: containerWidth * 0.14,),
              KTableCellHeader(header: "Mobile", context: context, cellWidth: containerWidth * 0.1,),
              KTableCellHeader(header: "Address", context: context, cellWidth: containerWidth * 0.14,),
              // KTableCellHeader(header: "Pin", context: context, cellWidth: containerWidth * 0.05,),
              KTableCellHeader(header: "City", context: context, cellWidth: containerWidth * .1,),
              KTableCellHeader(header: "State", context: context, cellWidth: containerWidth * 0.1,),
              // KTableCellHeader(header: "State Code", context: context, cellWidth: containerWidth * 0.05,),
              KTableCellHeader(header: "GST Number", context: context, cellWidth: containerWidth * 0.1,),
              KTableCellHeader(header: "Credit Period", context: context, cellWidth: containerWidth *.1,),
              KTableCellHeader(header: "Status", context: context, cellWidth: containerWidth *.05, isLastPos: true,),
            ],
        ),
      ],
    );
  }
}
