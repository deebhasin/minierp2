import 'dart:io';

import 'package:erpapp/model/invoice_product.dart';
import 'package:erpapp/model/organization.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../model/challan.dart';
import '../model/customer.dart';
import '../model/invoice.dart';

class PDFCreate {
  PDFCreate();
  // PdfColor lineColor = PdfColor.fromRYB(0, 0, 1);

  Future<void> createPdf(
    Invoice invoice,
    List<InvoiceProduct> invoiceProductList,
    Organization org,
    Customer customer,
    Function onPdfCreate,
  ) async {
    print(
        "in PDF Create invoice Product List Length: ${invoiceProductList.length}");

    final pdf = pw.Document();
    const double width = 1200;
    String address2 = "";
    print("PDF Created");

    // final Uint8List fontData =
    //     File('asset/fonts/OpenSans-Regular.ttf').readAsBytesSync();
    // final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => pw.Container(
          width: width,
          decoration: pw.BoxDecoration(border: pw.Border.all()),
          child: pw.Column(children: [
            pw.Container(
              width: width,
              height: 90,
              decoration: pw.BoxDecoration(border: pw.Border.all()),
              padding: pw.EdgeInsets.all(4),
              child: pw.Column(
                children: [
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                      children: [
                        pw.Text(
                          "GSTIN: ${org.gst}",
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                        pw.Text(
                          "TAX INVOICE",
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                        pw.Text(
                          "ORIGINAL",
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ]),
                  pw.SizedBox(height: 4),
                  pw.FittedBox(
                    child: pw.Text(
                      org.name,
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  pw.FittedBox(
                    child: pw.Text(
                      org.tagLine,
                      // textScaleFactor: 3,
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  pw.FittedBox(
                    child: pw.Text(
                      "${org.address}, ${org.city}, ${org.state}",
                      // textScaleFactor: 3,
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  pw.Text(
                    "Factory No:-${org.phone} Mob No:- ${org.mobile}",
                    // textScaleFactor: 3,
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            pw.Row(children: [
              pw.Container(
                width: 250,
                height: 15,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.FittedBox(
                  child: pw.Text(
                    "Details of Receiver:- ${invoice.customerName}",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
              pw.Container(
                width: 116,
                height: 15,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  "Invoice No.",
                  // textScaleFactor: 3,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Container(
                width: 116,
                height: 15,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.FittedBox(
                  child: pw.Text(
                    "${invoice.invoiceNo}",
                    // textScaleFactor: 3,
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 10,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
              ),
            ]),
            pw.Row(children: [
              pw.Container(
                width: 50,
                height: 50,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  "Name\n&\nAddress",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Column(children: [
                pw.Container(
                  width: 200,
                  height: 12.5,
                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                  child: pw.FittedBox(
                    child: pw.Text(
                      "Mobile No.- ${customer.contact_phone}",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                pw.Container(
                  width: 200,
                  height: 12.5,
                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                  child: pw.FittedBox(
                    child: pw.Text(
                      "${invoice.customerAddress}",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                pw.Container(
                  width: 200,
                  height: 12.5,
                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                  child: address2 == ""
                      ? pw.Container()
                      : pw.FittedBox(
                          child: pw.Text(
                            address2,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                ),
                pw.Container(
                  width: 200,
                  height: 12.5,
                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                  child: pw.FittedBox(
                    child: pw.Text(
                      "Delhi",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ]),
              pw.Column(children: [
                pw.Container(
                  width: 116,
                  height: 12.5,
                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                  child: pw.Text(
                    "Date",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 10,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                pw.Container(
                  width: 116,
                  height: 12.5,
                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                  child: pw.Text(
                    "State Code",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 10,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                pw.Container(
                  width: 116,
                  height: 12.5,
                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                  child: pw.Text(
                    "Transport Mode",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 10,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                pw.Container(
                  width: 116,
                  height: 12.5,
                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                  child: pw.Text(
                    "Vehicle No.",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 10,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
              ]),
              pw.Column(children: [
                pw.Container(
                  width: 116,
                  height: 12.5,
                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                  child: pw.Text(
                    "${DateFormat('dd-MM-yyyy').format(invoice.invoiceDate!)}",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 10,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                pw.Container(
                  width: 116,
                  height: 12.5,
                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                  child: pw.Text(
                    "${customer.stateCode}",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 10,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                pw.Container(
                  width: 116,
                  height: 12.5,
                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                  child: pw.Text(
                    "${invoice.transportMode}",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 10,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                pw.Container(
                  width: 116,
                  height: 12.5,
                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                  child: pw.Text(
                    "${invoice.vehicleNumber}",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 10,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
              ]),
            ]),
            pw.Row(children: [
              pw.Column(children: [
                pw.Container(
                  width: 50,
                  height: 15,
                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                  child: pw.Text(
                    "State",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 10,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                pw.Container(
                  width: 50,
                  height: 15,
                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                  child: pw.Text(
                    "GST No.",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 10,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
              ]),
              pw.Column(children: [
                pw.Row(children: [
                  pw.Container(
                    width: 66,
                    height: 15,
                    decoration: pw.BoxDecoration(border: pw.Border.all()),
                    child: pw.Text(
                      "${customer.state}",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                    // child: pw.FittedBox(
                    //   child: pw.Text(
                    //     "${customer.state}",
                    //     style: pw.TextStyle(
                    //       fontWeight: pw.FontWeight.bold,
                    //       fontSize: 10,
                    //     ),
                    //     textAlign: pw.TextAlign.center,
                    //   ),
                    // ),
                  ),
                  pw.Container(
                    width: 67,
                    height: 15,
                    decoration: pw.BoxDecoration(border: pw.Border.all()),
                    child: pw.Text(
                      "PIN Code",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.Container(
                    width: 67,
                    height: 15,
                    decoration: pw.BoxDecoration(border: pw.Border.all()),
                    child: pw.Text(
                      "${customer.pin}",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ]),
                pw.Container(
                  width: 200,
                  height: 15,
                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                  child: pw.Text(
                    "${customer.gst}",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 10,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
              ]),
              pw.Container(
                width: 116,
                height: 30,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  "Delivery Challan Details",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Container(
                width: 116,
                height: 30,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  "Challan details on backside of the invoice.",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                  textAlign: pw.TextAlign.center,
                  softWrap: true,
                ),
              ),
            ]),
            pw.Row(children: [
              pw.Container(
                width: 250,
                height: 15,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  "Tax is payable on reverse charge :-",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Container(
                width: 232,
                height: 15,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  "${invoice.taxPayableOnReverseCharges}",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
            ]),
            pw.Row(children: [
              pw.Container(
                width: 50,
                height: 30,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  "HSN Code",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                  textAlign: pw.TextAlign.center,
                  softWrap: true,
                ),
              ),
              pw.Container(
                width: 200,
                height: 30,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  "Description of Goods",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Container(
                width: 77,
                height: 30,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  "Total Qty",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Container(
                width: 77,
                height: 30,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  "Rate per Unit",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Container(
                width: 78,
                height: 30,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  "Amount",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
            ]),
            pw.Column(
              children: _getInvoiceProductList(invoiceProductList),
            ),
            pw.Row(children: [
              pw.Container(
                width: 250,
                height: 15,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  "Bank Details:-",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                  textAlign: pw.TextAlign.center,
                  softWrap: true,
                ),
              ),
              pw.Container(
                width: 154,
                height: 15,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  "Total Amount Before Tax",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Container(
                padding: pw.EdgeInsets.fromLTRB(0, 0, 5, 0),
                width: 78,
                height: 15,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  "${invoice.totalBeforeTax}",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                  textAlign: pw.TextAlign.right,
                ),
              ),
            ]),
            pw.Row(children: [
              pw.Column(children: [
                pw.Row(children: [
                  pw.Container(
                    width: 125,
                    height: 15,
                    decoration: pw.BoxDecoration(border: pw.Border.all()),
                    child: pw.Text(
                      "Name",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.Container(
                    width: 125,
                    height: 15,
                    decoration: pw.BoxDecoration(border: pw.Border.all()),
                    child: pw.Text(
                      "${org.name}",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.Container(
                    width: 78,
                    height: 15,
                    decoration: pw.BoxDecoration(border: pw.Border.all()),
                    child: pw.Text(
                      "Add : CGST",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.Container(
                    width: 76,
                    height: 15,
                    decoration: pw.BoxDecoration(border: pw.Border.all()),
                    child: pw.Text(
                      org.stateCode == customer.stateCode
                          ? (invoice.taxAmount / 2).toString()
                          : "-",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ]),
                pw.Row(children: [
                  pw.Container(
                    width: 125,
                    height: 15,
                    decoration: pw.BoxDecoration(border: pw.Border.all()),
                    child: pw.Text(
                      "Bank Name",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.Container(
                    width: 125,
                    height: 15,
                    decoration: pw.BoxDecoration(border: pw.Border.all()),
                    child: pw.Text(
                      "${org.bankName}",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.Container(
                    width: 78,
                    height: 15,
                    decoration: pw.BoxDecoration(border: pw.Border.all()),
                    child: pw.Text(
                      "Add : SGST",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.Container(
                    width: 76,
                    height: 15,
                    decoration: pw.BoxDecoration(border: pw.Border.all()),
                    child: pw.Text(
                      org.stateCode == customer.stateCode
                          ? (invoice.taxAmount / 2).toString()
                          : "-",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ]),
                pw.Row(children: [
                  pw.Container(
                    width: 125,
                    height: 15,
                    decoration: pw.BoxDecoration(border: pw.Border.all()),
                    child: pw.Text(
                      "Bank Account No.",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.Container(
                    width: 125,
                    height: 15,
                    decoration: pw.BoxDecoration(border: pw.Border.all()),
                    child: pw.Text(
                      "${org.bankAccountNumber}",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.Container(
                    width: 78,
                    height: 15,
                    decoration: pw.BoxDecoration(border: pw.Border.all()),
                    child: pw.Text(
                      "Add : IGST",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.Container(
                    width: 76,
                    height: 15,
                    decoration: pw.BoxDecoration(border: pw.Border.all()),
                    child: pw.Text(
                      org.stateCode != customer.stateCode
                          ? (invoice.taxAmount).toString()
                          : "-",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ]),
              ]),
              pw.Container(
                padding: pw.EdgeInsets.fromLTRB(0, 0, 5, 0),
                width: 78,
                height: 45,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        invoice.taxAmount.toString(),
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 10,
                        ),
                        textAlign: pw.TextAlign.right,
                      ),
                    ]),
              ),
            ]),
            pw.Row(children: [
              pw.Container(
                width: 125,
                height: 15,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  "IFSC CODE",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Container(
                width: 125,
                height: 15,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  "${org.bankIfscCode}",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Container(
                width: 154,
                height: 15,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  "Total Value of Invoice",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Container(
                padding: pw.EdgeInsets.fromLTRB(0, 0, 5, 0),
                width: 78,
                height: 15,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  invoice.invoiceAmount.toStringAsFixed(2),
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                  textAlign: pw.TextAlign.right,
                ),
              ),
            ]),
            pw.Row(children: [
              pw.Container(
                width: 125,
                height: 15,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  "BRANCH",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Container(
                width: 125,
                height: 15,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  "${org.bankBranch}",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Container(
                width: 154,
                height: 15,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  "( - / + ) Round Off Amount",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Container(
                padding: pw.EdgeInsets.fromLTRB(0, 0, 5, 0),
                width: 78,
                height: 15,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  (double.parse((invoice.invoiceAmount).toStringAsFixed(0)) -
                          invoice.invoiceAmount)
                      .toStringAsFixed(2),
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                  textAlign: pw.TextAlign.right,
                ),
              ),
            ]),
            pw.Row(children: [
              pw.Container(
                width: 250,
                height: 15,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  " ",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Container(
                width: 154,
                height: 15,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  "Net Value After Round Up",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Container(
                padding: pw.EdgeInsets.fromLTRB(0, 0, 5, 0),
                width: 78,
                height: 15,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  (invoice.invoiceAmount +
                          (double.parse(
                                  (invoice.invoiceAmount).toStringAsFixed(0)) -
                              invoice.invoiceAmount))
                      .toInt()
                      .toString(),
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                  textAlign: pw.TextAlign.right,
                ),
              ),
            ]),
            pw.Row(children: [
              pw.Container(
                width: 125,
                height: 30,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  "Total Amount In Words :-",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Container(
                width: 357,
                height: 30,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  numberToWords(invoice.invoiceAmount +
                      (double.parse(
                              (invoice.invoiceAmount).toStringAsFixed(0)) -
                          invoice.invoiceAmount)),
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
            ]),
            pw.Row(children: [
              pw.Container(
                padding: pw.EdgeInsets.fromLTRB(5, 1, 0, 1),
                width: 250,
                height: 63,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  "Terms and Conditions\n${invoice.termsAndConditions}",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                  textAlign: pw.TextAlign.left,
                ),
              ),
              pw.Container(
                width: 232,
                height: 63,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  "For ${org.name}\n\n\n\n\n\nAuthorised Signatory",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
            ]),
          ]),
        ),
      ),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => pw.Container(
          width: width,
          decoration: pw.BoxDecoration(border: pw.Border.all()),
          child: pw.Column(
            children: [
              pw.Row(
                children: [
                  pw.Container(
                    width: 50,
                    height: 30,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(),
                    ),
                    child: pw.Text(
                      "Challan #",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                      textAlign: pw.TextAlign.center,
                      softWrap: true,
                    ),
                  ),
                  pw.Container(
                    width: 100,
                    height: 30,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(),
                    ),
                    child: pw.Text(
                      "Challan Date",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.Container(
                    width: 120,
                    height: 30,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(),
                    ),
                    child: pw.Text(
                      "Total Before Tax",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.Container(
                    width: 92,
                    height: 30,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(),
                    ),
                    child: pw.Text(
                      "Tax",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.Container(
                    padding: pw.EdgeInsets.fromLTRB(0, 0, 5, 0),
                    width: 120,
                    height: 30,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(),
                    ),
                    child: pw.Text(
                      "Challan Amount",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ]
              ),
              pw.Column(
                children: _getChallanList(invoice.challanList),
              ),
            ],

          ),
        ),
      ),
    );
    String pdfMsg = "";
    if(invoice.pdfFileLocation == "") {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String filePath = join(documentsDirectory.path, "invoices/",
          "${invoice.invoiceNo}-${customer.shortCompanyName}-${DateFormat('dd-MM-yyyy').format(invoice.invoiceDate!)}.pdf");
      final file = await File(filePath).create(recursive: true);

      invoice.pdfFileLocation = filePath;
      await file.writeAsBytes(await pdf.save());
    }
    else{
      pdfMsg = "PDF File Exists";
    }
    print("PDF Message: $pdfMsg");
    onPdfCreate(invoice, pdfMsg);
  }

  List<pw.Widget> _getInvoiceProductList(
      List<InvoiceProduct> invoiceProductList) {
    List<pw.Widget> widgetList = [];

    for (int i = invoiceProductList.length; i <= 9; i++) {
      invoiceProductList.add(InvoiceProduct());
    }

    invoiceProductList.forEach((ip) {
      widgetList.add(pw.Row(
        children: [
          pw.Container(
            width: 50,
            height: 30,
            decoration: pw.BoxDecoration(
                border: pw.Border.symmetric(
                    vertical: pw.BorderSide(), horizontal: pw.BorderSide.none)),
            child: pw.Text(
              ip.hsnCode,
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
              textAlign: pw.TextAlign.center,
              softWrap: true,
            ),
          ),
          pw.Container(
            width: 200,
            height: 30,
            decoration: pw.BoxDecoration(
                border: pw.Border.symmetric(
                    vertical: pw.BorderSide(), horizontal: pw.BorderSide.none)),
            child: pw.Text(
              ip.productName,
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
              textAlign: pw.TextAlign.center,
            ),
          ),
          pw.Container(
            width: 77,
            height: 30,
            decoration: pw.BoxDecoration(
                border: pw.Border.symmetric(
                    vertical: pw.BorderSide(), horizontal: pw.BorderSide.none)),
            child: pw.Text(
              ip.quantity == 0 ? " " : ip.quantity.toString(),
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
              textAlign: pw.TextAlign.center,
            ),
          ),
          pw.Container(
            width: 77,
            height: 30,
            decoration: pw.BoxDecoration(
                border: pw.Border.symmetric(
                    vertical: pw.BorderSide(), horizontal: pw.BorderSide.none)),
            child: pw.Text(
              ip.quantity == 0 ? " " : ip.pricePerUnit.toString(),
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
              textAlign: pw.TextAlign.center,
            ),
          ),
          pw.Container(
            padding: pw.EdgeInsets.fromLTRB(0, 0, 5, 0),
            width: 78,
            height: 30,
            decoration: pw.BoxDecoration(
                border: pw.Border.symmetric(
                    vertical: pw.BorderSide(), horizontal: pw.BorderSide.none)),
            child: pw.Text(
              ip.quantity == 0 ? " " : ip.totalBeforeTax.toString(),
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
              textAlign: pw.TextAlign.right,
            ),
          ),
        ],
      ));
    });
    return widgetList;
  }


  List<pw.Widget> _getChallanList(List<Challan> _challanList) {
    List<pw.Widget> widgetList = [];

    _challanList.forEach((_challan) {
      widgetList.add(pw.Row(
        children: [
          pw.Container(
            width: 50,
            height: 30,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(),
            ),
            child: pw.Text(
              _challan.challanNo,
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
              textAlign: pw.TextAlign.center,
              softWrap: true,
            ),
          ),
          pw.Container(
            width: 100,
            height: 30,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(),
            ),
            child: pw.Text(
              DateFormat("dd-MM-yyyy").format(_challan.challanDate!),
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
              textAlign: pw.TextAlign.center,
            ),
          ),
          pw.Container(
            width: 120,
            height: 30,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(),
            ),
            child: pw.Text(
              _challan.total.toString(),
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
              textAlign: pw.TextAlign.center,
            ),
          ),
          pw.Container(
            width: 92,
            height: 30,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(),
            ),
            child: pw.Text(
              _challan.taxAmount.toString(),
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
              textAlign: pw.TextAlign.center,
            ),
          ),
          pw.Container(
            padding: pw.EdgeInsets.fromLTRB(0, 0, 5, 0),
            width: 120,
            height: 30,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(),
            ),
            child: pw.Text(
              _challan.challanAmount.toString(),
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
              textAlign: pw.TextAlign.right,
            ),
          ),
          // KPdfContainerTextWiget(label: "Disco"),
        ],
      ));
    });
    return widgetList;
  }

  String numberToWords(double num) {
    String words = "Rupees ";
    // num = 355842522.0;
    int temp = num.toInt();
    int paiseVal = ((num - temp) * 100).toInt();
    List<String> onedigit = [
      "Zero",
      "One",
      "Two",
      "Three",
      "Four",
      "Five",
      "Six",
      "Seven",
      "Eight",
      "Nine"
    ];
//string type array for two digits numbers
//the first index is empty because it makes indexing easy
    List<String> twodigits = [
      "Ten",
      "Eleven",
      "Twelve",
      "Thirteen",
      "Fourteen",
      "Fifteen",
      "Sixteen",
      "Seventeen",
      "Eighteen",
      "Nineteen"
    ];
//string type array of tens multiples
//the first two indexes are empty because it makes indexing easy
    List<String> multipleoftens = [
      "",
      "",
      "Twenty",
      "Thirty",
      "Forty",
      "Fifty",
      "Sixty",
      "Seventy",
      "Eighty",
      "Ninety"
    ];
//string type array of power of tens
    List<String> poweroftens = ["Hundred", "Thousand", "Lakh", "Crore"];

    String oneToNinetyNine(int val) {
      String oneToNinetyNineWords = "";
      if (val >= 20 && val <= 99) {
        print(val);
        // temp = temp ~/ 10;
        if (val > 0) {
          oneToNinetyNineWords += multipleoftens[val ~/ 10] + " ";
        }
        val = val.remainder(10);
      }
      if (val >= 10 && val <= 19) {
        print(val);
        // temp = temp ~/ 10;
        if (val > 0) {
          oneToNinetyNineWords += twodigits[val.remainder(10)] + " ";
        }
        // val = val.remainder(10);
      }
      if (val >= 1 && val <= 9) {
        print(val);
        // temp = temp ~/ 10;
        if (val > 0) {
          oneToNinetyNineWords += onedigit[val] + " ";
        }
      }
      return oneToNinetyNineWords;
    }

    if (temp >= 10000000 && temp <= 999999999) {
      print("Actual Value of TEmp $temp");
      int remainder = temp.remainder(10000000);
      temp = temp ~/ 10000000;
      print("Temp ~/10000000 $temp");
      words += "${oneToNinetyNine(temp)}${poweroftens[3]} ";
      temp = remainder;
      print("Remainder MOd 10000000 multipleoftens: $temp");
    }
    if (temp >= 100000 && temp <= 9999999) {
      print("Actual Value of TEmp $temp");
      int remainder = temp.remainder(100000);
      temp = temp ~/ 100000;
      print("Temp ~/100000 $temp");
      words += "${oneToNinetyNine(temp)}${poweroftens[2]} ";
      temp = remainder;
      print("Remainder MOd 100000 multipleoftens: $temp");
    }
    if (temp >= 1000 && temp <= 99999) {
      print("Actual Value of TEmp $temp");
      int remainder = temp.remainder(1000);
      temp = temp ~/ 1000;
      print("Temp ~/1000 $temp");
      words += "${oneToNinetyNine(temp)}${poweroftens[1]} ";
      temp = remainder;
      print("Remainder MOd 1000 multipleoftens: $temp");
    }
    if (temp >= 100 && temp <= 999) {
      print(temp);
      int remainder = temp.remainder(100);
      temp = temp ~/ 100;
      if (temp > 0) {
        words += onedigit[temp];
        words += " ${poweroftens[0]} ";
      }
      temp = remainder;
    }
    words += oneToNinetyNine(temp);

    if (paiseVal != 0) {
      words += "and Paise ${oneToNinetyNine(paiseVal)}";
    }

    words += "only";

    print("Number to Words: ${words}");

    return words;
  }
}

