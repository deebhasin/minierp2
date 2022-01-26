import 'package:flutter/material.dart';

import '../kwidgets/klisttilecard.dart';
import '../widgets/secondtabrowcontainer.dart';
import '../widgets/secondtabpandl.dart';
import '../kwidgets/ktabbar.dart';
import '../widgets/secondtabexpenses.dart';
import '../widgets/secondtabbankaccounts.dart';

class SecondTab extends StatefulWidget {
  final int sidebar;
  const SecondTab({Key? key, required this.sidebar}) : super(key: key);

  @override
  _SecondTabState createState() => _SecondTabState();
}

class _SecondTabState extends State<SecondTab> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      // physics: const NeverScrollableScrollPhysics(),
      children: [
        const KListTile(),
        const KListTile(),
        const KListTile(),
        const KListTile(),
        const KListTile(),
        SizedBox(
          width: KTabBar.sizedBoxWidth, //(MediaQuery.of(context).size.width - widget.sidebar) * 0.85,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                SecondTabRowContainer(child: SecondTabPAndL()),
                SecondTabRowContainer(child: SecondTabExpenses()),
                SecondTabRowContainer(child: SecondTabBankAccounts()),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
