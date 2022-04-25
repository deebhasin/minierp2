import 'package:flutter/material.dart';

class KPopupAlert extends StatelessWidget {
  final List<String> errorMsgList;
  const KPopupAlert({
    Key? key,
    required this.errorMsgList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Container(
        width: 700,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 100,
                child: ListView.builder(
                  itemCount: errorMsgList.length,
                  padding: EdgeInsets.all(2),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        errorMsgList[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Ok"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
