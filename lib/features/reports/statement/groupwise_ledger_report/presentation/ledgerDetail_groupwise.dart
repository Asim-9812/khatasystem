import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:khata_app/common/shimmer_loading.dart';
import 'package:khata_app/features/reports/common_widgets/date_input_formatter.dart';
import 'package:khata_app/features/reports/statement/daybook_report/provider/daybook_report_provider.dart';
import 'package:khata_app/features/reports/statement/groupwise_ledger_report/model/groupwiseledger_model.dart';
import 'package:khata_app/features/reports/statement/groupwise_ledger_report/model/groupwiseledger_model.dart';
import 'package:khata_app/features/reports/statement/groupwise_ledger_report/model/groupwiseledger_model.dart';
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
import '../provider/groupwiseledger_provider.dart';
import '../widgets/groupwise_dataRow.dart';

class LedgerDetailGroupWiseReport extends ConsumerStatefulWidget {

  final String groupName;
  final String branchName;
  final int id;
  final int ledgerId;
  final String dateFrom;
  final String dateTo;
  final String branchId;
  LedgerDetailGroupWiseReport({required this.ledgerId,required this.branchName,required this.dateTo,required this.dateFrom,required this.branchId,required this.id,required this.groupName});

  @override
  ConsumerState<LedgerDetailGroupWiseReport> createState() => _DayBookReportState();
}

class _DayBookReportState extends ConsumerState<LedgerDetailGroupWiseReport> {
  late int _currentPage;
  late int _rowPerPage;
  List<int> rowPerPageItems = [5, 10, 15, 20, 25, 50];
  late int _totalPages;
  TextEditingController dateFrom = TextEditingController();
  TextEditingController dateTo = TextEditingController();
  late MainInfoModel2 ledgerReportMainInfo;


  @override
  void initState() {
    super.initState();
    _currentPage = 1;
    _rowPerPage = 10;
    _totalPages = 0;
    dateFrom.text = widget.dateFrom;
    dateTo.text = widget.dateTo;

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Move your code that uses ref and providers here.
    // This code will run after initState.
    ref.invalidate(ledgerDetailGroupWiseProvider);
  }

  void getReport(FilterAnyModel2 fModel){

    ref.read(ledgerDetailGroupWiseProvider.notifier).getTableValues(fModel);
  }



  @override
  Widget build(BuildContext context) {


    var result = sessionBox.get('userReturn');
    var res = jsonDecode(result);

    String selectedBranch = branchBox.get('selectedBranch');
    int branchId = branchBox.get('selectedBranchId');
    final branchDepartmentId = branchBox.get('selectedBranchDepId');



    userId = "${res["userReturn"]["intUserId"]}-${res["ownerCompanyList"]["databaseName"]}";

    String companyName = res["ownerCompanyList"]["companyName"];
    String fiscalYear = res["fiscalYearInfo"]["fiscalYear"];

    ledgerReportMainInfo = MainInfoModel2(
        userId: res["userReturn"]["intUserId"],
        fiscalID: res["fiscalYearInfo"]["financialYearId"],
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
        startDate: res["fiscalYearInfo"]["fromDate"],
        endDate: res["fiscalYearInfo"]["toDate"],
        sessionId: res["userReturn"]["sessionId"],
        id: 0,
    );


    DataFilterModel filterModel = DataFilterModel();
    filterModel.tblName = "LedgerWiseGroupReport";
    filterModel.strName = "";
    filterModel.underColumnName = null;
    filterModel.underIntID = 0;
    filterModel.columnName = null;
    filterModel.filterColumnsString =
    "[\"ledgerId--${widget.ledgerId}\",\"fromDate--${dateFrom.text}\",\"toDate--${dateTo.text}\",\"accountGroupId--${widget.id}\",\"isInclusive--false\",\"${widget.branchId}\"]";
    filterModel.pageRowCount = _rowPerPage;
    filterModel.currentPageNumber = _currentPage;
    filterModel.strListNames = "";

    FilterAnyModel2 fModel = FilterAnyModel2();
    fModel.dataFilterModel = filterModel;
    fModel.mainInfoModel = ledgerReportMainInfo;




    return Consumer(
        builder: (context,ref,child){
          final res2 = ref.watch(ledgerDetailIndividualProvider(fModel));
          return WillPopScope(
            onWillPop: () async {
              ref.invalidate(ledgerDetailGroupWiseProvider);

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
                      ref.invalidate(ledgerDetailGroupWiseProvider);
                      Navigator.pop(context, true);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text('Ledger Detail'),
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
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('From Date',style: TextStyle(color: ColorManager.primary,fontWeight: FontWeight.bold),),
                                          ),
                                          InkWell(
                                            onTap:() async {
                                              DateTime? pickDate =
                                              await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.parse(mainInfo.startDate!),
                                                firstDate: DateTime.parse(mainInfo.startDate!),
                                                lastDate: !DateTime.parse(mainInfo.endDate!).isAfter(DateTime.now())?DateTime.parse(mainInfo.endDate!):DateTime.now(),
                                              );
                                              if (pickDate != null) {
                                                setState(() {
                                                  dateFrom.text =
                                                      DateFormat('yyyy/MM/dd')
                                                          .format(pickDate);
                                                });
                                              }
                                            } ,
                                            child: Container(
                                              padding: const EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: ColorManager.black.withOpacity(0.45)
                                                  )
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(dateFrom.text.isEmpty? 'From': dateFrom.text,style:TextStyle(fontSize: 18),),
                                                  Icon(
                                                    Icons.edit_calendar,
                                                    size: 30,
                                                    color: ColorManager.primary,
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('To Date',style: TextStyle(color: ColorManager.primary,fontWeight: FontWeight.bold),),
                                          ),
                                          InkWell(
                                            onTap:() async {
                                              DateTime? pickDate =
                                              await showDatePicker(
                                                context: context,
                                                initialDate: !DateTime.parse(mainInfo.endDate!).isAfter(DateTime.now())?DateTime.parse(mainInfo.endDate!):DateTime.now(),
                                                firstDate: DateTime.parse(mainInfo.startDate!),
                                                lastDate: !DateTime.parse(mainInfo.endDate!).isAfter(DateTime.now())?DateTime.parse(mainInfo.endDate!):DateTime.now(),
                                              );
                                              if (pickDate != null) {
                                                setState(() {
                                                  dateTo.text =
                                                      DateFormat('yyyy/MM/dd')
                                                          .format(pickDate);
                                                });
                                              }
                                            } ,
                                            child: Container(
                                              padding: const EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: ColorManager.black.withOpacity(0.45)
                                                  )
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(dateTo.text.isEmpty? 'To': dateTo.text,style:TextStyle(fontSize: 18),),
                                                  Icon(
                                                    Icons.edit_calendar,
                                                    size: 30,
                                                    color: ColorManager.primary,
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [

                                        Text('Group:',style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Html(data: widget.groupName,shrinkWrap: true,)
                                      ],
                                    ),),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [

                                        Text('Branch:',style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Html(data: widget.branchName,shrinkWrap: true,)
                                      ],
                                    ),),
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
                          res2.when(
                            data: (data) {
                              List<LedgerDetailGroupWiseModel> newList = <LedgerDetailGroupWiseModel>[];
                              List<String> reportTotal = <String>[];
                              if (data.isNotEmpty) {
                                final tableReport = ReportData.fromJson(data[2]);
                                _totalPages = tableReport.totalPages!;
                                for (var e in data[0]) {
                                  newList.add(LedgerDetailGroupWiseModel.fromJson(e));
                                }
                                data[1].forEach((key, value) {
                                  reportTotal.add(value);
                                });
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
                                          buildDataColumn(200, 'Date',
                                              TextAlign.center),
                                          buildDataColumn(200, 'Voucher No',
                                              TextAlign.center),
                                          buildDataColumn(
                                              200, 'Ref No', TextAlign.center),
                                          buildDataColumn(
                                              200, 'Cheque No', TextAlign.center),
                                          buildDataColumn(
                                              200, 'Voucher Type', TextAlign.center),
                                          buildDataColumn(160, 'Dr',
                                              TextAlign.center),
                                          buildDataColumn(160, 'Cr',
                                              TextAlign.center),
                                          buildDataColumn(200, 'Balance',
                                              TextAlign.center),
                                          buildDataColumn(200, 'Narration',
                                              TextAlign.center),
                                        ],
                                        rows: List.generate(
                                          newList.length,
                                              (index) => buildLedgerDetailGroupWiseRow(index, newList[index],'',context),
                                        ),
                                        columnSpacing: 0,
                                        horizontalMargin: 0,
                                      ),
                                      Table(
                                        columnWidths: const <int,
                                            TableColumnWidth>{
                                          0: FixedColumnWidth(50),
                                          1: FixedColumnWidth(200),
                                          2: FixedColumnWidth(200),
                                          3: FixedColumnWidth(200),
                                          4: FixedColumnWidth(200),
                                          5: FixedColumnWidth(200),
                                          6: FixedColumnWidth(200),
                                          7: FixedColumnWidth(160),
                                          8: FixedColumnWidth(160),
                                          9: FixedColumnWidth(200),
                                          10: FixedColumnWidth(200),
                                        },
                                        children: [
                                          TableRow(
                                            decoration: BoxDecoration(
                                              color: ColorManager.primary,
                                            ),
                                            children: [
                                              buildTableCell(''),
                                              buildTableCell(''),
                                              buildTableCell(''),
                                              buildTableCell(''),
                                              buildTableCell(''),
                                              buildTableCell('Total'),
                                              buildTableCell(
                                                  reportTotal[0],
                                                  TextAlign.center),
                                              buildTableCell(reportTotal[1],
                                                  TextAlign.center),
                                              buildTableCell(reportTotal[2],
                                                  TextAlign.center),
                                              buildTableCell(
                                                  reportTotal[3],
                                                  TextAlign.center),

                                            ],
                                          ),
                                        ],
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
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}


