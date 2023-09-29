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
import '../../customer_ledger_report/widget/table_widget.dart';
import '../../ledger_report/provider/report_provider.dart';


class BankCashView extends ConsumerStatefulWidget {

  final String voucherNo;
  final String date;
  final String dateTo;
  final String dateFrom;
  final String branchId;
  final String refNo;
  BankCashView({required this.voucherNo,required this.date,required this.refNo,required this.dateTo,required this.dateFrom,required this.branchId});

  @override
  ConsumerState<BankCashView> createState() => _DayBookReportState();
}

class _DayBookReportState extends ConsumerState<BankCashView> {
  late int _currentPage;
  late int _rowPerPage;
  List<int> rowPerPageItems = [5, 10, 15, 20, 25, 50];
  late int _totalPages;
  late MainInfoModel2 bankCashReportModel;


  @override
  void initState() {
    super.initState();
    _currentPage = 1;
    _rowPerPage = 10;
    _totalPages = 0;

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Move your code that uses ref and providers here.
    // This code will run after initState.
    ref.invalidate(bankCashProvider);
  }

  void getReport(FilterAnyModel2 fModel){

    ref.read(bankCashProvider.notifier).fetchTableData(fModel);
  }



  @override
  Widget build(BuildContext context) {
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
        searchText: '${widget.voucherNo}'
    );



    DataFilterModel filterModel = DataFilterModel();
    filterModel.tblName = "BankCashReport";
    filterModel.strName = "";
    filterModel.underColumnName = null;
    filterModel.underIntID = 0;
    filterModel.columnName = null;
    filterModel.filterColumnsString =
    "[\"${widget.dateFrom}\",\"${widget.dateTo}\",\"isDetailed--true\",\"${widget.branchId}\",\"ledgerId--${ref.watch(itemProvider).ledgerItem}\"]";
    filterModel.pageRowCount = _rowPerPage;
    filterModel.currentPageNumber = _currentPage;
    filterModel.strListNames = "";

    FilterAnyModel2 fModel = FilterAnyModel2();
    fModel.dataFilterModel = filterModel;
    fModel.mainInfoModel = bankCashReportModel;


    final bankCash = ref.watch(bankCashProvider);

    return WillPopScope(
      onWillPop: () async {
        ref.invalidate(bankCashProvider);

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
                ref.invalidate(bankCashProvider);
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
                                  Text(widget.voucherNo)
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Date',style: TextStyle(fontWeight: FontWeight.bold),),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(widget.date)
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
                              Text(widget.refNo)
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              getReport(fModel);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.green,
                              minimumSize: const Size(200, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const FaIcon(
                              FontAwesomeIcons.arrowsRotate,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
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
                        return SizedBox(
                          width: double.infinity,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const ClampingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DataTable(
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
                                /// Pager package used for pagination
                                _totalPages == 0 ? const Text('No records to show', style: TextStyle(fontSize: 16, color: Colors.red),) : Pager(
                                  currentItemsPerPage: _rowPerPage,
                                  currentPage: _currentPage,
                                  totalPages: _totalPages,
                                  onPageChanged: (page) {
                                    _currentPage = page;
                                    /// updates current page number of filterModel, because it does not update on its own
                                    fModel.dataFilterModel!.currentPageNumber = _currentPage;
                                    ref.read(bankCashProvider.notifier).fetchTableData(fModel);
                                  },
                                  showItemsPerPage: true,
                                  onItemsPerPageChanged: (itemsPerPage) {
                                    _rowPerPage = itemsPerPage;
                                    _currentPage = 1;
                                    /// updates row per page of filterModel, because it does not update on its own
                                    fModel.dataFilterModel!.pageRowCount = _rowPerPage;
                                    ref.read(bankCashProvider.notifier).fetchTableData(fModel);
                                  },
                                  itemsPerPageList: rowPerPageItems,
                                ),
                              ],
                            ),
                          ),
                        );



                      },
                      error: (error, stackTrace) =>
                          Center(child: Text('$error')),
                      loading: () => const Center(
                          child: CircularProgressIndicator()),
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

  @override
  void dispose() {
    super.dispose();
  }
}


