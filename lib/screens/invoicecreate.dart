import 'package:erpapp/kwidgets/KDateTextForm.dart';
import 'package:erpapp/kwidgets/kchallanbutton.dart';
import 'package:erpapp/kwidgets/ktextfield.dart';
import 'package:erpapp/model/challan.dart';
import 'package:erpapp/model/customer.dart';
import 'package:erpapp/model/invoice.dart';
import 'package:erpapp/model/product.dart';
import 'package:erpapp/providers/challan_provider.dart';
import 'package:erpapp/providers/customer_provider.dart';
import 'package:erpapp/providers/product_provider.dart';
import 'package:erpapp/widgets/alertdialognav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../kwidgets/kvariables.dart';
import '../kwidgets/kdropdown.dart';
import '../kwidgets/ktablecellheader.dart';
import 'challancreate.dart';

class InvoiceCreate extends StatefulWidget {
  Invoice? invoice;
  InvoiceCreate({
    Key? key,
    this.invoice,
  }) : super(key: key);

  @override
  State<InvoiceCreate> createState() => _InvoiceCreateState();
}

class _InvoiceCreateState extends State<InvoiceCreate> {
  late double containerWidth;
  late final invoiceNumberController;
  final _formKey = GlobalKey<FormState>();

  List<Customer> _customerList = [];
  List<Challan> _challanList = [];
  List<Product> _productList = [];

  String _companyName = "";
  DateTime _fromDate = DateFormat("yyyy-MM-dd").parse("2000-01-01");
  DateTime _toDate = DateTime.now();

  String dropdownValue = "-----";
  final currencyFormat = NumberFormat("#,##0.00", "en_US");
  double challanAmount = 0;
  bool isChecked = false;

  final double subtotal = 0;
  final double total = 0;
  final double challantotal = 0;

  @override
  void initState() {
    _getAllLists();
    invoiceNumberController =
        TextEditingController(text: widget.invoice!.invoiceNo);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    containerWidth =
        (MediaQuery.of(context).size.width - KVariables.sidebarWidth);

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color.fromRGBO(242, 243, 247, 1),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.zero,
                    bottomRight: Radius.zero),
              ),
              width: containerWidth,
              child: AlertDialogNav(),
            ),
            Container(
              width: containerWidth * 0.95,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.invoice!.id != 0
                            ? "Edit Invoice"
                            : "New Invoice",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const SizedBox(width: 50,),
                      KDropdown(
                        dropDownList: _customerList
                            .map((item) => item.company_name.toString())
                            .toList(),
                        label: "Customer Name",
                        width: 300,
                        onChangeDropDown: _onCompanyChange,
                      ),
                      Column(
                        children: [
                          KTextField(
                            label: "Invoice #",
                            controller: invoiceNumberController,
                            width: 200,
                          ),
                          KTextField(
                            label: "Invoice Date",
                            controller: invoiceNumberController,
                            width: 200,
                          )
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      KTextField(
                        label: "Billing Address",
                        controller: invoiceNumberController,
                        width: 310,
                        multiLine: 5,
                      ),
                      Column(
                        children: [
                          KTextField(
                            label: "GST #",
                            controller: invoiceNumberController,
                            width: 200,
                          ),
                          KTextField(
                            label: "Due Date",
                            controller: invoiceNumberController,
                            width: 200,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    // color: Colors.green,
                    padding: EdgeInsets.only(right: 10),
                    width: containerWidth * 0.95,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          // color: Colors.cyan,
                          width: containerWidth * 0.95 / 2.2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              KDateTextForm(
                                label: "From:",
                                selectedDate: fromDateSelected,
                              ),
                              SizedBox(
                                width: 50,
                              ),
                              KDateTextForm(
                                label: "To:",
                                selectedDate: toDateSelected,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: containerWidth * 0.95 / 2.2,
                          // color: Colors.red,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                "Amount",
                                style: TextStyle(fontSize: 11),
                              ),
                              Text(
                                "\u{20B9}${currencyFormat.format(challanAmount)}",
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Challan",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      KTableCellHeader(
                        header: "Select",
                        context: context,
                        cellWidth: containerWidth * .05,
                      ),
                      KTableCellHeader(
                        header: "#",
                        context: context,
                        cellWidth: containerWidth * .03,
                      ),
                      KTableCellHeader(
                        header: "Challan #",
                        context: context,
                        cellWidth: containerWidth * 0.08,
                      ),
                      KTableCellHeader(
                        header: "Challan Date",
                        context: context,
                        cellWidth: containerWidth * 0.08,
                      ),
                      // KTableCellHeader(header: "Customer Name", context: context, cellWidth: containerWidth * 0.14,),
                      KTableCellHeader(
                        header: "Product Name",
                        context: context,
                        cellWidth: containerWidth * 0.14,
                      ),
                      KTableCellHeader(
                        header: "Price Per Unit",
                        context: context,
                        cellWidth: containerWidth * 0.1,
                      ),
                      KTableCellHeader(
                        header: "Unit",
                        context: context,
                        cellWidth: containerWidth * 0.08,
                      ),
                      KTableCellHeader(
                        header: "Quantity",
                        context: context,
                        cellWidth: containerWidth * 0.06,
                      ),
                      KTableCellHeader(
                        header: "Amount",
                        context: context,
                        cellWidth: containerWidth * .1,
                      ),
                      KTableCellHeader(
                        header: "Tax",
                        context: context,
                        cellWidth: containerWidth * 0.07,
                      ),
                      KTableCellHeader(
                        header: "",
                        context: context,
                        cellWidth: containerWidth * .05,
                        isLastPos: true,
                      ),
                    ],
                  ),
                  _getChallanList(_companyName),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: containerWidth * 0.95,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  KChallanButton(
                                    label: "Add lines",
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  KChallanButton(
                                    label: "Clear all lines",
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  KChallanButton(
                                    label: "Add subtotal",
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              // KTextField(label: "Message displayed on estimate", width: 200, multiLine: 4, ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: const [
                                Text(
                                  "Subtotal",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Total",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Challan Total",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  subtotal.toString(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  total.toString(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  challantotal.toString(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _getAllLists() async {
    _customerList = await Provider.of<CustomerProvider>(context, listen: false)
        .getCustomerList();
    _challanList = await Provider.of<ChallanProvider>(context, listen: false)
        .getChallanList();
    _productList = await Provider.of<ProductProvider>(context, listen: false)
        .getProductList();
    setState(() {});
  }

  void _onCompanyChange(String companyName) {
    setState(() {
      this._companyName = companyName;
      print("Company NMae on CHange: $_companyName");
    });
  }

  Widget editAction(int id) {
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
              return ChallanCreate(
                challan: challan,
              );
            } else
              return Container();
          }
        },
      );
    });
  }

  void deleteAction(int id) {
    Provider.of<ChallanProvider>(context, listen: false).deleteChallan(id);
  }

  void fromDateSelected(DateTime _pickedDate) {
    setState(() {
      _fromDate = _pickedDate;
    });
    print("From Date: $_fromDate");
  }

  void toDateSelected(DateTime _pickedDate) {
    setState(() {
      _toDate = _pickedDate;
    });
    print("To Date: $_toDate");
  }

  Widget _getChallanList(String _companyName) {
    List<Challan> challanList;

    print("Date From in _getChallanList: $_fromDate");
    print("Date To in _getChallanList: $_toDate");

    return _companyName == ""
        ? Text("Company Name is Blank")
        : Consumer<ChallanProvider>(builder: (ctx, provider, child) {
            return FutureBuilder(
              future: provider.getChallanListByParameters(
                customerName: _companyName,
                active: 1,
                invoiceNo: "Not Assigned",
                fromDate: _fromDate,
                toDate: _toDate,
              ),
              builder: (context, AsyncSnapshot<List<Challan>> snapshot) {
                print("Inside fetchGST Function");
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                            "An error occured in _getChallanList.\n$snapshot"));
                    // return noData(context);
                  } else if (snapshot.hasData) {
                    challanList = snapshot.data!;
                    challanList.forEach((row) => print(row.customerName));
                    return _gSTList(challanList, _companyName, context);
                    // return _displayChallans(challanList, context);
                    // return Container();
                  } else
                    return Container();
                }
              },
            );
          });
  }

  Widget _gSTList(
      List<Challan> _challanList, String CompanyName, BuildContext context) {
    List<String> _gstList = [];
    return Consumer<ChallanProvider>(builder: (ctx, provider, child) {
      return FutureBuilder(
        future: provider.getChallanListwithGSTbyCompanyName(CompanyName),
        builder: (context, AsyncSnapshot<List<String>> snapshot) {
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
              _gstList = snapshot.data!;
              // _gstList.forEach((row) => print(row));
              return _displayChallans(_challanList, _gstList, context);
            } else
              return Container();
          }
        },
      );
    });
  }

  Widget _displayChallans(
      List<Challan> _challanList, List<String> _gstList, BuildContext context) {
    return Container(
      width: containerWidth,
      height: 100,
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (var i = 0; i < _challanList.length; i++)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    // key: _challanList[i].id.toString(),
                    value: isChecked,
                    onChanged: (bool? value) => checkboxChanged(value!, _challanList[i].id),
                  ),
                  KTableCellHeader(
                    header: (i + 1).toString(),
                    context: context,
                    cellWidth: containerWidth * .03,
                  ),
                  KTableCellHeader(
                    header: _challanList[i].challanNo,
                    context: context,
                    cellWidth: containerWidth * 0.08,
                  ),
                  KTableCellHeader(
                    header: DateFormat("d-M-y")
                        .format(_challanList[i].challanDate!),
                    context: context,
                    cellWidth: containerWidth * 0.08,
                  ),
                  // KTableCellHeader(header: challanList[i].customerName, context: context, cellWidth: containerWidth * 0.14,),
                  KTableCellHeader(
                    header: _challanList[i].productName,
                    context: context,
                    cellWidth: containerWidth * 0.14,
                  ),
                  KTableCellHeader(
                    header: _challanList[i].pricePerUnit.toString(),
                    context: context,
                    cellWidth: containerWidth * 0.1,
                  ),
                  KTableCellHeader(
                    header: _challanList[i].productUnit,
                    context: context,
                    cellWidth: containerWidth * 0.08,
                  ),
                  KTableCellHeader(
                    header: _challanList[i].quantity.toString(),
                    context: context,
                    cellWidth: containerWidth * 0.06,
                  ),
                  KTableCellHeader(
                    header: _challanList[i].totalAmount.toString(),
                    context: context,
                    cellWidth: containerWidth * .1,
                  ),
                  KTableCellHeader(
                    header: _gstList[i],
                    context: context,
                    cellWidth: containerWidth * 0.07,
                  ),
                  KTableCellHeader(
                    header: "",
                    context: context,
                    cellWidth: containerWidth * .05,
                    id: _challanList[i].id,
                    deleteAction: deleteAction,
                    editAction: editAction,
                    isLastPos: true,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void checkboxChanged(bool _isChecked, int _id) {
    setState(() {
      isChecked = _isChecked; 
      print("Checkbox Status: $_isChecked");
    });
  }
}
