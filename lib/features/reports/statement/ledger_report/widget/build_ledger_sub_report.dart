
import 'package:flutter/material.dart';
import 'package:khatasystem/common/colors.dart';
import 'package:khatasystem/features/reports/statement/ledger_report/model/showModel.dart';
import 'package:khatasystem/features/reports/statement/ledger_report/model/table_model.dart';
import 'package:khatasystem/features/reports/statement/ledger_report/presentation/ledgerIndividualReport.dart';

TableCell buildTableCell(String cellText, [TextAlign? cellTxtAlign]) {
  return TableCell(
    child: SizedBox(
      height: 40,
      child: Padding(
        padding: const EdgeInsets.only(top: 5, right: 10),
        child: Text(
          cellText,
          style: const TextStyle(
            fontFamily: 'Ubuntu',
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          textAlign: cellTxtAlign,
        ),
      ),
    ),
  );
}

DataRow buildLedgerSubReport(int index, ShowModal tblData, [BuildContext? context]) {
  return DataRow(
    color: MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      buildDataCell(80, '${tblData.sno}', TextAlign.center),
      buildDataCell(200, '${tblData.voucherDate}', TextAlign.center),
      buildDataCell(200, '${tblData.voucherNo}', TextAlign.center),
      buildDataCell(200, '${tblData.refNo}', TextAlign.center),
      buildDataCell(160, '${tblData.chequeNo}', TextAlign.center),
      buildDataCell(160, '${tblData.voucherTypeName}', TextAlign.center),
      // buildDataCell(200, '${tblData.ledgerName}', TextAlign.center),
      buildDataCell(160, '${tblData.strDebit}', TextAlign.center),
      buildDataCell(160, '${tblData.strCredit}', TextAlign.center),
      buildDataCell(160, '${tblData.strBalance}', TextAlign.center),
      buildDataCell(160, '${tblData.narration}', TextAlign.center),
      tblData.sno != '-' ?DataCell(
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context!,
                  MaterialPageRoute(
                      builder: (context) => LedgerVoucherIndividualReport(tblData: tblData)));
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
DataRow buildLedgerDetailedSubReport(int index, ShowModal tblData, [BuildContext? context]) {
  return DataRow(
    color: MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      buildDataCell(80, '${tblData.sno}', TextAlign.center),
      buildDataCell(200, '${tblData.voucherDate}', TextAlign.center),
      buildDataCell(200, '${tblData.voucherNo}', TextAlign.center),
      buildDataCell(200, '${tblData.refNo}', TextAlign.center),
      buildDataCell(160, '${tblData.chequeNo}', TextAlign.center),
      buildDataCell(160, '${tblData.voucherTypeName}', TextAlign.center),
      buildDataCell(200, '${tblData.ledgerName}', TextAlign.center),
      buildDataCell(160, '${tblData.strDebit}', TextAlign.center),
      buildDataCell(160, '${tblData.strCredit}', TextAlign.center),
      buildDataCell(160, '${tblData.strBalance}', TextAlign.center),
      buildDataCell(160, '${tblData.narration}', TextAlign.center),
      tblData.sno != '-' ?DataCell(
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context!,
                  MaterialPageRoute(
                      builder: (context) => LedgerVoucherIndividualReport(tblData: tblData)));
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




DataRow buildLedgerVoucherViewRow(int index, LedgerVoucherModel tblData,
    [BuildContext? context]) {
  return DataRow(
    color:
    MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      buildDataCell(
          60, tblData.sno??'', TextAlign.center),
      buildDataCell(
          200, tblData.ledgerName??'-', TextAlign.center),
      buildDataCell(
          160, tblData.dr??'-', TextAlign.center),
      buildDataCell(
          160, '${tblData.cr}', TextAlign.center),
      buildDataCell(
          160, tblData.chequeNo??'', TextAlign.center),
      buildDataCell(
          160, '${tblData.chequeDate}', TextAlign.center),
      buildDataCell(
          200, tblData.narration??'', TextAlign.center),
    ],
  );
}





DataCell buildDataCell(
    double cellWidth, String cellText, TextAlign cellTextAlign,
    [Color? footerColor]) {
  return DataCell(
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      width: cellWidth,
      color: footerColor,
      child: Text(
        cellText,
        style: const TextStyle(
          color: Colors.black,
        ),
        textAlign: cellTextAlign,
      ),
    ),
  );
}

DataColumn buildDataColumn(double width, String colName, TextAlign alignTxt) {
  return DataColumn(
    label: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      width: width,
      height: 50,
      decoration: BoxDecoration(
          color: ColorManager.primary,
          border: const Border(
              right: BorderSide(
                color: Colors.white,
                width: 1,
              ),
          ),
      ),
      child: Text(
        colName,
        style: const TextStyle(color: Colors.white, fontSize: 18),
        textAlign: alignTxt,
      ),
    ),
  );
}