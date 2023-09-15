import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:khata_app/common/export.dart';
import 'package:khata_app/features/reports/common_widgets/date_format.dart';
import 'package:khata_app/features/reports/common_widgets/date_input_formatter.dart';
import 'package:khata_app/features/reports/financial/trial_balance/model/trial_balance_group_model.dart';
import 'package:khata_app/features/reports/financial/trial_balance/model/trial_balance_ledger_model.dart';
import 'package:khata_app/features/reports/financial/trial_balance/provider/trial_balance_provider.dart';
import 'package:khata_app/features/reports/financial/trial_balance/widget/group_type.dart';
import 'package:khata_app/features/reports/financial/trial_balance/widget/data_tbl.dart';
import 'package:khata_app/features/reports/financial/trial_balance/widget/ledger_type.dart';
import 'package:khata_app/features/reports/statement/ledger_report/model/report_model.dart';
import 'package:khata_app/features/reports/statement/ledger_report/provider/report_provider.dart';
import 'package:khata_app/model/filter%20model/data_filter_model.dart';
import 'package:khata_app/model/filter%20model/filter_any_model.dart';
import 'package:khata_app/model/list%20model/get_list_model.dart';
import 'package:khata_app/features/dashboard/presentation/home_screen.dart';
import 'package:pager/pager.dart';

import '../../../../../common/snackbar.dart';

class TrialBalanceReport extends ConsumerStatefulWidget {
  const TrialBalanceReport({Key? key}) : super(key: key);

  @override
  ConsumerState<TrialBalanceReport> createState() => _TrialBalanceReportState();
}

class _TrialBalanceReportState extends ConsumerState<TrialBalanceReport> {
  TextEditingController dateFrom = TextEditingController();
  TextEditingController dateTo = TextEditingController();
  String? groupItem;
  bool _isChecked = false;
  bool _isDetailed = false;
  int typeData = 0;

  /// pagination variables
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
  Widget build(BuildContext context) {


    GetListModel modelRef = GetListModel();
    modelRef.refName = 'AccountLedgerReport';
    modelRef.isSingleList = 'false';
    modelRef.singleListNameStr = '';
    modelRef.listNameId =
        "['underGroup', 'mainLedger-${1}', 'mainBranch-${2}']";
    modelRef.mainInfoModel = mainInfo;
    modelRef.conditionalValues = '';

    return Consumer(
      builder: (context, ref, child) {
        final outCome = ref.watch(listProvider(modelRef));
        return WillPopScope(
          onWillPop: () async {
            ref.invalidate(trialBalanceGroupProvider);
            ref.invalidate(trialBalanceLedgerProvider);

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
                  ref.invalidate(trialBalanceGroupProvider);
                  ref.invalidate(trialBalanceLedgerProvider);
                  Navigator.pop(context, true);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 28,
                  color: Colors.white,
                ),
              ),
              title: const Text('Trial Balance'),
              titleTextStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              toolbarHeight: 70,
            ),
            body: outCome.when(
              data: (data) {
                List<Map<dynamic, dynamic>> allList = [];

                for (var e in data) {
                  allList.add(e);
                }

                List<String> branches = ['All'];
                List<String> groups = ['Group', 'Ledger'];
                groupItem = groups.first;

                data[2].forEach((key, _) {
                  branches.add(key);
                });

                String branchItem = branches[0];

                final branchItemData = ref.watch(itemProvider).branchItem;
                final typeItemData = ref.watch(updateTypeProvider).trialBalanceType;

                _isChecked = ref.watch(checkProvider).isChecked;

                GetListModel ledgerGroupListModel = GetListModel();
                ledgerGroupListModel.refName = 'AccountLedgerReport';
                ledgerGroupListModel.isSingleList = 'true';
                ledgerGroupListModel.singleListNameStr = 'account';
                ledgerGroupListModel.listNameId = "[]";
                ledgerGroupListModel.mainInfoModel = mainInfo;
                ledgerGroupListModel.conditionalValues = '';

                String getBranchValue(String branchVal) {
                  if (branchVal == "All") {
                    return 'BranchId--';
                  } else {
                    return 'BranchId--${data[2][branchItemData]}';
                  }
                }

                String getFromDate(TextEditingController txt) {
                  if (txt.text.isEmpty) {
                    return 'fromDate--';
                  } else {
                    return 'fromDate--${txt.text.trim()}';
                  }
                }

                String getToDate(TextEditingController txt) {
                  if (txt.text.isEmpty) {
                    return 'toDate--';
                  } else {
                    return 'toDate--${txt.text.trim()}';
                  }
                }

                DataFilterModel filterModel = DataFilterModel();
                filterModel.tblName = "TrialBalanceReport";
                filterModel.strName = "";
                filterModel.underColumnName = null;
                filterModel.underIntID = 0;
                filterModel.columnName = null;
                filterModel.filterColumnsString =
                    "[\"${getFromDate(dateFrom)}\",\"${getToDate(dateTo)}\",\"typeWise--$typeItemData\",\"isDetail--$_isChecked\",\"${getBranchValue(branchItemData)}\"]";
                filterModel.pageRowCount = _rowPerPage;
                filterModel.currentPageNumber = _currentPage;
                filterModel.strListNames = "";

                FilterAnyModel fModel = FilterAnyModel();
                fModel.dataFilterModel = filterModel;
                fModel.mainInfoModel = mainInfo;

                return SafeArea(
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
                            height: 330,
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
                                                lastDate: DateTime.now(),
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
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.parse(mainInfo.startDate!),
                                                lastDate: DateTime.now(),
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
                                const Spacer(),
                                const SizedBox(height: 5,),
                                DropdownSearch<String>(
                                  items: branches,
                                  selectedItem: branchItem,
                                  dropdownDecoratorProps: DropDownDecoratorProps(
                                    baseStyle: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                    dropdownSearchDecoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.black.withOpacity(0.45),
                                            width: 2,
                                          )),
                                      contentPadding: const EdgeInsets.all(15),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: ColorManager.primary,
                                              width: 1)),
                                      floatingLabelStyle:
                                          TextStyle(color: ColorManager.primary),
                                      labelText: 'Branch',
                                      labelStyle: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  popupProps: const PopupProps.menu(
                                    showSearchBox: true,
                                    fit: FlexFit.loose,
                                    constraints: BoxConstraints(maxHeight: 250),
                                    showSelectedItems: true,
                                    searchFieldProps: TextFieldProps(
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  onChanged: (dynamic value) {
                                    ref.read(itemProvider).updateBranch(value);
                                  },
                                ),
                                const Spacer(),
                                const SizedBox(height: 5,),
                                DropdownSearch<String>(
                                  items: groups,
                                  selectedItem: groupItem,
                                  dropdownDecoratorProps: DropDownDecoratorProps(
                                    baseStyle: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                    dropdownSearchDecoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.black.withOpacity(0.45),
                                            width: 2,
                                          )),
                                      contentPadding: const EdgeInsets.all(15),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: ColorManager.primary,
                                              width: 1)),
                                      floatingLabelStyle:
                                          TextStyle(color: ColorManager.primary),
                                      labelText: 'Type',
                                      labelStyle: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  popupProps: const PopupProps.menu(
                                    showSearchBox: true,
                                    fit: FlexFit.loose,
                                    constraints: BoxConstraints(maxHeight: 250),
                                    showSelectedItems: true,
                                    searchFieldProps: TextFieldProps(
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  onChanged: (dynamic value) {
                                    ref.read(updateTypeProvider).updateTrialBalanceType(value);
                                  },
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _isChecked,
                                      onChanged: (bool? val) {
                                        ref.read(checkProvider).updateCheck();
                                      },
                                      checkColor: Colors.white,
                                      fillColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) =>
                                                  getCheckBoxColor(states)),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const Text('Detailed',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ))
                                  ],
                                ),
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: () async {
                                    if(dateFrom.text.isEmpty || dateTo.text.isEmpty){
                                      final scaffoldMessage = ScaffoldMessenger.of(context);
                                      scaffoldMessage.showSnackBar(
                                        SnackbarUtil.showFailureSnackbar(
                                          message: 'Please pick a date',
                                          duration: const Duration(milliseconds: 1400),
                                        ),
                                      );
                                    }else{
                                      DateFormat dateFormat = DateFormat('yyyy/MM/dd');

                                      DateTime fromDate = dateFormat.parse(dateFrom.text);
                                      DateTime toDate = dateFormat.parse(dateTo.text);
                                      if (toDate.isBefore(fromDate)) {
                                        final scaffoldMessage = ScaffoldMessenger.of(context);
                                        scaffoldMessage.showSnackBar(
                                          SnackbarUtil.showFailureSnackbar(
                                            message: 'From date is greater than To date',
                                            duration: const Duration(milliseconds: 1400),
                                          ),
                                        );
                                      } else{
                                        if(typeItemData != "Group"){
                                          setState(() {
                                            typeData = 2;
                                          });
                                          await ref.read(trialBalanceLedgerProvider.notifier).getTableData(fModel);
                                        }else{
                                          setState(() {
                                            typeData =1;
                                          });
                                          await ref.read(trialBalanceGroupProvider.notifier).getTableData(fModel);
                                          if(_isChecked == true){
                                            setState(() {
                                              _isDetailed = true;
                                            });
                                          }else{
                                            setState(() {
                                              _isDetailed = false;
                                            });
                                          }
                                        }
                                      }
                                    }


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
                          SizedBox(
                            height: typeItemData == "Group" ? 40 : 50,
                          ),
                          typeData == 1 ? Consumer(
                            builder: (context, ref, child) {
                              final groupReport = ref.watch(trialBalanceGroupProvider);
                              return groupReport.when(
                                data: (data) {
                                  List<GroupWiseModel> groupTblData = <GroupWiseModel>[];
                                  List<String> totalFooter = [];
                                  if (data.isNotEmpty) {
                                    for (var e in data[0]) {
                                      groupTblData.add(GroupWiseModel.fromJson(e));
                                    }
                                    for(var e in data[1]){
                                      totalFooter.add(e);
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
                                        children: [
                                          Row(
                                            children: [
                                              DataTable(
                                                headingRowHeight: 60,
                                                columns: [
                                                  trialBalanceColumn(80, 'S.N', TextAlign.start),
                                                  trialBalanceColumn(250, 'Particulars', TextAlign.start)
                                                ],
                                                rows: List.generate(groupTblData.length, (index) => buildTrialBalanceDataRow(index, groupTblData[index], _isDetailed)),
                                                columnSpacing: 0,
                                                horizontalMargin: 0,
                                              ),
                                              Column(
                                                children: [
                                                  Container(
                                                    width: 400,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                        color: ColorManager.primary,
                                                        border: const Border(
                                                            bottom: BorderSide(
                                                                color: Colors.white,
                                                                width: 1
                                                            )
                                                        )
                                                    ),
                                                    child:  const Center(
                                                      child: Text(
                                                        'Closing Balance',
                                                        style: TextStyle(
                                                          fontFamily: 'Ubuntu',
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  DataTable(
                                                    headingRowHeight: 30,
                                                    columns: [
                                                      trialBalanceColumnRow(200, 'Debit Amount', TextAlign.end),
                                                      trialBalanceColumnRow(200, 'Credit Amount', TextAlign.end),
                                                    ],
                                                    rows: List.generate(groupTblData.length, (index) => buildTrialBalanceDataRow1(index, groupTblData[index], _isDetailed)),
                                                    columnSpacing: 0,
                                                    horizontalMargin: 0,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Table(
                                            columnWidths: const <int,
                                                TableColumnWidth>{
                                              0: FixedColumnWidth(330),
                                              1: FixedColumnWidth(200),
                                              2: FixedColumnWidth(200),
                                            },
                                            children: [
                                              TableRow(
                                                decoration: BoxDecoration(
                                                  color: ColorManager.primary,
                                                ),
                                                children: [
                                                  trialTblCell('Total', TextAlign.end),
                                                  trialTblCell(totalFooter[0], TextAlign.end),
                                                  trialTblCell(totalFooter[1], TextAlign.end),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10,),
                                        ],
                                      ),
                                    ),
                                  );

                                },
                                error: (error, stackTrace) => Text('$error'),
                                loading: () => Center(
                                    child: Image.asset("assets/gif/loading-img2.gif", height: 80, width: 80,)
                                ),
                              );
                            },
                          ) : Consumer(
                            builder: (context, ref, child) {
                              final ledgerReport = ref.watch(trialBalanceLedgerProvider);
                              return ledgerReport.when(
                                  data: (data) {
                                    List<LedgerWiseModel> tableData = <LedgerWiseModel>[];
                                    List<String> reportTotal = <String>[];
                                    if (data.isNotEmpty) {
                                      final tableReport = ReportData.fromJson(data[2]);
                                      _totalPages = tableReport.totalPages!;

                                      for (var e in data[0]) {
                                        tableData.add(LedgerWiseModel.fromJson(e));
                                      }
                                      data[1].forEach((key, value) {
                                        reportTotal.add(value);
                                      });

                                    } else{
                                      return SizedBox();
                                    }
                                    return SizedBox(
                                      width: double.infinity,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        physics: const ClampingScrollPhysics(),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                DataTable(
                                                  headingRowHeight: 60,
                                                  columns: [
                                                    trialBalanceColumn(80, 'S.N', TextAlign.start),
                                                    trialBalanceColumn(270, 'Particulars', TextAlign.start)
                                                  ],
                                                  rows: List.generate(tableData.length, (index) => trialBalanceLedgerRow(index, tableData[index])),
                                                  columnSpacing: 0,
                                                  horizontalMargin: 0,
                                                ),
                                                DataTable(
                                                  headingRowHeight: 60,
                                                  columns: [
                                                    trialBalanceColumn(180, 'Opening Balance', TextAlign.start),
                                                  ],
                                                  rows: List.generate(tableData.length, (index) => trialBalanceOpeningRow(index, tableData[index])),
                                                  columnSpacing: 0,
                                                  horizontalMargin: 0,
                                                ),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 400,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                          color: ColorManager.primary,
                                                          border: const Border(
                                                              bottom: BorderSide(
                                                                  color: Colors.white,
                                                                  width: 1
                                                              )
                                                          )
                                                      ),
                                                      child:  const Center(
                                                        child: Text(
                                                          'Transaction',
                                                          style: TextStyle(
                                                            fontFamily: 'Ubuntu',
                                                            fontWeight: FontWeight.w500,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    DataTable(
                                                      headingRowHeight: 30,
                                                      columns: [
                                                        trialBalanceColumnRow(200, 'Debit', TextAlign.end),
                                                        trialBalanceColumnRow(200, 'Credit', TextAlign.end),
                                                      ],
                                                      rows: List.generate(tableData.length, (index) => trialBalanceClosingBalanceRow(index, tableData[index])),
                                                      columnSpacing: 0,
                                                      horizontalMargin: 0,
                                                    ),
                                                  ],
                                                ),
                                                DataTable(
                                                  headingRowHeight: 60,
                                                  columns: [
                                                    trialBalanceColumn(180, 'Closing Balance', TextAlign.end),
                                                  ],
                                                  rows: List.generate(tableData.length, (index) => trialBalanceClosingRow(index, tableData[index])),
                                                  columnSpacing: 0,
                                                  horizontalMargin: 0,
                                                ),
                                              ],
                                            ),
                                            Table(
                                              columnWidths: const <int,
                                                  TableColumnWidth>{
                                                0: FixedColumnWidth(350),
                                                1: FixedColumnWidth(180),
                                                2: FixedColumnWidth(200),
                                                3: FixedColumnWidth(200),
                                                4: FixedColumnWidth(180),
                                              },
                                              children: [
                                                TableRow(
                                                  decoration: BoxDecoration(
                                                    color: ColorManager.primary,
                                                  ),
                                                  children: [
                                                    trialTblCell('Grand Total', TextAlign.end),
                                                    trialTblCell(reportTotal[0], TextAlign.start),
                                                    trialTblCell(reportTotal[1], TextAlign.end),
                                                    trialTblCell(reportTotal[2], TextAlign.end),
                                                    trialTblCell(reportTotal[3], TextAlign.end),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            /// Pager package used for pagination
                                            _totalPages == 0 ? const Text('No records to show', style: TextStyle(fontSize: 16, color: Colors.red),
                                            ) : Pager(
                                              currentItemsPerPage: _rowPerPage,
                                              currentPage: _currentPage,
                                              totalPages: _totalPages,
                                              onPageChanged: (page) {
                                                _currentPage = page;
                                                /// updates current page number of filterModel, because it does not update on its own
                                                fModel.dataFilterModel!.currentPageNumber = _currentPage;
                                                ref.read(trialBalanceLedgerProvider.notifier).getTableData(fModel);
                                              },
                                              showItemsPerPage: true,
                                              onItemsPerPageChanged: (itemsPerPage) {
                                                _rowPerPage = itemsPerPage;
                                                _currentPage = 1;
                                                /// updates row per page of filterModel, because it does not update on its own
                                                fModel.dataFilterModel!.pageRowCount = _rowPerPage;
                                                ref.read(trialBalanceLedgerProvider.notifier).getTableData(fModel);
                                              },
                                              itemsPerPageList: rowPerPageItems,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );

                                  }, error: (error, stackTrace) => const Center(child: Text('error'),),
                                  loading: () => Center(
                                      child: Image.asset("assets/gif/loading-img2.gif", height: 80, width: 80,)
                                  ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              error: (error, stackTrace) => Center(
                child: Text('$error'),
              ),
              loading: () => Center(
                  child: Image.asset("assets/gif/loading-img2.gif", height: 120, width: 120,)
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {


    super.dispose();
  }



}

TableCell buildTableCellLarge(String cellText, [TextAlign? cellTxtAlign]) {
  return TableCell(
    child: Container(
      height: 80,
      decoration: const BoxDecoration(
          border: Border(right: BorderSide(color: Colors.white, width: 1))),
      child: Padding(
        padding: const EdgeInsets.only(top: 5, right: 10),
        child: Center(
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
    ),
  );
}

TableCell buildTableCellNormal(String cellText, [TextAlign? cellTxtAlign]) {
  return TableCell(
    child: Container(
      height: 40,
      decoration: const BoxDecoration(
          border: Border(right: BorderSide(color: Colors.white, width: 1))),
      child: Padding(
        padding: const EdgeInsets.only(top: 5, right: 10),
        child: Center(
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
    ),
  );
}

/// this table cell is for "Closing balance" upper table row of debit amount and credit amount
TableCell buildTableCellMedium(String cellText, [TextAlign? cellTxtAlign]) {
  return TableCell(
    child: Container(
      height: 40,
      decoration: const BoxDecoration(
          border: Border(
        right: BorderSide(color: Colors.white, width: 1),
        bottom: BorderSide(color: Colors.white, width: 2),
      )),
      child: Padding(
        padding: const EdgeInsets.only(top: 5, right: 10),
        child: Center(
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
    ),
  );
}
