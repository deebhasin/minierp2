import 'package:flutter/material.dart';

class KListTile extends StatelessWidget {
  const KListTile({Key? key}) : super(key: key);

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
            title: const Text(
              "Alpha",
              style: TextStyle(color: Colors.black,),
            ),
            trailing: IconButton(
              onPressed: (){},
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
