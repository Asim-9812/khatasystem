


import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khata_app/features/reports/statement/daybook_report/model/daybook_model.dart';
import 'package:khata_app/features/reports/statement/daybook_report/presentation/daybook_report_view.dart';
import 'package:khata_app/features/reports/statement/daybook_report/provider/daybook_report_provider.dart';

import '../../../../../common/colors.dart';
import '../../../Register/voucher_report/widget/tbl_widgets.dart';



DataRow buildDayBookReportRow(int index, DayBookModel tblData,String voucherTypeId, String branchId,
    [BuildContext? context]) {
  return DataRow(
    color:
    MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      buildDataCell(
          60, (index+1).toString(), TextAlign.start, 2),
      buildDataCell(
          200, '${tblData.voucherNo}', TextAlign.start, 2),
      buildDataCell(200, '${tblData.refNo}', TextAlign.start,
          2),
      buildDataCell(
          160, '${tblData.voucherTypeName}', TextAlign.end, 2),
      buildDataCell(
          160, '${tblData.totalAmount}', TextAlign.end, 2),
      buildDataCell(
          160, tblData.narration!, TextAlign.end, 2),
       DataCell(
        Center(
          child: ElevatedButton(
            onPressed: () {

              Navigator.push(
                  context!,
                  MaterialPageRoute(
                    builder: (context) => DayBookReportView(
                      voucherNo: tblData.voucherNo!,
                      voucherTypeId: voucherTypeId ,
                      branchId: branchId,
                      ledgerId: tblData.ledgerId!,
                      date: tblData.voucherDate!,
                    ),
                  ));
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



DataRow buildDayBookDetailedReportRow(int index, DayBookDetailedModel tblData, String voucherTypeId, String branchId,
    [BuildContext? context]) {
  return DataRow(
    color:
    MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      buildDayBookDetailedDataCell(
          60, (index+1).toString(), TextAlign.start, 2),
      buildDayBookDetailedDataCell(
          200, tblData.voucherNo??'-', TextAlign.start, 2),
      buildDayBookDetailedDataCell(200, tblData.refNo??'-', TextAlign.start,
          2),
      buildDayBookDetailedDataCell(
          160, tblData.chequeNo??'-', TextAlign.end, 2),
      buildDayBookDetailedDataCell(
          160, '${tblData.voucherName}', TextAlign.end, 2),
      buildDayBookDetailedDataCell(
          160, tblData.particulars??'', TextAlign.end, 2),
      buildDayBookDetailedDataCell(
          160, '${tblData.strDebit}', TextAlign.end, 2),
      buildDayBookDetailedDataCell(
          160, '${tblData.strCredit}', TextAlign.end, 2),
      buildDayBookDetailedDataCell(
          200, tblData.narration??'', TextAlign.end, 2),
      tblData.voucherNo!=''?DataCell(
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context!,
                  MaterialPageRoute(
                    builder: (context) => DayBookReportView(
                      voucherNo: tblData.voucherNo!,
                      voucherTypeId: voucherTypeId ,
                      branchId: branchId,
                      ledgerId: tblData.ledgerID!,
                      date: tblData.voucherDate!,
                    ),
                  ));
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
      ):const DataCell(SizedBox()),
    ],
  );
}


DataRow buildDayBookViewRow(int index, DayBookDetailedModel tblData, String voucherTypeId, String branchId,
    [BuildContext? context]) {
  return DataRow(
    color:
    MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      buildDayBookDetailedDataCell(
          60, tblData.sno??'', TextAlign.start, 2),
      buildDayBookDetailedDataCell(
          200, tblData.particulars??'-', TextAlign.start, 2),
      buildDayBookDetailedDataCell(200, tblData.refNo??'-', TextAlign.start,
          2),
      buildDayBookDetailedDataCell(
          160, tblData.strDebit??'-', TextAlign.end, 2),
      buildDayBookDetailedDataCell(
          160, '${tblData.strCredit}', TextAlign.end, 2),
      buildDayBookDetailedDataCell(
          160, tblData.chequeNo??'', TextAlign.end, 2),
      buildDayBookDetailedDataCell(
          160, '${tblData.chequeDate}', TextAlign.end, 2),
      buildDayBookDetailedDataCell(
          200, tblData.narration??'', TextAlign.end, 2),
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


DataCell buildDayBookDetailedDataCell(double cellWidth, String cellText, TextAlign cellTextAlign, int layerPosition) {
  return DataCell(
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      width: cellWidth,
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Html(
          data: cellText,
        )),
    ),
  );
}


