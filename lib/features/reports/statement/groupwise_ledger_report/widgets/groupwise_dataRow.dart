


import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:khata_app/features/reports/statement/daybook_report/model/daybook_model.dart';
import 'package:html_unescape/html_unescape.dart';
import '../../../../../common/colors.dart';
import '../../../Register/voucher_report/widget/tbl_widgets.dart';
import '../../ledger_report/presentation/subreport.dart';
import '../model/groupwiseledger_model.dart';
import 'package:flutter_html/flutter_html.dart';

final HtmlUnescape unescape = HtmlUnescape();

DataRow buildGroupWiseRow(int index,GroupwiseLedgerReportModel tblData, String groupName,
    final List<Map<dynamic, dynamic>> dropDownList,
    [BuildContext? context]) {
  final accountGroup = unescape.convert(tblData.accountGroup!);
  return DataRow(
    color:
    MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      buildDataCell(
          60, '${tblData.sno}', TextAlign.start, 2),
      buildHtmlDataCell(
          200, accountGroup, TextAlign.start, 2),
      buildDataCell(200, tblData.openingBalance.toString(), TextAlign.start,
          2),
      buildDataCell(
          160,  '${tblData.debitAmount}', TextAlign.end, 2),
      buildDataCell(
          160, '${tblData.creditAmount}', TextAlign.end, 2),
      buildDataCell(
          160,  '${tblData.closingBalance}', TextAlign.end, 2),
    ],
  );
}




// DataRow buildDayBookSubReport(int index, DayBookDetailedModel tblData, [BuildContext? context]) {
//   return DataRow(
//     color: MaterialStateProperty.resolveWith((states) => getColor(states, index)),
//     cells: [
//       buildDataCell(80, '${tblData.sno}', TextAlign.start,2),
//       buildDataCell(200, '${tblData.voucherDate}', TextAlign.start,2),
//       buildDataCell(200, '${tblData.voucherNo}', TextAlign.start,2),
//       buildDataCell(200, '${tblData.refNo}', TextAlign.start,2),
//       buildDataCell(160, '${tblData.chequeNo}', TextAlign.start,2),
//       buildDataCell(160, '${tblData.voucherTypeName}', TextAlign.center,2),
//       // buildDataCell(200, '${tblData.ledgerName}', TextAlign.start),
//       buildDataCell(160, '${tblData.strDebitAmount}', TextAlign.end,2),
//       buildDataCell(160, '${tblData.strCreditAmount}', TextAlign.end,2),
//       buildDataCell(160, '${tblData.strAmount}', TextAlign.end,2),
//       buildDataCell(160, '${tblData.narration}', TextAlign.start,2),
//     ],
//   );
// }





DataCell buildHtmlDataCell(double cellWidth, String cellText, TextAlign cellTextAlign, int layerPosition) {
  return DataCell(
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      width: cellWidth,
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Html(
            data: cellText,
        ),
      )
    ),
  );
}


