import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:khata_app/common/export.dart';
import 'package:khata_app/features/dashboard/presentation/home_screen.dart';
import 'package:khata_app/features/reports/Register/voucher_report/model/voucher_report_model.dart';
import 'package:khata_app/features/reports/Register/voucher_report/provider/dropDownList_provider.dart';
import 'package:khata_app/features/reports/Register/voucher_report/provider/voucher_report_provider.dart';
import 'package:khata_app/features/reports/Register/voucher_report/widget/tbl_widgets.dart';
import 'package:khata_app/features/reports/common_widgets/date_format.dart';
import 'package:khata_app/features/reports/common_widgets/date_input_formatter.dart';
import 'package:khata_app/features/reports/statement/ledger_report/model/report_model.dart';
import 'package:khata_app/features/reports/statement/ledger_report/provider/report_provider.dart';
import 'package:khata_app/model/filter%20model/data_filter_model.dart';
import 'package:khata_app/model/filter%20model/filter_any_model.dart';
import 'package:khata_app/model/list%20model/get_list_model.dart';
import 'package:pager/pager.dart';

import '../../../../../common/snackbar.dart';

class VoucherReportPage extends StatefulWidget {
  const VoucherReportPage({Key? key}) : super(key: key);

  @override
  State<VoucherReportPage> createState() => _VoucherReportPageState();
}

class _VoucherReportPageState extends State<VoucherReportPage> {
  TextEditingController dateFrom = TextEditingController();
  TextEditingController dateTo = TextEditingController();
  TextEditingController search = TextEditingController();
  final searchTextController = TextEditingController();

  late int _currentPage;
  late int _rowPerPage;
  int _totalRecords = 0;
  List<int> rowPerPageItems = [5, 10, 15, 20, 25, 50];
  late int _totalPages;

  FilterAnyModel searchFilterModel = FilterAnyModel();

  bool? _isDetailed;


  late List<VoucherReportModel> voucherReports;
  String query = '';
  late String searchQuery;

  @override
  void initState() {
    super.initState();
    _isDetailed = false;
    _currentPage = 1;
    _rowPerPage = _isDetailed! ? 5 : 10;
    _totalPages = 0;
    voucherReports = [];
    dateFrom.text =DateFormat('yyyy/MM/dd').format( DateTime.parse(mainInfo.startDate!)).toString();
    dateTo.text =!DateTime.parse(mainInfo.endDate!).isAfter(DateTime.now())?DateFormat('yyyy/MM/dd').format(DateTime.parse(mainInfo.endDate!)):DateFormat('yyyy/MM/dd').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    GetListModel modelRef = GetListModel();
    modelRef.refName = 'VoucherReport';
    modelRef.isSingleList = 'false';
    modelRef.singleListNameStr = 'account';
    modelRef.listNameId = "[\"underGroup\",\"mainLedger-\",\"mainBranch-1\",\"voucherType\"]";
    modelRef.mainInfoModel = mainInfo;
    modelRef.conditionalValues = '';

    return Consumer(
      builder: (context, ref, child) {
        searchQuery = ref.watch(itemProvider).searchQuery;
        final fromDate = ref.watch(itemProvider).fromDate;
        final toDate = ref.watch(itemProvider).toDate;
        final listData = ref.watch(voucherListProvider(modelRef));
        final groupReport = ref.watch(voucherReportProvider);
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: WillPopScope(
            onWillPop: () async {
              ref.invalidate(voucherReportProvider);

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
                      ref.invalidate(voucherReportProvider);
                      Navigator.pop(context, true);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text('Voucher Report'),
                  titleTextStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  toolbarHeight: 70,
                ),
                body: listData.when(
                  data: (data) {
                    List<Map<dynamic, dynamic>> allList = [];

                    for (var e in data) {
                      allList.add(e);
                    }

                    List<String> groups = [];
                    List<String> ledgers = [];
                    List<String> branches = [];
                    List<String> voucherTypes = [];
                    List<String> statusTypes = ['All', 'Verified', 'Unverified'];

                    data[0].forEach((key, _) {
                      groups.add(key);
                    });
                    data[1].forEach((key, _) {
                      ledgers.add(key);
                    });
                    data[2].forEach((key, _) {
                      branches.add(key);
                    });

                    data[3].forEach(
                      (key, _) {
                        voucherTypes.add(key);
                      },
                    );

                    String groupItem = groups[0];
                    String ledgerItem = ledgers[0];
                    String branchItem = branches[0];
                    String voucherTypeItem = voucherTypes[0];
                    String statusItem = statusTypes[0];

                    /// the items of each dropdown list followed by "Data" are the updated Items by the provider which are then used in FilterColumnString since "groupItem" only are not useful at this stage
                    final groupItemData = ref.watch(itemProvider).item;
                    final ledgerItemData = ref.watch(itemProvider).ledgerItem;
                    final updatedLedgerItemData =
                        ref.watch(itemProvider).updateLedgerItem;
                    final branchItemData = ref.watch(itemProvider).branchItem;
                    final voucherTypeItemData =
                        ref.watch(itemProvider).voucherTypeItem;
                    final statusTypeItemData = ref.watch(itemProvider).statusType;

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
                        return 'accountGroudId--';
                      } else {
                        return 'accountGroudId--${data[0][groupItemData]}';
                      }
                    }

                    /// this function returns ledgerId according to the selected item from drop down
                    String getLedgerValue(String groupValue, String ledgerVal,
                        String updateLedgerVal) {
                      if (groupValue == "All" && ledgerVal == "All") {
                        return 'LedgerId--';
                      } else if (groupValue == "All" && ledgerVal != "All") {
                        return data[1][ledgerItemData] == null ? 'LedgerId--':  'LedgerId--${data[1][ledgerItemData]}';
                      } else if (groupValue != "All" && updateLedgerVal == "All") {
                        return 'LedgerId--';
                      } else {
                        return data[1][ledgerItemData] == null ? 'LedgerId--':'LedgerId--${data[1][updatedLedgerItemData]}';
                      }
                    }
                    String getBranchValue(String branchVal) {
                      if (branchVal == "All") {
                        return 'BranchId--';
                      } else {
                        return 'BranchId--${data[2][branchItemData]}';
                      }
                    }

                    String getVoucherType(String value) {
                      if (value == "All") {
                        return "voucherType--";
                      } else {
                        return data[3][voucherTypeItemData]==null? 'voucherType--': 'voucherType--${data[3][voucherTypeItemData]}';
                      }
                    }

                    String getVerifiedStatus(String statusType) {
                      if (statusType == "Verified") {
                        return 'verified--1';
                      } else if (statusType == "Unverified") {
                        return 'verified--0';
                      } else {
                        return 'verified--';
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
                    filterModel.tblName = "VoucherReport--VoucherReport";
                    filterModel.strName = "";
                    filterModel.underColumnName = null;
                    filterModel.underIntID = 0;
                    filterModel.columnName = null;
                    filterModel.filterColumnsString = "[\"${getFromDate(dateFrom)}\",\"${getToDate(dateTo)}\",\"isDetail--$_isDetailed\",\"${getBranchValue(branchItemData)}\",\"${groupValue(groupItemData)}\",\"${getLedgerValue(groupItemData, ledgerItemData, updatedLedgerItemData)}\",\"${getVerifiedStatus(statusTypeItemData)}\",\"${getVoucherType(voucherTypeItemData)}\"]";
                    filterModel.pageRowCount = _rowPerPage;
                    filterModel.currentPageNumber = _currentPage;
                    filterModel.strListNames = "";

                    FilterAnyModel fModel = FilterAnyModel();
                    fModel.dataFilterModel = filterModel;
                    fModel.mainInfoModel = mainInfo;

                    searchFilterModel = fModel;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
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
                            // const Spacer(),
                            const SizedBox(
                              height: 20,
                            ),
                            buildDropdownSearch('Group',
                              groups,
                              groupItem,
                                  (dynamic value) {
                                ref.read(itemProvider).updateItem(value);
                              },
                            ),
                            // const Spacer(),
                            const SizedBox(
                              height: 20,
                            ),
                            groupItemData == 'All'
                                ? DropdownSearch<String>(
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
                                  )
                                : Consumer(
                                    builder: (context, ref, child) {
                                      final newData = ref.watch(
                                          ledgerItemProvider(
                                              ledgerGroupListModel));
                                      return newData.when(
                                        data: (data) {
                                          List<String> uLedgerItem = [
                                            'All'
                                          ];
                                          data.forEach((key, _) {
                                            uLedgerItem.add(key);
                                          });
                                          return DropdownSearch<String>(
                                            items: uLedgerItem,
                                            selectedItem:
                                                updatedLedgerItemData,
                                            dropdownDecoratorProps:
                                                DropDownDecoratorProps(
                                              baseStyle: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight:
                                                      FontWeight.w500),
                                              dropdownSearchDecoration:
                                                  InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(10),
                                                    borderSide: BorderSide(
                                                      color: Colors.black
                                                          .withOpacity(
                                                              0.45),
                                                      width: 2,
                                                    )),
                                                contentPadding:
                                                    const EdgeInsets.all(
                                                        15),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(10),
                                                    borderSide: BorderSide(
                                                        color: ColorManager
                                                            .primary,
                                                        width: 1)),
                                                floatingLabelStyle:
                                                    TextStyle(
                                                        color: ColorManager
                                                            .primary),
                                                labelText: 'Ledger',
                                                labelStyle: const TextStyle(
                                                    fontSize: 18),
                                              ),
                                            ),
                                            popupProps:
                                                const PopupProps.menu(
                                              showSearchBox: true,
                                              fit: FlexFit.loose,
                                              constraints: BoxConstraints(
                                                  maxHeight: 250),
                                              showSelectedItems: true,
                                              searchFieldProps:
                                                  TextFieldProps(
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            onChanged: (dynamic value) {
                                              ref
                                                  .read(itemProvider)
                                                  .changeItem(value);
                                            },
                                          );
                                        },
                                        error: (error, stackTrace) =>
                                            Text('$error'),
                                        loading: () => const Center(
                                            child:
                                                CircularProgressIndicator()),
                                      );
                                    },
                                  ),
                            // const Spacer(),
                            const SizedBox(
                              height: 20,
                            ),
                            buildDropdownSearch(
                              'Branch',
                              branches,
                              branchItem,
                                  (dynamic value) {
                                ref.read(itemProvider).updateBranch(value);
                                },
                            ),
                            // const Spacer(),
                            const SizedBox(
                              height: 20,
                            ),
                            buildDropdownSearch(
                              'Voucher Type',
                              voucherTypes,
                              voucherTypeItem,
                                  (dynamic value) {
                                ref.read(itemProvider).updateVoucherType(value);
                              },
                            ),
                            // const Spacer(),
                            const SizedBox(
                              height: 20,
                            ),
                                                           buildDropdownSearch(
                             'Verified Status',
                             statusTypes,
                             statusItem,
                                 (dynamic value) {
                               ref.read(itemProvider).updateStatusType(value);
                             },
                                                           ),
                            // const Spacer(),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: _isDetailed,
                                  onChanged: (bool? val) {
                                    setState(() {
                                      _isDetailed = val!;
                                    });
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
                            // const Spacer(),
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
                                    searchFilterModel.dataFilterModel!.strName = query;
                                    query != '' ? ref.read(voucherReportProvider.notifier).getTableData(searchFilterModel)
                                        : ref.read(voucherReportProvider.notifier).getTableData(fModel);
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

                            const SizedBox(
                              height: 20,
                            ),
                            _isDetailed! ? groupReport.when(
                              data: (data) {
                                List<VoucherReportModel> tableData = <VoucherReportModel>[];
                                if (data.isNotEmpty) {
                                  final tableReport = ReportData.fromJson(data[1]);
                                  _totalPages = tableReport.totalPages!;
                    
                                    _totalRecords=tableReport.totalRecords!;
                    
                    
                                  for (var e in data[0]) {
                                    tableData.add(VoucherReportModel.fromJson(e));
                                  }
                                } else {
                                  return Container();
                                }
                                final filteredData = tableData.where((item) {
                                  final voucherNo = item.voucherNo.toString().toLowerCase();
                                  final voucherName = item.voucherName.toString().toLowerCase();
                                  final narration = item.narration.toString().toLowerCase();
                                  final date = item.voucherDate.toString().toLowerCase();
                                  return voucherNo.contains(searchQuery.toLowerCase()) || voucherName.contains(searchQuery.toLowerCase()) || narration.contains(searchQuery.toLowerCase())||date.contains(searchQuery.toLowerCase());
                                }).toList();
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        controller: search,
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: ColorManager.primary.withOpacity(0.25),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(15),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(15),
                                              borderSide: BorderSide(
                                                color: ColorManager.primary,
                                              ),
                                            ),
                                            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 21),
                                            suffixIcon: Icon(CupertinoIcons.search, color: ColorManager.iconGrey,),
                                            hintText: 'Search Anything',
                                            hintStyle: TextStyle(
                                                color:  ColorManager.textGrey,
                                                fontSize: 16
                                            )
                                        ),
                                        cursorColor: ColorManager.primary,
                                        onChanged: (value) {
                                          ref.read(itemProvider.notifier).updateSearch(value);
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        physics: const ClampingScrollPhysics(),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            DataTable(
                                              columns: [
                                                voucherReportDataColumn(60, 'S.N', TextAlign.center),
                                                voucherReportDataColumn(150, 'Voucher Date', TextAlign.center),
                                                voucherReportDataColumn(200, 'Voucher No', TextAlign.center),
                                                voucherReportDataColumn(120, 'Ref No', TextAlign.center),
                                                voucherReportDataColumn(200, 'Voucher Type', TextAlign.center),
                                                voucherReportDataColumn(250, 'Particulars', TextAlign.center),
                                                voucherReportDataColumn(200, 'Amount', TextAlign.center),
                                                voucherReportDataColumn(300, 'Narration', TextAlign.center),
                                                voucherReportDataColumn(120, 'Status', TextAlign.center),
                                                voucherReportDataColumn(80, 'View', TextAlign.center),
                                              ],
                                              rows: List.generate(filteredData.length, (index) => voucherReportDataRowDetailed(index: index, tblData: filteredData[index], context:  context)),
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
                                                ref.read(voucherReportProvider.notifier).getTableData(fModel);
                                              },
                                              itemsPerPageText: 'Showing $_rowPerPage of $_totalRecords :',
                                              itemsPerPageTextStyle: const TextStyle(fontWeight: FontWeight.bold,letterSpacing: 3),
                                              showItemsPerPage: true,
                                              onItemsPerPageChanged: (itemsPerPage) {
                                                setState(() {
                                                  _rowPerPage = itemsPerPage;
                                                  _currentPage = 1;
                                                });
                    
                    
                                                /// updates row per page of filterModel, because it does not update on its own
                                                fModel.dataFilterModel!.pageRowCount = _rowPerPage;
                                                fModel.dataFilterModel!.currentPageNumber = _currentPage;
                                                ref.read(voucherReportProvider.notifier).getTableData(fModel);
                                              },
                                              itemsPerPageList: rowPerPageItems,
                                            ),
                                            const SizedBox(height: 10,),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              error: (error, stackTrace) => Text('$error'),
                              loading: () => Center(
                                  child: Image.asset("assets/gif/loading-img2.gif", height: 80, width: 80,)),
                            ) : groupReport.when(
                              data: (data) {
                                List<VoucherReportModel> tableData = <VoucherReportModel>[];
                                if (data.isNotEmpty) {
                                  final tableReport = ReportData.fromJson(data[1]);
                                  _totalPages = tableReport.totalPages!;
                                  _totalRecords=tableReport.totalRecords!;
                                  for (var e in data[0]) {
                                    tableData.add(VoucherReportModel.fromJson(e));
                                  }
                                } else {
                                  return Container();
                                }
                                final filteredData = tableData.where((item) {
                                  final voucherNo = item.voucherNo.toString().toLowerCase();
                                  final voucherName = item.voucherName.toString().toLowerCase();
                                  final narration = item.narration.toString().toLowerCase();
                                  final date = item.voucherDate.toString().toLowerCase();
                                  final particulars = item.particulars.toString().toLowerCase();
                                  return voucherNo.contains(searchQuery.toLowerCase()) || voucherName.contains(searchQuery.toLowerCase()) || narration.contains(searchQuery.toLowerCase())||date.contains(searchQuery.toLowerCase())||particulars.contains(searchQuery.toLowerCase());
                                }).toList();
                    
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        controller: search,
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: ColorManager.primary.withOpacity(0.25),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(15),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(15),
                                              borderSide: BorderSide(
                                                color: ColorManager.primary,
                                              ),
                                            ),
                                            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 21),
                                            suffixIcon: Icon(CupertinoIcons.search, color: ColorManager.iconGrey,),
                                            hintText: 'Search Anything',
                                            hintStyle: TextStyle(
                                                color:  ColorManager.textGrey,
                                                fontSize: 16
                                            )
                                        ),
                                        cursorColor: ColorManager.primary,
                                        onChanged: (value) {
                                            ref.read(itemProvider.notifier).updateSearch(value);
                    
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        physics: const ClampingScrollPhysics(),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            DataTable(
                                              columns: [
                                                voucherReportDataColumn(
                                                    60, 'S.N', TextAlign.center),
                                                voucherReportDataColumn(200,
                                                    'Voucher Date', TextAlign.center),
                                                voucherReportDataColumn(200,
                                                    'Voucher No', TextAlign.center),
                                                voucherReportDataColumn(
                                                    140, 'Ref No', TextAlign.center),
                                                voucherReportDataColumn(200, 'Voucher Type', TextAlign.center),
                                                voucherReportDataColumn(
                                                    200, 'Amount', TextAlign.center),
                                                voucherReportDataColumn(300,
                                                    'Narration', TextAlign.center),
                                                voucherReportDataColumn(
                                                    120, 'Status', TextAlign.center),
                                                voucherReportDataColumn(
                                                    80, 'View', TextAlign.center),
                                              ],
                                              rows: List.generate(
                                                  filteredData.length,
                                                  (index) => buildVoucherReportDataRow(index: index, tblData: filteredData[index], context:  context)),
                                              columnSpacing: 0,
                                              horizontalMargin: 0,
                                            ),
                                            /// Pager package used for pagination
                                            _totalPages == 0 ? const Text('No records to show', style: TextStyle(fontSize: 16, color: Colors.red),) : Pager(
                                              currentItemsPerPage: _rowPerPage,
                                              currentPage: _currentPage,
                                              totalPages: _totalPages,
                                              itemsPerPageText: 'Showing $_rowPerPage of $_totalRecords :',
                                              itemsPerPageTextStyle: const TextStyle(fontWeight: FontWeight.bold,letterSpacing: 3),
                                              onPageChanged: (page) {
                                                _currentPage = page;
                                                /// updates current page number of filterModel, because it does not update on its own
                                                fModel.dataFilterModel!.currentPageNumber = _currentPage;
                                                ref.read(voucherReportProvider.notifier).getTableData(fModel);
                                              },
                                              showItemsPerPage: true,
                                              onItemsPerPageChanged: (itemsPerPage) {
                                                _rowPerPage = itemsPerPage;
                                                _currentPage = 1;
                                                /// updates row per page of filterModel, because it does not update on its own
                                                fModel.dataFilterModel!.pageRowCount = _rowPerPage;
                                                fModel.dataFilterModel!.currentPageNumber = _currentPage;
                                                ref.read(voucherReportProvider.notifier).getTableData(fModel);
                                              },
                                              itemsPerPageList: rowPerPageItems,
                                            ),
                                            const SizedBox(height: 10,),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              error: (error, stackTrace) => Text('$error'),
                              loading: () => Center(
                                  child: Image.asset(
                                "assets/gif/loading-img2.gif",
                                height: 80,
                                width: 80,
                              ),
                              ),
                            )
                          ],
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
                )),
          ),
        );
      },
    );
  }

  TextField buildTextField(BuildContext context, WidgetRef ref) {
    return TextField(
      controller: searchTextController,
      decoration: InputDecoration(
          filled: true,
          fillColor: ColorManager.primary.withOpacity(0.25),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: ColorManager.primary,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 21),
          suffixIcon: query.isNotEmpty ? GestureDetector(
            child: Icon(Icons.close, color: ColorManager.iconGrey),
            onTap: () {
              searchTextController.clear();
              setState(() {
                query = '';
              });
              FocusScope.of(context).requestFocus(FocusNode());
              },
          ) : Icon(CupertinoIcons.search, color: ColorManager.iconGrey,),
          hintText: 'Search Anything',
          hintStyle: TextStyle(
              color:  ColorManager.textGrey,
              fontSize: 16
          )
      ),
      cursorColor: ColorManager.primary,
      onSubmitted: (value) async {
        searchFilterModel.dataFilterModel!.strName = value;
        await ref.read(voucherReportProvider.notifier).getTableData(searchFilterModel);
        setState(() {
          query = value;
        });
      },
    );
  }
  DropdownSearch<String> buildDropdownSearch(String fieldName, List<String> dropDownList, String selectedItem, Function(dynamic) onChanged) {
    return DropdownSearch<String>(
      items: dropDownList,
      selectedItem: selectedItem,
      dropdownDecoratorProps: DropDownDecoratorProps(
        baseStyle: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w500),
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
                  color: ColorManager.primary, width: 1)),
          floatingLabelStyle:
          TextStyle(color: ColorManager.primary),
          labelText: fieldName,
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
      onChanged: onChanged,
    );
  }
}
