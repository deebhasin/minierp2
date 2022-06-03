import 'package:erpapp/kwidgets/k_dashboard_challan_data.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  final double sidebar;
  Dashboard({
    Key? key,
    this.sidebar = 150,
  }) : super(key: key);

  late double containerWidth;

  @override
  Widget build(BuildContext context) {
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
              KDashboardChallanData(
                width: containerWidth * 0.35,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
