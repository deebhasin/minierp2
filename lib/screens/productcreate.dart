import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

import '../model/product.dart';
import '../kwidgets/ktextfield.dart';
import '../kwidgets/kvariables.dart';
import '../providers/product_provider.dart';
import '../widgets/alertdialognav.dart';

class ProductCreate extends StatefulWidget {
  Product product;
  ProductCreate({Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductCreate> createState() => _ProductCreateState();
}

class _ProductCreateState extends State<ProductCreate> {
  late double containerWidth;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController idController ;
  late final nameController;
  late final unitController;
  late final pricePerUnitController;
  late final hsnController ;
  late final gstController;
  late final activeController;

  final nameValidator = MultiValidator([
    RequiredValidator(errorText: 'Company Name is required'),
    MinLengthValidator(8, errorText: 'Company Name must be at least 8 digits long'),
    // PatternValidator(r'(?=.*?[#?!@$%^&*-])', errorText: 'passwords must have at least one special character')
  ]);
  final hsnValidator = RequiredValidator(errorText: 'HSN is required');
  final gstValidator = RequiredValidator(errorText: 'GST is required');
  final activeValidator = RequiredValidator(errorText: 'Active Status is required');

  @override
  void initState() {
    String pricePerUnit = "";
    if(widget.product.price_per_unit != null){
      pricePerUnit = widget.product.price_per_unit.toString();
    }
    idController = TextEditingController(text: widget.product.id.toString());
    nameController = TextEditingController(text: widget.product.name);
    unitController = TextEditingController(text: widget.product.unit);
    pricePerUnitController = TextEditingController(text: pricePerUnit);
    hsnController = TextEditingController(text: widget.product.HSN);
    gstController = TextEditingController(text: widget.product.GST);
    activeController = TextEditingController(text: widget.product.isActive.toString());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    containerWidth = (MediaQuery
        .of(context)
        .size
        .width - KVariables.sidebarWidth);
    // if(widget.id == 0){
    //   customer = Customer(company_name: "");
    return _productCreate();
  }

  Widget _productCreate(){
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30)
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
                    "New Product",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: KTextField(label: "Product Name *", width: 250,controller: nameController, validator: nameValidator, ),
                ),
                Container(
                  child: KTextField(label: "Unit", width: 250, controller: unitController,),
                ),
                Container(
                  child: KTextField(label: "Price", width: 250, controller: pricePerUnitController,),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: KTextField(label: "HSN Code *", width: 250,controller: hsnController, validator: hsnValidator, ),
                ),
                Container(
                  child: KTextField(label: "GST Code", width: 250, controller: gstController, validator: gstValidator,),
                ),
              ],
            ),

            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: KTextField(label: "Active Status *", width: 250,controller: activeController, validator: activeValidator, ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: ElevatedButton(
                    onPressed: resetForm,
                    child: Text("Reset"),
                  ),
                ),
                Container(
                  child: ElevatedButton(
                    onPressed: submitForm,
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

  void resetForm(){
    setState(() {
      // idController.text = "";
      nameController.text = "";
      unitController.text = "";
      pricePerUnitController.text = "";
      hsnController.text = "";
      gstController.text = "";
      activeController.text = "";
    });
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      // Customer customer = Customer(

      widget.product.name = nameController.text;
      widget.product.unit = unitController.text;
      widget.product.price_per_unit = pricePerUnitController.text ==""? null : double.parse(pricePerUnitController.text);
      widget.product.HSN = hsnController.text;
      widget.product.GST = gstController.text;
      widget.product.isActive = int.parse(activeController.text);

      print("ID: ${widget.product.id}");

      if (widget.product.id != 0) {
        Provider.of<ProductProvider>(context, listen: false).updateProduct(
            widget.product);
        print("Product Updated");
      }
      else {
        Provider.of<ProductProvider>(context, listen: false).createProduct(
            widget.product);
      }
      Navigator.of(context).pop();
    }
    else {
      print("Validation Failed");
    }
  }
}
