import 'package:flutter/material.dart';

class AlertDialogNav extends StatelessWidget {
  const AlertDialogNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.help_outline),
              const Text("Help"),
              InkResponse(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.close),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
