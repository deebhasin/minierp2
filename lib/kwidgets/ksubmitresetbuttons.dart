import 'package:flutter/material.dart';

class KSubmitResetButtons extends StatelessWidget {
  final VoidCallback resetForm;
  final VoidCallback submitForm;
  final bool isReset;
  const KSubmitResetButtons({
    Key? key,
    required this.resetForm,
    required this.submitForm,
    this.isReset = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 40,
          width: 200,
          child: isReset? ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.red, // background
              onPrimary: Colors.white, // foreground
            ),
            onPressed: resetForm,
            child: Text(
              "Reset",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ) : Container(width: 1,),
        ),
        SizedBox(
          width: 30,
        ),
        Container(
          height: 40,
          width: 200,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.green, // background
              onPrimary: Colors.white, // foreground
            ),
            onPressed: submitForm,
            child: Text(
              "Submit",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
