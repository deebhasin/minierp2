import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SecondTabBankAccounts extends StatelessWidget {
  const SecondTabBankAccounts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat("#,##0.00", "en_US");
    const int netIncome = 6715609;
    const int income = 6699032;
    const int expenses = 16577;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("PROFIT AND LOSS"),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Last month"),
                InkWell(
                  child: const Icon(Icons.keyboard_arrow_down),
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\u{20B9}${currencyFormat.format(netIncome)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const Text(
                "Net income for December",
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '\u{20B9}${currencyFormat.format(income)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      // fontSize: 15,
                    ),
                  ),
                  const Text(
                    "Income",
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Container(
                  width: 130,
                  height: 20,
                  decoration: const BoxDecoration(color: Colors.green),
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '-\u{20B9}${currencyFormat.format(expenses)}',
              style: const TextStyle(
                  // fontWeight: FontWeight.bold,
                  // fontSize: 15,
                  ),
            ),
            const Text(
              "Expenses",
              style: TextStyle(
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
