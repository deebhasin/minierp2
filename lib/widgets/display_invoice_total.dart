import 'package:erpapp/providers/checkbox_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DisplayInvoiceTotal extends StatelessWidget {
  final String totalType;
  final double fontSize;
  DisplayInvoiceTotal({
    Key? key,
    required this.totalType,
    this.fontSize = 12,
  }) : super(key: key);
  final currencyFormat = NumberFormat("#,##0.00", "en_US");
  @override
  Widget build(BuildContext context) {
    List<double> _totalList = Provider.of<CheckboxProvider>(context).totalList;
    if (totalType == "subtotal") {
      return Text(
        "\u{20B9}${currencyFormat.format(_totalList[0])}",
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (totalType == "taxTotal") {
      return Text(
        "\u{20B9}${currencyFormat.format(_totalList[1])}",
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (totalType == "invoiceTotal") {
      return Text(
        "\u{20B9}${currencyFormat.format(_totalList[2])}",
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      return Container();
    }
  }
}
