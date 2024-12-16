


import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:khatasystem/features/reports/statement/groupwise_ledger_report/presentation/groupWiseDetailReport.dart';
import 'package:khatasystem/features/reports/statement/groupwise_ledger_report/presentation/ledgerDetail_groupwise.dart';
import '../../../../../common/colors.dart';
import '../../../Register/voucher_report/widget/tbl_widgets.dart';
import '../../ledger_report/presentation/subreport.dart';
import '../model/groupwiseledger_model.dart';
import 'package:flutter_html/flutter_html.dart';

final HtmlUnescape unescape = HtmlUnescape();

DataRow buildGroupWiseRow(int index,GroupwiseLedgerReportModel tblData, String branchName, String groupName, String dateFrom,String dateTo, String branchId, List<String> groups,List<String> branches,
    final List<Map<dynamic, dynamic>> dropDownList,
    [BuildContext? context]) {
  final accountGroup = unescape.convert(tblData.accountGroup!);
  return DataRow(
    color:
    MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      buildDataCell(
          60, '${tblData.sno}', TextAlign.center, 2),
      buildHtmlDataCell(
          200, accountGroup, TextAlign.center, 2),
      buildDataCell(200, tblData.strOpeningBalance.toString(), TextAlign.center,
          2),
      buildDataCell(
          160,  '${tblData.debitAmount}', TextAlign.center, 2),
      buildDataCell(
          160, '${tblData.creditAmount}', TextAlign.center, 2),
      buildDataCell(
          160,  '${tblData.strClosingBalance}', TextAlign.center, 2),
      tblData.sno != '' ?DataCell(
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context!,
                  MaterialPageRoute(
                    builder: (context) => GroupWiseDetailReport(
                  branchName: branchName,
                  dateTo: dateTo,
                  dateFrom: dateFrom,
                  branchId: branchId,
                  id: tblData.id!,
                  groupName: tblData.accountGroup!,
                      groups: groups,
                      branches: branches,
                      allData: dropDownList,
              )));
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
      )
      : DataCell(SizedBox()),
    ],
  );
}


DataRow buildGroupWiseDetailRow(int index,GroupWiseDetailModel tblData,String branchName, String dateFrom,String dateTo, String branchId,
    [BuildContext? context]) {
  return DataRow(
    color:
    MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      buildDataCell(
          60, '${tblData.sno}', TextAlign.center, 2),
      buildHtmlDataCell(
          200, '${tblData.accountLedger}', TextAlign.center, 2),
      buildHtmlDataCell(200, tblData.accountGroup, TextAlign.center,
          2),
      buildDataCell(
          160,  '${tblData.strOpeningBalance}', TextAlign.center, 2),
      buildDataCell(
          160, '${tblData.debitAmount}', TextAlign.center, 2),
      buildDataCell(
          160,  '${tblData.creditAmount}', TextAlign.center, 2),
      buildDataCell(
          200,  '${tblData.strClosingBalance}', TextAlign.center, 2),
      tblData.sno != ''? DataCell(
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context!,
                  MaterialPageRoute(
                    builder: (context) => LedgerDetailGroupWiseReport(
                      branchName: branchName,
                  dateTo: dateTo,
                  dateFrom: dateFrom,
                  branchId: branchId,
                  id: tblData.accountGroupId!,
                  ledgerId: tblData.ledgerId!,
                  groupName: tblData.accountGroup!
              )));
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
      )
          
          : DataCell(SizedBox()),
    ],
  );
}


DataRow buildLedgerDetailGroupWiseRow(int index,LedgerDetailGroupWiseModel tblData, String ledgerId,
    [BuildContext? context]) {
  return DataRow(
    color:
    MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      buildDataCell(
          60, '${tblData.sno}', TextAlign.center, 2),
      buildHtmlDataCell(
          200, '${tblData.voucherDate}', TextAlign.center, 2),
      buildHtmlDataCell(200, tblData.voucherNo??'-', TextAlign.center,
          2),
      buildDataCell(
          200,  '${tblData.refNo}', TextAlign.center, 2),
      buildDataCell(
          200, '${tblData.chequeNo}', TextAlign.center, 2),
      buildDataCell(
          200,  '${tblData.voucherTypeName}', TextAlign.center, 2),
      buildDataCell(
          160,  '${tblData.strDebit}', TextAlign.center, 2),
      buildDataCell(
          160,  '${tblData.strCredit}', TextAlign.center, 2),
      buildDataCell(
          200,  '${tblData.strBalance}', TextAlign.center, 2),
      buildDataCell(
          200,  '${tblData.narration}', TextAlign.center, 2),
    ],
  );
}






DataCell buildHtmlDataCell(double cellWidth, String cellText, TextAlign cellTextAlign, int layerPosition) {
  return DataCell(
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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


