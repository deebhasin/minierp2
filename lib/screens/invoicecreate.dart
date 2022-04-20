import 'package:erpapp/providers/checkbox_provider.dart';
import 'package:erpapp/providers/invoice_provider.dart';
import 'package:erpapp/widgets/challan_horizontal_data_table.dart';
import 'package:erpapp/widgets/display_invoice_total.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../kwidgets/kvariables.dart';
import '../kwidgets/kdropdown.dart';
import '../kwidgets/KDateTextForm.dart';
import '../kwidgets/ktextfield.dart';
import '../model/challan.dart';
import '../model/customer.dart';
import '../model/invoice.dart';
import '../model/product.dart';
import '../providers/challan_provider.dart';
import '../providers/customer_provider.dart';
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
  late final _dateFromController;
  late final _dateToController;

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
  List<int> challanSelected = [];

  String _companyName = "";

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
    // _gstNumber = _customerList
    //     .firstWhere(
    //         (element) => element.company_name == widget.invoice.customerName)
    //     .gst;
    // _dueDate = widget.invoice.id == 0? null : DateTime.now().add(Duration(
    //     days: _customerList
    //         .firstWhere((element) =>
    //             element.company_name == widget.invoice.customerName)
    //         .creditPeriod));

    invoiceNumberController =
        TextEditingController(text: widget.invoice.invoiceNo);
    invoiceDateController = TextEditingController(
        text: DateFormat("dd-MM-yyyy").format(widget.invoice.invoiceDate!));
    gstNumberController = TextEditingController(text: _gstNumber);
    dueDateController = TextEditingController(
        text:
            _dueDate == null ? "" : DateFormat("dd-MM-yyyy").format(_dueDate!));
    billingAddressController =
        TextEditingController(text: widget.invoice.customerAddress);
    _dateFromController = TextEditingController(
        text:
            "01-${DateFormat("MM").format(DateTime.now())}-${DateFormat("yyyy").format(DateTime.now())}");
    _dateToController = TextEditingController(
        text: DateFormat('dd-MM-yyyy').format(DateTime.now()));

    invoiceNumberValidator =
        RequiredValidator(errorText: 'Invoice number is required');
    invoiceDateValidator =
        RequiredValidator(errorText: 'Invoice Date   is required');
    gstValidator = RequiredValidator(errorText: 'GST number is required');
    billingAddressValidator =
        RequiredValidator(errorText: 'Billing number is required');
    Provider.of<CheckboxProvider>(context, listen: false).initialiseTotalList();
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
                        widget.invoice.id != 0 ? "Edit Invoice" : "New Invoice",
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
                        initialValue: widget.invoice.id == 0
                            ? "-----"
                            : widget.invoice.customerName,
                        onChangeDropDown: _onCompanyChange,
                        isShowSearchBox: false,
                      ),
                      Column(
                        children: [
                          KTextField(
                            label: "Invoice #",
                            controller: invoiceNumberController,
                            width: 200,
                            validator: invoiceNumberValidator,
                          ),
                          KDateTextForm(
                            label: "Invoice Date:",
                            dateInputController: invoiceDateController,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
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
                                dateInputController: _dateFromController,
                              ),
                              SizedBox(
                                width: 50,
                              ),
                              KDateTextForm(
                                label: "To:",
                                dateInputController: _dateToController,
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
                              DisplayInvoiceTotal(
                                  totalType: "invoiceTotal", fontSize: 30),
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
                          width: containerWidth * 0.95 / 1.3,
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
                                // DisplayInvoiceTotal(value: subtotal),

                                DisplayInvoiceTotal(totalType: "subtotal"),
                                const SizedBox(
                                  height: 20,
                                ),
                                DisplayInvoiceTotal(totalType: "taxTotal"),
                                const SizedBox(
                                  height: 20,
                                ),
                                DisplayInvoiceTotal(totalType: "invoiceTotal"),
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

  void _getAllLists() {
    _customerList =
        Provider.of<CustomerProvider>(context, listen: false).customerList;
  }

  void _onCompanyChange(String companyName) {
    setState(() {
      if (companyName == "") {
        companyName = widget.invoice.customerName;
      } else {
        _companyName = companyName;
        print("-ONcompanyChange Company NAme: $companyName");
        Customer _customerData = _customerList
            .where((element) => element.company_name == companyName)
            .toList()[0];
        _billingAddress = _customerData.address;
        _gstNumber = _customerData.gst;
        _dueDate = (widget.invoice.invoiceDate!
            .add(Duration(days: _customerData.creditPeriod)));

        billingAddressController.text = _billingAddress;
        gstNumberController.text = _gstNumber;
        dueDateController.text = DateFormat("d-M-y").format(_dueDate!);
      }
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

  Widget _getChallanList(String _companyName) {
    List<Challan> challanList;

    return _companyName == ""
        ? Text("Please Select Company")
        : Consumer<ChallanProvider>(builder: (ctx, provider, child) {
            return FutureBuilder(
              future: provider.getChallanListByParameters(
                customerName: _companyName,
                active: 1,
                invoiceNo: "Not Assigned",
                fromDate:
                    DateFormat("dd-MM-yyyy").parse(_dateFromController.text),
                toDate: DateFormat("dd-MM-yyyy").parse(_dateToController.text),
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
                    // challanList.forEach((row) => print(row.customerName));
                    // return _displayChallans(_challanList, context);
                    return _displayChallans(challanList, context);
                    // return Container();
                  } else
                    return Container();
                }
              },
            );
          });
  }

  Widget _displayChallans(List<Challan> _challanList, BuildContext context) {
    return ChallanHorizontalDataTable(
      leftHandSideColumnWidth: 0,
      rightHandSideColumnWidth: containerWidth * 0.73,
      challanList: _challanList,
      checkboxChanged: checkboxChanged,
      isCheckbox: true,
    );
  }

  void checkboxChanged() {
    List<double> totalList =
        Provider.of<CheckboxProvider>(context, listen: false).totalList;
    subtotal = totalList[0];
    taxTotal = totalList[1];
    invoiceTotal = totalList[2];
    print("checkboxChanged in Invoice Create ${subtotal}");
  }

  void _resetForm() {
    invoiceNumberController.text = "";
    invoiceDateController.text =
        DateFormat("dd-MM-yyyy").format(widget.invoice.invoiceDate!);
    billingAddressController.text = "";
    gstNumberController.text = "";
    dueDateController.text = "";
    _onCompanyChange("");
    challanSelected.clear();
  }

  void _submitForm() {
    print("Submit Form");
    widget.invoice.invoiceNo = invoiceNumberController.text;
    widget.invoice.invoiceDate =
        DateFormat("yyyy-MM-dd").parse(invoiceDateController.text);
    widget.invoice.customerName = _companyName;
    widget.invoice.customerAddress = billingAddressController.text;
    widget.invoice.invoiceAmount = subtotal;
    widget.invoice.invoiceTax = taxTotal;
    widget.invoice.invoiceTotal = invoiceTotal;
    Provider.of<InvoiceProvider>(context, listen: false)
        .saveInvoice(widget.invoice);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    invoiceNumberController.dispose();
    invoiceDateController.dispose();
    billingAddressController.dispose();
    gstNumberController.dispose();
    dueDateController.dispose();
    super.dispose();
  }
}
