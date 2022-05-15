import 'package:erpapp/model/organization.dart';
import 'package:erpapp/providers/customer_provider.dart';
import 'package:erpapp/providers/org_provider.dart';
import 'package:erpapp/widgets/pdf_create.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/customer.dart';
import '../model/invoice.dart';
import '../providers/invoice_provider.dart';
import '../kwidgets/k_confirmation_popup.dart';
import '../screens/invoicecreate.dart';

class InvoiceHorizontalDataTable extends StatefulWidget {
  List<Invoice> invoiceList;
  final double leftHandSideColumnWidth;
  final double rightHandSideColumnWidth;
  InvoiceHorizontalDataTable({
    Key? key,
    required this.leftHandSideColumnWidth,
    required this.rightHandSideColumnWidth,
    required this.invoiceList,
  }) : super(key: key);

  @override
  State<InvoiceHorizontalDataTable> createState() =>
      _InvoiceHorizontalDataTableState();
}

class _InvoiceHorizontalDataTableState
    extends State<InvoiceHorizontalDataTable> {
  HDTRefreshController _hdtRefreshController = HDTRefreshController();

  // final currencyFormat = NumberFormat("#,##0.00", "en_US");
  final currencyFormat = NumberFormat("#,##0", "en_US");

  bool _isChallanNoAscending = false;
  bool _isInvoiceDateAscending = false;
  bool _isCustomerNameAscending = false;
  bool _isInvoiceNoAscending = false;

  String sortType = "";
  bool sortAscDesc = true;

  PDFCreate pdfCreate = PDFCreate();

  List<bool> _isCheckedList = [];
  late Organization org;
  late List<Customer> customerList;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) => _sortStatus());
    org = Provider.of<OrgProvider>(context, listen: false).getOrg;
    customerList =
        Provider.of<CustomerProvider>(context, listen: false).customerList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      width: MediaQuery.of(context).size.width * 0.835,
      child: HorizontalDataTable(
        leftHandSideColumnWidth: widget.leftHandSideColumnWidth,
        rightHandSideColumnWidth: widget.rightHandSideColumnWidth,
        isFixedHeader: true,
        headerWidgets: _getTitleWidget(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: widget.invoiceList.length,
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
          thickness: 2.0,
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
          'Invoice # ' + (_isInvoiceNoAscending ? '↓' : '↑'),
          150,
          alignment: Alignment.centerLeft,
        ),
        onPressed: () {
          _sortInvoiceNo();
          setState(() {});
        },
      ),
      TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: _getTitleItemWidget(
          'Invoice Date ' + (_isInvoiceDateAscending ? '↓' : '↑'),
          150,
        ),
        onPressed: () {
          _sortInvoiceDate();
          setState(() {});
        },
      ),
      TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: _getTitleItemWidget(
          'Customer Name ' + (_isCustomerNameAscending ? '↓' : '↑'),
          200,
          alignment: Alignment.centerLeft,
        ),
        onPressed: () {
          _sortCustomerName();
          setState(() {});
        },
      ),
      _getTitleItemWidget(
        'Customer Address',
        200,
        alignment: Alignment.centerLeft,
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
      _getTitleItemWidget(
        '',
        50,
      ),
      _getTitleItemWidget(
        '',
        70,
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
    return Row();
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: [
        _columnItem(
          widget.invoiceList[index].invoiceNo,
          150,
          index,
          alignment: Alignment.centerLeft,
        ),
        _columnItem(
          DateFormat("dd-MM-yyyy")
              .format(widget.invoiceList[index].invoiceDate!),
          150,
          index,
        ),
        _columnItem(
          widget.invoiceList[index].customerName,
          200,
          index,
          alignment: Alignment.centerLeft,
        ),
        _columnItem(
          widget.invoiceList[index].customerAddress,
          200,
          index,
          alignment: Alignment.centerLeft,
        ),
        _columnItem(
          currencyFormat.format(widget.invoiceList[index].totalBeforeTax),
          150,
          index,
          alignment: Alignment.centerRight,
        ),
        _columnItem(
          currencyFormat.format(widget.invoiceList[index].taxAmount),
          140,
          index,
          alignment: Alignment.centerRight,
        ),
        _columnItem(
          currencyFormat.format(widget.invoiceList[index].invoiceAmount),
          150,
          index,
          alignment: Alignment.centerRight,
        ),
        Container(
          width: 50,
          child: InkWell(
            onTap: () => createPDF(widget.invoiceList[index]),
            child: Icon(
              Icons.picture_as_pdf,
              size: 16,
              color: Colors.red,
            ),
          ),
        ),
        Container(
          width: 70,
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
                        return editAction(widget.invoiceList[index]);
                      });
                },
                child: Icon(
                  widget.invoiceList[index].pdfFileLocation != ""
                      ? Icons.remove_red_eye_outlined
                      : Icons.edit,
                  size: 16,
                  color: widget.invoiceList[index].pdfFileLocation != ""
                      ? Colors.blue
                      : Colors.green,
                ),
              ),
              widget.invoiceList[index].pdfFileLocation != ""
                  ? Icon(
                      Icons.no_cell_outlined,
                      size: 16,
                      color: Colors.blueGrey,
                    )
                  : InkWell(
                      onTap: () => deleteAction(widget.invoiceList[index].id),
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
      height: widget.invoiceList[index].customerAddress.length <= 20
          ? 30
          : widget.invoiceList[index].customerAddress.length <= 40
              ? 60
              : 150,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 0,
      ),
      alignment: alignment,
    );
  }

  void _sortStatus() async {
    sortType =
        await Provider.of<InvoiceProvider>(context, listen: false).getSortType;
    sortAscDesc = await Provider.of<InvoiceProvider>(context, listen: false)
        .getIsAscending;
    print("SOrt Type in _sortSttus: $sortType");

    if (sortType == "_sortChallanNo") {
      _isChallanNoAscending = sortAscDesc;
      _sortInvoiceNo();
    } else if (sortType == "_sortChallanDate") {
      _isInvoiceDateAscending = sortAscDesc;
      _sortInvoiceDate();
    } else if (sortType == "_sortCustomerName") {
      _isCustomerNameAscending = sortAscDesc;
      _sortCustomerName();
    } else if (sortType == "_sortInvoiceNo") {
      _isInvoiceNoAscending = sortAscDesc;
      _sortInvoiceNo();
    }
    setState(() {});
  }

  void _sortInvoiceNo() {
    Provider.of<InvoiceProvider>(context, listen: false).setSortType =
        "_sortInvoiceNo";
    Provider.of<InvoiceProvider>(context, listen: false).setIsAscending =
        _isInvoiceNoAscending;

    widget.invoiceList.sort((a, b) {
      return _isInvoiceNoAscending
          ? a.invoiceNo.compareTo(b.invoiceNo)
          : b.invoiceNo.compareTo(a.invoiceNo);
    });
    _isInvoiceNoAscending = !_isInvoiceNoAscending;
  }

  void _sortInvoiceDate() {
    Provider.of<InvoiceProvider>(context, listen: false).setSortType =
        "_sortChallanDate";
    Provider.of<InvoiceProvider>(context, listen: false).setIsAscending =
        _isInvoiceDateAscending;

    widget.invoiceList.sort((a, b) {
      return _isInvoiceDateAscending
          ? a.invoiceDate!.compareTo(b.invoiceDate!)
          : b.invoiceDate!.compareTo(a.invoiceDate!);
    });
    _isInvoiceDateAscending = !_isInvoiceDateAscending;
  }

  void _sortCustomerName() {
    Provider.of<InvoiceProvider>(context, listen: false).setSortType =
        "_sortCustomerName";
    Provider.of<InvoiceProvider>(context, listen: false).setIsAscending =
        _isCustomerNameAscending;

    widget.invoiceList.sort((a, b) {
      return _isCustomerNameAscending
          ? a.customerName.compareTo(b.customerName)
          : b.customerName.compareTo(a.customerName);
    });
    _isCustomerNameAscending = !_isCustomerNameAscending;
  }

  void deleteAction(int id) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return KConfirmationPopup(
            id: id,
            deleteProvider: deleteInvoice,
          );
        });
  }

  void deleteInvoice(int id) {
    Provider.of<InvoiceProvider>(context, listen: false).deleteInvoice(id);
  }

  Widget editAction(Invoice invoice) {
    return InvoiceCreate(
      invoice: invoice,
    );
  }

  void createPDF(Invoice invoice) async {
    await pdfCreate.createPdf(
      invoice,
      await Provider.of<InvoiceProvider>(context, listen: false)
          .getInvoiceProductList(invoice.id),
      org,
      customerList.firstWhere(
          (element) => element.company_name == invoice.customerName),
      onPdfCreate,
    );
  }

  void onPdfCreate(Invoice invoice) async {
    await Provider.of<InvoiceProvider>(context, listen: false)
        .updateInvoice(invoice);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
