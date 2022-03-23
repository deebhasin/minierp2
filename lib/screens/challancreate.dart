import 'dart:convert';

import 'package:erpapp/kwidgets/ksubmitresetbuttons.dart';
import 'package:erpapp/kwidgets/ktextfield.dart';
import 'package:erpapp/model/challan.dart';
import 'package:erpapp/model/customer.dart';
import 'package:erpapp/model/product.dart';
import 'package:erpapp/providers/challan_product_provider.dart';
import 'package:erpapp/providers/challan_provider.dart';
import 'package:erpapp/providers/customer_provider.dart';
import 'package:erpapp/providers/product_provider.dart';
import 'package:erpapp/widgets/alertdialognav.dart';
import 'package:erpapp/widgets/challan_product_widget.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../kwidgets/kvariables.dart';
import '../kwidgets/kdropdown.dart';
import '../model/challan_product.dart';

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

  // late KDropdown customerDropdown;
  // late KDropdown productDropdown;
  late final challanNumberController;
  late final challanDateController;
  late final challanTotalController;
  late final challanTaxAmountController;
  late final challanChallanAmountController;
  late final challanInvoiceNoController;

  late final productNameController;

  int lineItem = 0;
  List<ChallanProduct> _challanProductList = [];
  List<ChallanProduct> _challanProductListOld = [];

  String customerName = "-----";
  late double containerWidth;
  List<Customer> customerList = [];
  List<Product> productList = [];

  final challanNumberValidator =
      RequiredValidator(errorText: 'Challan Number is required');
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
    _buildForm();
    _getdropdownList();
    // _challanProductList = widget.challan.challanProductList??[];
    // _challanProductList.length == 0? _challanProductList.add(ChallanProduct()) : _challanProductList;
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
                    widget.challan.id == 0 ? "New Challan" : "Edit Challan",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KDropdown(
                  dropDownList:
                      customerList.map((e) => e.company_name).toList(),
                  label: "Customer",
                  initialValue: customerName,
                  width: 250,
                  onChangeDropDown: _onCompanyChange,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KTextField(
                      label: "Challan #",
                      width: 150,
                      isMandatory: true,
                      controller: challanNumberController,
                      validator: challanNumberValidator,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    KTextField(
                      label: "Challan Date",
                      isMandatory: true,
                      width: 150,
                      controller: challanDateController,
                      validator: challanDateValidator,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: _getChallanProductWidgets(),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 80,
                  height: 25,
                  child: ElevatedButton(
                    onPressed: _addLineItem,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.add,
                          color: Colors.blue,
                          size: 20,
                        ),
                        // const SizedBox(width: 5,),
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
            const SizedBox(
              height: 30,
            ),
            KSubmitResetButtons(
              resetForm: _resetForm,
              submitForm: _submitForm,
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  _getdropdownList() async {
    customerList = await Provider.of<CustomerProvider>(context, listen: false)
        .getCustomerList();
    productList = await Provider.of<ProductProvider>(context, listen: false)
        .getProductList();
    _challanProductListOld =
        await Provider.of<ChallanProductProvider>(context, listen: false)
            .getChallanProductListByChallanId(widget.challan.id);
    _challanProductList = List.from(_challanProductListOld);
    print("CHallanProductList Length: $_challanProductList");
    setState(() {});
    print(
        "Customer List: ${customerList.length} and Product List: ${productList.length}");
  }

  void _onCompanyChange(String customerName) {
    this.customerName = customerName;
  }

  // void _onProductChange(String productName) {
  //   this.productNameInitialValueList[lineItem] = productName;
  //   final product =
  //       productList.singleWhere((element) => element.name == productName);
  //
  //   // print("Price: ${price.price_per_unit}");
  // }

  void _buildForm() {
    if (widget.challan.id != 0) {
      customerName = widget.challan.customerName;
    }
    // customerDropdown = KDropdown(dropDownList: customerList, label: "Customer", initialValue: customerName, width: 250,);
    // productDropdown = KDropdown(dropDownList: productList, label: "Product", initialValue: productName, width: 250,);
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
  }

  void _resetForm() {
    print("Reset Start");
    lineItem = 0;
    customerName = widget.challan.id != 0? widget.challan.customerName : "-----";
    // widgetList.clear();
    // customerDropdown.initialValueChanged(widget.challan.customerName);
    challanNumberController.text = widget.challan.challanNo;
    challanDateController.text =
        DateFormat("d-M-y").format(widget.challan.challanDate!);

    _challanProductList = List.from(_challanProductListOld);
    _getChallanProductWidgets();
    print("_challanProductList Reset to _challanProductListOld with Length: ${_challanProductList.length}");
    print("Reset End");
    setState(() {

    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      widget.challan.customerName = customerName;
      widget.challan.challanNo = challanNumberController.text;
      widget.challan.challanDate =
          DateFormat("d-M-y").parse(challanDateController.text);

      print("Customer Name: ${widget.challan.customerName}");
      widget.challan.total = 0;
      widget.challan.taxAmount = 0;
      widget.challan.challanAmount = 0;

      for (ChallanProduct _element in _challanProductList){
        widget.challan.total += _element.totalBeforeTax;
        widget.challan.taxAmount += _element.taxAmount;
        widget.challan.challanAmount += _element.totalAmount;

      }

      Provider.of<ChallanProductProvider>(context, listen: false).deleteChallanProductNotInList(_challanProductList, widget.challan.id);

      if (widget.challan.id != 0) {
        Provider.of<ChallanProvider>(context, listen: false)
            .updateChallan(widget.challan);

        for(ChallanProduct _element in _challanProductList){
          if(_element.challanId ==0){
            _element.challanId = widget.challan.id;
            Provider.of<ChallanProductProvider>(context, listen: false).createChallanProduct(_element);
          }
          else{
            Provider.of<ChallanProductProvider>(context, listen: false).updateChallanProduct(_element);
          }
        }

        print("Product Updated");
      } else {
        int _challanId = await Provider.of<ChallanProvider>(context, listen: false)
            .createChallan(widget.challan);
        for(ChallanProduct _element in _challanProductList){
            _element.challanId = _challanId;
            Provider.of<ChallanProductProvider>(context, listen: false).createChallanProduct(_element);
          }
      }
      Navigator.of(context).pop();
    } else {
      print("Validation Failed");
    }
  }

  @override
  void dispose() {
    challanNumberController.dispose();
    challanDateController.dispose();
    super.dispose();
  }

  void _addLineItem() {
    setState(() {
      _challanProductList.add(ChallanProduct());
    });
    // widgetList.add(ChallanProductWidget(productList: productList,challanProduct: challanProduct, onProductChange: _onProductChange,));
    // addLineItemOnClick();
  }

  Widget _getChallanProductWidgets() {
    // print("CHallan Product List Length ${_challanProductList.length}");
    // lineItem = 0;
    return Column(
        children: _challanProductList
            .map((challanProductItem) => ChallanProductWidget(
                  key: ObjectKey(challanProductItem),
                  productList: productList,
                  challanProduct: challanProductItem,
                  challanProductListPos: _challanProductList.indexOf(challanProductItem),
                  deleteChallanProductFromList: _deleteChallanProductFromList,
                ))
            .toList());
  }

  void _deleteChallanProductFromList(int pos ) {
    setState(() {
      _challanProductList.removeAt((pos));
      print("Position in List ${pos.toString()}");
    });
  }
}
