import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:khata_app/common/shimmer_loading.dart';
import 'package:khata_app/features/reports/common_widgets/date_input_formatter.dart';
import 'package:khata_app/features/reports/statement/ledger_report/provider/report_provider.dart';
import 'package:khata_app/features/reports/statement/supplier_ledger_report/model/supplier_ledger_report_model.dart';
import 'package:khata_app/features/reports/statement/supplier_ledger_report/provider/supplier_ledger_report_provider.dart';
import 'package:khata_app/model/filter%20model/data_filter_model.dart';
import 'package:khata_app/model/filter%20model/filter_any_model.dart';
import 'package:khata_app/model/list%20model/get_list_model.dart';
import 'package:khata_app/features/reports/statement/ledger_report/model/report_model.dart';
import 'package:khata_app/features/dashboard/presentation/home_screen.dart';
import 'package:pager/pager.dart';

import '../../../../../common/colors.dart';
import '../../../../../common/common_provider.dart';
import '../../../../../common/snackbar.dart';
import '../../../common_widgets/build_report_table.dart';
import '../widget/table_widget.dart';


class SupplierLedgerReport extends StatefulWidget {
  const SupplierLedgerReport({Key? key}) : super(key: key);

  @override
  State<SupplierLedgerReport> createState() => _SupplierLedgerReportState();
}

class _SupplierLedgerReportState extends State<SupplierLedgerReport> {
  TextEditingController dateFrom = TextEditingController();
  TextEditingController dateTo = TextEditingController();
  late int _currentPage;
  late int _rowPerPage;
  List<int> rowPerPageItems = [5, 10, 15, 20, 25, 50];
  late int _totalPages;
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
        final isCustomerSupplierLoading = ref.watch(itemProvider).isCustomerSupplierLoading;
        final outCome = ref.watch(supplierListProvider(modelRef));
        final res = ref.watch(supplierLedgerReportProvider);
        final fromDate = ref.watch(itemProvider).fromDate;
        final toDate = ref.watch(itemProvider).toDate;
        return WillPopScope(
          onWillPop: () async {
            ref.invalidate(supplierLedgerReportProvider);

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
                    ref.invalidate(supplierLedgerReportProvider);
                    Navigator.pop(context, true);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
                title: const Text('Supplier Ledger Report'),
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
                  List<String> ledgers = [];
                  List<String> branches = [];

                  data[1].forEach((key, _) {
                    groups.add(key);
                  });
                  data[2].forEach((key, _) {
                    ledgers.add(key);
                  });
                  data[0].forEach((key, _) {
                    branches.add(key);
                  });

                  String groupItem = groups[0];
                  String ledgerItem = ledgers[0];
                  String branchItem = branches[0];

                  final groupItemData = ref.watch(itemProvider).item;

                  final ledgerItemData = ref.watch(itemProvider).ledgerItem;
                  final updatedLedgerItemData = ref.watch(itemProvider).updateLedgerItem;

                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    ref.read(itemProvider).updateBranch(branchItem);
                  });

                  final branchItemData = ref.watch(itemProvider).branchItem;

                  GetListModel ledgerGroupListModel = GetListModel();
                  ledgerGroupListModel.refName = 'AccountLedgerReport';
                  ledgerGroupListModel.isSingleList = 'true';
                  ledgerGroupListModel.singleListNameStr = 'account';
                  ledgerGroupListModel.listNameId =
                      "['mainLedger-${data[0][groupItemData]}']";
                  ledgerGroupListModel.mainInfoModel = mainInfo;
                  ledgerGroupListModel.conditionalValues = '';

                  /// this function returns 'accountGroudId--' as required by the api and selected item
                  String groupValue(String val) {
                    if (val == "All") {
                      return 'accountGroudId--${data[1]['All']}';
                    } else {
                      return 'accountGroudId--${data[1][groupItemData]}';
                    }
                  }

                  /// this function returns ledgerId according to the selected item from drop down
                  String getLedgerValue(String groupValue, String ledgerVal,
                      String updateLedgerVal) {
                    if (groupValue == "All" && ledgerVal == "All") {
                      return 'LedgerId--0';
                    } else if (groupValue == "All" && ledgerVal != "All") {
                      return data[2][ledgerItemData] == null ? 'LedgerId--0':  'LedgerId--${data[2][ledgerItemData]}';
                    } else if (groupValue != "All" && updateLedgerVal == "All") {
                      return 'LedgerId--0';
                    } else {
                      return data[2][ledgerItemData] == null ? 'LedgerId--0':'LedgerId--${data[2][updatedLedgerItemData]}';
                    }
                  }

                  String getBranchValue(String branchVal) {
                    if (branchVal == "All") {
                      return 'BranchId--${branchId}';
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
                  filterModel.tblName =
                      "CustomerSupplierLedgerReport--CustomerSupplierLedgerReport";
                  filterModel.strName = "";
                  filterModel.underColumnName = null;
                  filterModel.underIntID = 0;
                  filterModel.columnName = null;
                  filterModel.filterColumnsString =
                      "[\"${getFromDate(dateFrom)}\",\"${getToDate(dateTo)}\",\"${groupValue(groupItemData)}\",\"${getLedgerValue(groupItemData, ledgerItemData, updatedLedgerItemData)}\",\"${getBranchValue(branchItemData)}\"]";
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
                              height: 350,
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
                                  const Spacer(),
                                  DropdownSearch<String>(
                                    items: groups,
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
                                      ref.read(itemProvider).updateItem(value);
                                    },
                                  ),
                                  const Spacer(),
                                  DropdownSearch<String>(
                                    items: ledgers,
                                    selectedItem: ledgerItem,
                                    dropdownDecoratorProps:
                                    DropDownDecoratorProps(
                                      baseStyle: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                      dropdownSearchDecoration:
                                      InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                              color: Colors.black
                                                  .withOpacity(0.45),
                                              width: 2,
                                            )),
                                        contentPadding:
                                        const EdgeInsets.all(15),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: ColorManager.primary,
                                                width: 1)),
                                        floatingLabelStyle: TextStyle(
                                            color: ColorManager.primary),
                                        labelText: 'Ledger',
                                        labelStyle:
                                        const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    popupProps: const PopupProps.menu(
                                      showSearchBox: true,
                                      fit: FlexFit.loose,
                                      constraints:
                                      BoxConstraints(maxHeight: 250),
                                      showSelectedItems: true,
                                      searchFieldProps: TextFieldProps(
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    onChanged: (dynamic value) {
                                      ref
                                          .read(itemProvider)
                                          .updateLedger(value);
                                    },
                                  ),
                                  const Spacer(),
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
                                        }else{
                                          ref.read(itemProvider.notifier).updateCustomerLoading(true);
                                          ref.read(supplierLedgerReportProvider.notifier).fetchTableData(fModel).then((value) =>
                                              ref.read(itemProvider.notifier).updateCustomerLoading(false)
                                          );
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
                                    child:isCustomerSupplierLoading? CircularProgressIndicator(color: ColorManager.white,) :  const FaIcon(
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
                                List<SupplierLedgerModel> newList = <SupplierLedgerModel>[];
                                List<String> reportTotal = <String>[];
                                if (data.isNotEmpty) {
                                  final tableReport = ReportData.fromJson(data[2]);
                                  _totalPages = tableReport.totalPages!;
                                  _totalRecords = tableReport.totalRecords!;
                                  for (var e in data[0]) {
                                    newList.add(SupplierLedgerModel.fromJson(e));
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
                                                60, 'S.N', TextAlign.start),
                                            buildDataColumn(200, 'Account Ledger',
                                                TextAlign.start),
                                            buildDataColumn(
                                                200, 'Group', TextAlign.start),
                                            buildDataColumn(
                                                160, 'Opening', TextAlign.end),
                                            buildDataColumn(
                                                160, 'Debit (Dr)', TextAlign.end),
                                            buildDataColumn(160, 'Credit (Cr)',
                                                TextAlign.end),
                                            buildDataColumn(
                                                160, 'Closing', TextAlign.end),
                                            buildDataColumn(
                                                80, 'View', TextAlign.center),
                                          ],
                                          rows: List.generate(
                                              newList.length,
                                              (index) => buildReportDataRow(index, newList[index], branchItem,allList, context),
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
                                            3: FixedColumnWidth(160),
                                            4: FixedColumnWidth(160),
                                            5: FixedColumnWidth(160),
                                            6: FixedColumnWidth(160),
                                            7: FixedColumnWidth(80),
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
                                                buildTableCell(
                                                    reportTotal[0],
                                                    TextAlign.end),
                                                buildTableCell(reportTotal[1],
                                                    TextAlign.end),
                                                buildTableCell(reportTotal[2],
                                                    TextAlign.end),
                                                buildTableCell(
                                                    reportTotal[3],
                                                    TextAlign.end),
                                                buildTableCell(
                                                  '',
                                                ),
                                              ],
                                            ),
                                          ],
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
                                            ref.read(supplierLedgerReportProvider.notifier).fetchTableData(fModel);
                                          },
                                          itemsPerPageText: 'Showing ${_rowPerPage > _totalRecords ? _totalRecords : _rowPerPage} of $_totalRecords :',
                                          itemsPerPageTextStyle: const TextStyle(fontWeight: FontWeight.bold,letterSpacing: 3),
                                          showItemsPerPage: true,
                                          onItemsPerPageChanged: (itemsPerPage) {
                                            setState(() {
                                            _rowPerPage = itemsPerPage;
                                            _currentPage = 1;
                                            });
                                            /// updates row per page of filterModel, because it does not update on its own
                                            fModel.dataFilterModel!.pageRowCount = _rowPerPage;
                                            ref.read(supplierLedgerReportProvider.notifier).fetchTableData(fModel);
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
