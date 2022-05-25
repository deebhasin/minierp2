import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/report_open_challan_horizontal_data_table.dart';
import '../model/report_open_challan.dart';
import '../providers/challan_provider.dart';


class ReportView extends StatefulWidget {
  final width;

  ReportView({
    Key? key,
    this.width = 150,
  }) : super(key: key);

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  List<ReportOpenChallan> _reportOpenChallanList = [];
  late double containerWidth;

  @override
  void initState() {
    containerWidth = widget.width * 0.95;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChallanProvider>(builder: (ctx, provider, child) {
      return FutureBuilder(
        future: provider.getOpenChallanReportChallanList(),
        builder: (context, AsyncSnapshot<List<ReportOpenChallan>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasError) {
              return Center(child: Text("An error occured.\n$snapshot"));
              // return noData(context);
            } else if (snapshot.hasData) {
              _reportOpenChallanList = snapshot.data!;
              if (_reportOpenChallanList.isEmpty) {
                return noData(context);
              } else {
                return _displayReportOpenChallan(context);
              }
            } else
              return noData(context);
          }
        },
      );
    });
  }

  Widget noData(context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Report",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 2,
                textBaseline: TextBaseline.alphabetic,
              ),
            ),
          ],
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Customer does Not Exist",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _displayReportOpenChallan(BuildContext context) {
    return Container(
      width: containerWidth * 0.95,
      child: Column(
        children: [
          Text(
            "Report",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 2,
              textBaseline: TextBaseline.alphabetic,
            ),
          ),
          const SizedBox(height: 10,),
          // const Divider(),
          ReportOpenChallanHorizontalDataTable(
            mediaQueryWidth: containerWidth,
            leftHandSideColumnWidth: 0,
            rightHandSideColumnWidth: containerWidth * 0.702,
            reportOpenChallanList: _reportOpenChallanList,
          ),
        ],
      ),
    );
  }

}
