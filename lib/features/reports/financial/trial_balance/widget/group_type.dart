
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:khata_app/features/reports/financial/trial_balance/model/trial_balance_group_model.dart';

import '../../../../../common/export.dart';



/// for the heading column of the data table
DataColumn trialBalanceColumn(double colWidth, String colName, TextAlign alignTxt) {
  return DataColumn(
    label: Container(
      height: 70,
      width: colWidth,
      decoration: BoxDecoration(
          color: ColorManager.primary,
          border: const Border(
              right: BorderSide(
                color: Colors.white,
                width: 1,
              ))),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 20, right: 5),
        child: Text(
          colName,
          style: const TextStyle(color: Colors.white, fontSize: 18),
          textAlign: alignTxt,
        ),
      ),
    ),
  );
}

/// Closing balance( debit amount and credit amount column cells)
DataColumn trialBalanceColumnRow(double colWidth, String colName, TextAlign alignTxt) {
  return DataColumn(
    label: Container(
      width: colWidth,
      height: 30,
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
        padding: const EdgeInsets.only(left: 10, top: 6, right: 10),
        child: Text(
          colName,
          style: const TextStyle(
            fontFamily: 'Ubuntu',
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          textAlign: alignTxt,
        ),
      ),
    ),
  );
}


/// for the rows of the data table
DataRow buildTrialBalanceDataRow(int index, GroupWiseModel tblData, bool isDetailed) {
  if(isDetailed == false){
    return DataRow(
      color: tblData.accountGroupName == 'Total Value' ?MaterialStateProperty.resolveWith((states) => ColorManager.primary): MaterialStateProperty.resolveWith((states) => getColor(states, index)),
      cells: [
        buildTrialBlncDataCell(80, tblData.accountGroupName == 'Total Value'? '' :'${tblData.sno}', TextAlign.start, tblData.sno! ,tblData.accountGroupName == 'Total Value' ?true:false),
        buildTrialBlncDataCell(250, '${tblData.accountGroupName}', TextAlign.start, tblData.sno!,tblData.accountGroupName == 'Total Value' ? true : false),
      ],
    );
  }else{
    return DataRow(
      color: tblData.accountGroupName == 'Total Value' ?MaterialStateProperty.resolveWith((states) => ColorManager.primary): MaterialStateProperty.resolveWith((states) => getColor(states, index)),
      cells: [
        buildTrialBlncDataCellDetailed(80, '${tblData.sno}', TextAlign.start, 2, true,tblData.accountGroupName == 'Total Value' ?true:false ),
        buildTrialBlncDataCellDetailed(250, '${tblData.accountGroupName}', TextAlign.start, 2, true,tblData.accountGroupName == 'Total Value' ?true:false),
      ],
    );
  }
}

/// Closing balance( debit amount and credit amount row cells)
DataRow buildTrialBalanceDataRow1(int index, GroupWiseModel tblData, bool isDetailed) {
  if(isDetailed == false){
    return DataRow(
      color: tblData.accountGroupName == 'Total Value' ?MaterialStateProperty.resolveWith((states) => ColorManager.primary): MaterialStateProperty.resolveWith((states) => getColor(states, index)),
      cells: [
        buildTrialBlncDataCell(200, '${tblData.sno != "" ? tblData.strDebit : ""}', TextAlign.end, tblData.sno!,tblData.accountGroupName == 'Total Value' ?true:false),
        buildTrialBlncDataCell(200, '${tblData.strCredit}', TextAlign.end, tblData.sno!,tblData.accountGroupName == 'Total Value' ?true:false),
      ],
    );
  }else{
    return DataRow(
      color: tblData.accountGroupName == 'Total Value' ?MaterialStateProperty.resolveWith((states) => ColorManager.primary): MaterialStateProperty.resolveWith((states) => getColor(states, index)),
      cells: [
        buildTrialBlncDataCellDetailed(200, '${tblData.strDebit}', TextAlign.end, 2, true,tblData.accountGroupName == 'Total Value' ?true:false),
        buildTrialBlncDataCellDetailed(200, '${tblData.strCredit}', TextAlign.end, 2, true,tblData.accountGroupName == 'Total Value' ?true:false),
      ],
    );
  }
}


DataCell buildTrialBlncDataCell(double cellWidth, String cellText, TextAlign cellTextAlign, String sNum,bool lastRow) {
  return DataCell(
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: cellWidth,
      child: Html(
          data: cellText,
        style: {
          'body': Style( color:lastRow ? Colors.white : ColorManager.black)
        },

      ),
    ),
  );
}

/// if the detail checkbox is used (only works for group type for now.)
DataCell buildTrialBlncDataCellDetailed(double cellWidth, String cellText, TextAlign cellTextAlign, int layerPosition, bool isGroup,bool lastRow) {
  return DataCell(
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      width: cellWidth,
      child: Html(
        data: cellText,
        style: {
          'body': Style( color:lastRow ? Colors.white : ColorManager.black)
        },

      ),
  ));
}


class DisplayText extends StatelessWidget {
  final String cellText;
  final int layerPosition;
  final TextAlign cellTextAlign;
  final bool isGroup;
  const DisplayText({
    super.key, required this.cellText, required this.layerPosition, required this.cellTextAlign, required this.isGroup,
  });

  @override
  Widget build(BuildContext context) {

    if(layerPosition == 2){
      return Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Text(
          cellText,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
          textAlign: cellTextAlign,
        ),
      );
    } else if(layerPosition == 3){
      return Padding(
        padding: const EdgeInsets.only(left: 25),
        child: Text(
          cellText,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
          textAlign: cellTextAlign,
        ),
      );
    } else if(layerPosition == 4){
      return Padding(
        padding: const EdgeInsets.only(left: 35),
        child: Text(
          cellText,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
          textAlign: cellTextAlign,
        ),
      );
    }else {
      return Text(
        cellText,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: isGroup ? FontWeight.bold : FontWeight.w400,
        ),
        textAlign: cellTextAlign,
      );
    }

  }
}