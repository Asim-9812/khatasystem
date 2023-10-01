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

class GroupWiseDetailReport extends ConsumerStatefulWidget {
  final String branchName;
  final String groupName;
  final int id;
  final String dateFrom;
  final String dateTo;
  final String branchId;
  final List<String> groups;
  final List<String> branches;
  final List<Map<dynamic, dynamic>> allData;
  GroupWiseDetailReport({required this.allData,required this.groups,required this.branches,required this.branchName,required this.dateTo,required this.dateFrom,required this.branchId,required this.id,required this.groupName});

  @override
  ConsumerState<GroupWiseDetailReport> createState() => _DayBookReportState();
}

class _DayBookReportState extends ConsumerState<GroupWiseDetailReport> {
  late int _currentPage;
  late int _rowPerPage;
  List<int> rowPerPageItems = [5, 10, 15, 20, 25, 50];
  late int _totalPages;
  late MainInfoModel2 vatReportMainInfo;
  TextEditingController dateFrom = TextEditingController();
  TextEditingController dateTo = TextEditingController();
  late String groupItem ;
  late String branchItem ;
  String selectedBranchId= '0';
  late int groupId;


  @override
  void initState() {
    super.initState();
    _currentPage = 1;
    _rowPerPage = 10;
    _totalPages = 0;
    dateFrom.text = widget.dateFrom;
    dateTo.text = widget.dateTo;
    groupItem = widget.groupName;
    branchItem = widget.branchName;
    groupId = widget.id;

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Move your code that uses ref and providers here.
    // This code will run after initState.
    ref.invalidate(groupWiseDetailProvider);
  }

  void getReport(FilterAnyModel2 fModel){

    ref.read(groupWiseDetailProvider.notifier).getTableValues(fModel);
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

    vatReportMainInfo = MainInfoModel2(
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
        id: groupId,
      searchText: 'AccountGroup'
    );


    DataFilterModel filterModel = DataFilterModel();
    filterModel.tblName = "GroupWiseLedgerReport";
    filterModel.strName = "";
    filterModel.underColumnName = null;
    filterModel.underIntID = 0;
    filterModel.columnName = null;
    filterModel.filterColumnsString =
    "[\"fromDate--${dateFrom.text}\",\"toDate--${dateFrom.text}\",\"groupID--\",\"branchId--$selectedBranchId\",\"voucherNo--AccountGroup\",\"masterId--\"]";
    filterModel.pageRowCount = _rowPerPage;
    filterModel.currentPageNumber = _currentPage;
    filterModel.strListNames = "";

    FilterAnyModel2 fModel = FilterAnyModel2();
    fModel.dataFilterModel = filterModel;
    fModel.mainInfoModel = vatReportMainInfo;


    final res2 = ref.watch(groupWiseDetailProvider);

    return WillPopScope(
      onWillPop: () async {
        ref.invalidate(groupWiseDetailProvider);

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
                ref.invalidate(groupWiseDetailProvider);
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
                          const SizedBox(
                            height: 20,
                          ),
                          DropdownSearch<String>(
                            items: widget.groups,
                            selectedItem: groupItem,
                            dropdownDecoratorProps:
                            DropDownDecoratorProps(
                              baseStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                              dropdownSearchDecoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color:
                                      Colors.black.withOpacity(0.45),
                                      width: 2,
                                    )),
                                contentPadding: const EdgeInsets.all(15),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: ColorManager.primary,
                                        width: 1)),
                                floatingLabelStyle: TextStyle(
                                    color: ColorManager.primary),
                                labelText: 'Group',
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
                              List<Map<dynamic, dynamic>> allDataItems = widget.allData;

                              // Find the item in allDataItems with the same text as selectedValue
                              // var selectedItem = allDataItems.firstWhere(
                              //       (item) => item.keys == value
                              // );

                              ref.read(itemProvider).updateItem(value);
                              setState(() {
                                groupId = int.parse(allDataItems[0][value]);
                              });



                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          DropdownSearch<String>(
                            items: widget.branches,
                            selectedItem: branchItem,
                            dropdownDecoratorProps:
                            DropDownDecoratorProps(
                              baseStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                              dropdownSearchDecoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color:
                                      Colors.black.withOpacity(0.45),
                                      width: 2,
                                    )),
                                contentPadding: const EdgeInsets.all(15),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: ColorManager.primary,
                                        width: 1)),
                                floatingLabelStyle: TextStyle(
                                    color: ColorManager.primary),
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
                              setState(() {
                                branchItem = value;
                              });
                              List<Map<dynamic, dynamic>> allDataItems = widget.allData;
                              ref.read(itemProvider).updateBranch(value);

                              if(value != 'All'){
                                setState(() {
                                  selectedBranchId = allDataItems[2][value];
                                });
                              }
                              else{
                                setState(() {
                                  groupId = 0;
                                });
                              }

                              print(allDataItems[2][value]);
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),

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
                              }
                              else{
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
                                }
                                else{
                                  getReport(fModel);
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
                    const SizedBox(
                      height: 30,
                    ),
                    res2.when(
                      data: (data) {
                        List<GroupWiseDetailModel> newList = <GroupWiseDetailModel>[];
                        if (data.isNotEmpty) {
                          final tableReport = ReportData.fromJson(data[1]);
                          _totalPages = tableReport.totalPages!;
                          for (var e in data[0]) {
                            newList.add(GroupWiseDetailModel.fromJson(e));
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
                                    buildDataColumn(200, 'Account Ledger',
                                        TextAlign.center),
                                    buildDataColumn(200, 'Account Group',
                                        TextAlign.center),
                                    buildDataColumn(
                                        200, 'Opening', TextAlign.center),
                                    buildDataColumn(
                                        160, 'Dr', TextAlign.center),
                                    buildDataColumn(
                                        160, 'Cr', TextAlign.center),
                                    buildDataColumn(200, 'Closing',
                                        TextAlign.center),
                                    buildDataColumn(160, 'View',
                                        TextAlign.center),
                                  ],
                                  rows: List.generate(
                                    newList.length,
                                        (index) => buildGroupWiseDetailRow(index, newList[index],branchItem,widget.dateFrom,widget.dateTo,widget.branchId,context),
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
                                    ref.read(groupWiseDetailProvider.notifier).getTableValues(fModel);
                                  },
                                  showItemsPerPage: true,
                                  onItemsPerPageChanged: (itemsPerPage) {
                                    _rowPerPage = itemsPerPage;
                                    _currentPage = 1;
                                    /// updates row per page of filterModel, because it does not update on its own
                                    fModel.dataFilterModel!.pageRowCount = _rowPerPage;
                                    ref.read(tableDataProvider.notifier).getTableValues2(fModel);
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


