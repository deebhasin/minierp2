import 'package:erpapp/model/challan.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/challan_horizontal_data_table.dart';
import 'challancreate.dart';
import '../kwidgets/kcreatebutton.dart';
import '../providers/challan_provider.dart';

class ViewChallan extends StatefulWidget {
  final double width;
  ViewChallan({Key? key, this.width = 50}) : super(key: key);

  @override
  State<ViewChallan> createState() => _ViewChallanState();
}

class _ViewChallanState extends State<ViewChallan> {
  late List<Challan> _challanList;
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
        future: provider.getChallanListByParameters(active: 1),
        builder: (context, AsyncSnapshot<List<Challan>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasError) {
//                  }
              return Center(child: Text("An error occured.\n$snapshot"));
              // return noData(context);
            } else if (snapshot.hasData) {
              _challanList = snapshot.data!;

              if (_challanList.isEmpty) {
                return _noData(context);
              } else {
                return _displayChallan(context);
              }
            } else
              return _noData(context);
          }
        },
      );
    });
  }

  Widget _noData(context) {
    return Column(
      children: [
        KCreateButton(
          callFunction: challanCreate,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Challan",
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
              "Challan does Not Exist",
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

  Widget _displayChallan(BuildContext context) {
    return Container(
      child: Column(
        children: [
          KCreateButton(
            callFunction: challanCreate,
          ),
          Text(
            "Challan",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 2,
              textBaseline: TextBaseline.alphabetic,
            ),
          ),
          const Divider(),
          ChallanHorizontalDataTable(
            leftHandSideColumnWidth: 100,
            rightHandSideColumnWidth: 800,
            challanList: _challanList,
          ),
        ],
      ),
    );
  }

  challanCreate(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ChallanCreate(
            challan: Challan(),
          );
        });
  }
}
