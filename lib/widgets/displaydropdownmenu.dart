import 'package:flutter/material.dart';

import '../utils/logfile.dart';

class DisplayDropdownMenu extends StatefulWidget {
  final List<String> dropDownList;
  final bool showdropdownflag;
  final double width;
  final double height;
  final Function setSelection;

  const DisplayDropdownMenu({
    Key? key,
    required this.dropDownList,
    this.showdropdownflag = false,
    this.width = 100,
    this.height = 25,
    required this.setSelection,
  }) : super(key: key);

  @override
  State<DisplayDropdownMenu> createState() => _DisplayDropdownMenuState();
}

class _DisplayDropdownMenuState extends State<DisplayDropdownMenu> {
  var hoverOnContainerFlag = [];
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    _focusNode.addListener(() {
      LogFile().logEntry("Has focus: ${_focusNode.hasFocus}");
    });
    for (int i = 0; i < widget.dropDownList.length; i++) {
      hoverOnContainerFlag.add(false);
    }
    super.initState();
  }

  void updateSelection(String selectedValue, int index) {
    hoverOnContainerFlag[index] = false;
    widget.setSelection(selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: widget.width,
        height: widget.height * 4,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(242, 243, 247, 1),
          border: Border(
            left: BorderSide(color: Colors.grey),
            top: BorderSide(color: Colors.grey),
            right: BorderSide(color: Colors.grey),
            bottom: BorderSide(color: Colors.grey),
          ),
        ),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.dropDownList.length,
          itemBuilder: (context, index) => InkWell(
            onTap: () => updateSelection(widget.dropDownList[index], index),
            focusNode: _focusNode,
            onHover: (value) {
              setState(() {
                hoverOnContainerFlag[index] = !hoverOnContainerFlag[index];
              });
            },
            /***** onFocusChange NOT WORKING  *****/
            onFocusChange: (hasFocus) {
              LogFile().logEntry(hasFocus);
              if (hasFocus) {
                LogFile().logEntry("Focus Set");
              }
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              child: Text(widget.dropDownList[index]),
              decoration: BoxDecoration(
                color: hoverOnContainerFlag[index]
                    ? Colors.grey
                    : Colors.transparent,
                border: const Border(
                  left: BorderSide(color: Colors.grey),
                  top: BorderSide(color: Colors.transparent),
                  right: BorderSide(color: Colors.grey),
                  bottom: BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
