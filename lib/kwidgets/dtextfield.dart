import 'package:erpapp/utils/default_fieldvalidator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart' as v;
import 'package:form_field_validator/form_field_validator.dart';

class DTextField extends StatelessWidget {
  final String label;
  final double width;
  final int maxLength;
  double height;
  final int multiLine;
  final bool isDisabled;
  final TextEditingController controller;
  final FieldValidator? validator;
  final bool isMandatory;
  static _myDefaultFunc() {}

  DTextField({
    Key? key,
    required this.label,
    this.width = 400,
    this.height = 100,
    this.multiLine = 1,
    this.isDisabled = false,
    required this.controller,
    this.validator,
    this.isMandatory = false,
    this.maxLength = 200
  }) : super(key: key) {
    height = multiLine == 1?  height : (height + multiLine*17) ;
  }

  @override
  Widget build(BuildContext context) {
    String mandatorySign = isMandatory ? "*" : "";


    return Container(
      height: height,
      width: width,
      // decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  mandatorySign,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
              width: 1,
            ),
            Container(
              // decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(36), border: Border.all(color: Colors.grey)),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                // maxLength: 6,
                inputFormatters: [
                  new LengthLimitingTextInputFormatter(maxLength),
                ],
                maxLines: multiLine,
                readOnly: isDisabled,
                controller: controller,
                validator: validator ?? DefaultFieldValidator(),
                style: const TextStyle(fontSize: 15),
                textAlignVertical: TextAlignVertical.bottom,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                ),
              ),
            ),
          ]),
    );
  }
}
