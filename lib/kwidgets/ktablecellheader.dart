import 'package:flutter/material.dart';

import 'kvariables.dart';

class KTableCellHeader extends StatelessWidget {
  var header;
  final BuildContext context;
  final CrossAxisAlignment crossAxisAlignment;
  final double cellWidth;
  final bool isLastPos;
  double width = 100;
  double height;

  KTableCellHeader({Key? key,
    required this.header,
    required this.context,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.cellWidth = 100,
    this.isLastPos = false,
    this.height = 25}) : super(key: key) {
    width = (MediaQuery.of(context).size.width - KVariables.sidebarWidth) * 0.95;
    // switch(pos){
    //   case 1: cellWidth = width * 0.03;
    //   break;
    //   case 2: cellWidth = width * 0.04;
    //   break;
    //   case 3: cellWidth = width * 0.18;
    //   isLeftAlign = true;
    //   break;
    //   case 4: cellWidth = width * 0.13;
    //   isLeftAlign = true;
    //   break;
    //   case 5: cellWidth = width * 0.18;
    //   isLeftAlign = true;
    //   break;
    //   case 6: cellWidth = width * 0.08;
    //   break;
    //   case 7: cellWidth = width * 0.08;
    //   break;
    //   case 8: cellWidth = width * 0.12;
    //   break;
    //   case 9: cellWidth = width * 0.12;
    //   isLeftAlign = true;
    //   break;
    //   case 10: cellWidth = width * 0.03;
    //   isLastPos = true;
    //   break;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cellWidth * 0.95,
      height: height,
      decoration: BoxDecoration(
        border: Border(
          left: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
          right: BorderSide(color: isLastPos? Colors.transparent : Colors.grey),
          bottom: const BorderSide(color: Colors.grey),
        ),
      ),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                header,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
