


import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khata_app/features/reports/statement/vat_report/presentation/detailed_vat_reports/detailed_info.dart';
import 'package:khata_app/features/reports/statement/vat_report/provider/vat_provider.dart';

import '../../../../../common/colors.dart';
import '../../../Register/voucher_report/widget/tbl_widgets.dart';
import '../model/vat_report_model.dart';
import '../presentation/detailed_vat_reports/monthly_vat_report.dart';

DataRow buildVatRow(int index, VatReportModel tblData,  String branchId, String dateFrom, String dateTo,
    final List<Map<dynamic, dynamic>> dropDownList,
    [BuildContext? context]) {
  return DataRow(
    color:
    MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      buildVatCell(
          60, '${tblData.sno}', TextAlign.center, 2),
      buildVatCell(
          200, tblData.particulars == '' ?'${tblData.strTotalTaxableAmount}':'${tblData.particulars}', TextAlign.center, 2),
      buildVatCell(200, '${tblData.totalAmount}', TextAlign.center,
          2),
      buildVatCell(
          200, '${tblData.totalTaxableAmount}', TextAlign.center, 2),
      buildVatCell(
          160, '${tblData.vatDr}', TextAlign.center, 2),
      buildVatCell(
          160, '${tblData.vatCr}', TextAlign.center, 2),
      tblData.sno!=''? DataCell(
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context!,
                  MaterialPageRoute(
                    builder: (context) => DetailedVatReport(
                      branchId: branchId,
                      voucherTypeId: tblData.vouchertypeID,
                      dateFrom: dateFrom,
                      dateTo: dateTo,
                      rowName: tblData.particulars
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
      ):DataCell(SizedBox()),
    ],
  );
}

DataRow buildVatRow2(int index, VatReportModel tblData, String branchId, String dateFrom, String dateTo,
    [BuildContext? context]) {
  return DataRow(
    color:
    MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      buildVatCell(
          60, '${tblData.sno}', TextAlign.center, 2),
      buildVatCell(
          200, tblData.particulars == '' ?'${tblData.strTotalTaxableAmount}':'${tblData.particulars}', TextAlign.center, 2),
      buildVatCell(200, '${tblData.totalAmount}', TextAlign.center,
          2),
      buildVatCell(
          160, '${tblData.totalTaxableAmount}', TextAlign.center, 2),
      buildVatCell(
          160, '${tblData.vatDr}', TextAlign.center, 2),
      buildVatCell(
          160, '${tblData.vatCr}', TextAlign.center, 2),
      tblData.sno!=''? DataCell(
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context!,
                  MaterialPageRoute(
                    builder: (context) => DetailedVatReport(
                      branchId: branchId,
                      voucherTypeId: tblData.vouchertypeID,
                      dateFrom: dateFrom,
                      dateTo: dateTo,
                      rowName: tblData.particulars,
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


DataRow buildVatDetailRow(int index, VatReportDetailModel tblData,
    [BuildContext? context]) {
  return DataRow(
    color:
    MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      buildVatCell(
          60, '${tblData.sno}', TextAlign.center, 2),
      buildVatCell(
          200, '${tblData.date}', TextAlign.center, 2),
      buildVatCell(200, '${tblData.strTotalAmount}', TextAlign.center,
          2),
      buildVatCell(
          160, '${tblData.strTaxableAmount}', TextAlign.center, 2),
      buildVatCell(
          160, '${tblData.strVATDr}', TextAlign.center, 2),
      buildVatCell(
          160, '${tblData.strVATCr}', TextAlign.center, 2),
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
          60, '${index+1}', TextAlign.center, 2),
      buildVatCell(
          200, '${tblData.pan}', TextAlign.center, 2),
      buildVatCell(200, '${tblData.taxPayerName}', TextAlign.center,
          2),
      buildVatCell(
          160, '${tblData.tradeNameType}', TextAlign.center, 2),
      buildVatCell(
          160, '${tblData.taxableAmount}', TextAlign.center, 2),
      buildVatCell(
          160, '${tblData.nonTaxableAmount}', TextAlign.center, 2),
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
          60, '${tblData.sno}', TextAlign.center, 2),
      buildVatCell(
          200, '${tblData.month}', TextAlign.center, 2),
      buildVatCell(200, '${tblData.openingBalance}', TextAlign.center,
          2),
      buildVatCell(
          160, '${tblData.debitAmount}', TextAlign.center, 2),
      buildVatCell(
          160, '${tblData.creditAmount}', TextAlign.center, 2),
      buildVatCell(
          200, '${tblData.strBalance}', TextAlign.center, 2),
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
                        builder: (context) => MonthlyVatReportTab(vatData: tblData,branchName: branchName,),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: cellWidth,
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Html(data: cellText),
      )
    ),
  );
}
