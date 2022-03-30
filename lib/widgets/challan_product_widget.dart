import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';

import '../kwidgets/kdropdown.dart';
import '../kwidgets/ktextfield.dart';
import '../kwidgets/kvalidator.dart';
import '../model/product.dart';
import '../model/challan_product.dart';

class ChallanProductWidget extends StatefulWidget {
  List<Product> productList;
  ChallanProduct challanProduct;
  int challanProductListPos;
  Function deleteChallanProductFromList;
  Function? checkRedundentLineItem;
  bool? isInvoice;
  Function? updateTotals;
  ChallanProductWidget({
    Key? key,
    required this.productList,
    required this.challanProduct,
    required this.challanProductListPos,
    required this.deleteChallanProductFromList,
    this.isInvoice = false,
    this.checkRedundentLineItem,
    this.updateTotals,
  }): super(key: key){
    print("Challan Product Position: ${challanProduct.productName} : $challanProductListPos");
  }

  @override
  State<ChallanProductWidget> createState() => _ChallanProductWidgetState();
}

class _ChallanProductWidgetState extends State<ChallanProductWidget> {
  String _dropdownInitialValue = "-----";
  String productName = "";
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
    quantityController =
        TextEditingController(text: currencyFormat.format(widget.challanProduct.quantity));
    productTotalBeforeTaxController = TextEditingController(
        text: currencyFormat.format(widget.challanProduct.totalBeforeTax));
    productGstPercentController = TextEditingController(
        text: currencyFormat.format(widget.challanProduct.gstPercent));
    productTaxAmountController =
        TextEditingController(text: currencyFormat.format(widget.challanProduct.taxAmount));
    productTotalAmountController = TextEditingController(
        text: currencyFormat.format(widget.challanProduct.totalAmount));


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    productNameValidator = MultiValidator([
      // KDropDownFieldValidator(errorText: "Required"),
      KDropDownFieldCheckReduncencyValidator(errorText: "Already Used",index: widget.challanProductListPos, checkRedundency: widget.checkRedundentLineItem!),
    ]);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        widget.isInvoice!
            ? KTextField(
                label: "Product",
                controller: productNameController,
                width: 250,
                isDisabled: widget.isInvoice!,
              )
            : KDropdown(
                dropDownList: widget.productList.map((e) => e.name).toList(),
                label: "Product",
                initialValue: _dropdownInitialValue,
                width: 250,
                onChangeDropDown: onProductChange,
                // validator: productName != ""? productNameValidator : null,
                validator: productNameValidator,
                isMandatory: true,
              ),
        KTextField(
          label: "Price Per Unit",
          isMandatory: true,
          width: 130,
          controller: pricePerUnitController,
          validator: productName != "" ? pricePerUnitValidator : null,
          valueUpdated: _pricePerUnitValueChanged,
          isDisabled: widget.isInvoice!,
        ),
        KTextField(
          label: "Unit",
          isMandatory: true,
          width: 70,
          controller: unitController,
          validator: productName != "" ? unitValidator : null,
          isDisabled: widget.isInvoice!,
          valueUpdated: _unitValueChanged,
        ),
        KTextField(
          label: "Quantity",
          isMandatory: true,
          width: 80,
          controller: quantityController,
          validator: productName != "" ? quantityValidator : null,
          isDisabled: widget.isInvoice!,
          valueUpdated: _quantityValueChanged,
        ),
        KTextField(
          label: "Total",
          width: 80,
          controller: productTotalBeforeTaxController,
          isDisabled: true,
        ),
        KTextField(
          label: "GST %",
          width: 70,
          controller: productGstPercentController,
          validator: productName != "" ? gstPercentValidator : null,
          isDisabled: widget.isInvoice!,
          valueUpdated: _gstPercentValueChanged,
        ),
        KTextField(
          label: "GST",
          width: 100,
          controller: productTaxAmountController,
          isDisabled: true,
        ),
        KTextField(
          label: "Total Amount",
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
    );
  }

  void onProductChange(String _productName) {
    if(!widget.checkRedundentLineItem!(_productName, widget.challanProductListPos)){
      productName = _productName;
      Product product = widget.productList
          .where((element) => element.name == _productName)
          .toList()[0];
      widget.challanProduct.productName = product.name;
      widget.challanProduct.productUnit = product.unit;
      pricePerUnitController.text = currencyFormat.format(product.pricePerUnit);
      unitController.text = product.unit;
      quantityController.text = currencyFormat.format(0);
      productGstPercentController.text = product.GST;
      widget.challanProduct.gstPercent = double.parse(product.GST);
      widget.challanProduct.pricePerUnit =
          double.parse(currencyFormat.parse(pricePerUnitController.text).toString());
      quantityController.text = currencyFormat.format(0);
      productTotalBeforeTaxController.text = currencyFormat.format(0);
      productTaxAmountController.text = currencyFormat.format(0);
      productTotalAmountController.text = currencyFormat.format(0);

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
      quantityController.text = currencyFormat.format(widget.challanProduct.quantity);
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
    print("Value Changed");
    widget.challanProduct.pricePerUnit =
        double.parse(currencyFormat.parse(pricePerUnitController.text).toString());
    widget.challanProduct.productUnit = unitController.text;
    widget.challanProduct.quantity = double.parse(currencyFormat.parse(quantityController.text).toString());
    productTotalBeforeTaxController.text =
        currencyFormat.format(widget.challanProduct.totalBeforeTax);
    widget.challanProduct.gstPercent =
        double.parse(currencyFormat.parse(productGstPercentController.text).toString());
    productTaxAmountController.text =
        currencyFormat.format(widget.challanProduct.taxAmount);
    productTotalAmountController.text =
        currencyFormat.format(widget.challanProduct.totalAmount);
    widget.updateTotals!();
  }

  void _deleteAction() {
    // print("Challan Product Widget _deleteAction Id: $id");

    // Provider.of<ChallanProvider>(context, listen: false).deleteChallan(id);
    print("Line Item in Challan Product ${widget.challanProductListPos}");
    widget.deleteChallanProductFromList(widget.challanProductListPos);
  }

  Widget _editAction(int id) {
    print("Challan Product Widget _editAction Id: $id");
    return Container();
    // Challan challan;
    // return Consumer<ChallanProvider>(builder: (ctx, provider, child) {
    //   return FutureBuilder(
    //     future: provider.getChallanById(id),
    //     builder: (context, AsyncSnapshot<Challan> snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return CircularProgressIndicator();
    //       } else {
    //         if (snapshot.hasError) {
    //           //                  if (snapshot.error is ConnectivityError) {
    //           //                    return NoConnectionScreen();
    //           //                  }
    //           return Center(child: Text("An error occured.\n$snapshot"));
    //           // return noData(context);
    //         } else if (snapshot.hasData) {
    //           challan = snapshot.data!;
    //           // customer.forEach((row) => print(row));
    //           // return displayCustomer(context);
    //           return ChallanCreate(challan: challan,);
    //         } else
    //           return Container();
    //       }
    //     },
    //   );
    // });
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
