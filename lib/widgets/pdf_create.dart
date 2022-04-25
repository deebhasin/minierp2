import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../model/invoice.dart';

class PDFCreate {
  PDFCreate();

  Future<void> createPdf(Invoice invoice) async {
    final pdf = pw.Document();
    print("PDF Created");

    final Uint8List fontData =
        File('asset/fonts/OpenSans-Regular.ttf').readAsBytesSync();
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Text(
            'Hello World! Invoice No: ${invoice.invoiceNo}',
            style: pw.TextStyle(font: ttf),
          ),
        ),
      ),
    );

    // final file = File('example.pdf');
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final file = File(join(documentsDirectory.path, "example.pdf"));

    await file.writeAsBytes(await pdf.save());
  }
}
