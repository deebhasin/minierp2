import 'package:erpapp/kwidgets/kdropdown.dart';
import 'package:erpapp/kwidgets/ktablecellheader.dart';
import 'package:erpapp/model/challan.dart';
import 'package:erpapp/model/customer.dart';
import 'package:erpapp/providers/challan_provider.dart';
import 'package:erpapp/providers/customer_provider.dart';
import 'package:erpapp/widgets/alertdialognav.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TestList extends StatefulWidget {

  TestList({Key? key}) : super(key: key);

  @override
  State<TestList> createState() => _TestListState();
}

class _TestListState extends State<TestList> {
  late double containerWidth;


  String companyName = "";
  List<Customer> _customerList = [];

  @override
  Widget build(BuildContext context) {
    containerWidth = MediaQuery.of(context).size.width;
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Container(
        child: Form(
          child: Column(
            children: [
              AlertDialogNav(),
              KDropdown(dropDownList: _customerList.map((item)  => item.company_name.toString()).toList(), label: "Customer Name", width: 300, onChangeDropDown: onCompanyChange,),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  KTableCellHeader(header: "#", context: context, cellWidth: containerWidth *.03,),
                  KTableCellHeader(header: "Challan #", context: context, cellWidth: containerWidth * 0.08,),
                  KTableCellHeader(header: "Challan Date", context: context, cellWidth: containerWidth * 0.08,),
                  // KTableCellHeader(header: "Customer Name", context: context, cellWidth: containerWidth * 0.14,),
                  KTableCellHeader(header: "Product Name", context: context, cellWidth: containerWidth * 0.14,),
                  KTableCellHeader(header: "Price Per Unit", context: context, cellWidth: containerWidth * 0.1,),
                  KTableCellHeader(header: "Unit", context: context, cellWidth: containerWidth * 0.08,),
                  KTableCellHeader(header: "Quantity", context: context, cellWidth: containerWidth * 0.06,),
                  KTableCellHeader(header: "Amount", context: context, cellWidth: containerWidth * .1,),
                  KTableCellHeader(header: "Tax", context: context, cellWidth: containerWidth * 0.07,),
                  KTableCellHeader(header: "", context: context, cellWidth: containerWidth *.05, isLastPos: true,),
                ],
              ),
              getChallanList(companyName),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getCustomerList();
  }

  void getCustomerList() async{
    _customerList = await Provider.of<CustomerProvider>(context, listen: false).getCustomerList();
  setState(() {

  });
  }

  void onCompanyChange(String companyName){
    setState(() {
     this.companyName = companyName;
    });
  }

  Widget getChallanList(String companyName){
    List<Challan> challanList;
    return companyName == ""? Text("Company Name is Blank") :
    Consumer<ChallanProvider>(builder: (ctx, provider, child) {
      return FutureBuilder(
        future: provider.getChallanByCompanyName(companyName),
        builder: (context, AsyncSnapshot<List<Challan>> snapshot) {
          print("Inside fetchGST Function");
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
              challanList.forEach((row) => print(row));
              return _displayChallans(challanList, context);
            } else
              return Container();
          }
        },
      );
    });
  }

  Widget _displayChallans(List<Challan> _challanList, BuildContext context){
    return Container(
      width: containerWidth,
      height: 100,
      child: SingleChildScrollView(
        child: Column(
          children: [
            for(var i = 0; i < _challanList.length; i++)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  KTableCellHeader(header: (i+1).toString(), context: context, cellWidth: containerWidth *.03,),
                  KTableCellHeader(header: _challanList[i].challanNo, context: context, cellWidth: containerWidth * 0.08,),
                  KTableCellHeader(header: DateFormat("d-M-y").format(_challanList[i].challanDate!), context: context, cellWidth: containerWidth * 0.08,),
                  // KTableCellHeader(header: challanList[i].customerName, context: context, cellWidth: containerWidth * 0.14,),
                  KTableCellHeader(header: _challanList[i].productName, context: context, cellWidth: containerWidth * 0.14,),
                  KTableCellHeader(header: _challanList[i].pricePerUnit.toString(), context: context, cellWidth: containerWidth * 0.1,),
                  KTableCellHeader(header: _challanList[i].productUnit, context: context, cellWidth: containerWidth * 0.08,),
                  KTableCellHeader(header: _challanList[i].quantity.toString(), context: context, cellWidth: containerWidth * 0.06,),
                  KTableCellHeader(header: _challanList[i].totalAmount.toString(), context: context, cellWidth: containerWidth * .1,),
                  // KTableCellHeader(header: testGST[i]["GST"], context: context, cellWidth: containerWidth * 0.07,),
                  KTableCellHeader(header: "",
                    context: context,
                    cellWidth: containerWidth *.05,
                    id: _challanList[i].id,
                    // deleteAction: deleteAction,
                    // editAction: editAction,
                    isLastPos: true,),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
