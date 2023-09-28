


import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khata_app/features/reports/statement/bank_cash_report/model/bank_cash_model.dart';
import 'package:khata_app/features/reports/statement/daybook_report/model/daybook_model.dart';
import 'package:khata_app/features/reports/statement/daybook_report/presentation/daybook_report_view.dart';
import 'package:khata_app/features/reports/statement/daybook_report/provider/daybook_report_provider.dart';

import '../../../../../common/colors.dart';
import '../../../Register/voucher_report/widget/tbl_widgets.dart';



DataRow buildBankCashRow(int index, BankCashModel tblData,
    [BuildContext? context]) {
  return DataRow(
    color:
    MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      buildBankCashDataCell(
          60, '${tblData.sno}', TextAlign.center, 2),
      buildBankCashDataCell(
          200, '${tblData.date}', TextAlign.center, 2),
      buildBankCashDataCell(200, '${tblData.voucherNo}', TextAlign.center,
          2),
      buildBankCashDataCell(
          160, '${tblData.refNo}', TextAlign.center, 2),
      buildBankCashDataCell(
          200, '${tblData.voucherName}', TextAlign.center, 2),
    ],
  );
}


DataRow buildBankCashRow1(int index, BankCashModel tblData,
    [BuildContext? context]) {
  return DataRow(
    color:
    MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      buildBankCashDataCell(
          200, '${tblData.cashDr}', TextAlign.center, 2),
      buildBankCashDataCell(
          200, '${tblData.cashCr}', TextAlign.center, 2),
      buildBankCashDataCell(200, '${tblData.cashBalance}', TextAlign.center,
          2),
    ],
  );
}

DataRow buildBankCashRow2(int index, BankCashModel tblData,
    [BuildContext? context]) {
  return DataRow(
    color:
    MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      buildBankCashDataCell(
          200, '${tblData.bankDr}', TextAlign.center, 2),
      buildBankCashDataCell(
          200, '${tblData.bankCr}', TextAlign.center, 2),
      buildBankCashDataCell(200, '${tblData.bankBalance}', TextAlign.center,
          2),
    ],
  );
}

DataRow buildBankCashRow3(int index, BankCashModel tblData,
    [BuildContext? context]) {
  return DataRow(
    color:
    MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      tblData.sno!=''?DataCell(
        Center(
          child: ElevatedButton(
            onPressed: () {
              // Navigator.push(
              //     context!,
              //     MaterialPageRoute(
              //       builder: (context) => DayBookReportView(
              //         voucherNo: tblData.voucherNo!,
              //         voucherTypeId: voucherTypeId ,
              //         branchId: branchId,
              //         ledgerId: tblData.ledgerID!,
              //         date: tblData.voucherDate!,
              //       ),
              //     ));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.green,
                fixedSize: Size.fromWidth(60)),
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






DataRow buildBankCashDetailedRow(int index, BankCashDetailedModel tblData,
    [BuildContext? context]) {
  return DataRow(
    color:
    MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      buildBankCashDetailedDataCell(
          60, '${tblData.sno}', TextAlign.center, 2),
      buildBankCashDetailedDataCell(
          200, '${tblData.date}', TextAlign.center, 2),
      buildBankCashDetailedDataCell(200, '${tblData.voucherNo}', TextAlign.center,
          2),
      buildBankCashDetailedDataCell(
          160, '${tblData.refNo}', TextAlign.center, 2),
      buildBankCashDetailedDataCell(
          200, '${tblData.voucherName}', TextAlign.center, 2),
      buildBankCashDetailedDataCell(
          200, tblData.particulars??'', TextAlign.center, 2),

    ],
  );
}

DataRow buildBankCashDetailedRow1(int index, BankCashDetailedModel tblData,
    [BuildContext? context]) {
  return DataRow(
    color:
    MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      buildBankCashDetailedDataCell(
          200, '${tblData.cashDr}', TextAlign.center, 2),
      buildBankCashDetailedDataCell(
          200, '${tblData.cashCr}', TextAlign.center, 2),
      buildBankCashDetailedDataCell(200, '${tblData.cashBalance}', TextAlign.center,
          2),

    ],
  );
}


DataRow buildBankCashDetailedRow2(int index, BankCashDetailedModel tblData,
    [BuildContext? context]) {
  return DataRow(
    color:
    MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      buildBankCashDetailedDataCell(
          200, '${tblData.bankDr}', TextAlign.center, 2),
      buildBankCashDetailedDataCell(
          200, '${tblData.bankCr}', TextAlign.center, 2),
      buildBankCashDetailedDataCell(200, '${tblData.bankBalance}', TextAlign.center,
          2),

    ],
  );
}

DataRow buildBankCashDetailedRow3(int index, BankCashDetailedModel tblData,
    [BuildContext? context]) {
  return DataRow(
    color:
    MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      tblData.sno!=''?DataCell(
        Center(
          child: ElevatedButton(
            onPressed: () {
              // Navigator.push(
              //     context!,
              //     MaterialPageRoute(
              //       builder: (context) => DayBookReportView(
              //         voucherNo: tblData.voucherNo!,
              //         voucherTypeId: voucherTypeId ,
              //         branchId: branchId,
              //         ledgerId: tblData.ledgerID!,
              //         date: tblData.voucherDate!,
              //       ),
              //     ));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.green,
                fixedSize: Size.fromWidth(60)),
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




DataRow buildBankCashViewRow(int index, DayBookDetailedModel tblData, String voucherTypeId, String branchId,
    [BuildContext? context]) {
  return DataRow(
    color:
    MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      buildBankCashDetailedDataCell(
          60, tblData.sno??'', TextAlign.center, 2),
      buildBankCashDetailedDataCell(
          200, tblData.particulars??'-', TextAlign.center, 2),
      buildBankCashDetailedDataCell(200, tblData.refNo??'-', TextAlign.center,
          2),
      buildBankCashDetailedDataCell(
          160, tblData.strDebit??'-', TextAlign.center, 2),
      buildBankCashDetailedDataCell(
          160, '${tblData.strCredit}', TextAlign.center, 2),
      buildBankCashDetailedDataCell(
          160, tblData.chequeNo??'', TextAlign.center, 2),
      buildBankCashDetailedDataCell(
          160, '${tblData.chequeDate}', TextAlign.center, 2),
      buildBankCashDetailedDataCell(
          200, tblData.narration??'', TextAlign.center, 2),
    ],
  );
}








DataCell buildBankCashDataCell(double cellWidth, String cellText, TextAlign cellTextAlign, int layerPosition) {
  return DataCell(
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      width: cellWidth,
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child:  Html(
          data: cellText,
        )
      )
    ),
  );
}


DataCell buildBankCashDetailedDataCell(double cellWidth, String cellText, TextAlign cellTextAlign, int layerPosition) {
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


