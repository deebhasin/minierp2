import 'package:desktop_window/desktop_window.dart';
import 'package:erpapp/kwidgets/ktextfield.dart';
import 'package:erpapp/model/organization.dart';
import 'package:erpapp/providers/org_provider.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

class OrganizationCreate extends StatefulWidget {
  final Organization org;
  final Function reFresh;
  OrganizationCreate({
    Key? key,
    required this.org,
    required this.reFresh,
  }) : super(key: key);

  @override
  State<OrganizationCreate> createState() => _OrganizationCreateState();
}

class _OrganizationCreateState extends State<OrganizationCreate> {
  final _formKey = GlobalKey<FormState>();

  late double width;
  late double height;

  late TextEditingController _nameController;
  late TextEditingController _tagLineController;
  late TextEditingController _contactPersonController;
  late TextEditingController _gstController;
  late TextEditingController _panController;
  late TextEditingController _phoneController;
  late TextEditingController _mobileController;

  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _pinController;

  late TextEditingController _bankAccountNameController;
  late TextEditingController _bankAccountNoController;
  late TextEditingController _bankNameController;
  late TextEditingController _bankIfscCodeController;
  late TextEditingController _bankBranchController;
  late TextEditingController _logoController;

  late TextEditingController _termsAndConditionsController;

  late final FieldValidator _requiredValidator;
  late final FieldValidator _pinValidator;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.org.name);
    _tagLineController = TextEditingController(text: widget.org.tagLine);
    _contactPersonController =
        TextEditingController(text: widget.org.contactPerson);
    _gstController = TextEditingController(text: widget.org.gst);
    _panController = TextEditingController(text: widget.org.pan);
    _phoneController = TextEditingController(text: widget.org.phone);
    _mobileController = TextEditingController(text: widget.org.mobile);

    _addressController = TextEditingController(text: widget.org.address);
    _cityController = TextEditingController(text: widget.org.city);
    _stateController = TextEditingController(text: widget.org.state);
    _pinController = TextEditingController(
        text: widget.org.pin == 0 ? "" : widget.org.pin.toString());

    _bankAccountNameController =
        TextEditingController(text: widget.org.bankAccountName);
    _bankAccountNoController =
        TextEditingController(text: widget.org.bankAccountNumber);
    _bankNameController = TextEditingController(text: widget.org.bankName);
    _bankIfscCodeController =
        TextEditingController(text: widget.org.bankIfscCode);
    _bankBranchController = TextEditingController(text: widget.org.bankBranch);
    _logoController = TextEditingController(text: widget.org.logo);

    _termsAndConditionsController =
        TextEditingController(text: widget.org.termsAndConditions);

    _requiredValidator = RequiredValidator(errorText: 'Field required');
    _pinValidator = MultiValidator([
      RequiredValidator(errorText: 'Field required'),
      PatternValidator(r'\d+?$', errorText: "PIN should be number"),
    ]);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _tagLineController.dispose();
    _contactPersonController.dispose();
    _gstController.dispose();
    _panController.dispose();
    _phoneController.dispose();
    _mobileController.dispose();

    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pinController.dispose();

    _bankAccountNameController.dispose();
    _bankAccountNoController.dispose();
    _bankNameController.dispose();
    _bankIfscCodeController.dispose();
    _bankBranchController.dispose();
    _logoController.dispose();

    _termsAndConditionsController.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    _setDesktopFullScreen();
    return Form(
      key: _formKey,
      child: Container(
        width: width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Create Organization",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      KTextField(
                        label: "Company Name",
                        controller: _nameController,
                        width: 250,
                        isMandatory: true,
                        validator: _requiredValidator,
                      ), KTextField(
                        label: "Tag Line",
                        controller: _tagLineController,
                        width: 400,
                      ),
                      KTextField(
                        label: "Contact Person",
                        controller: _contactPersonController,
                        width: 250,
                      ),
                      KTextField(
                        label: "GST #",
                        controller: _gstController,
                        width: 250,
                        isMandatory: true,
                        validator: _requiredValidator,
                      ),
                      KTextField(
                        label: "PAN",
                        controller: _panController,
                        width: 250,
                      ),
                      KTextField(
                        label: "Phone",
                        controller: _phoneController,
                        width: 250,
                        isMandatory: true,
                        validator: _requiredValidator,
                      ),
                      KTextField(
                        label: "Mobile",
                        controller: _mobileController,
                        width: 250,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      KTextField(
                        label: "Address",
                        controller: _addressController,
                        multiLine: 5,
                        width: 250,
                        isMandatory: true,
                        validator: _requiredValidator,
                      ),
                      KTextField(
                        label: "City",
                        controller: _cityController,
                        width: 250,
                        isMandatory: true,
                        validator: _requiredValidator,
                      ),
                      KTextField(
                        label: "State",
                        controller: _stateController,
                        width: 250,
                        isMandatory: true,
                        validator: _requiredValidator,
                      ),
                      KTextField(
                        label: "Pin",
                        controller: _pinController,
                        width: 250,
                        isMandatory: true,
                        validator: _pinValidator,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      KTextField(
                        label: "Bank Accout Name",
                        controller: _bankAccountNameController,
                        width: 250,
                        isMandatory: true,
                        validator: _requiredValidator,
                      ),
                      KTextField(
                        label: "Bank Account No.",
                        controller: _bankAccountNoController,
                        width: 250,
                        isMandatory: true,
                        validator: _requiredValidator,
                      ),
                      KTextField(
                        label: "Bank Name",
                        controller: _bankNameController,
                        width: 250,
                        isMandatory: true,
                        validator: _requiredValidator,
                      ),
                      KTextField(
                        label: "IFSC Code",
                        controller: _bankIfscCodeController,
                        width: 250,
                        isMandatory: true,
                        validator: _requiredValidator,
                      ),
                      KTextField(
                        label: "Branch",
                        controller: _bankBranchController,
                        width: 250,
                        isMandatory: true,
                        validator: _requiredValidator,
                      ),
                      KTextField(
                        label: "Logo",
                        controller: _logoController,
                        width: 250,
                        isMandatory: true,
                        validator: _requiredValidator,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  KTextField(
                    label: "Terms And Conditions",
                    controller: _termsAndConditionsController,
                    multiLine: 5,
                    width: 500,
                    isMandatory: true,
                    validator: _requiredValidator,
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      child: Text("Submit"),
                      onPressed: _submitForm,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      widget.org.name = _nameController.text;
      widget.org.tagLine = _tagLineController.text;
      widget.org.contactPerson = _contactPersonController.text;
      widget.org.gst = _gstController.text;
      widget.org.pan = _panController.text;
      widget.org.phone = _phoneController.text;
      widget.org.mobile = _mobileController.text;

      widget.org.address = _addressController.text;
      widget.org.city = _cityController.text;
      widget.org.state = _stateController.text;
      widget.org.pin =
          _pinController.text == "" ? 0 : int.parse(_pinController.text);

      widget.org.bankAccountName = _bankAccountNameController.text;
      widget.org.bankAccountNumber = _bankAccountNoController.text;
      widget.org.bankName = _bankNameController.text;
      widget.org.bankIfscCode = _bankIfscCodeController.text;
      widget.org.bankBranch = _bankBranchController.text;
      widget.org.logo = _logoController.text;

      widget.org.termsAndConditions = _termsAndConditionsController.text;

      await Provider.of<OrgProvider>(context, listen: false)
          .createOrganization(widget.org);
      widget.reFresh();
    }
  }

  _setDesktopFullScreen() {
    DesktopWindow.setFullScreen(true);
  }
}
