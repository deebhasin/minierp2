import 'package:erpapp/providers/invoice_provider.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../kwidgets/kvariables.dart';
import '../kwidgets/kdropdown.dart';
import '../kwidgets/ktablecellheader.dart';
import '../kwidgets/KDateTextForm.dart';
import '../kwidgets/ktextfield.dart';
import '../model/challan.dart';
import '../model/customer.dart';
import '../model/invoice.dart';
import '../model/product.dart';
import '../providers/challan_provider.dart';
import '../providers/customer_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/alertdialognav.dart';
import 'challancreate.dart';

class InvoiceCreate extends StatefulWidget {
  Invoice invoice;
  InvoiceCreate({
    Key? key,
    required this.invoice,
  }) : super(key: key);

  @override
  State<InvoiceCreate> createState() => _InvoiceCreateState();
}

class _InvoiceCreateState extends State<InvoiceCreate> {
  late double containerWidth;
  final _formKey = GlobalKey<FormState>();
  late final invoiceNumberController;
  late final invoiceDateController;
  late final gstNumberController;
  late final dueDateController;
  late final billingAddressController;

  late final RequiredValidator invoiceNumberValidator;
  late final RequiredValidator invoiceDateValidator;
  late final RequiredValidator gstValidator;
  late final RequiredValidator billingAddressValidator;


  String _gstNumber = "";
  String _billingAddress = "";
  DateTime? _dueDate;

  List<Customer> _customerList = [];
  List<Challan> _challanList = [];
  List<Product> _productList = [];
  List<bool> checkboxList = [];
  List<int> challanSelected = [];

  String _companyName = "";
  DateTime _fromDate = DateFormat("yyyy-MM-dd").parse("2000-01-01");
  DateTime _toDate = DateTime.now();

  String dropdownValue = "-----";
  final currencyFormat = NumberFormat("#,##0.00", "en_US");
  double challanAmount = 0;
  bool isChecked = false;

  double subtotal = 0;
  double taxTotal = 0;
  double invoiceTotal = 0;

  @override
  void initState() {
    _getAllLists();
    invoiceNumberController =
        TextEditingController(text: widget.invoice.invoiceNo);
    invoiceDateController =
        TextEditingController(text:DateFormat("d-M-y").format(widget.invoice.invoiceDate!));
    gstNumberController =
        TextEditingController(text: _gstNumber);
    dueDateController =
        TextEditingController(text: _dueDate == null? "" : DateFormat("d-M-y").format(_dueDate!));
    billingAddressController =
        TextEditingController(text: _billingAddress);

    invoiceNumberValidator = RequiredValidator(errorText: 'Invoice number is required');
    invoiceDateValidator = RequiredValidator(errorText: 'Invoice Date   is required');
    gstValidator = RequiredValidator(errorText: 'GST number is required');
    billingAddressValidator = RequiredValidator(errorText: 'Billing number is required');

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
                        widget.invoice.id != 0
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
                        initialValue: "-----",
                        onChangeDropDown: _onCompanyChange,
                      ),
                      Column(
                        children: [
                          KTextField(
                            label: "Invoice #",
                            controller: invoiceNumberController,
                            width: 200,
                            validator: invoiceNumberValidator,
                          ),
                          KTextField(
                            label: "Invoice Date",
                            controller: invoiceDateController,
                            width: 200,
                            validator: invoiceDateValidator,
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
                        controller: billingAddressController,
                        width: 310,
                        multiLine: 5,
                        validator: billingAddressValidator,
                      ),
                      Column(
                        children: [
                          KTextField(
                            label: "GST #",
                            controller: gstNumberController,
                            width: 200,
                            validator: gstValidator,
                          ),
                          KTextField(
                            label: "Due Date",
                            controller: dueDateController,
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
                                "\u{20B9}${currencyFormat.format(invoiceTotal)}",
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
                          width: containerWidth * 0.95/1.3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: 80,
                                child: ElevatedButton(
                                  onPressed: _resetForm,
                                  child: Text("Reset"),
                                ),
                              ),
                              Container(
                                width: 80,
                                child: ElevatedButton(
                                  onPressed: _submitForm,
                                  child: Text("Submit"),
                                ),
                              ),
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
                                  "Tax Total",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Invoice Total",
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
                                  "\u{20B9}${currencyFormat.format(subtotal)}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "\u{20B9}${currencyFormat.format(taxTotal)}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "\u{20B9}${currencyFormat.format(invoiceTotal)}",
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
      if(companyName != ""){
        Customer _customerData = _customerList.where((element) => element.company_name == companyName).toList()[0];
        _billingAddress = _customerData.address;
        _gstNumber = _customerData.gst;
        _dueDate = (widget.invoice.invoiceDate!.add(Duration(days: _customerData.creditPeriod))) ;

        billingAddressController.text = _billingAddress;
        gstNumberController.text = _gstNumber;
        dueDateController.text = DateFormat("d-M-y").format(_dueDate!);
      }
      checkboxList.clear();
      challanSelected.clear();
      subtotal = 0;
      taxTotal = 0;
      invoiceTotal = 0;
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
        ? Text("Please Select Company")
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
    print("CheckboxKist LEngth: ${checkboxList.length}");

    if (checkboxList.isEmpty) {
      for (int i = 0; i < _challanList.length; i++) {
        checkboxList.add(false);
        challanSelected.add(-1);
      }
    }

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
                    value: checkboxList[i],
                    onChanged: (bool? value) => checkboxChanged(
                        value!, _challanList[i], i, _gstList[i]),
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

  void checkboxChanged(bool _isChecked, Challan _challan, int i, String _gst) {
    setState(() {
      checkboxList[i] = _isChecked;
      if (_isChecked) {
        challanSelected[i] = _challan.id;
        subtotal += _challan.totalAmount;
        taxTotal += _challan.totalAmount * double.parse(_gst) / 100;
        invoiceTotal += _challan.totalAmount +
            (_challan.totalAmount * double.parse(_gst) / 100);
      } else {
        challanSelected[i] = -1;
        subtotal -= _challan.totalAmount;
        taxTotal -= _challan.totalAmount * double.parse(_gst) / 100;
        invoiceTotal -= (_challan.totalAmount +
            (_challan.totalAmount * double.parse(_gst) / 100));
      }
      print("Checkbox Status: $_isChecked od id: $_challan.id");
      print("Selected Challans: ${challanSelected}");
    });
  }

  void _resetForm() {
    invoiceNumberController.text = "";
    invoiceDateController.text = DateFormat("d-M-y").format(widget.invoice.invoiceDate!);
    billingAddressController.text = "";
    gstNumberController.text = "";
    dueDateController.text = "";
    _onCompanyChange("");
  }

  void _submitForm() {
    print("Submit Form");
    widget.invoice.invoiceNo = invoiceNumberController.text;
    widget.invoice.invoiceDate = DateFormat("yyyy-MM-dd").parse(invoiceDateController.text);
    widget.invoice.customerName = _companyName;
    widget.invoice.customerAddress = billingAddressController.text;
    widget.invoice.invoiceAmount = subtotal;
    widget.invoice.invoiceTax = taxTotal;
    widget.invoice.invoiceTotal = invoiceTotal;
    Provider.of<InvoiceProvider>(context, listen: false).saveInvoice(widget.invoice);
    Provider.of<ChallanProvider>(context, listen: false).updateInvoiceNumberInChallan(challanSelected, widget.invoice.invoiceNo);
    Navigator.of(context).pop();
  }
}
