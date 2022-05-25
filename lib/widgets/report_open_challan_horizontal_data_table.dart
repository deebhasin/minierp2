import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/challan_provider.dart';
import '../model/report_open_challan.dart';
import '../providers/home_screen_provider.dart';

class ReportOpenChallanHorizontalDataTable extends StatefulWidget {
  final double mediaQueryWidth;
  List<ReportOpenChallan> reportOpenChallanList;
  final double leftHandSideColumnWidth;
  final double rightHandSideColumnWidth;
  ReportOpenChallanHorizontalDataTable({
    Key? key,
    required this.mediaQueryWidth,
    required this.leftHandSideColumnWidth,
    required this.rightHandSideColumnWidth,
    required this.reportOpenChallanList,
  }) : super(key: key);

  @override
  State<ReportOpenChallanHorizontalDataTable> createState() =>
      _ReportOpenChallanHorizontalDataTableState();
}

class _ReportOpenChallanHorizontalDataTableState
    extends State<ReportOpenChallanHorizontalDataTable> {
  HDTRefreshController _hdtRefreshController = HDTRefreshController();

  // final currencyFormat = NumberFormat("#,##0.00", "en_US");
  final currencyFormat = NumberFormat("#,##0", "en_US");

  bool _isCustomerNameAscending = false;

  String sortType = "";
  bool sortAscDesc = true;

  List<bool> _isCheckedList = [];

  @override
  void initState() {
    for (int i = 0; i < widget.reportOpenChallanList.length; i++) {
      _isCheckedList.add(false);
    }
    WidgetsBinding.instance!.addPostFrameCallback((_) => _sortStatus());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      width: MediaQuery.of(context).size.width * 0.582,
      child: HorizontalDataTable(
        leftHandSideColumnWidth: widget.leftHandSideColumnWidth,
        rightHandSideColumnWidth: widget.rightHandSideColumnWidth,
        isFixedHeader: true,
        headerWidgets: _getTitleWidget(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: widget.reportOpenChallanList.length,
        rowSeparatorWidget: const Divider(
          color: Colors.black54,
          height: 1.0,
          thickness: 0.0,
        ),
        leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
        rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
        verticalScrollbarStyle: const ScrollbarStyle(
          thumbColor: Colors.transparent,
          isAlwaysShown: true,
          thickness: 1.0,
          radius: Radius.circular(5.0),
        ),
        horizontalScrollbarStyle: const ScrollbarStyle(
          thumbColor: Colors.red,
          isAlwaysShown: true,
          thickness: 4.0,
          radius: Radius.circular(5.0),
        ),
        enablePullToRefresh: true,
        refreshIndicator: const WaterDropHeader(),
        refreshIndicatorHeight: 60,
        onRefresh: () async {
          //Do sth
          await Future.delayed(const Duration(milliseconds: 500));
          _hdtRefreshController.refreshCompleted();
        },
        enablePullToLoadNewData: false,
        loadIndicator: const ClassicFooter(),
        onLoad: () async {
          //Do sth
          await Future.delayed(const Duration(milliseconds: 100));
          _hdtRefreshController.loadComplete();
        },
        htdRefreshController: _hdtRefreshController,
      ),
      height: MediaQuery.of(context).size.height - 200,
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      Row(),
      TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: _getTitleItemWidget(
          'Customer Name ' + (_isCustomerNameAscending ? '↓' : '↑'),
          300,
          alignment: Alignment.centerLeft,
        ),
        onPressed: () {
          _sortCustomerName();
          setState(() {});
        },
      ),
      _getTitleItemWidget(
        'Total Open Challans',
        150,
      ),
      _getTitleItemWidget(
        'Amount Before Tax\n(\u{20B9})',
        150,
        alignment: Alignment.centerRight,
      ),
      _getTitleItemWidget(
        'Tax\n(\u{20B9})',
        140,
        alignment: Alignment.centerRight,
      ),
      _getTitleItemWidget(
        'Total\n(\u{20B9})',
        150,
        alignment: Alignment.centerRight,
      ),
    ];
  }

  Widget _getTitleItemWidget(
    String label,
    double width, {
    Alignment alignment = Alignment.center,
  }) {
    return Container(
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      width: width,
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      alignment: alignment,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Row(
      children: [
        // _columnItem(
        //   widget.challanList[index].challanNo,
        //   100,
        //   index,
        // ),
      ],
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Container(
      width: widget.mediaQueryWidth * 1.5,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Provider.of<HomeScreenProvider>(context, listen: false)
                  .setDisplayPage = "Challan";
              Provider.of<HomeScreenProvider>(context, listen: false)
                  .setDisplayMap = {"dispayPage": "Challan",
                "customerName": widget.reportOpenChallanList[index].customerName,
                "isChallanReport": true,};
            },
            focusColor: Colors.blue,
            child: Container(
              child: Text(
                widget.reportOpenChallanList[index].customerName,
                style: TextStyle(
                  fontSize: 16,
                  // fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              width: 300,
              height: widget.reportOpenChallanList[index].customerName.length <=
                      20
                  ? 30
                  : widget.reportOpenChallanList[index].customerName.length <= 80
                      ? 60
                      : 150,
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 0,
              ),
              alignment: Alignment.centerLeft,
            ),
          ),
          _columnItem(
            widget.reportOpenChallanList[index].totalOpenChallans.toString(),
            150,
            index,
          ),
          _columnItem(
            currencyFormat.format(widget.reportOpenChallanList[index].total),
            150,
            index,
            alignment: Alignment.centerRight,
          ),
          _columnItem(
            currencyFormat.format(widget.reportOpenChallanList[index].taxAmount),
            140,
            index,
            alignment: Alignment.centerRight,
          ),
          _columnItem(
            currencyFormat
                .format(widget.reportOpenChallanList[index].challanTotal),
            150,
            index,
            alignment: Alignment.centerRight,
          ),
        ],
      ),
    );
  }

  void _sortStatus() async {
    sortType =
        await Provider.of<ChallanProvider>(context, listen: false).getSortType;
    sortAscDesc = await Provider.of<ChallanProvider>(context, listen: false)
        .getIsAscending;
    print("SOrt Type in _sortSttus: $sortType");

    if (sortType == "_sortCustomerName") {
      _isCustomerNameAscending = sortAscDesc;
      _sortCustomerName();
    }
    setState(() {});
  }

  Widget _columnItem(String item, double width, int index,
      {Alignment alignment = Alignment.center}) {
    return Container(
      child: Text(
        item,
        style: TextStyle(fontSize: 16),
      ),
      width: width,
      height: widget.reportOpenChallanList[index].customerName.length <= 20
          ? 30
          : widget.reportOpenChallanList[index].customerName.length <= 80
              ? 60
              : 150,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 0,
      ),
      alignment: alignment,
    );
  }

  void _sortCustomerName() {
    Provider.of<ChallanProvider>(context, listen: false).setSortType =
        "_sortCustomerName";
    Provider.of<ChallanProvider>(context, listen: false).setIsAscending =
        _isCustomerNameAscending;

    widget.reportOpenChallanList.sort((a, b) {
      return _isCustomerNameAscending
          ? a.customerName.compareTo(b.customerName)
          : b.customerName.compareTo(a.customerName);
    });
    _isCustomerNameAscending = !_isCustomerNameAscending;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
