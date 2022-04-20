import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../kwidgets/kcreatebutton.dart';
import '../kwidgets/ktablecellheader.dart';
import '../model/invoice.dart';
import '../providers/invoice_provider.dart';
import '../screens/invoicecreate.dart';


class InvoiceView extends StatefulWidget {
  final double width;
  const InvoiceView({Key? key, this.width = 150}) : super(key: key);

  @override
  State<InvoiceView> createState() => _InvoiceViewState();
}

class _InvoiceViewState extends State<InvoiceView> {
  late List<Invoice> invoiceList;
  late double containerWidth;

  @override
  void initState() {
    containerWidth = widget.width * 0.95;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Consumer<InvoiceProvider>(builder: (ctx, provider, child) {
      return FutureBuilder(
        future: provider.getInvoiceList(),
        builder: (context, AsyncSnapshot<List<Invoice>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasError) {
              return Center(child: Text("An error occured.\n$snapshot"));
              // return noData(context);
            } else if (snapshot.hasData) {
              invoiceList = snapshot.data!;

              if(invoiceList.isEmpty){
                return _noData(context);
              }
              else {
                return _displayInvoice(context);
              }

            } else
              return _noData(context);
          }
        },
      );
    });
  }



  Widget _noData(BuildContext context){
    return Column(
      children: [
        KCreateButton(callFunction: invoiceCreate,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Invoice",
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
              "Invoice does Not Exist",
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

  Widget _displayInvoice(BuildContext context){
    return Column(
      children: [
        KCreateButton(callFunction: invoiceCreate,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Invoice",
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
            KTableCellHeader(header: "Invoice #", context: context, cellWidth: containerWidth * 0.08,),
            KTableCellHeader(header: "Invoice Date", context: context, cellWidth: containerWidth * 0.08,),
            KTableCellHeader(header: "Customer Name", context: context, cellWidth: containerWidth * 0.14,),
            KTableCellHeader(header: "Customer Address", context: context, cellWidth: containerWidth * 0.14,),
            KTableCellHeader(header: "Invoice Amount", context: context, cellWidth: containerWidth * 0.1,),
            KTableCellHeader(header: "Invoice Tax", context: context, cellWidth: containerWidth * 0.08,),
            KTableCellHeader(header: "Invoice Total", context: context, cellWidth: containerWidth * 0.08,),
            KTableCellHeader(header: "Generate PDF", context: context, cellWidth: containerWidth * .1,),
            KTableCellHeader(header: "", context: context, cellWidth: containerWidth *.05, isLastPos: true,),
          ],
        ),
        for(var i = 0; i < invoiceList.length; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              KTableCellHeader(header: invoiceList[i].id.toString(), context: context, cellWidth: containerWidth *.03,),
              KTableCellHeader(header: invoiceList[i].invoiceNo, context: context, cellWidth: containerWidth * 0.08,),
              KTableCellHeader(header: DateFormat("d-M-y").format(invoiceList[i].invoiceDate!), context: context, cellWidth: containerWidth * 0.08,),
              KTableCellHeader(header: invoiceList[i].customerName, context: context, cellWidth: containerWidth * 0.14,),
              KTableCellHeader(header: invoiceList[i].customerAddress, context: context, cellWidth: containerWidth * 0.14,),
              KTableCellHeader(header: invoiceList[i].invoiceAmount.toString(), context: context, cellWidth: containerWidth * 0.1,),
              KTableCellHeader(header: invoiceList[i].invoiceTax.toString(), context: context, cellWidth: containerWidth * 0.08,),
              KTableCellHeader(header: invoiceList[i].invoiceTotal.toString(), context: context, cellWidth: containerWidth * 0.08,),
              KTableCellHeader(header: invoiceList[i].pdfFileLocation.toString(), context: context, cellWidth: containerWidth * .1,),
              KTableCellHeader(header: "",
                isInvoice: true,
                context: context,
                cellWidth: containerWidth *.05,
                id: invoiceList[i].id,
                deleteAction: deleteAction,
                editAction: editAction,
                isLastPos: true,),
            ],
          ),
      ],
    );
  }

  invoiceCreate(BuildContext context){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){

          return InvoiceCreate(invoice: Invoice(),);
          // return TestList();
        }
    );
  }

  void deleteAction(int id){
    Provider.of<InvoiceProvider>(context, listen: false).deleteInvoice(id);
  }

  Widget editAction(int id){
    Invoice invoice = Invoice();
    return Consumer<InvoiceProvider>(builder: (ctx, provider, child) {
      return FutureBuilder(
        future: provider.getInvoiceById(id),
        builder: (context, AsyncSnapshot<Invoice> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasError) {
              return Center(child: Text("An error occured.\n$snapshot"));
              // return noData(context);
            } else if (snapshot.hasData) {
              invoice = snapshot.data!;
              return InvoiceCreate(invoice: invoice,);
            } else
              return Container();
          }
        },
      );
    });
  }
}
