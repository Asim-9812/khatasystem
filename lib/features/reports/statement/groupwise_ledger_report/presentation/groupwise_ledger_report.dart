import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:khata_app/common/shimmer_loading.dart';
import 'package:khata_app/features/reports/common_widgets/date_input_formatter.dart';
import 'package:khata_app/features/reports/statement/groupwise_ledger_report/model/groupwiseledger_model.dart';
import 'package:khata_app/features/reports/statement/groupwise_ledger_report/provider/groupwiseledger_provider.dart';
import 'package:khata_app/features/reports/statement/groupwise_ledger_report/widgets/groupwise_dataRow.dart';
import 'package:khata_app/features/reports/statement/ledger_report/provider/report_provider.dart';
import 'package:khata_app/model/filter%20model/data_filter_model.dart';
import 'package:khata_app/model/filter%20model/filter_any_model.dart';
import 'package:khata_app/model/list%20model/get_list_model.dart';
import 'package:khata_app/features/reports/statement/ledger_report/model/report_model.dart';
import 'package:khata_app/features/dashboard/presentation/home_screen.dart';
import 'package:pager/pager.dart';
import '../../../../../common/colors.dart';
import '../../../../../common/common_provider.dart';
import '../../../../../common/snackbar.dart';
import '../../customer_ledger_report/widget/table_widget.dart';


class GroupWiseLedgerReport extends StatefulWidget {
  const GroupWiseLedgerReport({Key? key}) : super(key: key);

  @override
  State<GroupWiseLedgerReport> createState() => _GroupWiseLedgerReportState();
}

class _GroupWiseLedgerReportState extends State<GroupWiseLedgerReport> {
  TextEditingController dateFrom = TextEditingController();
  TextEditingController dateTo = TextEditingController();
  late int _currentPage;
  late int _rowPerPage;
  List<int> rowPerPageItems = [5, 10, 15, 20, 25, 50];
  late int _totalPages;
  String validation = '';
  late int _totalRecords;

  @override
  void initState() {
    super.initState();
    _currentPage = 1;
    _rowPerPage = 10;
    _totalPages = 0;
    dateFrom.text =DateFormat('yyyy/MM/dd').format( DateTime.parse(mainInfo.startDate!)).toString();
    dateTo.text =!DateTime.parse(mainInfo.endDate!).isAfter(DateTime.now())?DateFormat('yyyy/MM/dd').format(DateTime.parse(mainInfo.endDate!)):DateFormat('yyyy/MM/dd').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    GetListModel2 modelRef = GetListModel2();
    modelRef.refName = 'GroupWiseLedgerReport';
    modelRef.isSingleList = 'false';
    modelRef.singleListNameStr = '';
    modelRef.listNameId = "[\"groupwise_ledger_branch\",\"groupwise_ledger_group\"]";
    modelRef.mainInfoModel = mainInfo2;
    modelRef.conditionalValues = '';
    return Consumer(
      builder: (context, ref, child) {
        final outCome = ref.watch(listProvider3(modelRef));
        final res = ref.watch(groupWiseLedgerProvider);
        final fromDate = ref.watch(itemProvider).fromDate;
        final toDate = ref.watch(itemProvider).toDate;
        return WillPopScope(
          onWillPop: () async {
            ref.invalidate(groupWiseLedgerProvider);

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
                    ref.invalidate(groupWiseLedgerProvider);
                    Navigator.pop(context, true);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
                title: const Text('Group-wise Ledger Report'),
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

                  List<String> groups = [];
                  List<String> branches = [];

                  data[1].forEach((key, _) {
                    groups.add(key);
                  });
                  data[0].forEach((key, _) {
                    branches.add(key);
                  });

                  String groupItem = groups[groups.indexOf('Primary')];

                  String branchItem = branches[0];

                  final groupItemData = ref.watch(itemProvider).item2;

                  final ledgerItemData = ref.watch(itemProvider).ledgerItem;
                  final updatedLedgerItemData = ref.watch(itemProvider).updateLedgerItem;

                  final branchItemData = ref.watch(itemProvider).branchItem;

                  /// this function returns 'accountGroudId--' as required by the api and selected item
                  String groupValue(String val) {
                    if (val == "Primary") {
                      return 'groupID--1';
                    }
                    else {
                      return 'groupID--${data[1][groupItemData]}';
                    }
                  }


                  String getBranchValue(String branchVal) {
                    if (branchVal == "All") {
                      return 'BranchId--0';
                    } else {
                      return 'BranchId--${data[0][branchItemData]}';
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
                  groupValue(groupItemData);

                  DataFilterModel filterModel = DataFilterModel();
                  filterModel.tblName = "GroupWiseLedgerReport";
                  filterModel.strName = "";
                  filterModel.underColumnName = null;
                  filterModel.underIntID = 0;
                  filterModel.columnName = null;
                  filterModel.filterColumnsString =
                  "[\"${getFromDate(dateFrom)}\",\"${getToDate(dateTo)}\",\"${groupValue(groupItemData)}\",\"${getBranchValue(branchItemData)}\"]";
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
                                    items: groups,
                                    selectedItem: groupItem ,
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
                                      validation = value;
                                      ref.read(itemProvider).updateItem2(value);
                                      print(validation);
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  DropdownSearch<String>(
                                    items: branches,
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
                                      ref.read(itemProvider).updateBranch(value);
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
                                          }
                                          else{
                                            ref.read(groupWiseLedgerProvider.notifier).getTableValues(fModel);
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
                            res.when(
                              data: (data) {
                                List<GroupwiseLedgerReportModel> newList = <GroupwiseLedgerReportModel>[];

                                if (data.isNotEmpty) {
                                  final tableReport = ReportData.fromJson(data[1]);
                                  _totalPages = tableReport.totalPages!;
                                  _totalRecords = tableReport.totalRecords!;
                                  for (var e in data[0]) {
                                    newList.add(GroupwiseLedgerReportModel.fromJson(e));
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
                                            buildDataColumn(200, 'Account Group',
                                                TextAlign.center),
                                            buildDataColumn(
                                                200, 'Opening', TextAlign.center),
                                            buildDataColumn(
                                                160, 'Dr', TextAlign.center),
                                            buildDataColumn(
                                                160, 'Cr', TextAlign.center),
                                            buildDataColumn(160, 'Closing',
                                                TextAlign.center),
                                            buildDataColumn(160, 'View',
                                                TextAlign.center),
                                          ],
                                          rows: List.generate(
                                            newList.length,
                                                (index) => buildGroupWiseRow(index, newList[index], branchItem,groupItem,dateFrom.text,dateTo.text,getBranchValue(branchItemData),groups,branches,allList, context),
                                          ),
                                          columnSpacing: 0,
                                          horizontalMargin: 0,
                                        ),
                                        /// Pager package used for pagination
                                        _totalPages == 0 ? const Text('No records to show', style: TextStyle(fontSize: 16, color: Colors.red),) : Pager(
                                          currentItemsPerPage: _rowPerPage,
                                          currentPage: _currentPage,
                                          totalPages: _totalPages,
                                          itemsPerPageText: 'Showing ${_rowPerPage > _totalRecords ? _totalRecords : _rowPerPage} of $_totalRecords :',
                                          itemsPerPageTextStyle: const TextStyle(fontWeight: FontWeight.bold,letterSpacing: 3),
                                          onPageChanged: (page) {
                                            _currentPage = page;
                                            /// updates current page number of filterModel, because it does not update on its own
                                            fModel.dataFilterModel!.currentPageNumber = _currentPage;
                                            ref.read(groupWiseLedgerProvider.notifier).getTableValues(fModel);
                                          },
                                          showItemsPerPage: true,
                                          onItemsPerPageChanged: (itemsPerPage) {
                                            setState(() {
                                              _rowPerPage = itemsPerPage;
                                              _currentPage = 1;
                                            });

                                            /// updates row per page of filterModel, because it does not update on its own
                                            fModel.dataFilterModel!.pageRowCount = _rowPerPage;
                                            ref.read(tableDataProvider.notifier).getTableValues(fModel);
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
                  );
                },
                error: (error, stackTrace) => Center(
                  child: Text('$error'),
                ),
                loading: () {
                  return const Padding(
                    padding: EdgeInsets.only(right: 20, left: 20, top: 20),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: CustomShimmer(width: double.infinity, height: 50, borderRadius: 10,)),
                              SizedBox(width: 10,),
                              Expanded(child: CustomShimmer(width: double.infinity, height: 50, borderRadius: 10,)),
                            ],
                          ),
                          SizedBox(height: 18,),
                          CustomShimmer(width: double.infinity, height: 50, borderRadius: 10,),
                          SizedBox(height: 18,),
                          CustomShimmer(width: double.infinity, height: 50, borderRadius: 10,),
                          SizedBox(height: 18,),
                          CustomShimmer(width: double.infinity, height: 50, borderRadius: 10,),
                          SizedBox(height: 18,),
                          CustomShimmer(width: 180, height: 50, borderRadius: 10,),
                          SizedBox(height: 40,),
                          Row(
                            children: [
                              Expanded(child: CustomShimmer(width: 40, height: 50,)),
                              SizedBox(width: 1,),
                              Expanded(child: CustomShimmer(width: 180, height: 50,)),
                              SizedBox(width: 1,),
                              Expanded(child: CustomShimmer(width: 120, height: 50,)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

String convertDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  String formattedDate =
      "${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}";
  return formattedDate;
}
