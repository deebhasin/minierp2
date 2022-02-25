import 'package:flutter/material.dart';


class KTextField extends StatefulWidget {
  final String label;
  final double width;
  double height;
  final int multiLine;
  bool isEmail = false;
  final String initialValue;
  final bool isDisabled;
  final TextEditingController controller;

  KTextField({Key? key,
    required this.label,
    this.width = 100,
    this.height = 30,
    this.multiLine = 1,
    this.initialValue = "",
    this.isDisabled = false,
    required this.controller}) : super(key: key){
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
  bool _isError = false;

  String? checkValidation(String? value){
    setState(() {
      if(widget.label != "PIN" && widget.label != "Credit Period") {
        if (value == null || value.isEmpty) {
          _errormsg = '${widget.label} cannot be blank';
        }
        // return null;
      }
      else if (value == null || value.isEmpty) {
        _errormsg = '${widget.label} cannot be blank';
        }
        else if(int.tryParse(value) == null){
        _errormsg = 'Please enter numeric value';
        }
        else {
          return null;
        }
        if(_errormsg != ""){
          _isError = true;
        }
        if(widget.label == "Customer Id"){
          _isError = false;
          _errormsg = "";
        }
      });
    return null;
  }

  void valueChanged(String? value){
    setState(() {
      _isError = false;
      _errormsg = "";
    });
  }

  @override
  Widget build(BuildContext context) {
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
