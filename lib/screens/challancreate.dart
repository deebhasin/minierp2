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
  late final challanQuantityController;
  late final challanAmountController;

  String challanNewOrEdit = "New Challan";

  String customerName = "-----";
  String productName = "-----";
  late double containerWidth;
  List<String> customerList = [];
  List<String> productList = [];

  final challanNumberValidator = RequiredValidator(errorText: 'Company Name is required');
  final challanDateValidator = RequiredValidator(errorText: 'Company Name is required');
  final challanPricePerUnitValidator = MultiValidator([
    RequiredValidator(errorText: 'Credit Period is required'),
    PatternValidator(r'\d+?$', errorText: "Credit Period should be number"),
  ]);
  final challanQuantityValidator = MultiValidator([
    RequiredValidator(errorText: 'Credit Period is required'),
    PatternValidator(r'\d+?$', errorText: "Credit Period should be number"),
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


    return _challanCreate();
  }

  Widget _challanCreate(){
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
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
                  child: customerDropdown,
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
                  child: productDropdown,
                ),
                Container(
                  child: KTextField(label: "Challan Date *", width: 250,controller: challanDateController, validator: challanDateValidator, ),
                ),
              ],
            ),
            const SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: KTextField(label: "Price Per Unit *", width: 250,controller: challanPricePerUnitController, validator: challanPricePerUnitValidator, ),
                ),
                Container(
                  child: KTextField(label: "Quantity *", width: 250,controller: challanQuantityController, validator: challanQuantityValidator, ),
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
    List<Customer> customerListFetched = await customerProvider.getCustomerList();

    for(int i=0; i < customerListFetched.length;i++){
      customerList.add(customerListFetched[i].company_name);
    };
    List<Product> productListFetched = await productProvider.getProductList();
    for(int i=0; i < productListFetched.length;i++){
      productList.add(productListFetched[i].name);
    };
  }

  void _buildForm(){
    if(widget.challan.id != 0) {
      challanNewOrEdit = "Edit Challan";
      customerName = widget.challan.customerName;
      productName =widget.challan.productName;
    }
    customerDropdown = KDropdown(dropDownList: customerList, label: "Customer", initialValue: customerName, width: 250,);
    productDropdown = KDropdown(dropDownList: productList, label: "Product", initialValue: productName, width: 250,);
    challanNumberController = TextEditingController(text:widget.challan.challanNo);
    challanDateController = TextEditingController(text:DateFormat("d-M-y").format(widget.challan.challanDate!));
    challanPricePerUnitController = TextEditingController(text: widget.challan.pricePerUnit.toString());
    challanQuantityController = TextEditingController(text: widget.challan.quantity.toString());
    challanAmountController = TextEditingController(text: widget.challan.totalAmount.toString());

  }
  void _resetForm(){
    setState(() {
      print("Reset Start");
      customerName = "-----";
      productName = "-----";
      challanNumberController.text = widget.challan.challanNo;
      challanDateController.text = DateFormat("d-M-y").format(widget.challan.challanDate!);
      challanPricePerUnitController.text = widget.challan.pricePerUnit.toString();
      challanQuantityController.text = widget.challan.quantity.toString();
      challanAmountController.text = widget.challan.totalAmount.toString();
      print("Reset End");
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {

      widget.challan.customerName = customerDropdown.getSelectedValue() == ""? widget.challan.customerName : customerDropdown.getSelectedValue();
      widget.challan.productName = productDropdown.getSelectedValue() == ""? widget.challan.productName : productDropdown.getSelectedValue();
      widget.challan.challanNo = challanNumberController.text;
      widget.challan.challanDate = DateTime.parse(challanDateController.text);
      widget.challan.pricePerUnit = double.parse(challanPricePerUnitController.text);
      widget.challan.quantity = double.parse(challanQuantityController.text);
      widget.challan.totalAmount = widget.challan.pricePerUnit * widget.challan.quantity;

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
  }

}
