import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../kwidgets/k_confirmation_popup.dart';
import '../kwidgets/kdropdown.dart';
import '../kwidgets/ktextfield.dart';
import '../kwidgets/kvalidator.dart';
import '../model/product.dart';
import '../model/challan_product.dart';
import '../providers/product_provider.dart';
import '../utils/logfile.dart';

class ChallanProductWidget extends StatefulWidget {
  ChallanProduct challanProduct;
  int challanProductListPos;
  Function deleteChallanProductFromList;
  Function? checkRedundentLineItem;
  bool? isInvoice;
  Function? updateTotals;
  ChallanProductWidget({
    Key? key,
    required this.challanProduct,
    required this.challanProductListPos,
    required this.deleteChallanProductFromList,
    this.isInvoice = false,
    this.checkRedundentLineItem,
    this.updateTotals,
  }) : super(key: key) {
    LogFile().logEntry(
        "Challan Product Position: ${challanProduct.productName} : $challanProductListPos");
  }

  @override
  State<ChallanProductWidget> createState() => _ChallanProductWidgetState();
}

class _ChallanProductWidgetState extends State<ChallanProductWidget> {
  String _dropdownInitialValue = "-----";
  String productName = "";
  late List<Product> _productList;
  bool isChallan = false;
  final currencyFormat = NumberFormat("#,##0.00", "en_US");

  late final productNameController;
  late final pricePerUnitController;
  late final unitController;
  late final quantityController;
  late final productTotalBeforeTaxController;
  late final productGstPercentController;
  late final productTaxAmountController;
  late final productTotalAmountController;

  late MultiValidator productNameValidator;
  final pricePerUnitValidator = MultiValidator([
    RequiredValidator(errorText: "Required"),
    PatternValidator(r'\d+?$', errorText: "Not Number"),
    KZeroValidator(errorText: "Not Zero"),
  ]);
  final unitValidator = RequiredValidator(errorText: "Unit is required");
  final quantityValidator = MultiValidator([
    RequiredValidator(errorText: "Required"),
    PatternValidator(r'\d+?$', errorText: "Not Number"),
    KZeroValidator(errorText: "Not Zero"),
  ]);
  final gstPercentValidator = MultiValidator([
    RequiredValidator(errorText: "Required"),
    PatternValidator(r'\d+?$', errorText: "Not Number"),
    KZeroValidator(errorText: "Not Zero"),
  ]);

  @override
  void initState() {
    _dropdownInitialValue = widget.challanProduct.id != 0
        ? widget.challanProduct.productName
        : _dropdownInitialValue;
    productName = widget.challanProduct.productName;
    productNameController =
        TextEditingController(text: widget.challanProduct.productName);
    pricePerUnitController = TextEditingController(
        text: currencyFormat.format(widget.challanProduct.pricePerUnit));
    unitController =
        TextEditingController(text: widget.challanProduct.productUnit);
    quantityController = TextEditingController(
        text: currencyFormat.format(widget.challanProduct.quantity));
    productTotalBeforeTaxController = TextEditingController(
        text: currencyFormat.format(widget.challanProduct.totalBeforeTax));
    productGstPercentController = TextEditingController(
        text: currencyFormat.format(widget.challanProduct.gstPercent));
    productTaxAmountController = TextEditingController(
        text: currencyFormat.format(widget.challanProduct.taxAmount));
    productTotalAmountController = TextEditingController(
        text: currencyFormat.format(widget.challanProduct.totalAmount));
    _productList =
        Provider.of<ProductProvider>(context, listen: false).productList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    productNameValidator = MultiValidator([
      // KDropDownFieldValidator(errorText: "Required"),
      KDropDownFieldCheckReduncencyValidator(
          errorText: "Already Used",
          index: widget.challanProductListPos,
          checkRedundency: widget.checkRedundentLineItem!),
    ]);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.isInvoice!
              ? KTextField(
                  label: "",
                  controller: productNameController,
                  width: 250,
                  isDisabled: widget.isInvoice!,
                )
              : Column(
                  children: [
                    KDropdown(
                      dropDownList: _productList.map((e) => e.name).toList(),
                      label: "",
                      initialValue: _dropdownInitialValue,
                      width: 250,
                      onChangeDropDown: onProductChange,
                      validator: productNameValidator,
                      isShowSearchBox: false,
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                  ],
                ),
          KTextField(
            label: "",
            width: 130,
            controller: pricePerUnitController,
            validator: productName != "" ? pricePerUnitValidator : null,
            valueUpdated: _pricePerUnitValueChanged,
            isDisabled: widget.isInvoice!,
          ),
          KTextField(
            label: "",
            width: 70,
            controller: unitController,
            validator: productName != "" ? unitValidator : null,
            isDisabled: widget.isInvoice!,
            valueUpdated: _unitValueChanged,
          ),
          KTextField(
            label: "",
            width: 80,
            controller: quantityController,
            validator: productName != "" ? quantityValidator : null,
            isDisabled: widget.isInvoice!,
            valueUpdated: _quantityValueChanged,
          ),
          KTextField(
            label: "",
            width: 80,
            controller: productTotalBeforeTaxController,
            isDisabled: true,
          ),
          KTextField(
            label: "",
            width: 70,
            controller: productGstPercentController,
            validator: productName != "" ? gstPercentValidator : null,
            isDisabled: widget.isInvoice!,
            valueUpdated: _gstPercentValueChanged,
          ),
          KTextField(
            label: "",
            width: 100,
            controller: productTaxAmountController,
            isDisabled: true,
          ),
          KTextField(
            label: "",
            width: 110,
            controller: productTotalAmountController,
            isDisabled: true,
          ),
          widget.isInvoice!
              ? Container()
              : InkWell(
                  onTap: () => _deleteAction(),
                  child: Icon(
                    Icons.delete,
                    size: 16,
                    color: Colors.red,
                  ),
                ),
        ],
      ),
    );
  }

  void onProductChange(String _productName) {
    if (!widget.checkRedundentLineItem!(
        _productName, widget.challanProductListPos)) {
      productName = _productName;
      Product product = _productList
          .where((element) => element.name == _productName)
          .toList()[0];
      widget.challanProduct.productName = product.name;
      widget.challanProduct.productUnit = product.unit;
      widget.challanProduct.hsnCode = product.HSN;
      pricePerUnitController.text = currencyFormat.format(product.pricePerUnit);
      unitController.text = product.unit;
      productGstPercentController.text = product.GST;
      widget.challanProduct.gstPercent = double.parse(product.GST);
      widget.challanProduct.pricePerUnit = double.parse(
          currencyFormat.parse(pricePerUnitController.text).toString());
    }
    setState(() {});
  }

  void _pricePerUnitValueChanged(String value) {
    if (productName != "") {
      _onValuesChanged();
    } else {
      pricePerUnitController.text =
          currencyFormat.format(widget.challanProduct.pricePerUnit);
    }
  }

  void _quantityValueChanged(String value) {
    if (productName != "") {
      _onValuesChanged();
    } else {
      quantityController.text =
          currencyFormat.format(widget.challanProduct.quantity);
    }
  }

  void _unitValueChanged(String value) {
    if (productName != "") {
      _onValuesChanged();
    } else {
      quantityController.text = widget.challanProduct.productUnit;
    }
  }

  void _gstPercentValueChanged(String value) {
    if (productName != "") {
      _onValuesChanged();
    } else {
      productGstPercentController.text =
          currencyFormat.format(widget.challanProduct.gstPercent);
    }
  }

  void _onValuesChanged() {
    LogFile().logEntry("Value Changed");
    widget.challanProduct.pricePerUnit = double.parse(
        currencyFormat.parse(pricePerUnitController.text).toString());
    widget.challanProduct.productUnit = unitController.text;
    widget.challanProduct.quantity =
        double.parse(currencyFormat.parse(quantityController.text).toString());
    productTotalBeforeTaxController.text =
        currencyFormat.format(widget.challanProduct.totalBeforeTax);
    widget.challanProduct.gstPercent = double.parse(
        currencyFormat.parse(productGstPercentController.text).toString());
    productTaxAmountController.text =
        currencyFormat.format(widget.challanProduct.taxAmount);
    productTotalAmountController.text =
        currencyFormat.format(widget.challanProduct.totalAmount);
    widget.updateTotals!();
  }

  void _deleteAction() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return KConfirmationPopup(
            id: 0,
            deleteProvider: _deleteChallanProduct,
          );
        });
  }

  void _deleteChallanProduct(int id) {
    LogFile().logEntry("Line Item in Challan Product ${widget.challanProductListPos}");
    widget.deleteChallanProductFromList(widget.challanProductListPos);
  }

  @override
  void dispose() {
    pricePerUnitController.dispose();
    unitController.dispose();
    quantityController.dispose();
    productTotalBeforeTaxController.dispose();
    productTaxAmountController.dispose();
    productTotalAmountController.dispose();
    super.dispose();
  }
}
