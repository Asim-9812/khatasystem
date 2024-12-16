import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:khatasystem/features/reports/statement/bank_cash_report/model/bank_cash_model.dart';
import 'package:khatasystem/features/reports/statement/bank_cash_report/provider/bankCashBookProvider.dart';
import 'package:khatasystem/features/reports/statement/bank_cash_report/widget/bankCash_dataRow.dart';
import 'package:khatasystem/model/filter%20model/data_filter_model.dart';
import 'package:khatasystem/model/filter%20model/filter_any_model.dart';
import 'package:khatasystem/model/list%20model/get_list_model.dart';
import '../../../../../common/colors.dart';
import '../../../../../common/common_provider.dart';
import '../../../../../main.dart';
import '../../customer_ledger_report/widget/table_widget.dart';


class BankCashView extends ConsumerWidget {

  final String voucherNo;
  final String date;
  final String dateTo;
  final String dateFrom;
  final String branchId;
  final String refNo;
  BankCashView({required this.voucherNo,required this.date,required this.refNo,required this.dateTo,required this.dateFrom,required this.branchId});

  late MainInfoModel2 bankCashReportModel;

  @override
  Widget build(BuildContext context,ref) {
    final now =  DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now());
    final fromDate = ref.watch(itemProvider).fromDate;
    final toDate = ref.watch(itemProvider).toDate;
    final fy = ref.watch(itemProvider).fiscalYear;
    final fyId = ref.watch(itemProvider).fiscalId;


    var result = sessionBox.get('userReturn');
    var res = jsonDecode(result);

    String selectedBranch = branchBox.get('selectedBranch');
    int branchId = branchBox.get('selectedBranchId');
    final branchDepartmentId = branchBox.get('selectedBranchDepId');


    bankCashReportModel = MainInfoModel2(
        userId: res["userReturn"]["intUserId"],
        fiscalID:fyId == 0? res["fiscalYearInfo"]["financialYearId"]:fyId,
        branchDepartmentId: branchDepartmentId,
        branchId: branchId,
        isEngOrNepaliDate: res["otherInfo"]["isEngOrNepali"],
        isMenuVerified: false,
        filterId: 0,
        refId: 0,
        mainId: 0,
        strId: '',
        dbName: res["ownerCompanyList"]["databaseName"],
        decimalPlace:res["otherInfo"]["decimalPlace"],
        startDate: fromDate == '' ? res["fiscalYearInfo"]["fromDate"]:fromDate,
        endDate:toDate == ''? res["fiscalYearInfo"]["toDate"]:toDate,
        sessionId: res["userReturn"]["sessionId"],
        id: 0,
        searchText: '${voucherNo}'
    );



    DataFilterModel filterModel = DataFilterModel();
    filterModel.tblName = "BankCashReport";
    filterModel.strName = "";
    filterModel.underColumnName = null;
    filterModel.underIntID = 0;
    filterModel.columnName = null;
    filterModel.filterColumnsString =
    "[\"${dateFrom}\",\"${dateTo}\",\"isDetailed--true\",\"branchId--${branchId}\",\"ledgerId--${ref.watch(itemProvider).ledgerItem}\"]";
    filterModel.pageRowCount = 10;
    filterModel.currentPageNumber = 1;
    filterModel.strListNames = "";

    FilterAnyModel2 fModel = FilterAnyModel2();
    fModel.dataFilterModel = filterModel;
    fModel.mainInfoModel = bankCashReportModel;




    return Consumer(
        builder: (context, ref, child){


          final bankCash = ref.watch(bankCashIndividualProvider(fModel));
          return WillPopScope(
            onWillPop: () async {
              ref.invalidate(bankCashProvider2);

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
                  title: const Text('Bank Cash Book Detail'),
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
                                        Text(voucherNo)
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('Date',style: TextStyle(fontWeight: FontWeight.bold),),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(date)
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
                                    Text(refNo)
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
                          bankCash.when(
                            data: (data) {
                              List<BankCashViewModel> newList = <BankCashViewModel>[];
                              if (data.isNotEmpty) {
                                for (var e in data) {
                                  newList.add(BankCashViewModel.fromJson(e));
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
                                          buildDataColumn(200, 'Particulars',
                                              TextAlign.center),
                                          buildDataColumn(
                                              200, 'Dr', TextAlign.center),
                                          buildDataColumn(
                                              160, 'Cr', TextAlign.center),
                                          buildDataColumn(
                                              160, 'Cheque No', TextAlign.center),
                                          buildDataColumn(160, 'Cheque Date',
                                              TextAlign.center),
                                          buildDataColumn(200, 'Narration',
                                              TextAlign.center),
                                        ],
                                        rows: List.generate(
                                          newList.length,
                                              (index) => buildBankCashViewRow(index, newList[index],'','', context),
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
                                          Text('${newList[0].mainNarration}')
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Row(

                                            children: [
                                              Text('Dr:',style: TextStyle(fontWeight: FontWeight.bold),),
                                              Text('${newList[0].strDebit}')
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Row(

                                            children: [
                                              Text('Cr:',style: TextStyle(fontWeight: FontWeight.bold),),
                                              Text('${newList[0].strCredit}')
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


