import 'package:erpapp/utils/default_fieldvalidator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';

class KTextField extends StatelessWidget {
  final String label;
  final double width;
  final int maxLength;
  double height;
  final int multiLine;
  final bool isDisabled;
  final TextEditingController controller;
  final FieldValidator? validator;
  final bool isMandatory;
  final Function? valueUpdated;
  final String errMsg;

  KTextField({
    Key? key,
    required this.label,
    this.width = 400,
    this.height = 90,
    this.multiLine = 1,
    this.isDisabled = false,
    required this.controller,
    this.validator,
    this.isMandatory = false,
    this.maxLength = 200,
    this.valueUpdated,
    this.errMsg = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String mandatorySign = isMandatory ? "*" : "";
    height = multiLine == 1 ? height : (height + multiLine * 17);

    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      // height: height + 10,
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
            if(label != "") SizedBox(
              height: 5,
              width: 1,
            ),
            TextFormField(
              // cursorColor: Colors.greenAccent,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              inputFormatters: [
                LengthLimitingTextInputFormatter(maxLength),
              ],
              // onEditingComplete: () => valueUpdatedTest,
              onChanged: (value) => valueUpdated == null? (){} : valueUpdated!(value),
              maxLines: multiLine,
              readOnly: isDisabled,
              controller: controller,
              validator: validator ?? DefaultFieldValidator(),
              style: const TextStyle(fontSize: 15),
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                isDense: true,
                fillColor: isDisabled
                    ? Color.fromRGBO(0, 0, 0, 0.05)
                    : Colors.transparent,
                filled: true,
              ),
            ),
            SizedBox(height: 2,),
            Text(
              errMsg,
              style: TextStyle(
                color: Colors.red,
                fontSize: 11,
              ),
            ),
          ]),
    );
  }

  void valueUpdatedTest(String val) {
    print("Testing On Changed of TextFormField");
  }
}
