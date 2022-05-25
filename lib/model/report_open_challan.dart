import 'package:flutter/material.dart';

class ReportOpenChallan {
  int id;
  String customerName;
  int totalOpenChallans;
  double total;
  double taxAmount;
  double challanTotal;

  ReportOpenChallan({
    this.id = 0,
    this.customerName = "",
    this.totalOpenChallans = 0,
    this.total = 0,
    this.taxAmount = 0,
    this.challanTotal = 0,
  });

  ReportOpenChallan.fromMap(Map<String, dynamic> res)
      : id = 0,
        customerName = res["customer_name"],
        totalOpenChallans = res["challan_count"],
        total = res["sum_total"],
        taxAmount = res["sum_tax_amount"],
        challanTotal = res["sum_challan_amount"];
}
