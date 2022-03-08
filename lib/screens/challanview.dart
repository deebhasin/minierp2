import 'package:erpapp/model/challan.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'challancreate.dart';
import '../kwidgets/kcreatebutton.dart';
import '../kwidgets/ktablecellheader.dart';
import '../providers/challan_provider.dart';


class ViewChallan extends StatefulWidget {
  final double width;
  ViewChallan({Key? key,
    this.width = 50
  }) : super(key: key);

  @override
  State<ViewChallan> createState() => _ViewChallanState();
}

class _ViewChallanState extends State<ViewChallan> {
  late List<Challan> challanList;
  late double containerWidth;

  @override
  void initState() {
    containerWidth = widget.width * 0.95;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ChallanProvider challanProvider = ChallanProvider();
    // challanProvider.challanTest(challanProvider);
    return Consumer<ChallanProvider>(builder: (ctx, provider, child) {
      return FutureBuilder(
        future: provider.getChallanList(),
        builder: (context, AsyncSnapshot<List<Challan>> snapshot) {
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
              challanList = snapshot.data!;

              if(challanList.isEmpty){
                return _noData(context);
              }
              else {
                return _displayChallan(context);
              }

            } else
              return _noData(context);
          }
        },
      );
    });
  }

  Widget _noData(context) {
    return Column(
      children: [
        KCreateButton(callFunction: challanCreate,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Challan",
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
              "Challan does Not Exist",
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

Widget _displayChallan(BuildContext context){
    return Column(
      children: [
        KCreateButton(callFunction: challanCreate,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Challan",
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
            KTableCellHeader(header: "Challan #", context: context, cellWidth: containerWidth * 0.08,),
            KTableCellHeader(header: "Challan Date", context: context, cellWidth: containerWidth * 0.08,),
            KTableCellHeader(header: "Customer Name", context: context, cellWidth: containerWidth * 0.14,),
            KTableCellHeader(header: "Product Name", context: context, cellWidth: containerWidth * 0.14,),
            KTableCellHeader(header: "Price Per Unit", context: context, cellWidth: containerWidth * 0.1,),
            KTableCellHeader(header: "Unit", context: context, cellWidth: containerWidth * 0.08,),
            KTableCellHeader(header: "Quantity", context: context, cellWidth: containerWidth * 0.06,),
            KTableCellHeader(header: "Amount", context: context, cellWidth: containerWidth * .1,),
            KTableCellHeader(header: "Invoice #", context: context, cellWidth: containerWidth * 0.07,),
            KTableCellHeader(header: "", context: context, cellWidth: containerWidth *.05, isLastPos: true,),
          ],
        ),
        for(var i = 0; i < challanList.length; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              KTableCellHeader(header: challanList[i].id.toString(), context: context, cellWidth: containerWidth *.03,),
              KTableCellHeader(header: challanList[i].challanNo, context: context, cellWidth: containerWidth * 0.08,),
              KTableCellHeader(header: DateFormat("d-M-y").format(challanList[i].challanDate!), context: context, cellWidth: containerWidth * 0.08,),
              KTableCellHeader(header: challanList[i].customerName, context: context, cellWidth: containerWidth * 0.14,),
              KTableCellHeader(header: challanList[i].productName, context: context, cellWidth: containerWidth * 0.14,),
              KTableCellHeader(header: challanList[i].pricePerUnit.toString(), context: context, cellWidth: containerWidth * 0.1,),
              KTableCellHeader(header: challanList[i].productUnit, context: context, cellWidth: containerWidth * 0.08,),
              KTableCellHeader(header: challanList[i].quantity.toString(), context: context, cellWidth: containerWidth * 0.06,),
              KTableCellHeader(header: challanList[i].totalAmount.toString(), context: context, cellWidth: containerWidth * .1,),
              KTableCellHeader(header: challanList[i].invoiceNo, context: context, cellWidth: containerWidth * 0.07,),
              KTableCellHeader(header: "",
                context: context,
                cellWidth: containerWidth *.05,
                id: challanList[i].id,
                deleteAction: deleteAction,
                editAction: editAction,
                isLastPos: true,),
            ],
          ),
      ],
    );
  }

  challanCreate(BuildContext context){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){

          return ChallanCreate(challan: Challan(),);
        }
    );
  }

  void deleteAction(int id){
    Provider.of<ChallanProvider>(context, listen: false).deleteChallan(id);
  }

  Widget editAction(int id){
    Challan challan;
    return Consumer<ChallanProvider>(builder: (ctx, provider, child) {
      return FutureBuilder(
        future: provider.getChallanById(id),
        builder: (context, AsyncSnapshot<Challan> snapshot) {
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
              challan = snapshot.data!;
              // customer.forEach((row) => print(row));
              // return displayCustomer(context);
              return ChallanCreate(challan: challan,);
            } else
              return Container();
          }
        },
      );
    });
  }
}
