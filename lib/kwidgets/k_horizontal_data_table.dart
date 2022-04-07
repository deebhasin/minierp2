import 'package:erpapp/model/challan.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/challan_provider.dart';
import '../screens/challancreate.dart';
import 'k_confirmation_popup.dart';

class KHorizontalDataTable extends StatefulWidget {
  List<Challan> challanList;
  final double leftHandSideColumnWidth;
  final double rightHandSideColumnWidth;
  KHorizontalDataTable({
    Key? key,
    required this.leftHandSideColumnWidth,
    required this.rightHandSideColumnWidth,
    required this.challanList,
  }) : super(key: key);

  @override
  State<KHorizontalDataTable> createState() => _KHorizontalDataTableState();
}

class _KHorizontalDataTableState extends State<KHorizontalDataTable> {
  HDTRefreshController _hdtRefreshController = HDTRefreshController();

  final currencyFormat = NumberFormat("#,##0.00", "en_US");

  bool _isChallanNoAscending = false;
  bool _isChallanDateAscending = false;
  bool _isCustomerNameAscending = false;
  bool _isInvoiceNoAscending = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      width: MediaQuery.of(context).size.width * 0.6,
      child: HorizontalDataTable(
        leftHandSideColumnWidth: widget.leftHandSideColumnWidth,
        rightHandSideColumnWidth: widget.rightHandSideColumnWidth,
        isFixedHeader: true,
        headerWidgets: _getTitleWidget(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: widget.challanList.length,
        rowSeparatorWidget: const Divider(
          color: Colors.black54,
          height: 1.0,
          thickness: 0.0,
        ),
        leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
        rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
        verticalScrollbarStyle: const ScrollbarStyle(
          thumbColor: Colors.yellow,
          isAlwaysShown: true,
          thickness: 4.0,
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
        enablePullToLoadNewData: true,
        loadIndicator: const ClassicFooter(),
        onLoad: () async {
          //Do sth
          await Future.delayed(const Duration(milliseconds: 500));
          _hdtRefreshController.loadComplete();
        },
        htdRefreshController: _hdtRefreshController,
      ),
      height: MediaQuery.of(context).size.height - 200,
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      Row(
        children: [
          _getTitleItemWidget('#', 40),
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            child: _getTitleItemWidget(
              'Challan # ' + (_isChallanNoAscending ? '↓' : '↑'),
              100,
            ),
            onPressed: () {
              _sortChallanNo();
              setState(() {});
            },
          ),
        ],
      ),
      TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: _getTitleItemWidget(
          'Challan Date ' + (_isChallanDateAscending ? '↓' : '↑'),
          100,
        ),
        onPressed: () {
          _sortChallanDate();
          setState(() {});
        },
      ),
      TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: _getTitleItemWidget(
          'Customer Name ' + (_isCustomerNameAscending ? '↓' : '↑'),
          150,
        ),
        onPressed: () {
          _sortCustomerName();
          setState(() {});
        },
      ),
      _getTitleItemWidget(
        'Amount Before Tax',
        150,
      ),
      _getTitleItemWidget(
        'Tax',
        100,
      ),
      _getTitleItemWidget(
        'Grand Total',
        100,
      ),
      TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: _getTitleItemWidget(
          'Invoice # ' + (_isInvoiceNoAscending ? '↓' : '↑'),
          120,
        ),
        onPressed: () {
          _sortInvoiceNo();
          setState(() {});
        },
      ),
      // _getTitleItemWidget('', 100),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      // color: Colors.grey,
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      width: width,
      height: 30,
      // padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.center,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Row(
      children: [
        Container(
          child: Text((index + 1).toString()),
          width: 40,
          height: 30,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
        ),
        Container(
          child: Text(widget.challanList[index].challanNo),
          width: 100,
          height: 30,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
        ),
      ],
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: [
        Container(
          // color: Colors.grey,
          child: Text(DateFormat("dd-MM-yyyy")
              .format(widget.challanList[index].challanDate!)),
          width: 100,
          height: 30,
          // padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
        ),
        Container(
          // color: Colors.grey,
          child: Text(widget.challanList[index].customerName),
          width: 150,
          height: 30,
          // padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
        ),
        Container(
          // color: Colors.grey,
          child: Text(currencyFormat.format(widget.challanList[index].total)),
          width: 150,
          height: 30,
          // padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
        ),
        Container(
          // color: Colors.grey,
          child:
              Text(currencyFormat.format(widget.challanList[index].taxAmount)),
          width: 100,
          height: 30,
          // padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
        ),
        Container(
          // color: Colors.grey,
          child: Text(
              currencyFormat.format(widget.challanList[index].challanAmount)),
          width: 100,
          height: 30,
          // padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
        ),
        Container(
          // color: Colors.grey,
          child: Text(widget.challanList[index].invoiceNo),
          width: 120,
          height: 30,
          // padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
        ),
        Container(
          width: 80,
          height: 30,
          // padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        if (editAction(widget.challanList[index].id) != null) {
                          return editAction(widget.challanList[index].id);
                        } else {
                          return Container();
                        }
                      });
                },
                child: Icon(
                  widget.challanList[index].invoiceNo != ""
                      ? Icons.remove_red_eye_outlined
                      : Icons.edit,
                  size: 16,
                  color: widget.challanList[index].invoiceNo != ""
                      ? Colors.blue
                      : Colors.green,
                ),
              ),
              widget.challanList[index].invoiceNo != ""
                  ? Icon(
                      Icons.no_cell_outlined,
                      size: 16,
                      color: Colors.blueGrey,
                    )
                  : InkWell(
                      onTap: () => deleteAction(widget.challanList[index].id),
                      child: Icon(
                        Icons.delete,
                        size: 16,
                        color: Colors.red,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  void _sortChallanNo() {
    widget.challanList.sort((a, b) {
      return _isChallanNoAscending
          ? a.challanNo.compareTo(b.challanNo)
          : b.challanNo.compareTo(a.challanNo);
    });
    _isChallanNoAscending = !_isChallanNoAscending;
  }

  void _sortChallanDate() {
    widget.challanList.sort((a, b) {
      return _isChallanDateAscending
          ? a.challanDate!.compareTo(b.challanDate!)
          : b.challanDate!.compareTo(a.challanDate!);
    });
    _isChallanDateAscending = !_isChallanDateAscending;
  }

  void _sortCustomerName() {
    widget.challanList.sort((a, b) {
      return _isCustomerNameAscending
          ? a.customerName.compareTo(b.customerName)
          : b.customerName.compareTo(a.customerName);
    });
    _isCustomerNameAscending = !_isCustomerNameAscending;
  }

  void _sortInvoiceNo() {
    widget.challanList.sort((a, b) {
      return _isInvoiceNoAscending
          ? a.invoiceNo.compareTo(b.invoiceNo)
          : b.invoiceNo.compareTo(a.invoiceNo);
    });
    _isInvoiceNoAscending = !_isInvoiceNoAscending;
  }

  void deleteAction(int id) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return KConfirmationPopup(challanId: id,);
        });
    // Provider.of<ChallanProvider>(context, listen: false).deleteChallan(id);
  }


  Widget editAction(int id) {
    Challan challan;
    return Consumer<ChallanProvider>(builder: (ctx, provider, child) {
      return FutureBuilder(
        future: provider.getChallanById(id),
        builder: (context, AsyncSnapshot<Challan> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasError) {
              //                  if (snapshot.error is ConnectivityError) {
              //                    return NoConnectionScreen();
              //                  }
              return Center(child: Text("An error occured.\n$snapshot"));
              // return noData(context);
            } else if (snapshot.hasData) {
              challan = snapshot.data!;
              return ChallanCreate(
                challan: challan,
              );
            } else
              return Container();
          }
        },
      );
    });
  }
}
