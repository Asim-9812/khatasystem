//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:html_to_pdf_plus/html_to_pdf_plus.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:printing/printing.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf/src/pdf/page_format.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
//
// class TesterPage extends StatelessWidget {
//
//   String data = "<html><head><style>.invoice-POS {width: 8.5cm; margin: auto;}\r\n.dashed-line{border - top: 1px dashed #000;margin - top: 5px;} \r\n#top {text - align: center;}   \r\n#top p { margin: 0; }\r\n#bot {text - align: center; }\r\n.table-margin-zero { margin: 0;}     \r\n.table-margin-zero tbody tr {margin: 0;padding: 0;}\r\n.company-logo {float: left;margin-right: 0px;}\r\n</style>\r\n</head>\r\n<body><div class=\"container invoice-POS\"><div>\r\n   <div class=\"company-logo\">\r\n            <img src=\"/\" width=\"80\" height=\"80\" alt=\"\" onerror=\"this.style.display='none'; \" >\r\n        </div>\r\n\r\n<div id=\"top\">\r\n<p style=\"text-align: center;\">Search Technology</p>\r\n<p style=\"text-align: center;\">Dhangadhi</p> <br>\r\n<p style=\"text-align: center;\">VAT No. : 920822695 </p><p style=\"text-align: center;\">\r\nTax Invoice\r\n</p><br><br></div>          <table>                                                         <tbody style=\"font-size: 15px\">                                          <tr><td>Bill No</td><td>:</td><td>SI_251_080/81</td></tr>                                                             <tr><td>Date</td><td>:</td><td>2024-05-28</td></tr>          <tr><td>Miti</td><td>:</td><td></td></tr>         <tr><td>Name</td><td>:</td><td>Cash</td></tr>                       <tr><td>Address</td><td>:</td><td></td></tr>                               <tr><td>PAN No</td><td>:</td><td></td></tr>                      <tr><td>Payment Mode</td><td>: </td><td>Cash</td></tr>                                <tr><td>Remarks</td><td>:</td><td></td></tr>                                                      </tbody>                                                     </table>                                                     </div>                                                                                             </div>                                                                                                                                                                                         <div id=\"bot\" class=\"invoice-POS\">                                                         <div id=\"table\" id=\"productReceit\">                                                             <table class=\"table\">                                                                 <thead>                                                                     <tr> <td class=\"dashed-line\" colspan=\"12\"></td></tr>                                                                     <tr>                                                                         <th class=\"col-1 text-center\">SN</th>                                                                         <th class=\"col-5 text-center\">Particulars</th>                                                                         <th class=\"col-1 text-center\">Qty</th>                                                                         <th class=\"col-2 text-center\">Rate</th>    \r\n<th class=\"col-2 text-center\">Discount</th>                                                                              <th class=\"col-2 text-right\">Amount</th>                                                                     </tr                                                                     <tr> <td class=\"dashed-line\" colspan=\"12\"></td></tr>                                                                 </thead><tbody> <tbody><tr class=\"service\"><td class=\"col-1 text-center\">1</td><td class=\"col-5 text-left\">Monitor</td><td class=\"col-1 text-right\">1.00</td><td class=\"col-1 text-right\">6000.00</td><td class=\"col-2 text-right\">0.00</td><td class=\"col-2 text-right\">6000.00</td></tr></tbody >       </tbody></table>                                                              </div></div><div class=\"invoice-POS\"> <div class=\"row\">                                                                     <div class=\"col-4 no-border\"></div>                                                                     <div class=\"col-8 no-border\">                                                                         <table class=\"table table-borderless table-margin-zero\">                                                                             <tbody style=\"font-size: 15px\">                                                                                 <tr> <td class=\"dashed-line\" colspan=\"4\"></td></tr>                                                                                 <tr> <td style=\"width: 30%;\"></td><td style=\"width: 70%;\"><span>------------------------</span></td></tr>                                                                                 <tr> <td style=\"width: 20%;\"></td><td style=\"width: 35%;\">Gross Amount</td><td style=\"width: 5%;\">:</td><td style=\"width: 30%;\">5309.73</td></tr>  <tr><td style=\"width: 20%;\"></td><td style=\"width: 35%;\">Discount</td><td style=\"width: 5%;\">:</td><td style=\"width: 30%;\">0.00</td></tr>    <tr><td style=\"width: 20%;\"></td><td style=\"width: 35%;\">Vat Amount:</td><td style=\"width: 5%;\">:</td><td style=\"width: 30%;\">690.27</td></tr>    <tr> <td style=\"width: 20%;\"></td> <td style=\"width: 35%;\">Net Amount</td> <td style=\"width: 5%;\">:</td><td style=\"width: 30%;\">6000.00 </td></tr>                                                                                 <tr> <td style=\"width: 30%;\"></td><td style=\"width: 70%;\">-------------------------</td></tr>                                                                                                                                                           </tbody>                                                                         </table>                                                                     </div>                                                                 </div>                                                                         <div class=\"row\">                                                                             <div class=\"col-md-12 text-left\">                                                                                 ------------------------------------------------------ <br>                                                                                     Six Thousand  Rupees Only.  <br>                                                                                         ------------------------------------------------------<br>                                                                                     CustomerID: 2 <br>                                                                                     Thank you for visiting us. <br>                                                                                                     ------------------------------------------------------ <br>                                                                                                                                                                    Cashier: 1143 <br>                                                                                                                       </div>                                                                          </div>                                                               </div>                                                                                                                                                   </body>                                                                                 </html> ";
//
//   @override
//   Widget build(BuildContext context) {
//
//     Widget htmlWidget = HtmlWidget(data);
//
//
//
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Tester Page'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: _htmlToPdf,
//           child: Text('Print'),
//         ),
//       ),
//     );
//   }
//
//
//
//
//   void _htmlToPdf() async {
//     // Get the documents directory
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String targetPath = documentsDirectory.path;
//     String targetFileName = "example_pdf_file";
//
//     // Generate PDF from HTML content
//     final generatedPdfFile = await HtmlToPdf.convertFromHtmlContent(
//       htmlContent: data,
//       configuration: PdfConfiguration(
//         targetDirectory: targetPath,
//         targetName: targetFileName,
//         printSize: PrintSize.A4,
//         printOrientation: PrintOrientation.Landscape,
//       ),
//     );
//
//     print("Generated PDF file: ${generatedPdfFile.path}");
//
//     final doc = pw.Document();
//
//     final pdfBytes = await generatedPdfFile.readAsBytes();
//     // Print or preview the PDF
//     await Printing.layoutPdf(
//       onLayout: (PdfPageFormat format) async => pdfBytes,
//     );
//   }
//
//   // void _print() async {
//   //
//   //   Widget htmlWidget = HtmlWidget(data);
//   //
//   //   await Printing.layoutPdf(
//   //       dynamicLayout: false,
//   //       // format: html.PdfPageFormat(648 ,588),
//   //       onLayout: (PdfPageFormat format) async {
//   //         // var body = '${receipt}';
//   //
//   //         final pdf = pw.Document();
//   //         // final pdf = pw.Document();
//   //         // final widgets = await html.HTMLToPdf().convert(body);
//   //         pdf.addPage(pw.MultiPage(build: (context) => [htmlWidget]));
//   //         return await pdf.save();
//   //       });
//   //
//   // }
//
// }
