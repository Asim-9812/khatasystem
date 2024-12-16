import 'package:flutter/material.dart';
import 'package:khatasystem/common/colors.dart';
import 'package:khatasystem/features/reports/statement/ledger_report/presentation/subreport.dart';
import 'package:khatasystem/features/reports/statement/ledger_report/model/table_model.dart';

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
            color: Colors.white,
          ),
          textAlign: cellTxtAlign,
        ),
      ),
    ),
  );
}

DataRow buildReportDataRow(int index, TableData tblData, String branch,
    final List<Map<dynamic, dynamic>> dropDownList,
    [BuildContext? context]) {
  return DataRow(
    color:
        MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      buildDataCell(
          60, '${tblData.sno}', TextAlign.start, tblData.isPageFooter!),
      buildDataCell(
          200, '${tblData.ledgerName}', TextAlign.start, tblData.isPageFooter!),
      buildDataCell(200, '${tblData.accountGroupName}', TextAlign.start,
          tblData.isPageFooter!),
      buildDataCell(
          160, '${tblData.strOpening}', TextAlign.end, tblData.isPageFooter!),
      buildDataCell(
          160, '${tblData.strDebit}', TextAlign.end, tblData.isPageFooter!),
      buildDataCell(
          160, '${tblData.strCredit}', TextAlign.end, tblData.isPageFooter!),
      buildDataCell(
          160, '${tblData.strClosing}', TextAlign.end, tblData.isPageFooter!),
      tblData.isPageFooter == true
          ? const DataCell(SizedBox())
          : DataCell(
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context!,
                        MaterialPageRoute(
                          builder: (context) => SubReportPage(
                            ledgerName: tblData.ledgerName!,
                            selectedGroup: tblData.accountGroupName!,
                            dropDownList: dropDownList,
                            branchName: branch,
                            tblData: tblData,
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

DataCell buildDataCell(
    double cellWidth, String cellText, TextAlign cellTextAlign, bool isFooter,
    [Color? footerColor]) {
  return DataCell(
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      width: cellWidth,
      color: footerColor,
      child: Text(
        cellText,
        style: TextStyle(
          color: Colors.black,
          fontWeight: isFooter ? FontWeight.bold : FontWeight.w400,
        ),
        textAlign: cellTextAlign,
      ),
    ),
  );
}

DataColumn buildDataColumn(double width, String colName, TextAlign alignTxt) {
  return DataColumn(
    label: Container(
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
      child: Padding(
        padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
        child: Text(
          colName,
          style: const TextStyle(color: Colors.white, fontSize: 18),
          textAlign: alignTxt,
        ),
      ),
    ),
  );
}
