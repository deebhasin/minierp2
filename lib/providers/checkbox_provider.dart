import 'package:flutter/material.dart';

import '../model/challan.dart';

class CheckboxProvider with ChangeNotifier {
  List<double> totalList = [0,0,0];
  List<int> challanIdList = [];

  void initialiseTotalList(){
    totalList[0] = 0;
    totalList[1] = 0;
    totalList[2] = 0;
    challanIdList.clear();
  }

  Future<void> updateCheckbox(bool isChecked, Challan challan) async{
    if(isChecked) {
      totalList[0] += challan.total;
      totalList[1] += challan.taxAmount;
      totalList[2] += challan.challanAmount;
      challanIdList.add(challan.id);
    }
    else{
      totalList[0] -= challan.total;
      totalList[1] -= challan.taxAmount;
      totalList[2] -= challan.challanAmount;
      challanIdList.removeWhere((element) => element == challan.id);
    }
    print("updateCheckbox in Checkbox PRovider ${totalList[0]}");
    notifyListeners();
  }
}
