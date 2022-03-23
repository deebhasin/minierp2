import 'package:flutter/material.dart';

import '../kwidgets/kdropdown.dart';
import '../kwidgets/ktextfield.dart';
import '../model/product.dart';
import '../model/challan_product.dart';

class ChallanProductWidget extends StatefulWidget {
  List<Product> productList;
  ChallanProduct challanProduct;
  int challanProductListPos;
  Function deleteChallanProductFromList;
  bool? isInvoice;
  ChallanProductWidget({
    Key? key,
    required this.productList,
    required this.challanProduct,
    required this.challanProductListPos,
    required this.deleteChallanProductFromList,
    this.isInvoice = false,
  }) : super(key: key);

  @override
  State<ChallanProductWidget> createState() => _ChallanProductWidgetState();
}

class _ChallanProductWidgetState extends State<ChallanProductWidget> {
  String _dropdownInitialValue = "-----";
  String productName = "";
  bool isChallan = false;

  late final productNameController;
  late final pricePerUnitController;
  late final unitController;
  late final quantityController;
  late final productTotalBeforeTaxController;
  late final productGstPercentController;
  late final productTaxAmountController;
  late final productTotalAmountController;

  @override
  void initState() {
    _dropdownInitialValue = widget.challanProduct.id != 0
        ? widget.challanProduct.productName
        : _dropdownInitialValue;
    productNameController =
        TextEditingController(text: widget.challanProduct.productName);
    pricePerUnitController = TextEditingController(
        text: widget.challanProduct.pricePerUnit.toString());
    unitController =
        TextEditingController(text: widget.challanProduct.productUnit);
    quantityController =
        TextEditingController(text: widget.challanProduct.quantity.toString());
    productTotalBeforeTaxController = TextEditingController(
        text: widget.challanProduct.totalBeforeTax.toString());
    productGstPercentController = TextEditingController(
        text: widget.challanProduct.gstPercent.toString());
    productTaxAmountController =
        TextEditingController(text: widget.challanProduct.taxAmount.toString());
    productTotalAmountController = TextEditingController(
        text: widget.challanProduct.totalAmount.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Row(
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
                ),
          KTextField(
            label: "Price Per Unit",
            isMandatory: true,
            width: 130,
            controller: pricePerUnitController,
            // validator: challanPricePerUnitValidator,
            valueUpdated: pricePerUnitValueChanged,
            isDisabled: widget.isInvoice!,
          ),
          KTextField(
            label: "Unit",
            isMandatory: true,
            width: 70,
            controller: unitController,
            isDisabled: widget.isInvoice!,
            // validator: challanUnitValidator,
          ),
          KTextField(
            label: "Quantity",
            isMandatory: true,
            width: 80,
            controller: quantityController,
            isDisabled: widget.isInvoice!,
            // validator: challanQuantityValidator,
            valueUpdated: quantityValueChanged,
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
            isDisabled: true,
          ),
          KTextField(
            label: "GST",
            width: 100,
            controller: productTaxAmountController,
            isDisabled: true,
          ),
          KTextField(
            label: "Total Anount",
            width: 100,
            controller: productTotalAmountController,
            isDisabled: true,
          ),
          Row(
            children: [
              isChallan
                  ? Icon(
                      Icons.edit_off,
                      size: 16,
                      color: Colors.grey,
                    )
                  : InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return _editAction(widget.challanProduct.id) !=
                                      null
                                  ? _editAction(widget.challanProduct.id)
                                  : Container();
                            });
                      },
                      child: Icon(
                        Icons.edit,
                        size: 16,
                        color: Colors.green,
                      ),
                    ),
              const SizedBox(
                width: 8,
              ),
              InkWell(
                onTap: () => _deleteAction(),
                child: Icon(
                  Icons.delete,
                  size: 16,
                  color: Colors.red,
                ),
              ),
              // Text(widget.challanProductListPos.toString()),
            ],
          ),
        ],
      ),
    );
  }

  void onProductChange(String productName) {
    this.productName = productName;
    Product product = widget.productList
        .where((element) => element.name == productName)
        .toList()[0];
    widget.challanProduct.productName = product.name;
    widget.challanProduct.productUnit = product.unit;
    pricePerUnitController.text = product.price_per_unit.toString();
    unitController.text = product.unit;
    productGstPercentController.text = product.GST;
    widget.challanProduct.gstPercent = double.parse(product.GST);
    widget.challanProduct.pricePerUnit =
        double.parse(pricePerUnitController.text);
    quantityController.text = "0.0";
    productTotalBeforeTaxController.text = "0.0";
    productTaxAmountController.text = "0.0";
    productTotalAmountController.text = "0.0";
  }

  void pricePerUnitValueChanged(String value) {
    if (productName != "") {
      widget.challanProduct.pricePerUnit =
          double.parse(pricePerUnitController.text);
      productTotalBeforeTaxController.text =
          widget.challanProduct.totalBeforeTax.toString();
      productTaxAmountController.text =
          widget.challanProduct.taxAmount.toString();
      productTotalAmountController.text =
          widget.challanProduct.totalAmount.toString();
    } else {
      pricePerUnitController.text =
          widget.challanProduct.pricePerUnit.toString();
    }
  }

  void quantityValueChanged(String value) {
    if (productName != "") {
      widget.challanProduct.quantity = double.parse(quantityController.text);
      productTotalBeforeTaxController.text =
          widget.challanProduct.totalBeforeTax.toString();
      productTaxAmountController.text =
          widget.challanProduct.taxAmount.toString();
      productTotalAmountController.text =
          widget.challanProduct.totalAmount.toString();
    } else {
      quantityController.text = widget.challanProduct.quantity;
    }
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
