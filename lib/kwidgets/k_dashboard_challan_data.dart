import 'package:erpapp/model/dashboard_challan_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/dashboard_provider.dart';

class KDashboardChallanData extends StatelessWidget {
  final double width;
  KDashboardChallanData({
    Key? key,
    this.width = 100,
  }) : super(key: key);
  late bool _isMtd;
  late DashboardChallanData _dashboardChallanData;

  @override
  Widget build(BuildContext context) {
    _isMtd = Provider.of<DashboardProvider>(context).isMtd;
    return Consumer<DashboardProvider>(builder: (ctx, provider, child) {
      return FutureBuilder(
        future: provider.getDashboardChallanData(),
        builder: (context, AsyncSnapshot<DashboardChallanData> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasError) {
              return Center(child: Text("An error occugrey.\n$snapshot"));
              // return noData(context);
            } else if (snapshot.hasData) {
              _dashboardChallanData = snapshot.data!;
            }
          }
          return publishData(context);
        },
      );
    });
  }

  Widget publishData(BuildContext context) {
    return Container(
      width: width,
      // height: 500,
      decoration: BoxDecoration(
        color: Color.fromRGBO(247, 247, 247, 1),
        border: Border.all(
          color: Color.fromRGBO(227, 227, 227, 1),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () => setMtdStatus(!_isMtd, context),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: _isMtd ? Colors.greenAccent : Colors.transparent,
                        border: Border.all(
                          // color: Color.fromRGBO(227, 227, 227, 1),
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Month ${DateFormat("MMMM").format(DateTime.now())}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => setMtdStatus(!_isMtd, context),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color:
                            !_isMtd ? Colors.greenAccent : Colors.transparent,
                        border: Border.all(
                          // color: Color.fromRGBO(227, 227, 227, 1),
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Year ${DateFormat("yyyy").format(DateTime.now())}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: width * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: width * 0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _textLabel("Total Challans"),
                      const SizedBox(
                        height: 10,
                      ),
                      _textLabel("Total Challan Amount"),
                      const SizedBox(
                        height: 10,
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _textLabel("Total Pending Challans"),
                      const SizedBox(
                        height: 10,
                      ),
                      _textLabel("Total Pending Challan Amount"),
                      const SizedBox(
                        height: 10,
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _textLabel("Total Invoices"),
                      const SizedBox(
                        height: 10,
                      ),
                      _textLabel("Total Invoice Amount"),
                    ],
                  ),
                ),
                // const SizedBox(
                //   width: 10,
                // ),
                Container(
                  width: width * 0.3,
                  child: Column(
                    children: [
                      _isMtd
                          ? _textLabel(
                              _dashboardChallanData.mtdTotalChallans.toString())
                          : _textLabel(
                              _dashboardChallanData.ytdTotalChallans.toString()),
                      const SizedBox(
                        height: 10,
                      ),
                      _isMtd
                          ? _textLabel(
                              "\u{20B9} ${_dashboardChallanData.mtdTotalChallanAmount.toString()}")
                          : _textLabel(
                              "\u{20B9} ${_dashboardChallanData.ytdTotalChallanAmount.toString()}"),
                      const SizedBox(
                        height: 10,
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _isMtd
                          ? _textLabel(_dashboardChallanData
                              .mtdTotalPendingChallans
                              .toString())
                          : _textLabel(_dashboardChallanData
                              .ytdTotalPendingChallans
                              .toString()),
                      const SizedBox(
                        height: 10,
                      ),
                      _isMtd
                          ? _textLabel(
                              "\u{20B9} ${_dashboardChallanData.mtdTotalPendingChallanAmount.toString()}")
                          : _textLabel(
                              "\u{20B9} ${_dashboardChallanData.ytdTotalPendingChallanAmount.toString()}"),
                      const SizedBox(
                        height: 10,
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _isMtd
                          ? _textLabel(
                              _dashboardChallanData.mtdTotalInvoices.toString())
                          : _textLabel(
                              _dashboardChallanData.ytdTotalInvoices.toString()),
                      const SizedBox(
                        height: 10,
                      ),
                      _isMtd
                          ? _textLabel(
                              "\u{20B9} ${_dashboardChallanData.mtdTotalInvoiceAmount.toString()}")
                          : _textLabel(
                              "\u{20B9} ${_dashboardChallanData.ytdTotalInvoiceAmount.toString()}"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _textLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Color.fromRGBO(57, 129, 202, 1)),
    );
  }

  void setMtdStatus(bool status, BuildContext context){
    Provider.of<DashboardProvider>(context, listen: false).isMtd = status;
  }

}
