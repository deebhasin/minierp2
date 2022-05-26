import 'package:erpapp/utils/logfile.dart';
import 'package:flutter/material.dart';

class LogsView extends StatelessWidget {
  final double width;
  const LogsView({
    Key? key,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          child: LogFile().logList.length > 0
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Logs",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    for (int i = 0; i < LogFile().logList.length; i++)
                      Text(LogFile().logList[i]),
                  ],
                )
              : Text("LogFile is Empty"),
        ),
      ),
    );
  }
}
