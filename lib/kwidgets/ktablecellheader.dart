import 'package:flutter/material.dart';

import 'kvariables.dart';

class KTableCellHeader extends StatelessWidget {
  String header = "";
  final BuildContext context;
  final CrossAxisAlignment crossAxisAlignment;
  final double cellWidth;
  final bool isLastPos;
  double width = 100;
  double height;
  final int id;
  final Function? deleteAction;
  final Function? editAction;
  final bool isInvoice;

  KTableCellHeader({
    Key? key,
    required this.header,
    required this.context,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.cellWidth = 100,
    this.isLastPos = false,
    this.height = 25,
    this.id = 0,
    this.deleteAction,
    this.editAction,
    this.isInvoice = false,
  }) : super(key: key) {
    width =
        (MediaQuery.of(context).size.width - KVariables.sidebarWidth) * 0.95;
  }

  _test() {}
  @override
  Widget build(BuildContext context) {
    return Container(
      width: cellWidth * 0.95,
      // height: height,
      decoration: BoxDecoration(
        border: Border(
          left: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
          right:
              BorderSide(color: isLastPos ? Colors.transparent : Colors.grey),
          bottom: const BorderSide(color: Colors.grey),
        ),
      ),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: (isLastPos && id != 0)
                ? showIcons(id, context)
                : showText(header),
          ),
        ],
      ),
    );
  }

  Widget showText(String header) {
    return Text(
      header,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget showIcons(
    int id,
    BuildContext context,
  ) {
    return Row(
      children: [
        isInvoice
            ? Icon(
                Icons.edit_off,
                size: 16,
                color: Colors.grey,
              )
            : InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        if (editAction!(id) != null) {
                          return editAction!(id);
                        } else {
                          return Container();
                        }
                      });
                },
                child: Icon(
                  Icons.edit,
                  size: 16,
                  color: Colors.grey,
                ),
              ),
        const SizedBox(
          width: 8,
        ),
        InkWell(
          onTap: () => deleteAction!(id),
          child: Icon(
            Icons.delete,
            size: 16,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
