


import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khata_app/features/reports/statement/vat_report/provider/vat_provider.dart';

import '../../../../../common/colors.dart';
import '../../../Register/voucher_report/widget/tbl_widgets.dart';
import '../model/vat_report_model.dart';
import '../presentation/monthly_vat_report.dart';

DataRow buildVatRow(int index, VatReportModel tblData,
    final List<Map<dynamic, dynamic>> dropDownList,
    [BuildContext? context]) {
  return DataRow(
    color:
    MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      buildVatCell(
          60, '${tblData.sno}', TextAlign.start, 2),
      buildVatCell(
          200, tblData.particulars == '' ?'${tblData.strTotalTaxableAmount}':'${tblData.particulars}', TextAlign.start, 2),
      buildVatCell(200, '${tblData.totalAmount}', TextAlign.start,
          2),
      buildVatCell(
          160, '${tblData.totalTaxableAmount}', TextAlign.end, 2),
      buildVatCell(
          160, '${tblData.vatDr}', TextAlign.end, 2),
      buildVatCell(
          160, '${tblData.vatCr}', TextAlign.end, 2),
       DataCell(
        Center(
          child: ElevatedButton(
            onPressed: () {
              // Navigator.push(
              //     context!,
              //     MaterialPageRoute(
              //       builder: (context) => SubReportPage(
              //         ledgerName: tblData.ledgerName!,
              //         selectedGroup: tblData.accountGroupName!,
              //         dropDownList: dropDownList,
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

DataRow buildVatRow2(int index, VatReportModel tblData,
    [BuildContext? context]) {
  return DataRow(
    color:
    MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      buildVatCell(
          60, '${tblData.sno}', TextAlign.start, 2),
      buildVatCell(
          200, tblData.particulars == '' ?'${tblData.strTotalTaxableAmount}':'${tblData.particulars}', TextAlign.start, 2),
      buildVatCell(200, '${tblData.totalAmount}', TextAlign.start,
          2),
      buildVatCell(
          160, '${tblData.totalTaxableAmount}', TextAlign.end, 2),
      buildVatCell(
          160, '${tblData.vatDr}', TextAlign.end, 2),
      buildVatCell(
          160, '${tblData.vatCr}', TextAlign.end, 2),
      DataCell(
        Center(
          child: ElevatedButton(
            onPressed: () {
              // Navigator.push(
              //     context!,
              //     MaterialPageRoute(
              //       builder: (context) => SubReportPage(
              //         ledgerName: tblData.ledgerName!,
              //         selectedGroup: tblData.accountGroupName!,
              //         dropDownList: dropDownList,
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


DataRow buildAboveLakhRow(int index, AboveLakhModel tblData,
    final List<Map<dynamic, dynamic>> dropDownList,
    [BuildContext? context]) {
  return DataRow(
    color:
    MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      buildVatCell(
          60, '${index+1}', TextAlign.start, 2),
      buildVatCell(
          200, '${tblData.pan}', TextAlign.start, 2),
      buildVatCell(200, '${tblData.taxPayerName}', TextAlign.start,
          2),
      buildVatCell(
          160, '${tblData.tradeNameType}', TextAlign.end, 2),
      buildVatCell(
          160, '${tblData.taxableAmount}', TextAlign.end, 2),
      buildVatCell(
          160, '${tblData.nonTaxableAmount}', TextAlign.end, 2),
    ],
  );
}

DataRow buildMonthlyRow(int index, MonthlyModel tblData,
    final List<Map<dynamic, dynamic>> dropDownList, String branchName,
    [BuildContext? context]) {
  return DataRow(
    color:
    MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      buildVatCell(
          60, '${tblData.sno}', TextAlign.start, 2),
      buildVatCell(
          200, '${tblData.month}', TextAlign.start, 2),
      buildVatCell(200, '${tblData.openingBalance}', TextAlign.start,
          2),
      buildVatCell(
          160, '${tblData.debitAmount}', TextAlign.end, 2),
      buildVatCell(
          160, '${tblData.creditAmount}', TextAlign.end, 2),
      buildVatCell(
          200, '${tblData.strBalance}', TextAlign.end, 2),
       DataCell(
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  ref.invalidate(vatReportProvider);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MonthlyVatReportTab(data: tblData,branchName: branchName,),
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
            );
          },
        ),
      ),
    ],
  );
}





DataCell buildVatCell(double cellWidth, String cellText, TextAlign cellTextAlign, int layerPosition) {
  return DataCell(
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      width: cellWidth,
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Html(data: cellText),
      )
    ),
  );
}
