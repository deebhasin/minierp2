import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/challan.dart';

class KInvoiceCheckbox extends StatefulWidget {
  bool checkStatus;
  Challan challan;
  int index;
  Function onChangeStatus;
  KInvoiceCheckbox({
    Key? key,
    this.checkStatus = false,
    required this.onChangeStatus,
    required this.index,
    required this.challan,
  }) : super(key: key);

  @override
  State<KInvoiceCheckbox> createState() => _KInvoiceCheckboxState();
}

class _KInvoiceCheckboxState extends State<KInvoiceCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
        value: widget.checkStatus,
        onChanged: (bool? value) async{
          setState(() {
            widget.onChangeStatus(value!, widget.challan, widget.index);
            widget.checkStatus = !widget.checkStatus;
          });
        });
  }
}
