import 'package:erpapp/kwidgets/kchallanbutton.dart';
import 'package:erpapp/kwidgets/ktextfield.dart';
import 'package:erpapp/model/challan.dart';
import 'package:erpapp/model/customer.dart';
import 'package:erpapp/model/product.dart';
import 'package:erpapp/providers/challan_provider.dart';
import 'package:erpapp/providers/customer_provider.dart';
import 'package:erpapp/providers/product_provider.dart';
import 'package:erpapp/widgets/alertdialognav.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../kwidgets/kvariables.dart';
import '../kwidgets/kdropdown.dart';

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

  late KDropdown customerDropdown;
  late KDropdown productDropdown;
  late final challanNumberController;
  late final challanDateController;
  late final challanPricePerUnitController;
  late final challanUnitController;
  late final challanQuantityController;
  late final challanAmountController;


  String challanNewOrEdit = "New Challan";

  String customerName = "-----";
  String productName = "-----";
  late double containerWidth;
  late List<Customer> customerListFetched;
  late List<Product> productListFetched;
  List<String> customerList = [];
  List<String> productList = [];

  final challanNumberValidator = RequiredValidator(errorText: 'Challan Number is required');
  final challanDateValidator = RequiredValidator(errorText: 'Challan Date is required');
  final challanPricePerUnitValidator = MultiValidator([
    RequiredValidator(errorText: 'Price Per Unit is required'),
    PatternValidator(r'\d+?$', errorText: "Price Per Unit should be number"),
  ]);
  final challanUnitValidator = RequiredValidator(errorText: 'Item Unit is required');
  final challanQuantityValidator = MultiValidator([
    RequiredValidator(errorText: 'Quantity is required'),
    PatternValidator(r'\d+?$', errorText: "Quantity should be number"),
  ]);


  @override
  void initState() {
    _buildForm();
    _getdropdownList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    containerWidth = (MediaQuery.of(context).size.width - KVariables.sidebarWidth);

    print("CHallan create bui;d ca;;ed");
    return _challanCreate();
  }

  Widget _challanCreate(){
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
                color: Color.fromRGBO(242,243,247,1),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30), bottomLeft: Radius.zero, bottomRight: Radius.zero),
              ),
              width:  containerWidth,
              child: AlertDialogNav(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    challanNewOrEdit,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: KDropdown(dropDownList: customerList, label: "Customer", initialValue: customerName, width: 250, onChangeDropDown: _onCompanyChange,),
                ),
                Container(
                  child: KTextField(label: "Challan # *", width: 250,controller: challanNumberController, validator: challanNumberValidator, ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: KDropdown(dropDownList: productList, label: "Product", initialValue: productName, width: 250, onChangeDropDown: _onProductyChange,),
                ),
                Container(
                  child: KTextField(label: "Challan Date *", width: 250,controller: challanDateController, validator: challanDateValidator,),
                ),
              ],
            ),
            const SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: KTextField(label: "Price Per Unit *", width: 250,controller: challanPricePerUnitController, validator: challanPricePerUnitValidator, valueUpdated: valueUpdated,),
                ),
                Container(
                  child: KTextField(label: "Unit *", width: 250,controller: challanUnitController, validator: challanUnitValidator),
                ),
                Container(
                  child: KTextField(label: "Quantity *", width: 250,controller: challanQuantityController, validator: challanQuantityValidator, valueUpdated: valueUpdated,),
                ),
                Container(
                  child: KTextField(label: "Total Amount", width: 250,controller: challanAmountController, isDisabled: true, ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: ElevatedButton(
                    onPressed: _resetForm,
                    child: Text("Reset"),
                  ),
                ),
                Container(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: Text("Submit"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _getdropdownList() async{
    CustomerProvider customerProvider = CustomerProvider();
    ProductProvider productProvider = ProductProvider();
    customerListFetched = await customerProvider.getCustomerList();

    for(int i=0; i < customerListFetched.length;i++){
      customerList.add(customerListFetched[i].company_name);
    };
    productListFetched = await productProvider.getProductList();
    for(int i=0; i < productListFetched.length;i++){
      productList.add(productListFetched[i].name);
    };
  }

  void valueUpdated(){
    print("Value Updated");
    challanAmountController.text =
        (double.parse(challanPricePerUnitController.text) *
        double.parse(challanQuantityController.text)).toString();
  }
  onChangeDropdown(String value){
    List<String> val = value.split(":");
    if(val[0] == "Customer"){
      customerName = val[1];
    }
    else if(val[0] == "Product"){
      productName = val[1];
      print("New List Begins");
      // List newlist = productListFetched.where((item) => item.name == val[1]).toList();
      final product = productListFetched.singleWhere((element) => element.name == val[1]);
      // print("Price: ${price.price_per_unit}");
      challanPricePerUnitController.text = product.price_per_unit.toString();
      challanUnitController.text = product.unit;
    }

    print("${val[0]}: ${val[1]}");
  }

  void _onCompanyChange(String companyName){
    setState(() {
      this.customerName = companyName;
    });
  }

  void _onProductyChange(String productName){
    setState(() {
      this.productName = productName;
      final product = productListFetched.singleWhere((element) => element.name == productName);
      // print("Price: ${price.price_per_unit}");
      challanPricePerUnitController.text = product.price_per_unit.toString();
      challanUnitController.text = product.unit;
    });
  }

  void _buildForm(){
    if(widget.challan.id != 0) {
      challanNewOrEdit = "Edit Challan";
      customerName = widget.challan.customerName;
      productName =widget.challan.productName;
    }
    // customerDropdown = KDropdown(dropDownList: customerList, label: "Customer", initialValue: customerName, width: 250,);
    // productDropdown = KDropdown(dropDownList: productList, label: "Product", initialValue: productName, width: 250,);
    challanNumberController = TextEditingController(text:widget.challan.challanNo);
    challanDateController = TextEditingController(text:DateFormat("d-M-y").format(widget.challan.challanDate!));
    challanPricePerUnitController = TextEditingController(text: widget.challan.pricePerUnit.toString());
    challanUnitController = TextEditingController(text: widget.challan.productUnit);
    challanQuantityController = TextEditingController(text: widget.challan.quantity.toString());
    challanAmountController = TextEditingController(text: widget.challan.totalAmount.toString());
  }
  void _resetForm(){
    setState(() {
      print("Reset Start");
      customerName = "-----";
      productName = "-----";
      // customerDropdown.initialValueChanged(widget.challan.customerName);
      challanNumberController.text = widget.challan.challanNo;
      challanDateController.text = DateFormat("d-M-y").format(widget.challan.challanDate!);
      challanPricePerUnitController.text = widget.challan.pricePerUnit.toString();
      challanUnitController.text = widget.challan.productUnit;
      challanQuantityController.text = widget.challan.quantity.toString();
      challanAmountController.text = widget.challan.totalAmount.toString();
      print("Reset End");
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {

      // widget.challan.customerName = customerDropdown.getSelectedValue() == ""? widget.challan.customerName : customerDropdown.getSelectedValue();
      // widget.challan.productName = productDropdown.getSelectedValue() == ""? widget.challan.productName : productDropdown.getSelectedValue();
      widget.challan.customerName = customerName;
      widget.challan.productName = productName;
      widget.challan.challanNo = challanNumberController.text;
      widget.challan.challanDate = DateFormat("d-M-y").parse(challanDateController.text);
      widget.challan.pricePerUnit = double.parse(challanPricePerUnitController.text);
      widget.challan.productUnit = challanUnitController.text;
      widget.challan.quantity = double.parse(challanQuantityController.text);
      widget.challan.totalAmount = double.parse(challanAmountController.text);

      print("Customer Name: ${widget.challan.customerName}");

      if (widget.challan.id != 0) {
        Provider.of<ChallanProvider>(context, listen: false).updateChallan(
            widget.challan);
        print("Product Updated");
      }
      else {
        Provider.of<ChallanProvider>(context, listen: false).createChallan(
            widget.challan);
      }
      Navigator.of(context).pop();
    }
    else {
      print("Validation Failed");
    }

    @override
    void dispose(){
      challanNumberController.dispose();
      challanDateController.dispose();
      challanPricePerUnitController.dispose();
      challanQuantityController.dispose();
      challanAmountController.dispose();
    }
  }

}
