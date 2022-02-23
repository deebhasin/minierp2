import 'package:erpapp/kwidgets/kdropdownfield.dart';
import 'package:erpapp/kwidgets/ktextfield.dart';
import 'package:flutter/material.dart';

import 'kdropdown.dart';
import 'kvariables.dart';


class KTableCell extends StatelessWidget {
  final String parameterValue;
  final int pos;
  final List<String> dropdownList;
  final BuildContext context;
  bool isLeftAlign = false;
  bool isFirstPos = false;
  bool isLastPos = false;
  double width = 100;
  double cellWidth = 100;
  double height = 50;
  Widget parameter = const SizedBox(width: 0, height: 0,);

  KTableCell({Key? key,
    this.parameterValue = "",
    required this.pos,
    required this.context,
    this.dropdownList = const [""]}) : super(key: key){
    width = (MediaQuery.of(context).size.width - KVariables.sidebarWidth) * 0.95;
    switch(pos){
      case 1: cellWidth = width * 0.03;
      break;
      case 2: cellWidth = width * 0.04;
      parameter = Text( parameterValue, style: const TextStyle(fontSize: 11),);
      break;
      case 3: cellWidth = width * 0.18;
      parameter = KDropdown(dropDownList: dropdownList, label: "");
      isLeftAlign = true;
      break;
      case 4: cellWidth = width * 0.13;
      parameter = TextFormField(initialValue: parameterValue, style: const TextStyle(fontSize: 11),
        textAlignVertical: TextAlignVertical.center,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),);
      isLeftAlign = true;
      break;
      case 5: cellWidth = width * 0.18;
      parameter = TextFormField(initialValue: parameterValue, style: const TextStyle(fontSize: 11),
        textAlignVertical: TextAlignVertical.center,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),);
      isLeftAlign = true;
      break;
      case 6: cellWidth = width * 0.08;
      parameter = TextFormField(initialValue: parameterValue, style: const TextStyle(fontSize: 11),
        textAlignVertical: TextAlignVertical.center,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),);
      break;
      case 7: cellWidth = width * 0.08;
      parameter = TextFormField(initialValue: parameterValue, style: const TextStyle(fontSize: 11),
        textAlignVertical: TextAlignVertical.center,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),);
      break;
      case 8: cellWidth = width * 0.12;
      parameter = Text( parameterValue, style: const TextStyle(fontSize: 11),         );
      break;
      case 9: cellWidth = width * 0.12;
      parameter = KDropdown(dropDownList: dropdownList, label: "");
      isLeftAlign = true;
      break;
      case 10: cellWidth = width * 0.03;
      parameter = const Icon(Icons.delete_outlined, color: Colors.grey,);
      isLastPos = true;
      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cellWidth,
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
        crossAxisAlignment: isLeftAlign? CrossAxisAlignment.start : CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: parameter,
          ),
        ],
      ),
    );
  }
}
