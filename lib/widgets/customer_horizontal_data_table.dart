import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:provider/provider.dart';

import '../kwidgets/k_confirmation_popup.dart';
import '../model/customer.dart';
import '../screens/customercreate.dart';
import '../providers/customer_provider.dart';

class CustomerHorizontalDataTable extends StatefulWidget {
  List<Customer> customerList;
  final double leftHandSideColumnWidth;
  final double rightHandSideColumnWidth;

  CustomerHorizontalDataTable({
    Key? key,
    required this.leftHandSideColumnWidth,
    required this.rightHandSideColumnWidth,
    required this.customerList,
  }) : super(key: key);

  @override
  State<CustomerHorizontalDataTable> createState() =>
      _CustomerHorizontalDataTableState();
}

class _CustomerHorizontalDataTableState
    extends State<CustomerHorizontalDataTable> {
  HDTRefreshController _hdtRefreshController = HDTRefreshController();

  bool _isCustomerNameAscending = true;
  bool _isContactPersonAscending = true;
  bool _isStateAscending = true;

  List<ScrollController> _scrollControllerList = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      width: MediaQuery.of(context).size.width * 0.85,
      child: HorizontalDataTable(
        leftHandSideColumnWidth: widget.leftHandSideColumnWidth,
        rightHandSideColumnWidth: widget.rightHandSideColumnWidth,
        isFixedHeader: true,
        headerWidgets: _getTitleWidget(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: widget.customerList.length,
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
      Row(),
      TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: _getTitleItemWidget(
          'Company Name ' + (_isCustomerNameAscending ? '↓' : '↑'),
          250,
          alignment: Alignment.centerLeft,
        ),
        onPressed: () {
          _sortCustomerName();
          setState(() {});
        },
      ),
      TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: _getTitleItemWidget(
          'Contact Person ' + (_isContactPersonAscending ? '↓' : '↑'),
          170,
          alignment: Alignment.centerLeft,
        ),
        onPressed: () {
          _sortContactPerson();
          setState(() {});
        },
      ),
      _getTitleItemWidget(
        'Mobile',
        150,
      ),
      _getTitleItemWidget(
        'Address',
        200,
        alignment: Alignment.centerLeft,
      ),
      _getTitleItemWidget(
        'Pin',
        75,
      ),
      TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: _getTitleItemWidget(
          'State ' + (_isStateAscending ? '↓' : '↑'),
          150,
          alignment: Alignment.centerLeft,
        ),
        onPressed: () {
          _sortState();
          setState(() {});
        },
      ),
      _getTitleItemWidget(
        'GST Number',
        120,
        alignment: Alignment.centerLeft,
      ),
      _getTitleItemWidget(
        'Credit Period\n(Days)',
        100,
      ),
    ];
  }

  Widget _getTitleItemWidget(String label, double width, {Alignment alignment = Alignment.center,}) {
    return Container(
      child: Text(label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      width: width,
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      alignment: alignment,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5.0),
      child: Row(
        children: [
          // _columnItem(
          //   widget.customerList[index].company_name,
          //   200,
          //   index,
          // ),
        ],
      ),
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5.0),
      child: Row(
        children: [
          _columnItem(
            widget.customerList[index].company_name,
            250,
            index,
            alignment: Alignment.centerLeft,
          ),
          _columnItem(
            widget.customerList[index].contact_person,
            170,
            index,
            alignment: Alignment.centerLeft,
          ),
          _columnItem(
            widget.customerList[index].contact_phone,
            150,
            index,
          ),
          _columnItem(
            widget.customerList[index].address,
            200,
            index,
            alignment: Alignment.centerLeft,
          ),
          _columnItem(
            widget.customerList[index].pin.toString(),
            75,
            index,
          ),
          _columnItem(
            widget.customerList[index].state,
            150,
            index,
            alignment: Alignment.centerLeft,
          ),
          _columnItem(
            widget.customerList[index].gst,
            120,
            index,
            alignment: Alignment.centerLeft,
          ),
          _columnItem(
            widget.customerList[index].creditPeriod.toString(),
            100,
            index,
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
                          if (editAction(widget.customerList[index].id) !=
                              null) {
                            return editAction(widget.customerList[index].id);
                          } else {
                            return Container();
                          }
                        });
                  },
                  child: Icon(
                    Icons.edit,
                    size: 16,
                    color: widget.customerList[index].id != ""
                        ? Colors.blue
                        : Colors.green,
                  ),
                ),
                InkWell(
                  onTap: () => deleteAction(widget.customerList[index].id),
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
      ),
    );
  }

  Widget _columnItem(String item, double width, int index,
      {Alignment alignment = Alignment.center}) {
    String _columnName = widget.customerList[index].company_name.length >=
            widget.customerList[index].address.length
        ? widget.customerList[index].company_name
        : widget.customerList[index].address;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0,),
      child: Text(
        item,
        style: TextStyle(fontSize: 16),
      ),
      width: width,
      height: _columnName.length <= 30
          ? 30
          : _columnName.length <= 150
              ? 60
              : 150,
      alignment: alignment,
    );
  }

  void _sortCustomerName() {
    widget.customerList.sort((a, b) {
      return _isCustomerNameAscending
          ? a.company_name.toLowerCase().compareTo(b.company_name.toLowerCase())
          : b.company_name
              .toLowerCase()
              .compareTo(a.company_name.toLowerCase());
    });
    _isCustomerNameAscending = !_isCustomerNameAscending;
  }

  void _sortContactPerson() {
    widget.customerList.sort((a, b) {
      return _isContactPersonAscending
          ? a.contact_person
              .toLowerCase()
              .compareTo(b.contact_person.toLowerCase())
          : b.contact_person
              .toLowerCase()
              .compareTo(a.contact_person.toLowerCase());
    });
    _isContactPersonAscending = !_isContactPersonAscending;
  }

  void _sortState() {
    widget.customerList.sort((a, b) {
      return _isStateAscending
          ? a.state.toLowerCase().compareTo(b.state.toLowerCase())
          : b.state.toLowerCase().compareTo(a.state.toLowerCase());
    });
    _isStateAscending = !_isStateAscending;
  }

  void deleteAction(int id) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return KConfirmationPopup(
            id: id,
            deleteProvider: _deleteCustomer,
          );
        });
  }

  void _deleteCustomer(int id) {
    Provider.of<CustomerProvider>(context, listen: false).deleteCustomer(id);
  }

  Widget editAction(int id) {
    Customer customer;
    return Consumer<CustomerProvider>(builder: (ctx, provider, child) {
      return FutureBuilder(
        future: provider.getCustomerWithId(id),
        builder: (context, AsyncSnapshot<Customer> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasError) {
              return Center(child: Text("An error occured.\n$snapshot"));
              // return noData(context);
            } else if (snapshot.hasData) {
              customer = snapshot.data!;
              return CustomerCreate(
                customer: customer,
              );
            } else
              return Container();
          }
        },
      );
    });
  }
}
