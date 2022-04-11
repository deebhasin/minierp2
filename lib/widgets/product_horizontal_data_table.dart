import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:provider/provider.dart';

import '../kwidgets/k_confirmation_popup.dart';
import '../providers/product_provider.dart';
import '../screens/productcreate.dart';
import '../model/product.dart';

class ProductHorizontalDataTable extends StatefulWidget {
  List<Product> productList;
  final double leftHandSideColumnWidth;
  final double rightHandSideColumnWidth;

  ProductHorizontalDataTable({
    Key? key,
    required this.leftHandSideColumnWidth,
    required this.rightHandSideColumnWidth,
    required this.productList,
  }) : super(key: key);

  @override
  State<ProductHorizontalDataTable> createState() =>
      _ProductHorizontalDataTableState();
}

class _ProductHorizontalDataTableState
    extends State<ProductHorizontalDataTable> {
  HDTRefreshController _hdtRefreshController = HDTRefreshController();

  bool _isCustomerNameAscending = true;
  bool _isContactPersonAscending = true;
  bool _isStateAscending = true;

  List<ScrollController> _scrollControllerList = [];

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
        itemCount: widget.productList.length,
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
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            child: _getTitleItemWidget(
              'Product Name ' + (_isCustomerNameAscending ? '↓' : '↑'),
              200,
            ),
            onPressed: () {
              _sortProductName();
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
          'Unit ' + (_isContactPersonAscending ? '↓' : '↑'),
          150,
        ),
        onPressed: () {
          _sortUnit();
          setState(() {});
        },
      ),
      _getTitleItemWidget(
        'Price Per Unit',
        150,
      ),
      _getTitleItemWidget(
        'HSN Code',
        150,
      ),
      _getTitleItemWidget(
        'GST %',
        150,
      ),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      // color: Colors.grey,
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      width: width,
      height: 50,
      // padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
      alignment: Alignment.center,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5.0),
      child: Row(
        children: [
          _columnItem(
            widget.productList[index].name,
            200,
            index,
          ),
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
            widget.productList[index].unit,
            150,
            index,
          ),
          _columnItem(
            widget.productList[index].pricePerUnit.toString(),
            150,
            index,
          ),
          _columnItem(
            widget.productList[index].HSN,
            150,
            index,
          ),
          _columnItem(
            widget.productList[index].GST,
            150,
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
                          if (editAction(widget.productList[index].id) !=
                              null) {
                            return editAction(widget.productList[index].id);
                          } else {
                            return Container();
                          }
                        });
                  },
                  child: Icon(
                    Icons.edit,
                    size: 16,
                    color: widget.productList[index].id != ""
                        ? Colors.blue
                        : Colors.green,
                  ),
                ),
                InkWell(
                  onTap: () => deleteAction(widget.productList[index].id),
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

  Widget _columnItem(String label, double width, int index) {
    return Container(
      // color: Colors.grey,
      child: Text(label),
      width: width,
      height: 30,
      // padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.center,
    );
  }

  void _sortProductName() {
    widget.productList.sort((a, b) {
      return _isCustomerNameAscending
          ? a.name.toLowerCase().compareTo(b.name.toLowerCase())
          : b.name.toLowerCase().compareTo(a.name.toLowerCase());
    });
    _isCustomerNameAscending = !_isCustomerNameAscending;
  }

  void _sortUnit() {
    widget.productList.sort((a, b) {
      return _isContactPersonAscending
          ? a.unit.toLowerCase().compareTo(b.unit.toLowerCase())
          : b.unit.toLowerCase().compareTo(a.unit.toLowerCase());
    });
    _isContactPersonAscending = !_isContactPersonAscending;
  }

  void deleteAction(int id) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return KConfirmationPopup(
            id: id,
            deleteProvider: _deleteProduct,
          );
        });
  }

  void _deleteProduct(int id) {
    Provider.of<ProductProvider>(context, listen: false).deleteProduct(id);
  }

  Widget editAction(int id) {
    Product product;
    return Consumer<ProductProvider>(builder: (ctx, provider, child) {
      return FutureBuilder(
        future: provider.getProductById(id),
        builder: (context, AsyncSnapshot<Product> snapshot) {
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
              product = snapshot.data!;
              return ProductCreate(
                product: product,
              );
            } else
              return Container();
          }
        },
      );
    });
  }
}
