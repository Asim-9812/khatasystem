


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
      buildDataCell(200, tblData.strOpeningBalance.toString(), TextAlign.start,
          2),
      buildDataCell(
          160,  '${tblData.debitAmount}', TextAlign.end, 2),
      buildDataCell(
          160, '${tblData.creditAmount}', TextAlign.end, 2),
      buildDataCell(
          160,  '${tblData.strClosingBalance}', TextAlign.end, 2),
      DataCell(
        Center(
          child: ElevatedButton(
            onPressed: () {
              // Navigator.push(
              //     context!,
              //     MaterialPageRoute(
              //       builder: (context) => DetailedVatReport(
              //         branchId: branchId,
              //         voucherTypeId: tblData.vouchertypeID,
              //         dateFrom: dateFrom,
              //         dateTo: dateTo,
              //       ),
              //     ));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.green,
                minimumSize: const Size(30, 30)),
            child: const Icon(
              Icons.remove_red_eye_rounded,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ],
  );
}






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


