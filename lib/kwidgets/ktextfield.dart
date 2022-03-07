import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart' as v;
import 'package:form_field_validator/form_field_validator.dart';


class KTextField extends StatefulWidget {
  final String label;
  final double width;
  double height;
  final int multiLine;
  bool isEmail = false;
  final String initialValue;
  final bool isDisabled;
  final TextEditingController controller;
  final bool isValidate;
  final FieldValidator? validator;
  final Function? valueUpdated;

  KTextField({Key? key,
    required this.label,
    this.width = 100,
    this.height = 30,
    this.multiLine = 1,
    this.initialValue = "",
    this.isDisabled = false,
    required this.controller,
    this.isValidate = false,
    this.validator = null,
    this.valueUpdated,
  }) : super(key: key){
    height *= multiLine;
    if (label == "Email"){
      isEmail = true;
    }
    if(multiLine > 1){
      height *= 0.9;
    }
  }

  @override
  State<KTextField> createState() => _KTextFieldState();
}

class _KTextFieldState extends State<KTextField> {
  String _errormsg = "";
  String? _validatorError;
  bool _isError = false;

  String? checkValidation(String? value){
    setState(() {
       print("${widget.label}");
      _validatorError = widget.validator?.call(value);
      if(_validatorError != null){
        _errormsg = _validatorError!;
        _isError = true;
      }
      print(_validatorError);
    });
    return null;
  }

  void valueChanged(String? value){
    setState(() {
      print("Value Changed");
      _isError = false;
      _errormsg = "";
      widget.valueUpdated!();
      print("Changed to $value");
    });
  }

  @override
  Widget build(BuildContext context) {
    // widget.controller.text = widget.initialValue;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ widget.isEmail? Container(
          width: widget.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Cc/Bcc",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ) : Text(
            widget.label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: widget.width,
              height: widget.height,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: _isError? Colors.red : Colors.grey),
              ),
              child: TextFormField(
                onChanged: (value) => valueChanged(value),
                maxLines: widget.multiLine,
                readOnly: widget.isDisabled,
                controller: widget.controller,
                validator: (value) => checkValidation(value),
                // validator: widget.validator,
                // initialValue: initialValue,
                style: const TextStyle(fontSize: 14),
                textAlignVertical: TextAlignVertical.center,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                 // enabledBorder: OutlineInputBorder(
                 //   borderSide: BorderSide(color: Colors.transparent),
                 // ),
                ),
              ),
            ),
            Text(
              _errormsg,
              style: TextStyle(
                fontSize: 14,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
