import 'package:flutter/material.dart';

class KCreateButton extends StatelessWidget {
  final Color buttonColor = Colors.blue;
  final callFunction;
  const KCreateButton({Key? key, required this.callFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: callFunction,
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
                Icons.add,
                color: buttonColor,
              ),
              Text(
                "Create",
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
