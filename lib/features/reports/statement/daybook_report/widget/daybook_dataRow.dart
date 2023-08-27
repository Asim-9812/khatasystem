


import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:khata_app/features/reports/statement/daybook_report/model/daybook_model.dart';

import '../../../../../common/colors.dart';
import '../../../Register/voucher_report/widget/tbl_widgets.dart';
import '../presentation/daybook_details.dart';

DataRow buildDayBookReportRow(int index, DayBookModel tblData,
    final List<Map<dynamic, dynamic>> dropDownList,
    [BuildContext? context]) {
  return DataRow(
    color:
    MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      buildDataCell(
          60, (index+1).toString(), TextAlign.start, 2),
      buildDataCell(
          200, tblData.voucherNo!, TextAlign.start, 2),
      buildDataCell(200, tblData.refNo!, TextAlign.start,
          2),
      buildDataCell(
          160, tblData.voucherTypeName!, TextAlign.end, 2),
      buildDataCell(
          160, '${tblData.crTotal}', TextAlign.end, 2),
      buildDataCell(
          160, tblData.narration!, TextAlign.end, 2),
      //  DataCell(
      //   Center(
      //     child: ElevatedButton(
      //       onPressed: () {
      //         // Navigator.push(
      //         //     context!,
      //         //     MaterialPageRoute(
      //         //       builder: (context) => SubReportPage(
      //         //         ledgerName: tblData.ledgerName!,
      //         //         selectedGroup: tblData.accountGroupName!,
      //         //         dropDownList: dropDownList,
      //         //       ),
      //         //     ));
      //       },
      //       style: ElevatedButton.styleFrom(
      //           backgroundColor: ColorManager.green,
      //           minimumSize: const Size(30, 30)),
      //       child: const Icon(
      //         Icons.remove_red_eye_rounded,
      //         color: Colors.white,
      //       ),
      //     ),
      //   ),
      // ),
    ],
  );
}



DataRow buildDayBookDetailedReportRow(int index, DayBookDetailedModel tblData,
    final List<Map<dynamic, dynamic>> dropDownList,
    [BuildContext? context]) {
  return DataRow(
    color:
    MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      buildDataCell(
          60, (index+1).toString(), TextAlign.start, 2),
      buildDataCell(
          200, tblData.voucherNo??'-', TextAlign.start, 2),
      buildDataCell(200, tblData.refNo??'-', TextAlign.start,
          2),
      buildDataCell(
          160, tblData.chequeNo??'-', TextAlign.end, 2),
      buildDataCell(
          160, tblData.voucherTypeName??'', TextAlign.end, 2),
      buildDataCell(
          160, tblData.particulars??'', TextAlign.end, 2),
      buildDataCell(
          160, '${tblData.strDebitAmount??0}', TextAlign.end, 2),
      buildDataCell(
          160, '${tblData.strCreditAmount??0}', TextAlign.end, 2),
      buildDataCell(
          200, tblData.narration??'', TextAlign.end, 2),
      // DataCell(
      //   Center(
      //     child: ElevatedButton(
      //       onPressed: () {
      //         // Navigator.push(
      //         //     context!,
      //         //     MaterialPageRoute(
      //         //       builder: (context) => DayBookDetails(
      //         //         ledgerName: tblData.ledgerName!,
      //         //         dropDownList: dropDownList,
      //         //       ),
      //         //     ));
      //       },
      //       style: ElevatedButton.styleFrom(
      //           backgroundColor: ColorManager.green,
      //           minimumSize: const Size(30, 30)),
      //       child: const Icon(
      //         Icons.remove_red_eye_rounded,
      //         color: Colors.white,
      //       ),
      //     ),
      //   ),
      // ),
    ],
  );
}



DataRow buildDayBookSubReport(int index, DayBookDetailedModel tblData, [BuildContext? context]) {
  return DataRow(
    color: MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      buildDataCell(80, '${tblData.sno}', TextAlign.start,2),
      buildDataCell(200, '${tblData.voucherDate}', TextAlign.start,2),
      buildDataCell(200, '${tblData.voucherNo}', TextAlign.start,2),
      buildDataCell(200, '${tblData.refNo}', TextAlign.start,2),
      buildDataCell(160, '${tblData.chequeNo}', TextAlign.start,2),
      buildDataCell(160, '${tblData.voucherTypeName}', TextAlign.center,2),
      // buildDataCell(200, '${tblData.ledgerName}', TextAlign.start),
      buildDataCell(160, '${tblData.strDebitAmount}', TextAlign.end,2),
      buildDataCell(160, '${tblData.strCreditAmount}', TextAlign.end,2),
      buildDataCell(160, '${tblData.strAmount}', TextAlign.end,2),
      buildDataCell(160, '${tblData.narration}', TextAlign.start,2),
    ],
  );
}





DataCell buildDayBookDataCell(double cellWidth, String cellText, TextAlign cellTextAlign, int layerPosition) {
  return DataCell(
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      width: cellWidth,
      child: layerPosition == 2 ? Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Text(
          cellText,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
          textAlign: cellTextAlign,
        ),
      ) : Text(
        cellText,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
        textAlign: cellTextAlign,
      ),
    ),
  );
}


