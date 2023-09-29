import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:khata_app/common/shimmer_loading.dart';
import 'package:khata_app/features/reports/common_widgets/date_input_formatter.dart';
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
import '../../customer_ledger_report/widget/table_widget.dart';
import '../../ledger_report/provider/report_provider.dart';
import '../model/daybook_model.dart';
import '../widget/daybook_dataRow.dart';

class DayBookReportView extends ConsumerStatefulWidget {
  final String voucherTypeId;
  final String voucherNo;
  final int ledgerId;
  final String date;
  final String branchId;
  final String refNo;
  DayBookReportView({required this.refNo,required this.voucherNo,required this.date,required this.branchId,required this.ledgerId,required this.voucherTypeId});

  @override
  ConsumerState<DayBookReportView> createState() => _DayBookReportState();
}

class _DayBookReportState extends ConsumerState<DayBookReportView> {
  late int _currentPage;
  late int _rowPerPage;
  List<int> rowPerPageItems = [5, 10, 15, 20, 25, 50];
  late int _totalPages;


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
    ref.invalidate(dayBookProvider);
  }

  void getReport(FilterAnyModel fModel){

    ref.read(dayBookProvider.notifier).fetchTableData(fModel);
  }



  @override
  Widget build(BuildContext context) {


    DataFilterModel filterModel = DataFilterModel();
    filterModel.tblName = "DayBookReport";
    filterModel.strName = "";
    filterModel.underColumnName = null;
    filterModel.underIntID = 0;
    filterModel.columnName = null;
    filterModel.filterColumnsString =
    "[\"${widget.branchId}\",\"currentDate--${widget.date}\",\"voucherType--${widget.voucherTypeId}\",\"LedgerId--${widget.ledgerId}\",\"isDetailed--true\"]";
    filterModel.pageRowCount = _rowPerPage;
    filterModel.currentPageNumber = _currentPage;
    filterModel.strListNames = "";

    FilterAnyModel fModel = FilterAnyModel();
    fModel.dataFilterModel = filterModel;
    fModel.mainInfoModel = mainInfo;


    final res = ref.watch(dayBookProvider);

    return WillPopScope(
      onWillPop: () async {
        ref.invalidate(dayBookProvider);

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
                ref.invalidate(dayBookProvider);
                Navigator.pop(context, true);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 28,
                color: Colors.white,
              ),
            ),
            title: const Text('Day Book Report'),
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
                                  Text('Date:',style: TextStyle(fontWeight: FontWeight.bold),),
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
                              Text('Ref No:',style: TextStyle(fontWeight: FontWeight.bold),),
                              SizedBox(
                                width: 10,
                              ),
                              Text(widget.voucherNo)
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    res.when(
                      data: (data) {
                          List<DayBookDetailedModel> newList = <DayBookDetailedModel>[];
                          if (data.isNotEmpty) {
                            final tableReport = ReportData.fromJson(data[1]);
                            _totalPages = tableReport.totalPages!;
                            for (var e in data[0]) {
                              newList.add(DayBookDetailedModel.fromJson(e));
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
                                          60, 'S.N', TextAlign.start),
                                      buildDataColumn(200, 'Particulars',
                                          TextAlign.start),
                                      buildDataColumn(200, 'Ref No',
                                          TextAlign.start),
                                      buildDataColumn(
                                          200, 'Dr', TextAlign.start),
                                      buildDataColumn(
                                          160, 'Cr', TextAlign.end),
                                      buildDataColumn(
                                          160, 'Cheque No', TextAlign.end),
                                      buildDataColumn(160, 'Cheque Date',
                                          TextAlign.end),
                                      buildDataColumn(200, 'Narration',
                                          TextAlign.end),
                                    ],
                                    rows: List.generate(
                                      newList.length,
                                          (index) => buildDayBookViewRow(index, newList[index],'','', context),
                                    ),
                                    columnSpacing: 0,
                                    horizontalMargin: 0,
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


