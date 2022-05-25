import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:erpapp/kwidgets/ktextfield.dart';
import 'package:erpapp/model/organization.dart';
import 'package:erpapp/providers/org_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class OrganizationCreate extends StatefulWidget {
  final Organization org;
  final isDisabled;
  OrganizationCreate({
    Key? key,
    required this.org,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  State<OrganizationCreate> createState() => _OrganizationCreateState();
}

class _OrganizationCreateState extends State<OrganizationCreate> {
  final _formKey = GlobalKey<FormState>();
  late double width;
  late double height;

  late String filePath;
  File file = File("");

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
  late TextEditingController _stateCodeController;
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
    _stateCodeController = TextEditingController(text: widget.org.stateCode);
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
    _stateCodeController.dispose();
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
    height = widget.isDisabled
        ? MediaQuery.of(context).size.height - 200
        : MediaQuery.of(context).size.height;
    height = (widget.org.id != 0 && !widget.isDisabled)
        ? MediaQuery.of(context).size.height - 200
        : height;
    _setDesktopFullScreen();
    return Form(
      key: _formKey,
      child: Container(
        width: width,
        height: height,
        child: Column(
          children: [
            Text(
              widget.org.id == 0 ? "Create Organization" : "View Organization",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
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
                              isDisabled: widget.isDisabled,
                            ),
                            KTextField(
                              label: "Tag Line",
                              controller: _tagLineController,
                              width: 400,
                              isDisabled: widget.isDisabled,
                            ),
                            KTextField(
                              label: "Contact Person",
                              controller: _contactPersonController,
                              width: 250,
                              isDisabled: widget.isDisabled,
                            ),
                            KTextField(
                              label: "GST #",
                              controller: _gstController,
                              width: 250,
                              isMandatory: true,
                              validator: _requiredValidator,
                              isDisabled: widget.isDisabled,
                            ),
                            KTextField(
                              label: "PAN",
                              controller: _panController,
                              width: 250,
                              isDisabled: widget.isDisabled,
                            ),
                            KTextField(
                              label: "Phone",
                              controller: _phoneController,
                              width: 250,
                              isMandatory: true,
                              validator: _requiredValidator,
                              isDisabled: widget.isDisabled,
                            ),
                            KTextField(
                              label: "Mobile",
                              controller: _mobileController,
                              width: 250,
                              isDisabled: widget.isDisabled,
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
                              isDisabled: widget.isDisabled,
                            ),
                            KTextField(
                              label: "City",
                              controller: _cityController,
                              width: 250,
                              isMandatory: true,
                              validator: _requiredValidator,
                              isDisabled: widget.isDisabled,
                            ),
                            KTextField(
                              label: "State",
                              controller: _stateController,
                              width: 250,
                              isMandatory: true,
                              validator: _requiredValidator,
                              isDisabled: widget.isDisabled,
                            ),
                            KTextField(
                              label: "State Code",
                              controller: _stateCodeController,
                              width: 250,
                              isMandatory: true,
                              validator: _requiredValidator,
                              isDisabled: widget.isDisabled,
                            ),
                            KTextField(
                              label: "Pin",
                              controller: _pinController,
                              width: 250,
                              isMandatory: true,
                              validator: _pinValidator,
                              isDisabled: widget.isDisabled,
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
                              isDisabled: widget.isDisabled,
                            ),
                            KTextField(
                              label: "Bank Account No.",
                              controller: _bankAccountNoController,
                              width: 250,
                              isMandatory: true,
                              validator: _requiredValidator,
                              isDisabled: widget.isDisabled,
                            ),
                            KTextField(
                              label: "Bank Name",
                              controller: _bankNameController,
                              width: 250,
                              isMandatory: true,
                              validator: _requiredValidator,
                              isDisabled: widget.isDisabled,
                            ),
                            KTextField(
                              label: "IFSC Code",
                              controller: _bankIfscCodeController,
                              width: 250,
                              isMandatory: true,
                              validator: _requiredValidator,
                              isDisabled: widget.isDisabled,
                            ),
                            KTextField(
                              label: "Branch",
                              controller: _bankBranchController,
                              width: 250,
                              isMandatory: true,
                              validator: _requiredValidator,
                              isDisabled: widget.isDisabled,
                            ),
                            Container(
                              width: 250,
                              child: Column(
                                children: [
                                  KTextField(
                                    label: "Logo",
                                    controller: _logoController,
                                    width: 250,
                                    isDisabled: true,
                                  ),
                                  widget.isDisabled
                                      ? Container()
                                      : ElevatedButton(
                                          onPressed: _logoUpload,
                                          child: Text("Upload Logo"),
                                        ),
                                ],
                              ),
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
                          isDisabled: widget.isDisabled,
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
                          child: widget.isDisabled
                              ? Container()
                              : ElevatedButton(
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
          ],
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
      widget.org.stateCode = _stateCodeController.text;
      widget.org.pin =
          _pinController.text == "" ? 0 : int.parse(_pinController.text);

      widget.org.bankAccountName = _bankAccountNameController.text;
      widget.org.bankAccountNumber = _bankAccountNoController.text;
      widget.org.bankName = _bankNameController.text;
      widget.org.bankIfscCode = _bankIfscCodeController.text;
      widget.org.bankBranch = _bankBranchController.text;
      widget.org.logo = _logoController.text;

      widget.org.termsAndConditions = _termsAndConditionsController.text;

      if(file.path != "") await file.copySync(filePath);

      await Provider.of<OrgProvider>(context, listen: false)
          .saveOrganization(widget.org);
      if (widget.org.id != "" && !widget.isDisabled)
        Navigator.of(context).pop();
    }
  }

  void _logoUpload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'gif'],
    );

    if (result != null) {
      file = File(result.files.single.path!);

      List<String> fileStr = file.path.split("\\");

      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      filePath = path.join(documentsDirectory.path, "Org\\",
          fileStr[fileStr.length - 1]);
      _logoController.text = filePath;

      print("${filePath}");
    } else {
      // User canceled the picker
    }
  }

  _setDesktopFullScreen() {
    DesktopWindow.setFullScreen(true);
  }
}
