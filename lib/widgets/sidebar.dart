import 'package:flutter/material.dart';

import '../kwidgets/ksidebar_row.dart';


class Sidebar extends StatelessWidget {
  final int sidebarWidth;
  const Sidebar({Key? key,
    this.sidebarWidth = 50}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      width: sidebarWidth.toDouble(),
      height: MediaQuery.of(context).size.height,
      color: Color.fromRGBO(63, 64, 66, 1),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                  "asset/images/minierp_logo.png",
                fit: BoxFit.fill,
                // width: 100,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 150,
                height: 40,
                child: ElevatedButton(
                    onPressed: (){},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add),
                        Text(
                          "New",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    side: const BorderSide(
                      width: 2,
                        color: Colors.white,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),

                ),
              ),
            ),
            const KSidebarRow(text: "Dashboard"),
            const KSidebarRow(text: "Challan"),
            const KSidebarRow(text: "Invoice"),
            const KSidebarRow(text: "Payments"),
            const KSidebarRow(text: "Customers"),
            const KSidebarRow(text: "Organization"),
            const KSidebarRow(text: "Reports"),
          ],
          ),
      ),
    );
  }
}
