import 'package:erpapp/providers/org_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../kwidgets/k_popup_alert.dart';
import '../kwidgets/kvariables.dart';
import '../kwidgets/kdropdown.dart';
import '../kwidgets/KDateTextForm.dart';
import '../kwidgets/ktextfield.dart';
import '../model/challan.dart';
import '../model/customer.dart';
import '../model/invoice.dart';
import '../model/organization.dart';
import '../providers/challan_provider.dart';
import '../providers/customer_provider.dart';
import '../widgets/alertdialognav.dart';
import '../providers/invoice_provider.dart';
import '../widgets/challan_checkbox_horizontal_data_table.dart';
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
  late final _invoiceNumberController;
  late final _invoiceDateController;
  late final _gstNumberController;
  late final _dueDateController;
  late final _billingAddressController;
  late final _dateFromController;
  late final _dateToController;
  late final _transportModeController;
  late final _vehicleNumberController;
  late final _taxPayableOnReverseChargeController;
  late final _termsAndConditionsController;

  late final RequiredValidator _invoiceNumberValidator;
  late final RequiredValidator _invoiceDateValidator;
  late final RequiredValidator _gstValidator;
  late final RequiredValidator _billingAddressValidator;
  late final RequiredValidator _transportModeValidator;
  late final RequiredValidator _vehicleNumberValidator;
  late final RequiredValidator _taxPayableOnReverseChargeCoValidator;

  String _gstNumber = "";
  String _billingAddress = "";
  DateTime? _dueDate;

  List<Customer> _customerList = [];
  List<Challan> _challanList = [];
  Organization organization = Organization();

  List<String> _errorMsgList = [];
  bool _hasErrors = false;

  String _companyName = "";

  String dropdownValue = "-----";
  final currencyFormat = NumberFormat("#,##0.00", "en_US");
  double challanAmount = 0;
  List<bool> _isCheckedList = [];

  double subtotal = 0;
  double taxTotal = 0;
  double invoiceTotal = 0;

  @override
  void initState() {
    _getAllLists();

    if (widget.invoice.id != 0) {
      print(
          "InvoiceCreate ChallanList Length: ${widget.invoice.challanList.length}");
      _companyName = widget.invoice.customerName;
      _gstNumber = _customerList
          .where(
              (element) => element.company_name == widget.invoice.customerName)
          .toList()[0]
          .gst;
      _dueDate = widget.invoice.invoiceDate!.add(Duration(
          days: _customerList
              .where((element) =>
                  element.company_name == widget.invoice.customerName)
              .toList()[0]
              .creditPeriod));
      _updateTotals();
    }

    _invoiceNumberController =
        TextEditingController(text: widget.invoice.invoiceNo);
    _invoiceDateController = TextEditingController(
        text: DateFormat("dd-MM-yyyy").format(widget.invoice.invoiceDate!));
    _gstNumberController = TextEditingController(text: _gstNumber);
    _dueDateController = TextEditingController(
        text:
            _dueDate == null ? "" : DateFormat("dd-MM-yyyy").format(_dueDate!));
    _billingAddressController =
        TextEditingController(text: widget.invoice.customerAddress);
    _transportModeController =
        TextEditingController(text: widget.invoice.transportMode);
    _vehicleNumberController =
        TextEditingController(text: widget.invoice.vehicleNumber);
    _taxPayableOnReverseChargeController = TextEditingController(
        text: widget.invoice.id == 0
            ? "Yes"
            : widget.invoice.taxPayableOnReverseCharges);
    _termsAndConditionsController = TextEditingController(
        text: widget.invoice.id == 0
            ? organization.termsAndConditions
            : widget.invoice.termsAndConditions);

    _dateFromController = TextEditingController(
        text:
            "01-${DateFormat("MM").format(DateTime.now())}-${DateFormat("yyyy").format(DateTime.now())}");
    _dateToController = TextEditingController(
        text: DateFormat('dd-MM-yyyy').format(DateTime.now()));

    _invoiceNumberValidator =
        RequiredValidator(errorText: 'Invoice number is required');
    _invoiceDateValidator =
        RequiredValidator(errorText: 'Invoice Date is required');
    _gstValidator = RequiredValidator(errorText: 'GST number is required');
    _billingAddressValidator =
        RequiredValidator(errorText: 'Billing number is required');
    _transportModeValidator =
        RequiredValidator(errorText: 'Transport Mode is required');
    _vehicleNumberValidator =
        RequiredValidator(errorText: 'Vehicle Number is required');
    _taxPayableOnReverseChargeCoValidator =
        RequiredValidator(errorText: 'Required');

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
            Expanded(
              child: SingleChildScrollView(
                child: Container(
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                isMandatory: true,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              KTextField(
                                label: "Billing Address ",
                                controller: _billingAddressController,
                                width: 310,
                                multiLine: 5,
                                validator: _billingAddressValidator,
                                isMandatory: true,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              KTextField(
                                label: "Invoice #",
                                controller: _invoiceNumberController,
                                width: 200,
                                validator: _invoiceNumberValidator,
                                isMandatory: true,
                              ),
                              KDateTextForm(
                                label: "Invoice Date:",
                                dateInputController: _invoiceDateController,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              KDateTextForm(
                                label: "Due Date:",
                                dateInputController: _dueDateController,
                                lastDate:
                                    DateTime.now().add(Duration(days: 365)),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              KTextField(
                                label: "GST #",
                                controller: _gstNumberController,
                                width: 200,
                                validator: _gstValidator,
                                isMandatory: true,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              KTextField(
                                label: "Transport Mode",
                                controller: _transportModeController,
                                width: 200,
                                validator: _transportModeValidator,
                                isMandatory: true,
                              ),
                              KTextField(
                                label: "Vehicle Number",
                                controller: _vehicleNumberController,
                                width: 200,
                                validator: _vehicleNumberValidator,
                                isMandatory: true,
                              ),
                              KTextField(
                                label: "Tax payable on reverse charge",
                                controller:
                                    _taxPayableOnReverseChargeController,
                                width: 240,
                                validator:
                                    _taxPayableOnReverseChargeCoValidator,
                                isMandatory: true,
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
                                    onDateChange: _dateSelected,
                                  ),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  KDateTextForm(
                                    label: "To:",
                                    dateInputController: _dateToController,
                                    onDateChange: _dateSelected,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "Challan",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
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
                                    "\u{20B9}${currencyFormat.format(widget.invoice.invoiceAmount)}",
                                    style: TextStyle(
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
                          // Text(
                          //   "Challan",
                          //   style: TextStyle(
                          //       fontWeight: FontWeight.bold, fontSize: 20),
                          // )
                        ],
                      ),
                      _getChallanList(_companyName),
                      SizedBox(
                        height: 140,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              children: [
                                Expanded(
                                  child: KTextField(
                                    label: "Terms and Conditions",
                                    controller: _termsAndConditionsController,
                                    width: 310,
                                    multiLine: 3,
                                    validator: _billingAddressValidator,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: 200,
                                  child: ElevatedButton(
                                    onPressed: _submitForm,
                                    child: Text("Submit"),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: const [
                                        Text(
                                          "Subtotal",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Tax Total",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "\u{20B9}${currencyFormat.format(widget.invoice.totalBeforeTax)}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "\u{20B9}${currencyFormat.format(widget.invoice.taxAmount)}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        // DisplayInvoiceTotal(totalType: "taxTotal"),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "\u{20B9}${currencyFormat.format(widget.invoice.invoiceAmount)}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        // DisplayInvoiceTotal(totalType: "invoiceTotal"),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
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
    organization = Provider.of<OrgProvider>(context, listen: false).getOrg;
    print("Organization Terms: ${organization.termsAndConditions}");
  }

  void _onCompanyChange(String companyName) {
    setState(() {
      _companyName = companyName;
      print("-ONcompanyChange Company NAme: $companyName");
      Customer _customerData = _customerList
          .where((element) => element.company_name == companyName)
          .toList()[0];
      _billingAddress = _customerData.address;
      _gstNumber = _customerData.gst;
      _dueDate = (widget.invoice.invoiceDate!
          .add(Duration(days: _customerData.creditPeriod)));

      _billingAddressController.text = _billingAddress;
      _gstNumberController.text = _gstNumber;
      _dueDateController.text = DateFormat("d-M-y").format(_dueDate!);

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
        ? Container(
            height: 185,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Please Select Company"),
              ],
            ),
          )
        : Consumer<ChallanProvider>(builder: (ctx, provider, child) {
            return FutureBuilder(
              future: widget.invoice.id == 0
                  ? provider.getChallanListByParameters(
                      customerName: _companyName,
                      active: 1,
                      invoiceNo: "Not Assigned",
                      fromDate: DateFormat("dd-MM-yyyy")
                          .parse(_dateFromController.text),
                      toDate: DateFormat("dd-MM-yyyy")
                          .parse(_dateToController.text),
                    )
                  : provider.getChallanListByParameters(
                      customerName: _companyName,
                      active: 1,
                      invoiceNo: widget.invoice.invoiceNo + "*or",
                      fromDate: DateFormat("dd-MM-yyyy")
                          .parse(_dateFromController.text),
                      toDate: DateFormat("dd-MM-yyyy")
                          .parse(_dateToController.text),
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

                    _isCheckedList.clear();
                    challanList.forEach((challan) {
                      print(
                          "Disco Khisco Challan List Length: ${widget.invoice.challanList.length}");
                      print(
                          "DIsco ${challan.id}: ${widget.invoice.challanList.any((invoiceChallan) => challan.id == invoiceChallan.id)}");
                      if (widget.invoice.challanList.any((invoiceChallan) =>
                          challan.id == invoiceChallan.id)) {
                        _isCheckedList.add(true);
                      } else {
                        _isCheckedList.add(false);
                      }
                    });
                    print(
                        "_isCheckedList Length in Invoice Create: ${_isCheckedList.length}");
                    return _displayChallans(
                        challanList, context, _isCheckedList);
                    // return Container();
                  } else
                    return Container();
                }
              },
            );
          });
  }

  Widget _displayChallans(
      List<Challan> challanList, BuildContext context, List<bool> isCheckList) {
    return challanList.isEmpty
        ? Text("Challans Dont Exist for the selected period.")
        : ChallanCheckboxHorizontalDataTable(
            leftHandSideColumnWidth: 0,
            rightHandSideColumnWidth: containerWidth * 0.65,
            challanList: challanList,
            isCheckedList: _isCheckedList,
            checkboxChanged: checkboxChanged,
          );
  }

  void checkboxChanged(bool isChecked, Challan challan) {
    challan.invoiceNo = _invoiceNumberController.text;
    setState(() {
      isChecked
          ? widget.invoice.addChallan(challan)
          : widget.invoice.removeChallan(challan);
    });
    _updateTotals();
  }

  void _updateTotals() {
    subtotal = widget.invoice.totalBeforeTax;
    taxTotal = widget.invoice.taxAmount;
    invoiceTotal = widget.invoice.invoiceAmount;
  }

  void _dateSelected() {
    _onCompanyChange(_companyName);
  }

  void _resetForm() {
    _invoiceNumberController.text = "";
    _invoiceDateController.text =
        DateFormat("dd-MM-yyyy").format(widget.invoice.invoiceDate!);
    _billingAddressController.text = "";
    _gstNumberController.text = "";
    _dueDateController.text = "";
    _onCompanyChange("");
  }

  void _submitForm() async {
    print("Submit Form");
    _hasErrors = false;
    _errorMsgList.clear();
    _checkInvoiceNumberError();
    _checkLineItemError();

    if (_hasErrors) _popupAlert(_errorMsgList);

    if (_formKey.currentState!.validate() && !_hasErrors) {
      widget.invoice.invoiceNo = _invoiceNumberController.text;
      widget.invoice.invoiceDate =
          DateFormat("dd-MM-yyyy").parse(_invoiceDateController.text);
      widget.invoice.dueDate =
          DateFormat("dd-MM-yyyy").parse(_dueDateController.text);
      widget.invoice.customerName = _companyName;
      widget.invoice.customerAddress = _billingAddressController.text;
      widget.invoice.gst = _gstNumberController.text;
      widget.invoice.transportMode = _transportModeController.text;
      widget.invoice.vehicleNumber = _vehicleNumberController.text;
      widget.invoice.taxPayableOnReverseCharges = _taxPayableOnReverseChargeController.text;
      widget.invoice.termsAndConditions = _termsAndConditionsController.text;

      await Provider.of<InvoiceProvider>(context, listen: false)
          .saveInvoice(widget.invoice);
      await Provider.of<ChallanProvider>(context, listen: false)
          .updateInvoiceNumberInChallan(
              widget.invoice.challanList, widget.invoice.invoiceNo);
      print("Invoice Date: ${_invoiceDateController.text}");
      Navigator.of(context).pop();
    }
  }

  Future<void> _checkInvoiceNumberError() async {
    bool _isInvoiceNo = false;
    _isInvoiceNo = await Provider.of<InvoiceProvider>(context, listen: false)
        .checkInvoiceNumber(_invoiceNumberController.text);
    if (widget.invoice.id == 0) {
      _hasErrors = _isInvoiceNo;
      _errorMsgList.add("The Invoice Number Exists");
    } else {
      if (_invoiceNumberController.text != widget.invoice.invoiceNo) {
        _hasErrors = _isInvoiceNo;
        _errorMsgList.add("The Invoice Number Cannot be changed");
        print("Error in _checkInvoiceNumberError: $_hasErrors");
      }
    }
  }

  void _checkLineItemError() {
    bool isChecked = _isCheckedList.any((element) => element == true);
    if (!isChecked) {
      _hasErrors = true;
      _errorMsgList.add("Select atleast one Challan");
    }
  }

  void _popupAlert(List<String> _errorMsgList) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return KPopupAlert(
            errorMsgList: _errorMsgList,
          );
        });
  }

  @override
  void dispose() {
    _invoiceNumberController.dispose();
    _invoiceDateController.dispose();
    _billingAddressController.dispose();
    _gstNumberController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }
}
