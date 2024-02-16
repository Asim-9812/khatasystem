




import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:khata_app/features/pos/domain/model/pos_model.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';
import 'package:number_to_words/number_to_words.dart';


pw.Widget generatePdf({
  required ReceiptPOSModel receipt
}) {

  String companyName = receipt.item1.companyName;
  String companyAddress = receipt.item1.companyAddress;
  String buyersPAN = receipt.item1.buyersPanVat;
  String salesInvoice = receipt.item1.salesMasterID.toString();
  DateTime dateTime = DateFormat('MM/dd/yyyy hh:mm:ss').parse(receipt.item1.billDate);
  String engDate = DateFormat('yyyy-MM-dd').format(dateTime);
  NepaliDateTime nepDateTime = dateTime.toNepaliDateTime();
  String nepDate = DateFormat('yyyy-MM-dd').format(nepDateTime);
  String vendorName = receipt.item1.vendorName;
  String vendorAddress = receipt.item1.vendorAddress;
  String vendorsPan = receipt.item1.vendorsPan;
  String paymentMode = receipt.item1.paymentMode ?? 'Cash';
  String narration = receipt.item1.narration == '0' ? '' : receipt.item1.narration;
  double totalAmt = receipt.item1.totalAmount;
  double discount = receipt.item1.billDiscountAmt;
  double netAmt = receipt.item1.grandTotalAmount;
  String amountInWord = NumberToWord().convert('en-in',receipt.item1.grandTotalAmount.round());
  int customerId = receipt.item1.customerID;
  int userID = receipt.item1.userID;
  String cashierName = receipt.item1.customerSignatureusername;

  return pw.Container(
    child: pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(companyName),
        pw.Text(companyAddress),
        pw.SizedBox(height: 20),
        pw.Text('VAT No.'),
        pw.Text('ABBREVIATED TAX INVOICE'),
        pw.SizedBox(height: 20),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 18.0),
          child: pw.Row(
            children: [
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Bill No'),
                  pw.Text('Date'),
                  pw.Text('Miti'),
                  pw.Text('Name'),
                  pw.Text('Address'),
                  pw.Text('PAN No'),
                  pw.Text('Payment Mode'),
                  pw.Text('Remarks'),
                ],
              ),
              pw.SizedBox(width: 20),
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(': $salesInvoice'),
                  pw.Text(': $engDate'),
                  pw.Text(': $nepDate'),
                  pw.Text(': $vendorName'),
                  pw.Text(': $vendorAddress'),
                  pw.Text(': $buyersPAN'),
                  pw.Text(': $paymentMode'),
                  pw.Text(': $narration'),
                ],
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 30),
        // Manual table creation
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 20),
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
              ...receipt.item3.map((e) => pw.TableRow(
                children: [
                  pw.Text('${e.sno}'),
                  pw.Text(e.particulars),
                  pw.Text('${e.qty}'),
                  pw.Text('${e.rate.toPrecision(2)}'),
                  pw.Text('${e.totalAmount.toPrecision(2)}'),
                ],
              ),).toList(),

            ],
          ),
        ),

        pw.SizedBox(height: 20),
        pw.Text('-------------------------------------', style: const pw.TextStyle(letterSpacing: 5)),
        pw.SizedBox(height: 10),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 18.0),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Gross Amount', style: const pw.TextStyle()),
                  pw.Text('Discount', style: const pw.TextStyle()),
                  pw.Text('Net Amount', style: const pw.TextStyle()),
                ],
              ),
              pw.SizedBox(width: 20),
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(': ${totalAmt.toPrecision(2)}', style: const pw.TextStyle()),
                  pw.Text(': ${discount.toPrecision(2)}', style: const pw.TextStyle()),
                  pw.Text(': ${netAmt.toPrecision(2)}', style: const pw.TextStyle()),
                ],
              ),
            ],
          ),
        ),
        pw.Text('-------------------------------------', style: const pw.TextStyle(letterSpacing: 5)),
        pw.SizedBox(height: 10),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 18.0),
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Divider(),
              pw.Text('${amountInWord.toUpperCase()} Rupees Only', style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
              pw.Divider(),
              pw.Text('Customer ID : $customerId', style: const pw.TextStyle()),
              pw.SizedBox(height: 10),
              pw.Text('Thank you for visiting us', style: const pw.TextStyle()),
              pw.Divider(),
              pw.Text('Cashier: $cashierName', style: const pw.TextStyle()),
            ],
          ),
        ),
      ],
    ),
  );
}

