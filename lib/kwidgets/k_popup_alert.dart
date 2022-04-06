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
        height: 350,
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
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Ok"),
            ),
          ],
        ),
      ),
    );
  }
}
