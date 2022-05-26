import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/challan.dart';
import '../providers/challan_provider.dart';
import '../utils/localDB_repo.dart';
import '../widgets/challan_horizontal_data_table.dart';

class TestLocalDBRepo extends StatelessWidget {
  List<Challan> challanList = [];

  TestLocalDBRepo({
    Key? key,
    this.challanList = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    callDB(context);
     return ChallanHorizontalDataTable(
      leftHandSideColumnWidth: 0,
      rightHandSideColumnWidth: 700,
      challanList: challanList,
    );
//     return Consumer<ChallanProvider>(builder: (ctx, provider, child) {
//       return FutureBuilder(
//         future: provider.getChallanList(),
//         builder: (context, AsyncSnapshot<List<Challan>> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           } else {
//             if (snapshot.hasError) {
// //                  }
//               return Center(child: Text("An error occured.\n$snapshot"));
//               // return noData(context);
//             } else if (snapshot.hasData) {
//               challanList = snapshot.data!;
//              return ChallanHorizontalDataTable(
//                 leftHandSideColumnWidth: 0,
//                 rightHandSideColumnWidth: 700,
//                 challanList: challanList,
//               );
//             }
//             else{
//               return Container();
//             }
//           }
//         },
//       );
//     });
  }

  void callDB(BuildContext context) async {
    challanList = await Provider.of<ChallanProvider>(context, listen: false)
        .getChallanList();
  }
}
