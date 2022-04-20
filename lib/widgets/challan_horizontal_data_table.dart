import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../kwidgets/k_invoice_checkbox.dart';
import '../providers/challan_provider.dart';
import '../screens/challancreate.dart';
import '../kwidgets/k_confirmation_popup.dart';
import '../model/challan.dart';

class ChallanHorizontalDataTable extends StatefulWidget {
  List<Challan> challanList;
  bool isCheckbox;
  final double leftHandSideColumnWidth;
  final double rightHandSideColumnWidth;
  final Function? checkboxChanged;
  ChallanHorizontalDataTable({
    Key? key,
    required this.leftHandSideColumnWidth,
    required this.rightHandSideColumnWidth,
    required this.challanList,
    this.isCheckbox = false,
    this.checkboxChanged,
  }) : super(key: key);

  @override
  State<ChallanHorizontalDataTable> createState() =>
      _ChallanHorizontalDataTableState();
}

class _ChallanHorizontalDataTableState
    extends State<ChallanHorizontalDataTable> {
  HDTRefreshController _hdtRefreshController = HDTRefreshController();

  // final currencyFormat = NumberFormat("#,##0.00", "en_US");
  final currencyFormat = NumberFormat("#,##0.", "en_US");

  bool _isChallanNoAscending = false;
  bool _isChallanDateAscending = false;
  bool _isCustomerNameAscending = false;
  bool _isInvoiceNoAscending = false;

  List<ScrollController> _scrollControllerList = [];

  List<int> _challanSelectedList = [];
  List<bool> _isCheckedList = [];

  @override
  void initState() {
    for(int i = 0; i <widget.challanList.length; i++){
      _isCheckedList.add(false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      width: widget.isCheckbox
          ? MediaQuery.of(context).size.width * 0.64
          : MediaQuery.of(context).size.width * 0.9,
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
      height:
          widget.isCheckbox ? 185 : MediaQuery.of(context).size.height - 200,
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      Row(),
      if (widget.isCheckbox)
        _getTitleItemWidget(
          'Select',
          80,
        ),
      TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: _getTitleItemWidget(
          'Challan # ' + (_isChallanNoAscending ? '↓' : '↑'),
          150,
          alignment: Alignment.centerLeft,
        ),
        onPressed: () {
          _sortChallanNo();
          setState(() {});
        },
      ),
      TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: _getTitleItemWidget(
          'Challan Date ' + (_isChallanDateAscending ? '↓' : '↑'),
          150,
        ),
        onPressed: () {
          _sortChallanDate();
          setState(() {});
        },
      ),
      if (!widget.isCheckbox)
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
      TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: _getTitleItemWidget(
          'Invoice # ' + (_isInvoiceNoAscending ? '↓' : '↑'),
          150,
          alignment: Alignment.centerLeft,
        ),
        onPressed: () {
          _sortInvoiceNo();
          setState(() {});
        },
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
    return Row(
      children: [
        if (widget.isCheckbox)
          Container(
            width: 80,
            child: KInvoiceCheckbox(
              checkStatus: _isCheckedList[index],
              challan: widget.challanList[index],
              index: index,
              onChangeStatus: onCheckboxChanged,
            ),
          ),
        _columnItem(
          widget.challanList[index].challanNo,
          150,
          index,
          alignment: Alignment.centerLeft,
        ),
        _columnItem(
          DateFormat("dd-MM-yyyy")
              .format(widget.challanList[index].challanDate!),
          150,
          index,
        ),
        if (!widget.isCheckbox)
          _columnItem(
            widget.challanList[index].customerName,
            300,
            index,
            alignment: Alignment.centerLeft,
          ),
        _columnItem(
          currencyFormat.format(widget.challanList[index].total),
          150,
          index,
          alignment: Alignment.centerRight,
        ),
        _columnItem(
          currencyFormat.format(widget.challanList[index].taxAmount),
          140,
          index,
          alignment: Alignment.centerRight,
        ),
        _columnItem(
          currencyFormat.format(widget.challanList[index].challanAmount),
          150,
          index,
          alignment: Alignment.centerRight,
        ),
        _columnItem(
          widget.challanList[index].invoiceNo,
          150,
          index,
          alignment: Alignment.centerLeft,
        ),
        if (!widget.isCheckbox)
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
                          if (editAction(widget.challanList[index].id) !=
                              null) {
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

  Widget _columnItem(String item, double width, int index,
      {Alignment alignment = Alignment.center}) {
    return Container(
      child: Text(
        item,
        style: TextStyle(fontSize: 16),
      ),
      width: width,
      height: widget.challanList[index].customerName.length <= 20
          ? 30
          : widget.challanList[index].customerName.length <= 80
              ? 60
              : 150,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 0,
      ),
      alignment: alignment,
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
          return KConfirmationPopup(
            id: id,
            deleteProvider: deleteChallan,
          );
        });
  }

  void deleteChallan(int id) {
    Provider.of<ChallanProvider>(context, listen: false).deleteChallan(id);
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

  void onCheckboxChanged(bool _isChecked, Challan _challan, int i){
    _isCheckedList[i] = _isChecked;
    widget.checkboxChanged!();
  }

  @override
  void dispose() {
    for (int i = 0; i < _scrollControllerList.length; i++) {
      _scrollControllerList[i].dispose();
    }
    super.dispose();
  }
}
