
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:khata_app/features/reports/financial/trial_balance/model/trial_balance_ledger_model.dart';

import '../../../../../common/export.dart';


/// for the rows of the data table (S.NO and Particular)
DataRow trialBalanceLedgerRow(int index, LedgerWiseModel tblData,) {
  return DataRow(
    color: MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      buildTrialBlncDataCell(80, '${tblData.sno}', TextAlign.start, tblData.sno!),
      buildTrialBlncDataCell(270,  '${(tblData.ledgerName!)}', TextAlign.start, tblData.sno!),
    ],
  );
}

/// Debit amount and Credit amount rows
DataRow trialBalanceClosingBalanceRow(int index, LedgerWiseModel tblData) {
  return DataRow(
    color: MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      buildTrialBlncDataCell(200, '${tblData.debit}', TextAlign.end, tblData.sno!,),
      buildTrialBlncDataCell(200, '${tblData.credit}', TextAlign.end, tblData.sno!,),
    ],
  );
}

/// Opening rows
DataRow trialBalanceOpeningRow(int index, LedgerWiseModel tblData) {
  return DataRow(
    color: MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      buildTrialBlncDataCell(180, '${tblData.strOpening}', TextAlign.start, tblData.sno!,),
    ],
  );
}

/// Closing rows
DataRow trialBalanceClosingRow(int index, LedgerWiseModel tblData) {
  return DataRow(
    color: MaterialStateProperty.resolveWith((states) => getColor(states, index)),
    cells: [
      buildTrialBlncDataCell(180, '${tblData.strClosing}', TextAlign.end, tblData.sno!,),
    ],
  );
}



DataCell buildTrialBlncDataCell(double cellWidth, String cellText, TextAlign cellTextAlign, String sNum,) {
  return DataCell(
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: cellWidth,
      child: Html(data: cellText),
    ),
  );
}
