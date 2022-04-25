import 'package:erpapp/widgets/invoice_horizontal_data_table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../kwidgets/kcreatebutton.dart';
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

              if (invoiceList.isEmpty) {
                return _noData(context);
              } else {
                return _displayInvoice(context);
              }
            } else
              return _noData(context);
          }
        },
      );
    });
  }

  Widget _noData(BuildContext context) {
    return Column(
      children: [
        KCreateButton(
          callFunction: invoiceCreate,
        ),
        Text(
          "Invoice",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 2,
            textBaseline: TextBaseline.alphabetic,
          ),
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

  Widget _displayInvoice(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        KCreateButton(
          callFunction: invoiceCreate,
        ),
        Text(
          "Invoice",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 2,
            textBaseline: TextBaseline.alphabetic,
          ),
        ),
        const SizedBox(height: 10,),
        InvoiceHorizontalDataTable(
          leftHandSideColumnWidth: 0,
          rightHandSideColumnWidth: containerWidth * 1.01,
          invoiceList: invoiceList,
        ),
      ],
    );
  }

  invoiceCreate(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InvoiceCreate(
            invoice: Invoice(),
          );
        });
  }
}
