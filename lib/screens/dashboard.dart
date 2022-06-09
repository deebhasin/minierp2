import 'package:erpapp/kwidgets/k_dashboard_barchart.dart';
import 'package:erpapp/kwidgets/k_dashboard_challan_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/dashboard_provider.dart';

class Dashboard extends StatelessWidget {
  final double sidebar;
  Dashboard({
    Key? key,
    this.sidebar = 150,
  }) : super(key: key);

  late double containerWidth;

  @override
  Widget build(BuildContext context) {
    // Provider.of<DashboardProvider>(context, listen: false).isMtd = true;
    containerWidth = MediaQuery.of(context).size.width - sidebar;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Divider(),
        Container(
          width: containerWidth * 0.95,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: containerWidth * 0.95,
                child: Row(
                  children: [
                    KDashboardChallanData(
                      width: containerWidth * 0.35,
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: KDashboardBarchart(
                        width: containerWidth * 0.59,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
