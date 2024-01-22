




import 'package:get/get.dart';
import 'package:khata_app/features/pos/presentation/receipt_pdf.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';

class PrintingTest extends StatefulWidget {
  const PrintingTest({super.key});

  @override
  State<PrintingTest> createState() => _PrintingTestState();
}

class _PrintingTestState extends State<PrintingTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ElevatedButton(onPressed: () async {
          // Get.to(()=>ReceiptPdf());

          final doc = pw.Document();

          doc.addPage(pw.Page(
              pageFormat: PdfPageFormat.a4,
              build: (pw.Context context) {
                return generatePdf(); // Center
              })); // Page

          await Printing.layoutPdf(
              onLayout: (PdfPageFormat format) async => doc.save());

        }, child: Text('print'))
      ),
    );
  }

  pw.Widget generatePdf() {
    return pw.Container(
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text('Company Name'),
          pw.Text('Company Address'),
          pw.SizedBox(height: 20),
          pw.Text('VAT Number'),
          pw.Text('ABBREVIATED TAX INVOICE'),
          pw.SizedBox(height: 20),
          pw.Padding(
            padding: pw.EdgeInsets.symmetric(horizontal: 18.0),
            child: pw.Row(
              children: [
                pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Bill No'),
                    pw.Text('Bill No'),
                    pw.Text('Bill No'),
                    pw.Text('Bill No'),
                    pw.Text('Bill No'),
                    pw.Text('Bill No'),
                    pw.Text('Bill No'),
                    pw.Text('Bill No'),
                  ],
                ),
                pw.SizedBox(width: 20),
                pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(': Bill No'),
                    pw.Text(': Bill No'),
                    pw.Text(': Bill No'),
                    pw.Text(': Bill No'),
                    pw.Text(': Bill No'),
                    pw.Text(': Bill No'),
                    pw.Text(': Bill No'),
                    pw.Text(': Bill No'),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          // Manual table creation

          pw.Center(
            child: pw.Table(
              border: pw.TableBorder.all(
                  color: PdfColors.white
              ),
              children: [
                pw.TableRow(
                  children: [
                    pw.Text('S.N.'),
                    pw.Text('Particulars'),
                    pw.Text('Qty'),
                    pw.Text('Rate'),
                    pw.Text('Amount'),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Text('1'),
                    pw.Text('Curtains'),
                    pw.Text('1'),
                    pw.Text('619.54'),
                    pw.Text('619.54'),
                  ],
                ),
              ],
            ),
          ),
          pw.Text('-------------------------------------', style: pw.TextStyle(letterSpacing: 5)),
          pw.SizedBox(height: 10),
          pw.Padding(
            padding: pw.EdgeInsets.symmetric(horizontal: 18.0),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Gross Amount', style: pw.TextStyle()),
                    pw.Text('Discount', style: pw.TextStyle()),
                    pw.Text('Net Amount', style: pw.TextStyle()),
                  ],
                ),
                pw.SizedBox(width: 20),
                pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(': 619.54', style: pw.TextStyle()),
                    pw.Text(': 0.00', style: pw.TextStyle()),
                    pw.Text(': 619.54', style: pw.TextStyle()),
                  ],
                ),
              ],
            ),
          ),
          pw.Text('-------------------------------------', style: pw.TextStyle(letterSpacing: 5)),
          pw.SizedBox(height: 10),
          pw.Padding(
            padding: pw.EdgeInsets.symmetric(horizontal: 18.0),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Divider(),
                pw.Text('Six Hundred Twenty Rupees Only.', style: pw.TextStyle()),
                pw.Divider(),
                pw.Text('Customer ID : 2', style: pw.TextStyle()),
                pw.SizedBox(height: 10),
                pw.Text('Thank you for visiting us', style: pw.TextStyle()),
                pw.Divider(),
                pw.Text('Cashier: 1126', style: pw.TextStyle()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
