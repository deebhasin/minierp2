import 'package:flutter/material.dart';

import '../kwidgets/klisttilecard.dart';
import '../widgets/secondtabrowcontainer.dart';
import '../widgets/secondtabpandl.dart';
import '../kwidgets/ktabbar.dart';
import '../widgets/secondtabexpenses.dart';
import '../widgets/secondtabbankaccounts.dart';

class SecondTab extends StatefulWidget {
  final int sidebar;
  static List<String> cardList = ["Alpha", "Beta", "Gamma", "Delta", "Pi"];
  const SecondTab({Key? key, required this.sidebar}) : super(key: key);

  @override
  _SecondTabState createState() => _SecondTabState();
}

class _SecondTabState extends State<SecondTab> {
  void removeItemFromList(String listitem){
    setState(() {
      SecondTab.cardList.removeWhere((item) => item == listitem);
    });
  }
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      // physics: const NeverScrollableScrollPhysics(),
      children: [
        // for(var item in cardList) const KListTile(listText: item),
        ...SecondTab.cardList.map((item) => KListTile(listText: item, removeItemFromList: (item) => removeItemFromList(item))).toList(),
        // const KListTile(),
        // const KListTile(),
        // const KListTile(),
        // const KListTile(),
        // const KListTile(),
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
