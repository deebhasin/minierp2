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
                width: 100,
              ),
            ),
            const KSidebarRow(text: "Dashboard"),
            const KSidebarRow(text: "Banking"),
            const KSidebarRow(text: "Sales"),
            const KSidebarRow(text: "Cashflow"),
            const KSidebarRow(text: "Expenses"),
            const KSidebarRow(text: "Employees"),
            const KSidebarRow(text: "Reports"),
            const KSidebarRow(text: "Taxes"),
            const KSidebarRow(text: "Accounting"),
            const KSidebarRow(text: "MyAccountant"),
            const KSidebarRow(text: "Apps"),
          ],
          ),
      ),
    );
  }
}
