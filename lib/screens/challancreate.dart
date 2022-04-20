import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../kwidgets/k_popup_alert.dart';
import '../providers/challan_provider.dart';
import '../providers/customer_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/alertdialognav.dart';
import '../widgets/challan_product_widget.dart';

import '../model/challan_product.dart';
import '../model/challan.dart';
import '../model/customer.dart';
import '../model/product.dart';

import '../kwidgets/kvariables.dart';
import '../kwidgets/kdropdown.dart';
import '../kwidgets/KDateTextForm.dart';
import '../kwidgets/ksubmitresetbuttons.dart';
import '../kwidgets/ktextfield.dart';
import '../kwidgets/kvalidator.dart';

class ChallanCreate extends StatefulWidget {
  Challan challan;
  ChallanCreate({
    Key? key,
    required this.challan,
  }) : super(key: key);

  @override
  State<ChallanCreate> createState() => _ChallanCreateState();
}

class _ChallanCreateState extends State<ChallanCreate> {
  final _formKey = GlobalKey<FormState>();
  bool _isInvoice = false;
  final currencyFormat = NumberFormat("#,##0.00", "en_US");

  double _totalBeforeTax = 0;
  double _taxAmount = 0;
  double _challanAmount = 0;

  late final customerNameController;
  late final challanNumberController;
  late final challanDateController;
  late final challanTotalController;
  late final challanTaxAmountController;
  late final challanChallanAmountController;
  late final challanInvoiceNoController;
  late final _dateInputController;

  late final productNameController;

  int lineItem = 0;
  List<ChallanProduct> _challanProductList = [];
  late bool _isChallanNo;

  String customerName = "-----";
  late double containerWidth;
  List<Customer> customerList = [];
  List<Product> _productList = [];

  String _challanNumberErrorMessage = "";
  List<String> _errorMsgList = [];
  bool _hasErrors = false;

  final _customerNameValidator =
      KDropDownFieldValidator(errorText: 'Customer is required');
  MultiValidator challanNumberValidator = MultiValidator([]);
  final challanDateValidator =
      RequiredValidator(errorText: 'Challan Date is required');
  final challanPricePerUnitValidator = MultiValidator([
    RequiredValidator(errorText: 'Price Per Unit is required'),
    PatternValidator(r'\d+?$', errorText: "Price Per Unit should be number"),
  ]);
  final challanUnitValidator =
      RequiredValidator(errorText: 'Item Unit is required');
  final challanQuantityValidator = MultiValidator([
    RequiredValidator(errorText: 'Quantity is required'),
    PatternValidator(r'\d+?$', errorText: "Quantity should be number"),
  ]);

  @override
  void initState() {
    _isInvoice = widget.challan.invoiceNo != "" ? true : false;
    _challanProductList = widget.challan.challanProductList;
    print("Challan Product List Length in Init: ${_challanProductList.length}");

    if (widget.challan.id == 0) {
      for (int i = _challanProductList.length; i < 3; i++) {
        _challanProductList.add(ChallanProduct());
        print("List Counter: $i");
      }
    }

    print("Challan Product List Length in Init: ${_challanProductList.length}");
    _buildForm();
    _updateTotals();
    _getdropdownList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    containerWidth =
        (MediaQuery.of(context).size.width - KVariables.sidebarWidth);

    print("CHallan create bui;d ca;;ed");
    return _challanCreate();
  }

  Widget _challanCreate() {
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.challan.id == 0
                        ? "New Challan"
                        : _isInvoice
                            ? "View Challan"
                            : "Edit Challan",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _isInvoice
                    ? KTextField(
                        label: "Customer",
                        controller: customerNameController,
                        width: 250,
                        isDisabled: true,
                      )
                    : KDropdown(
                        dropDownList:
                            customerList.map((e) => e.company_name).toList(),
                        label: "Customer",
                        initialValue: customerName,
                        width: 250,
                        onChangeDropDown: _onCompanyChange,
                        validator: _customerNameValidator,
                        isMandatory: true,
                        isShowSearchBox: false,
                      ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_isInvoice)
                      KTextField(
                        label: "Invoice #",
                        width: 150,
                        controller: challanInvoiceNoController,
                        isDisabled: _isInvoice,
                        valueUpdated: (String) {},
                      ),
                    KTextField(
                      label: "Challan # ",
                      width: 150,
                      isMandatory: _isInvoice ? false : true,
                      controller: challanNumberController,
                      validator: challanNumberValidator,
                      isDisabled: _isInvoice,
                      valueUpdated: (String) {},
                    ),
                    _isInvoice
                        ? KTextField(
                            label: "Challan Date",
                            width: 150,
                            controller: challanDateController,
                            validator: challanNumberValidator,
                            isDisabled: _isInvoice,
                          )
                        : KDateTextForm(
                            label: "Challan Date",
                            dateInputController: _dateInputController,
                          ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: containerWidth *0.95,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _textFieldHeader("Product", 250,),
                  _textFieldHeader("Price Per Unit", 130,),
                  _textFieldHeader("Unit", 70,),
                  _textFieldHeader("Quantity", 80,),
                  _textFieldHeader("Total", 80,),
                  _textFieldHeader("GST %", 70,),
                  _textFieldHeader("GST", 100,),
                  _textFieldHeader("Total Amount", 110,),
                  _textFieldHeader("", 2,),
                ],
              ),
            ),
            const Divider(thickness: 3,),
            Expanded(
              child: SingleChildScrollView(
                child: _getChallanProductWidgets(),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _isInvoice
                    ? Container(
                        width: containerWidth * 0.7,
                      )
                    : Container(
                        width: containerWidth * 0.7,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 80,
                                  height: 25,
                                  child: ElevatedButton(
                                    onPressed: _addLineItem,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.add,
                                          color: Colors.blue,
                                          size: 20,
                                        ),
                                        Text(
                                          "Add",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Color.fromRGBO(0, 0, 0, .05),
                                      shadowColor: Colors.transparent,
                                      side: const BorderSide(
                                        width: 2,
                                        color: Colors.blue,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                KSubmitResetButtons(
                                  isReset: false,
                                  resetForm: () {},
                                  submitForm: _submitForm,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text("Sub Total: \u{20B9} "),
                        Text("Tax: \u{20B9} "),
                        Text("Total: \u{20B9} "),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${currencyFormat.format(_totalBeforeTax)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${currencyFormat.format(_taxAmount)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${currencyFormat.format(_challanAmount)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget _textFieldHeader(String _label, double _width) {
    return Container(
      width: _width,
      alignment: Alignment.center,
      child: Text(
        _label,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  Future<void> _getdropdownList() async {
    customerList =
        Provider.of<CustomerProvider>(context, listen: false).customerList;
    _productList =
        Provider.of<ProductProvider>(context, listen: false).productList;
    print("CHallanProductList Length: ${_challanProductList.length}");
    setState(() {});
    print(
        "Customer List: ${customerList.length} and Product List: ${_productList.length}");
  }

  void _onCompanyChange(String customerName) {
    this.customerName = customerName;
  }

  void _buildForm() {
    if (widget.challan.id != 0) {
      customerName = widget.challan.customerName;
    }
    customerNameController =
        TextEditingController(text: widget.challan.customerName);
    challanNumberController =
        TextEditingController(text: widget.challan.challanNo);
    challanDateController = TextEditingController(
        text: DateFormat("d-M-y").format(widget.challan.challanDate!));
    challanTotalController =
        TextEditingController(text: widget.challan.total.toString());
    challanTaxAmountController =
        TextEditingController(text: widget.challan.taxAmount.toString());
    challanChallanAmountController =
        TextEditingController(text: widget.challan.challanAmount.toString());
    challanInvoiceNoController =
        TextEditingController(text: widget.challan.invoiceNo.toString());

    _dateInputController = TextEditingController(
        text: DateFormat('dd-MM-yyyy').format(widget.challan.challanDate!));
    print('_dateInputController ${_dateInputController.text}');

    challanNumberValidator = MultiValidator([
      RequiredValidator(errorText: 'Challan Number is required'),
    ]);
  }

  void _updateTotals() {
    _totalBeforeTax = 0;
    _taxAmount = 0;
    _challanAmount = 0;
    print("Update Totalts Begin");
    for (ChallanProduct _element in _challanProductList) {
      _totalBeforeTax += _element.totalBeforeTax;
      _taxAmount += _element.taxAmount;
      _challanAmount += _element.totalAmount;
    }
    print("Total Before Tax: $_totalBeforeTax");
    print("Tax Amount: $_taxAmount");
    print("Challan Total: $_challanAmount");
    setState(() {});
  }

  Future<void> _submitForm() async {
    _hasErrors = false;
    _errorMsgList.clear();
    await _checkChallanNumberError();
    _checkLineItemError();

    if (_hasErrors) _popupAlert(_errorMsgList);
    print("Check Errors Has Errors: $_challanNumberErrorMessage");

    if (_formKey.currentState!.validate() && !_hasErrors) {
      // if (_formKey.currentState!.validate()) {
      widget.challan.customerName = customerName;
      widget.challan.challanNo = challanNumberController.text;
      widget.challan.challanDate =
          DateFormat('dd-MM-yyyy').parse(_dateInputController.text);

      print("Customer Name: ${widget.challan.customerName}");
      widget.challan.total = 0;
      widget.challan.taxAmount = 0;
      widget.challan.challanAmount = 0;
      widget.challan.challanProductList = List.from(_challanProductList);

      widget.challan.total += _totalBeforeTax;
      widget.challan.taxAmount += _taxAmount;
      widget.challan.challanAmount += _challanAmount;

      Provider.of<ChallanProvider>(context, listen: false)
          .challanSave(widget.challan);

      Navigator.of(context).pop();
    } else {
      print("Validation Failed");
    }
  }

  @override
  void dispose() {
    challanNumberController.dispose();
    challanDateController.dispose();
    _dateInputController.dispose();
    super.dispose();
  }

  void _addLineItem() {
    setState(() {
      _challanProductList.add(ChallanProduct());
    });
  }

  Widget _getChallanProductWidgets() {
    return Column(
        children: _challanProductList
            .map((challanProductItem) => ChallanProductWidget(
                  key: ObjectKey(challanProductItem),
                  challanProduct: challanProductItem,
                  challanProductListPos:
                      _challanProductList.indexOf(challanProductItem),
                  deleteChallanProductFromList: _deleteChallanProductFromList,
                  isInvoice: _isInvoice,
                  checkRedundentLineItem: _checkRedundentLineItem,
                  updateTotals: _updateTotals,
                ))
            .toList());
  }

  void _deleteChallanProductFromList(int pos) {
    setState(() {
      _challanProductList.removeAt((pos));
      _updateTotals();
      print("Position in List ${pos.toString()}");
    });
  }

  bool _checkRedundentLineItem(String _productNameCheck, int index) {
    bool checkStatus;
    checkStatus = _challanProductList.any((element) =>
        element.productName == _productNameCheck &&
        _challanProductList.indexOf(element) != index);
    print("REdundency Statussss: $checkStatus");
    print("Challan Product List Length: ${_challanProductList.length}");
    print("Index: $index");
    _challanProductList.forEach((element) {
      print(element.productName);
    });
    return checkStatus;
  }

  Future<void> _checkChallanNumberError() async {
    _isChallanNo = false;
    _isChallanNo = await Provider.of<ChallanProvider>(context, listen: false)
        .checkChallanNumber(challanNumberController.text);
    // setState(() {
    if (widget.challan.id == 0) {
      _hasErrors = _isChallanNo;
    } else {
      if (challanNumberController.text != widget.challan.challanNo) {
        _hasErrors = _isChallanNo;
        print("Error in Edit: $_hasErrors");
      }
    }

    _challanNumberErrorMessage = _hasErrors ? "Challan Number exists" : "";
    if (_hasErrors) _errorMsgList.add(_challanNumberErrorMessage);
    print("Check Error Challan Id: ${widget.challan.id}");
    print(":Has Errors: $_hasErrors");
    print("ISChallanNumber: $_isChallanNo");
    print("_challanNumberErrorMessage: $_challanNumberErrorMessage");
    // });
  }

  void _checkLineItemError() {
    bool isLineItemEmpty = false;
    isLineItemEmpty =
        _challanProductList.every((element) => element.totalAmount <= 0);
    if (isLineItemEmpty) {
      _errorMsgList.add("Line Items are not Addedd to Challan.");
      _hasErrors = true;
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
}
