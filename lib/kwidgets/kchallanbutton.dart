import 'package:flutter/material.dart';

class KChallanButton extends StatelessWidget {
  final String label;

  const KChallanButton({Key? key,
    required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (){},
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 11,
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        elevation: MaterialStateProperty.all(0),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            side: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }
}
