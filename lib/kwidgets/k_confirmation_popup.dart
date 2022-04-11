import 'package:flutter/material.dart';

class KConfirmationPopup extends StatelessWidget {
  final int id;
  final Function deleteProvider;
  const KConfirmationPopup({
    Key? key,
    required this.id,
    required this.deleteProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color.fromRGBO(242, 243, 247, 1),
          borderRadius: BorderRadius.circular(30),
        ),
        width: 500,
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Are You Sure You wish to delete?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.green,),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"),
                  ),
                ),
                Container(
                  width: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.red,),
                    onPressed: () {
                      print("Delete Button Pressed");
                      deleteProvider(id);
                      Navigator.of(context).pop();
                    },
                    child: Text("OK"),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
