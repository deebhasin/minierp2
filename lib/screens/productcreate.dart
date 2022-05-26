import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

import '../model/product.dart';
import '../kwidgets/ktextfield.dart';
import '../kwidgets/kvariables.dart';
import '../providers/product_provider.dart';
import '../utils/logfile.dart';
import '../widgets/alertdialognav.dart';
import '../kwidgets/kdropdown.dart';
import '../kwidgets/ksubmitresetbuttons.dart';
import '../kwidgets/kvalidator.dart';

class ProductCreate extends StatefulWidget {
  Product product;
  ProductCreate({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductCreate> createState() => _ProductCreateState();
}

class _ProductCreateState extends State<ProductCreate> {
  late double containerWidth;
  final _formKey = GlobalKey<FormState>();
  late final _nameController;
  late final _unitController;
  late final _pricePerUnitController;
  late final _hsnController;
  late final _gstController;
  late final _activeController;

  late bool _isActiveInitialValue;
  List<Product> _productList = [];

  List<String> _statusList = ["true", "false"];

  late final _nameValidator;
  final _hsnValidator = RequiredValidator(errorText: 'HSN is required');
  final _pricePerUnitValidator =
      PatternValidator(r'\d+?$', errorText: "This should be number");
  final _gstValidator = MultiValidator([
    RequiredValidator(errorText: 'GST is required'),
    PatternValidator(r'\d+?$', errorText: "This should be number"),
  ]);
  final _activeValidator =
      RequiredValidator(errorText: 'Active Status is required');

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.product.name);
    _unitController = TextEditingController(text: widget.product.unit);
    _pricePerUnitController = TextEditingController(
        text: widget.product.pricePerUnit == 0
            ? ""
            : widget.product.pricePerUnit.toString());
    _hsnController = TextEditingController(text: widget.product.HSN);
    _gstController = TextEditingController(text: widget.product.GST);
    _activeController =
        TextEditingController(text: widget.product.isActive.toString());
    _isActiveInitialValue = widget.product.isActive;
    _getProductsList();
    _nameValidator = MultiValidator([
      RequiredValidator(errorText: 'Company Name is required'),
      MinLengthValidator(8, errorText: 'Must be at least 8 digits long'),
      KCheckProductNameValidator(
          errorText: "Product Name Aready Exists",
          productList: _productList,
          isEdit: widget.product.id != 0 ? true : false),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    containerWidth =
        (MediaQuery.of(context).size.width - KVariables.sidebarWidth);
    return _productCreate();
  }

  Widget _productCreate() {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
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
                    widget.product.id == 0 ? "New Product" : "Edit Product",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KTextField(
                      label: "Product Name",
                      isMandatory: true,
                      width: 250,
                      controller: _nameController,
                      validator: _nameValidator,
                    ),
                    KTextField(
                      label: "HSN Code",
                      isMandatory: true,
                      width: 250,
                      controller: _hsnController,
                      validator: _hsnValidator,
                    ),
                    KTextField(
                      label: "GST (%)",
                      isMandatory: true,
                      width: 250,
                      controller: _gstController,
                      validator: _gstValidator,
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KTextField(
                      label: "Unit",
                      width: 250,
                      controller: _unitController,
                    ),
                    KTextField(
                      label: "Price",
                      width: 250,
                      controller: _pricePerUnitController,
                      validator: _pricePerUnitValidator,
                    ),
                    KDropdown(
                      dropDownList: _statusList,
                      label: "Active",
                      initialValue: _isActiveInitialValue == true
                          ? _statusList[0]
                          : _statusList[1],
                      isShowSearchBox: false,
                      maxHeight: 100,
                      onChangeDropDown: _onActiveChanged,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            KSubmitResetButtons(
              resetForm: _resetForm,
              submitForm: _submitForm,
            ),
          ],
        ),
      ),
    );
  }

  void _getProductsList() async {
    _productList = await Provider.of<ProductProvider>(context, listen: false)
        .getProductList();
    LogFile().logEntry("Product List Length in getProuductList: ${_productList.length}");
  }

  void _onActiveChanged(String status) {
    _isActiveInitialValue = status == "true" ? true : false;
    LogFile().logEntry("_onActiveChanged: $_isActiveInitialValue");
  }

  void _resetForm() {
    setState(() {
      // idController.text = "";
      _nameController.text = widget.product.name;
      _unitController.text = widget.product.unit;
      _pricePerUnitController.text = widget.product.pricePerUnit == 0
          ? ""
          : widget.product.pricePerUnit.toString();
      _hsnController.text = widget.product.HSN;
      _gstController.text = widget.product.GST;
      _isActiveInitialValue = widget.product.isActive;
      LogFile().logEntry("Is Active in Product Reset: $_isActiveInitialValue");
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.product.name = _nameController.text;
      widget.product.unit = _unitController.text;
      widget.product.pricePerUnit = _pricePerUnitController.text == ""
          ? 0
          : double.parse(_pricePerUnitController.text);
      widget.product.HSN = _hsnController.text;
      widget.product.GST = _gstController.text;
      widget.product.isActive = _isActiveInitialValue;

      LogFile().logEntry("ID: ${widget.product.id}");

      Provider.of<ProductProvider>(context, listen: false)
          .saveProduct(widget.product);

      Navigator.of(context).pop();
    } else {
      LogFile().logEntry("Product Validation Failed");
    }
  }
}
