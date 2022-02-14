import 'package:flutter/material.dart';


class KTextField extends StatelessWidget {
  final String label;
  final double width;
  double height;
  final int multiLine;
  bool isEmail = false;
  String initialValue;

  KTextField({Key? key,
    required this.label,
    this.width = 100,
    this.height = 25,
    this.multiLine = 1,
    this.initialValue = ""}) : super(key: key){
    height *= multiLine;
    if (label == "Email"){
      isEmail = true;
    }
    if(multiLine > 1){
      height *= 0.9;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ isEmail? Container(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Cc/Bcc",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ) : Text(
            label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          child: TextFormField(
            maxLines: multiLine,
            initialValue: initialValue,
            style: const TextStyle(fontSize: 12),
            textAlignVertical: TextAlignVertical.center,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
