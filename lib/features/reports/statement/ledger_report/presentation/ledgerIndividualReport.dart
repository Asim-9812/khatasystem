



import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:khata_app/common/shimmer_loading.dart';
import 'package:khata_app/features/reports/common_widgets/date_input_formatter.dart';
import 'package:khata_app/features/reports/statement/bank_cash_report/model/bank_cash_model.dart';
import 'package:khata_app/features/reports/statement/bank_cash_report/provider/bankCashBookProvider.dart';
import 'package:khata_app/features/reports/statement/bank_cash_report/widget/bankCash_dataRow.dart';
import 'package:khata_app/features/reports/statement/daybook_report/provider/daybook_report_provider.dart';
import 'package:khata_app/features/reports/statement/ledger_report/model/showModel.dart';
import 'package:khata_app/features/reports/statement/ledger_report/widget/build_ledger_sub_report.dart';
import 'package:khata_app/model/filter%20model/data_filter_model.dart';
import 'package:khata_app/model/filter%20model/filter_any_model.dart';
import 'package:khata_app/model/list%20model/get_list_model.dart';
import 'package:khata_app/features/reports/statement/ledger_report/model/report_model.dart';
import 'package:khata_app/features/dashboard/presentation/home_screen.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:pager/pager.dart';

import '../../../../../common/colors.dart';
import '../../../../../common/common_provider.dart';

import '../../../../../common/snackbar.dart';
import '../../../../../main.dart';
import '../../ledger_report/provider/report_provider.dart';
import '../model/table_model.dart';


class LedgerVoucherIndividualReport extends ConsumerWidget {

  final ShowModal tblData;
  LedgerVoucherIndividualReport({required this.tblData});


  @override
  Widget build(BuildContext context,ref) {


    DataFilterModel filterModel = DataFilterModel();
    filterModel.tblName = "VoucherReport--VoucherReportIndividualDetail";
    filterModel.strName = "";
    filterModel.underColumnName = null;
    filterModel.underIntID = 0;
    filterModel.columnName = null;
    filterModel.filterColumnsString =
    "[\"MasterId--${tblData.masterId}\"]";
    filterModel.pageRowCount = 10;
    filterModel.currentPageNumber = 1;
    filterModel.strListNames = "";

    FilterAnyModel fModel = FilterAnyModel();
    fModel.dataFilterModel = filterModel;
    fModel.mainInfoModel = mainInfo;




    return Consumer(
        builder: (context, ref, child){


          final ledgerVoucher = ref.watch(ledgerVoucherIndividualProvider(fModel));
          return WillPopScope(
            onWillPop: () async {
              ref.invalidate(ledgerVoucherIndividualProvider);

              // Return true to allow the back navigation, or false to prevent it
              return true;
            },
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: ColorManager.primary,
                  centerTitle: true,
                  elevation: 0,
                  leading: IconButton(
                    onPressed: () {
                      ref.invalidate(bankCashProvider2);
                      Navigator.pop(context, true);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text('Purchase Details'),
                  titleTextStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  toolbarHeight: 70,
                ),
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text('Voucher No:',style: TextStyle(fontWeight: FontWeight.bold),),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text('${tblData.voucherNo}')
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('Date',style: TextStyle(fontWeight: FontWeight.bold),),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text('${tblData.voucherDate}')
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Text('Ref No',style: TextStyle(fontWeight: FontWeight.bold),),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('${tblData.refNo}')
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                // ElevatedButton(
                                //   onPressed: () async {
                                //     getReport(fModel);
                                //   },
                                //   style: ElevatedButton.styleFrom(
                                //     backgroundColor: ColorManager.green,
                                //     minimumSize: const Size(200, 50),
                                //     shape: RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.circular(10),
                                //     ),
                                //   ),
                                //   child: const FaIcon(
                                //     FontAwesomeIcons.arrowsRotate,
                                //     color: Colors.white,
                                //     size: 25,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          ledgerVoucher.when(
                            data: (data) {
                              List<LedgerVoucherModel> newList = <LedgerVoucherModel>[];
                              if (data.isNotEmpty) {
                                for (var e in data[0]) {
                                  newList.add(LedgerVoucherModel.fromJson(e));
                                }
                              } else {
                                return Container();
                              }
                              return Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      physics: const ClampingScrollPhysics(),
                                      child: DataTable(
                                        columns: [
                                          buildDataColumn(
                                              60, 'S.N', TextAlign.center),
                                          buildDataColumn(200, 'Account Ledger',
                                              TextAlign.center),
                                          buildDataColumn(
                                              200, 'Dr Amount', TextAlign.center),
                                          buildDataColumn(
                                              160, 'Cr Amount', TextAlign.center),
                                          buildDataColumn(
                                              160, 'Cheque No', TextAlign.center),
                                          buildDataColumn(160, 'Cheque Date',
                                              TextAlign.center),
                                          buildDataColumn(200, 'Narration',
                                              TextAlign.center),
                                        ],
                                        rows: List.generate(
                                          newList.length,
                                              (index) => buildLedgerVoucherViewRow(index, newList[index],context),
                                        ),
                                        columnSpacing: 0,
                                        horizontalMargin: 0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(

                                        children: [
                                          Text('Narration:',style: TextStyle(fontWeight: FontWeight.bold),),
                                          Text('${data[1]['narration']}')
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Row(

                                            children: [
                                              Text('Dr:',style: TextStyle(fontWeight: FontWeight.bold),),
                                              Text('${data[1]['drSum']}')
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Row(

                                            children: [
                                              Text('Cr:',style: TextStyle(fontWeight: FontWeight.bold),),
                                              Text('${data[1]['crSum']}')
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              );



                            },
                            error: (error, stackTrace) =>
                                Center(child: Text('$error')),
                            loading: () => Center(
                                child: Image.asset("assets/gif/loading-img2.gif", height: 120, width: 120,)
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          );
        }
    );
  }
}


