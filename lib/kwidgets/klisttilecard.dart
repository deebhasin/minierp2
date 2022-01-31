import 'package:flutter/material.dart';

import '../widgets/secondtab.dart';

class KListTile extends StatelessWidget {
  final String listText;
  final Function removeItemFromList;
  const KListTile({Key? key, required this.listText, required this.removeItemFromList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: ListTile(
            leading: const CircleAvatar(
              radius: 15,
              child: Text(
                "i",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
              backgroundColor: Colors.blue,
            ),
            title: Text(
              listText,
              style: const TextStyle(color: Colors.black,),
            ),
            trailing: IconButton(
              onPressed: () => removeItemFromList(listText),
              icon: const Icon(
                  Icons.cancel,
                color: Colors.black26,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
