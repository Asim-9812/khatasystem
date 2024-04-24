




import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:khata_app/features/reports/statement/bank_cash_report/provider/bankCashBookProvider.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:pager/pager.dart';

import '../../../../../common/colors.dart';
import '../../../../../common/common_provider.dart';
import '../../../../../common/shimmer_loading.dart';
import '../../../../../common/snackbar.dart';
import '../../../../../model/filter model/data_filter_model.dart';
import '../../../../../model/filter model/filter_any_model.dart';
import '../../../../../model/list model/get_list_model.dart';
import '../../../../dashboard/presentation/home_screen.dart';
import '../../../common_widgets/build_report_table.dart';
import '../../ledger_report/model/report_model.dart';
import '../../ledger_report/provider/report_provider.dart';
import '../model/daybook_model.dart';
import '../provider/daybook_report_provider.dart';
import '../widget/daybook_dataRow.dart';

class DayBookReport extends ConsumerStatefulWidget {
  const DayBookReport({super.key});

  @override
  ConsumerState<DayBookReport> createState() => _TestState();
}

class _TestState extends ConsumerState<DayBookReport> {

  TextEditingController search = TextEditingController();
  TextEditingController dateFrom = TextEditingController();
  TextEditingController dateTo = TextEditingController();
  List<DayBookModel> filteredList = [];
  late int _currentPage;
  late int _rowPerPage;
  List<int> rowPerPageItems = [5, 10, 15, 20, 25, 50];
  late int _totalPages;
  String branchName = '';
  String groupName = '';
  String voucherValue = '';
  late List _selectedVouchers;
  String searchQuery = '';
  GetListModel modelRef2 = GetListModel();
  GetLedgerListModel ledgerRef = GetLedgerListModel();


  @override
  void initState() {
    super.initState();
    getList();
    _currentPage = 1;
    _rowPerPage = 10;
    _totalPages = 0;
    dateFrom.text =!DateTime.parse(mainInfo.endDate!).isAfter(DateTime.now())?DateFormat('yyyy/MM/dd').format(DateTime.parse(mainInfo.endDate!)):DateFormat('yyyy/MM/dd').format(DateTime.now());

  }





  void getList() {
    GetListModel modelRef = GetListModel();
    modelRef.refName = 'DayBook';
    modelRef.isSingleList = 'false';
    modelRef.singleListNameStr = '';
    modelRef.listNameId = "[\"branch\",\"voucherType\",\"ledger\"]";
    modelRef.mainInfoModel = mainInfo;
    modelRef.conditionalValues = '';
    setState(() {
      modelRef2 = modelRef;
    });
  }


  // @override
  // void didChangeDependencies(){
  //   super.didChangeDependencies();
  //   ref.read(itemProvider.notifier).updateSelected(true);
  //
  // }



  @override
  Widget build(BuildContext context) {
    _selectedVouchers =ref.watch(itemProvider).selectedDayBookList;
    final outCome = ref.watch(dayBookListProvider(modelRef2));
    final ledgerList = ref.watch(bankCashLedgerListProvider(ledgerRef));
    final res = ref.watch(dayBookProvider);
    final fromDate = ref.watch(itemProvider).fromDate;
    final toDate = ref.watch(itemProvider).toDate;
    return WillPopScope(
      onWillPop: () async {
        ref.invalidate(dayBookProvider);
        ref.read(itemProvider.notifier).updateSelectedDayBookList([]);

        ref.read(itemProvider).updateIsDetailed(false);
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
                ref.read(itemProvider.notifier).updateSelectedDayBookList([]);
                ref.read(itemProvider).updateIsDetailed(false);
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
          body: outCome.when(
            data: (data) {
              List<Map<dynamic, dynamic>> allList = [];

              for (var e in data) {
                allList.add(e);
              }

              List<Map<String,dynamic>> vouchers = [];
              List<String> ledgers = [];
              List<String> branches = [];

              data[0].forEach((key, _) {
                branches.add(key);
              });
              data[1].forEach((key, _) {
                vouchers.add({'text': key, 'value': _});
              });

              data[2].forEach((key, _) {
                ledgers.add(key);
              });

              // if(ref.watch(itemProvider).selected){
              //   ref.read(itemProvider.notifier).updateSelectedDayBookList(vouchers.map((e) => e['value']).toList());
              //   String formattedList = ref.watch(itemProvider).selectedDayBookList.map((e) => '\\\"$e\\\"').join(',');
              //   ref.read(itemProvider).updateVoucherType('[$formattedList]');
              //
              //
              // }

              String ledgerItem = ledgers[0];
              String branchItem = branches[0];


              final ledgerItemData = ref.watch(itemProvider).ledgerItem2;
              final updatedLedgerItemData = ref.watch(itemProvider).updateLedgerItem2;

              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                ref.read(itemProvider).updateBranch2(branchItem);
              });

              final branchItemData = ref.watch(itemProvider).branchItem2;
              final voucherItemData = ref.watch(itemProvider).voucherTypeItem;
              final isDetailed = ref.watch(itemProvider).isDetailed;



              String getLedgerValue(String ledgerVal) {
                if (ledgerVal == "ALL") {
                  return 'LedgerId--0';
                } else {
                  return 'LedgerId--${data[2][ledgerItemData]}';
                }
              }

              String getBranchValue(String branchVal) {
                if (branchVal == "ALL") {
                  return 'BranchId--0';
                } else {
                  return 'BranchId--${data[0][branchItemData]}';
                }
              }

              String getCurrentDate(TextEditingController txt) {
                if (txt.text.isEmpty) {
                  return 'currentDate--2022/07/17';
                } else {
                  return 'currentDate--${txt.text.trim()}';
                }
              }


              DataFilterModel filterModel = DataFilterModel();
              filterModel.tblName = "DayBookReport";
              filterModel.strName = "";
              filterModel.underColumnName = null;
              filterModel.underIntID = 0;
              filterModel.columnName = null;
              filterModel.filterColumnsString =
              "[\"${getBranchValue(branchItemData)}\",\"${getCurrentDate(dateFrom)}\",\"voucherType--$voucherItemData\",\"${getLedgerValue(updatedLedgerItemData)}\",\"isDetailed--$isDetailed\"]";
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Date',style: TextStyle(color: ColorManager.primary,fontWeight: FontWeight.bold),)),
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
                                      dateFrom.text =
                                          DateFormat('yyyy/MM/dd')
                                              .format(pickDate);
                                    });
                                  }
                                } ,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
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
                              SizedBox(
                                height: 20,
                              ),
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
                                  branchName = value;
                                  ref.read(itemProvider).updateBranch2(value);
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Voucher Type',style: TextStyle(color: ColorManager.primary,fontWeight: FontWeight.bold),)),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: MultiSelectDialogField(
                                      title: Text('Voucher Type'),
                                      buttonText: Text(ref.watch(itemProvider).selectedDayBookList.length == vouchers.length?'All':_selectedVouchers.isNotEmpty?'${_selectedVouchers.length} items':'Select items'),
                                      initialValue: ref.watch(itemProvider).selectedDayBookList,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black.withOpacity(0.5),
                                          ),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      chipDisplay: MultiSelectChipDisplay.none(),
                                      searchable: true,
                                      items: vouchers.map((e) => MultiSelectItem(e['value'],e['text'])).toList(),
                                      listType: MultiSelectListType.LIST,
                                      onConfirm: (values) {
                                        ref.read(itemProvider.notifier).updateSelected(false);
                                        ref.read(itemProvider.notifier).updateSelectedDayBookList(values);
                                        String formattedList = '[${ref.watch(itemProvider).selectedDayBookList.map((e) => '\\\"$e\\\"').join(',')}]';
                                        ref.read(itemProvider).updateVoucherType(formattedList);
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Row(
                                    children: [

                                      Checkbox(
                                        value: ref.watch(itemProvider).selectedDayBookList.length == vouchers.length,
                                        onChanged: (value) {
                                          setState(() {
                                            if (value!) {

                                              // Select all items
                                              ref.read(itemProvider.notifier).updateSelectedDayBookList(vouchers.map((e) => e['value']).toList());
                                              String formattedList = '[${ref.watch(itemProvider).selectedDayBookList.map((e) => '\\\"$e\\\"').join(',')}]';
                                              ref.read(itemProvider).updateVoucherType(formattedList);
                                            } else {
                                              // Unselect all items
                                              ref.read(itemProvider.notifier).updateSelected(false);
                                              ref.read(itemProvider.notifier).updateSelectedDayBookList([]);
                                            }
                                          });
                                        },
                                      ),
                                      Text(_selectedVouchers.length == vouchers.length?'Unselect All':'Select All'),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: isDetailed,
                                      onChanged: (val) {
                                        if(isDetailed == true){
                                          ref.read(itemProvider).updateIsDetailed(false);
                                          ref.invalidate(dayBookProvider);
                                        }
                                        else{
                                          ref.read(itemProvider).updateIsDetailed(true);
                                          ref.invalidate(dayBookProvider);
                                        }
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
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  final scaffoldMessage = ScaffoldMessenger.of(context);
                                  if(dateFrom.text.isEmpty){

                                    scaffoldMessage.showSnackBar(
                                      SnackbarUtil.showFailureSnackbar(
                                        message: 'Please pick a date',
                                        duration: const Duration(milliseconds: 1400),
                                      ),
                                    );
                                  }else if(branchItemData == 'All'){
                                    scaffoldMessage.showSnackBar(
                                      SnackbarUtil.showFailureSnackbar(
                                        message: 'Please pick a branch',
                                        duration: const Duration(milliseconds: 1400),
                                      ),
                                    );

                                  }else if(ledgerItemData == 'All'){
                                    scaffoldMessage.showSnackBar(
                                      SnackbarUtil.showFailureSnackbar(
                                        message: 'Please pick a ledger',
                                        duration: const Duration(milliseconds: 1400),
                                      ),
                                    );

                                  }else if(_selectedVouchers.isEmpty){
                                    scaffoldMessage.showSnackBar(
                                      SnackbarUtil.showFailureSnackbar(
                                        message: 'Please pick a voucher type',
                                        duration: const Duration(milliseconds: 1400),
                                      ),
                                    );
                                  }
                                  else{
                                    ref.read(dayBookProvider.notifier).fetchTableData(fModel);
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

                            if(isDetailed == false){
                              List<DayBookModel> newList = <DayBookModel>[];
                              if (data.isNotEmpty) {

                                final tableReport = ReportData.fromJson(data[1]);
                                _totalPages = tableReport.totalPages!;

                                for (var e in data[0]) {
                                  newList.add(DayBookModel.fromJson(e));
                                }
                              } else {
                                return Container();
                              }
                              final filteredData = newList.where((item) {
                                final voucherNo = item.voucherNo.toString().toLowerCase();
                                final voucherName = item.voucherTypeName.toString().toLowerCase();
                                final narration = item.narration.toString().toLowerCase();
                                final amount = item.totalAmount.toString();
                                return voucherNo.contains(searchQuery.toLowerCase()) || voucherName.contains(searchQuery.toLowerCase()) || narration.contains(searchQuery.toLowerCase()) || amount.contains(searchQuery);
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
                                        setState(() {
                                          searchQuery = value;
                                        });
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
                                              buildDataColumn(
                                                  60, 'S.N', TextAlign.center),
                                              buildDataColumn(200, 'Voucher No.',
                                                  TextAlign.center),
                                              buildDataColumn(
                                                  200, 'Ref No', TextAlign.center),
                                              buildDataColumn(
                                                  160, 'Voucher Type', TextAlign.center),
                                              buildDataColumn(
                                                  160, 'Amount', TextAlign.center),
                                              buildDataColumn(200, 'Narration',
                                                  TextAlign.center),
                                              buildDataColumn(160, 'View',
                                                  TextAlign.center),
                                            ],
                                            rows: List.generate(
                                              filteredData.length,
                                                  (index) => buildDayBookReportRow(index, filteredData[index],voucherItemData,getBranchValue(branchItemData), context),
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
                                              ref.read(dayBookProvider.notifier).fetchTableData(fModel);
                                            },
                                            showItemsPerPage: true,
                                            onItemsPerPageChanged: (itemsPerPage) {
                                              _rowPerPage = itemsPerPage;
                                              _currentPage = 1;
                                              /// updates row per page of filterModel, because it does not update on its own
                                              fModel.dataFilterModel!.pageRowCount = _rowPerPage;
                                              ref.read(tableDataProvider.notifier).getTableValues(fModel);
                                            },
                                            itemsPerPageList: rowPerPageItems,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );



                            }
                            else{
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
                              final filteredData = newList.where((item) {
                                final voucherNo = item.voucherNo.toString().toLowerCase();
                                final voucherName = item.particulars.toString().toLowerCase();
                                final narration = item.narration.toString().toLowerCase();
                                final amount = item.strCredit.toString();
                                return voucherNo.contains(searchQuery.toLowerCase()) || voucherName.contains(searchQuery.toLowerCase()) || narration.contains(searchQuery.toLowerCase()) || amount.contains(searchQuery);
                              }).toList();
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
                                          buildDataColumn(200, 'Voucher No.',
                                              TextAlign.center),
                                          buildDataColumn(
                                              200, 'Ref No', TextAlign.center),
                                          buildDataColumn(
                                              160, 'Cheque No', TextAlign.center),
                                          buildDataColumn(
                                              160, 'Voucher Type', TextAlign.center),
                                          buildDataColumn(160, 'Particular',
                                              TextAlign.center),
                                          buildDataColumn(80, 'Dr',
                                              TextAlign.center),
                                          buildDataColumn(80, 'Cr',
                                              TextAlign.center),
                                          buildDataColumn(200, 'Narration',
                                              TextAlign.center),
                                          buildDataColumn(160, 'View',
                                              TextAlign.center)
                                        ],
                                        rows: List.generate(
                                          newList.length,
                                              (index) => buildDayBookDetailedReportRow(index, newList[index],voucherItemData,getBranchValue(branchItemData), context),
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
                                          ref.read(dayBookProvider.notifier).fetchTableData(fModel);
                                        },
                                        showItemsPerPage: true,
                                        onItemsPerPageChanged: (itemsPerPage) {
                                          _rowPerPage = itemsPerPage;
                                          _currentPage = 1;
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
                            }




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
          )
      ),
    );
  }
}
