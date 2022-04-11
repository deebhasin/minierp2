import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class SecondTabExpenses extends StatefulWidget {
  const SecondTabExpenses({Key? key}) : super(key: key);

  @override
  State<SecondTabExpenses> createState() => _SecondTabExpensesState();
}

class _SecondTabExpensesState extends State<SecondTabExpenses> {
  late List<charts.Series<Task, String>> _seriesPieData;

  _generateData() {
    var pieData = [
      Task('Work', 99.9, Colors.black12),
      Task('No Work', 0.1, Colors.white),
    ];
    _seriesPieData.add(charts.Series(
      data: pieData,
      domainFn: (Task task, _) => task.task,
      measureFn: (Task task, _) => task.taskValue,
      colorFn: (Task task, _) => charts.ColorUtil.fromDartColor(task.taskColor),
      id: "Daily Task",
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _seriesPieData = <charts.Series<Task, String>>[];
    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat("#,##0.00", "en_US");
    const int totalExpenses = 0;
    const int expenses = 0;
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("EXPENSES"),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Last 30 days"),
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
                    '\u{20B9}${currencyFormat.format(totalExpenses)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const Text(
                    "Total expenses",
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 4,
                      backgroundColor: Colors.green,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                      child: Text(
                        '\u{20B9}${currencyFormat.format(expenses)}',
                        style: const TextStyle(
                            // fontWeight: FontWeight.bold,
                            // fontSize: 15,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Positioned(
          top: 80,
          right: -10,
          child: Container(
            width: 150,
            height: 150,
            decoration: const BoxDecoration(color: Colors.transparent),
            child: Center(
              child: charts.PieChart<String>(
                //<String> IS USED ELSE IT GIVES ERROR
                _seriesPieData,
                animate: true,
                animationDuration: const Duration(milliseconds: 300),
                defaultRenderer: charts.ArcRendererConfig<String>(
                  //THSI DOESNT SEEM TO BE WORKING HENCE WILL USE CIRCLE AVATAR
                  arcWidth: 150,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 80,
          right: -10,
          child: Container(
            width: 150,
            height: 150,
            decoration: const BoxDecoration(color: Colors.transparent),
            child: const Center(
              child: CircleAvatar(
                radius: 36,
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// created from Link https://www.youtube.com/watch?v=GwDMwnELTP4  Pie Cnart and Bar Chart explained well
// Using the Charts package from pub.dev
class Task {
  String task;
  double taskValue;
  Color taskColor;
  Task(this.task, this.taskValue, this.taskColor);
}
