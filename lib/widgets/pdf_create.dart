import 'dart:io';
import 'dart:typed_data';

import 'package:erpapp/model/organization.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../model/customer.dart';
import '../model/invoice.dart';

class PDFCreate {
  PDFCreate();
  // PdfColor lineColor = PdfColor.fromRYB(0, 0, 1);

  Future<void> createPdf(
      Invoice invoice, Organization org, Customer customer) async {
    final pdf = pw.Document();
    const double width = 1200;
    print("PDF Created");

    final Uint8List fontData =
        File('asset/fonts/OpenSans-Regular.ttf').readAsBytesSync();
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

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
                  child: pw.FittedBox(
                    child: pw.Text(
                      "-",
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
            pw.Row(
              children: [
                pw.Column(
                  children: [
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
                  ]
                ),
                pw.Column(
                    children: [
                      pw.Row(
                        children: [
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
                        ]
                      ),
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
                    ]
                ),
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
              ]
            ),
            pw.Row(
              children: [
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
              ]
            ),
            pw.Row(
              children: [
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
              ]
            ),
          ]),
        ),
      ),
    );

    // final file = File('example.pdf');
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final file = File(join(documentsDirectory.path,
        "${invoice.invoiceNo}-${invoice.customerName}-${DateFormat('dd-MM-yyyy').format(invoice.invoiceDate!)}.pdf"));

    await file.writeAsBytes(await pdf.save());
  }
}
