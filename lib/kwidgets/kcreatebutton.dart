import 'package:flutter/material.dart';

class KCreateButton extends StatelessWidget {
  Color buttonColor = Colors.blue;
  final callFunction;
  late String label;
  KCreateButton({
    Key? key,
    required this.callFunction,
    this.label = "Create",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (label == "Edit") buttonColor = Colors.green;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () => callFunction(context),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(50, 40),
            primary: Colors.transparent,
            shadowColor: Colors.transparent,
            side: BorderSide(
              width: 2,
              color: buttonColor,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                label == "Edit"? Icons.edit : Icons.add,
                color: buttonColor,
                size: 20,
              ),
              Text(
                label,
                style: TextStyle(
                  color: buttonColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 30,
        ),
      ],
    );
  }
}
