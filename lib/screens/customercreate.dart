import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

import '../kwidgets/kvariables.dart';
import '../model/customer.dart';
import '../providers/customer_provider.dart';
import '../kwidgets/dtextfield.dart';
import '../kwidgets/ksubmitresetbuttons.dart';
import '../utils/logfile.dart';
import '../widgets/alertdialognav.dart';

class CustomerCreate extends StatefulWidget {
  late final Customer customer;

  CustomerCreate({
    Key? key,
    required this.customer,
  }) : super(key: key);

  @override
  State<CustomerCreate> createState() => _CustomerCreateState();
}

class _CustomerCreateState extends State<CustomerCreate> {
  late double containerWidth;
  double containerHeight = 200;
  final _formKey = GlobalKey<FormState>();
  late final customerIdController;
  late final companyController;
  late final contactPersonController;
  late final shortCompanyNameController;
  late final contactPhoneController;
  late final addressController;
  late final pinController;
  late final cityController;
  late final stateController;
  late final stateCodeController;
  late final gstController;
  late final creditPeriodController;
  final companyNameValidator = MultiValidator([
    RequiredValidator(errorText: 'Company Name is required'),
    MinLengthValidator(4,
        errorText: 'Company Name must be at least 4 digits long'),
  ]);
  final shortCompanyNameValidator =
      MaxLengthValidator(10, errorText: "Required Less than 10 charcters");
  final pinValidator =
      PatternValidator(r'\d+?$', errorText: "PIN should be number");
  final gstValidator =
      RequiredValidator(errorText: 'Customers GST number is required');
  final addressValidator = RequiredValidator(errorText: 'Address is required');
  final stateCdValidator =
      RequiredValidator(errorText: 'State code is required');
  final creditPeriodValidator = MultiValidator([
    RequiredValidator(errorText: 'Credit Period is required'),
    PatternValidator(r'\d+?$', errorText: "Credit Period should be number"),
  ]);

  @override
  void initState() {
    super.initState();
    customerIdController = TextEditingController();
    companyController = TextEditingController();
    shortCompanyNameController = TextEditingController();
    contactPersonController = TextEditingController();
    contactPhoneController = TextEditingController();
    addressController = TextEditingController();
    pinController = TextEditingController();
    cityController = TextEditingController();
    stateController = TextEditingController();
    stateCodeController = TextEditingController();
    gstController = TextEditingController();
    creditPeriodController = TextEditingController();
    _initializeForm();
  }

  _initializeForm() {
    customerIdController.text = widget.customer.id.toString();
    companyController.text = widget.customer.company_name;
    shortCompanyNameController.text =
        widget.customer.company_name == widget.customer.shortCompanyName
            ? ""
            : widget.customer.shortCompanyName;
    contactPersonController.text = widget.customer.contact_person;
    contactPhoneController.text = widget.customer.contact_phone;
    addressController.text = widget.customer.address;
    pinController.text =
        widget.customer.pin == 0 ? "" : widget.customer.pin.toString();
    cityController.text = widget.customer.city;
    stateController.text = widget.customer.state;
    stateCodeController.text = widget.customer.stateCode;
    gstController.text = widget.customer.gst;
    creditPeriodController.text = widget.customer.creditPeriod.toString();
  }

  @override
  Widget build(BuildContext context) {
    containerWidth =
        (MediaQuery.of(context).size.width - KVariables.sidebarWidth);
    return _createCustomer();
  }

  Widget _createCustomer() {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      // backgroundColor: Color.fromRGBO(242,243,247,1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Color.fromRGBO(242, 243, 247, 1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.zero,
                  bottomRight: Radius.zero),
            ),
            width: containerWidth,
            // height: containerHeight,
            child: AlertDialogNav(),
          ),
          Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
              // color: Colors.yellow,
              child: Column(
                children: [
                  Text(
                    widget.customer.id == 0 ? "New Customer" : "Edit Customer",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DTextField(
                                label: "Company name",
                                isMandatory: true,
                                controller: companyController,
                                validator: companyNameValidator,
                              ),
                              DTextField(
                                label: "Address",
                                controller: addressController,
                                validator: addressValidator,
                                isMandatory: true,
                                multiLine: 5,
                              ),
                              DTextField(
                                label: "City",
                                controller: cityController,
                              ),
                              DTextField(
                                label: "State",
                                controller: stateController,
                              ),
                              DTextField(
                                label: "PIN",
                                maxLength: 6,
                                controller: pinController,
                                validator: pinValidator,
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DTextField(
                                label: "Short Company Name",
                                controller: shortCompanyNameController,
                                validator: shortCompanyNameValidator,
                              ),
                              DTextField(
                                label: "Contact Person",
                                controller: contactPersonController,
                              ),
                              DTextField(
                                label: "Contact Phone",
                                controller: contactPhoneController,
                              ),
                              DTextField(
                                label: "Credit Period",
                                controller: creditPeriodController,
                                validator: creditPeriodValidator,
                                maxLength: 3,
                              ),
                              DTextField(
                                label: "State Code",
                                controller: stateCodeController,
                                validator: stateCdValidator,
                                maxLength: 5,
                                isMandatory: true,
                              ),
                              DTextField(
                                label: "GST Number",
                                maxLength: 15,
                                controller: gstController,
                                validator: gstValidator,
                                isMandatory: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  KSubmitResetButtons(
                    resetForm: _resetForm,
                    submitForm: _submitForm,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    _initializeForm();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.customer.company_name = companyController.text;
      widget.customer.shortCompanyName = shortCompanyNameController.text != ""
          ? shortCompanyNameController.text
          : companyController.text;
      widget.customer.contact_person = contactPersonController.text;
      widget.customer.contact_phone = contactPhoneController.text;
      widget.customer.address = addressController.text;
      widget.customer.pin =
          int.parse(pinController.text == "" ? "0" : pinController.text);
      widget.customer.city = cityController.text;
      widget.customer.state = stateController.text;
      widget.customer.stateCode = stateCodeController.text;
      widget.customer.gst = gstController.text;
      widget.customer.creditPeriod =
          int.parse(creditPeriodController.text ?? "0");

      LogFile().logEntry("ID: ${widget.customer.id}");
      Provider.of<CustomerProvider>(context, listen: false)
          .saveCustomer(widget.customer);
      Navigator.of(context).pop();
    } else {
      LogFile().logEntry("Validation Failed");
    }
  }

  @override
  void dispose() {
    customerIdController.dispose();
    contactPersonController.dispose();
    pinController.dispose();
    addressController.dispose();
    stateCodeController.dispose();
    stateController.dispose();
    gstController.dispose();
    creditPeriodController.dispose();
    super.dispose();
  }
}
