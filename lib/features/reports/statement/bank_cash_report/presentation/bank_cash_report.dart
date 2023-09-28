



import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:khata_app/features/reports/statement/bank_cash_report/provider/bankCashBookProvider.dart';
import 'package:khata_app/features/reports/statement/bank_cash_report/widget/bankCash_dataRow.dart';
import 'package:khata_app/model/filter%20model/data_filter_model.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:pager/pager.dart';

import '../../../../../common/colors.dart';
import '../../../../../common/common_provider.dart';
import '../../../../../common/shimmer_loading.dart';
import '../../../../../common/snackbar.dart';
import '../../../../../main.dart';
import '../../../../../model/filter model/filter_any_model.dart';
import '../../../../../model/list model/get_list_model.dart';
import '../../../../dashboard/presentation/home_screen.dart';
import '../../customer_ledger_report/widget/table_widget.dart';
import '../../ledger_report/model/report_model.dart';
import '../model/bank_cash_model.dart';

class BankCashReport extends ConsumerStatefulWidget {
  const BankCashReport({super.key});

  @override
  ConsumerState<BankCashReport> createState() => _BankCashReportState();
}

class _BankCashReportState extends ConsumerState<BankCashReport> {

  TextEditingController search = TextEditingController();
  TextEditingController dateFrom = TextEditingController();
  TextEditingController dateTo = TextEditingController();
  late int _currentPage;
  late int _rowPerPage;
  List<int> rowPerPageItems = [5, 10, 15, 20, 25, 50];
  late int _totalPages;
  String branchName = '';
  String groupName = '';
  String voucherValue = '';
  late List _selectedGroups;
  bool _isChecked = false;
  late MainInfoModel2 bankCashReportModel;

  String searchQuery = '';
  GetListModel modelRef2 = GetListModel();
  GetLedgerListModel getLedgerListModel = GetLedgerListModel();




  @override
  void initState() {
    super.initState();
    getList();
    _currentPage = 1;
    _rowPerPage = 10;
    _totalPages = 0;
    dateFrom.text =DateFormat('yyyy/MM/dd').format( DateTime.parse(mainInfo.startDate!)).toString();

    dateTo.text =!DateTime.parse(mainInfo.endDate!).isAfter(DateTime.now())?DateFormat('yyyy/MM/dd').format(DateTime.parse(mainInfo.endDate!)):DateFormat('yyyy/MM/dd').format(DateTime.now());

  }



  void getList() {
    GetListModel modelRef = GetListModel();
    modelRef.refName = 'BankCashBook';
    modelRef.isSingleList = 'false';
    modelRef.singleListNameStr = '';
    modelRef.listNameId = "[\"branch\",\"branch\",\"ledger\"]";
    modelRef.mainInfoModel = mainInfo;
    modelRef.conditionalValues = '';
    setState(() {
      modelRef2 = modelRef;
    });
    print('Executed');
  }

  void ledgerList(){
    GetLedgerListModel ledref = GetLedgerListModel();
    ledref.mainInfoModel = mainInfo;
    ledref.branchId =0;
    ledref.accountGroupId =ref.watch(itemProvider).selectedList ;

    setState(() {
      getLedgerListModel = ledref;
    });

    ref.read(bankCashLedgerListProvider(getLedgerListModel));




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
      searchText: ''
    );









    _selectedGroups =ref.watch(itemProvider).selectedList;
    final outCome = ref.watch(bankCashListProvider(modelRef2));
    final ledgerMenu = ref.watch(bankCashLedgerListProvider(getLedgerListModel));
    final bankCash = ref.watch(bankCashProvider);
    return WillPopScope(
      onWillPop: () async {
        ref.invalidate(bankCashProvider);
        // ref.read(itemProvider.notifier).updateSelectedList([]);

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
              // ref.invalidate(dayBookProvider);
              Navigator.pop(context, true);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 28,
              color: Colors.white,
            ),
          ),
          title: const Text('Bank Cash Book'),
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

              List<Map<String,dynamic>> groups = [];
              List<String> branches = [];

              data[0].forEach((key, _) {
                branches.add(key);
              });
              data[1].forEach((key, _) {
                groups.add({'text': key, 'value': _});
              });


              String branchItem = branches[ref.watch(itemProvider).index];



              final branchItemData = ref.watch(itemProvider).branchItem2;
              final particularItemData = ref.watch(itemProvider).particularTypeItem;




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


              String isDetailed = _isChecked ? 'true' : 'false';
              DataFilterModel filterModel = DataFilterModel();


              filterModel.tblName = "BankCashReport";
              filterModel.strName = "";
              filterModel.underColumnName = null;
              filterModel.underIntID = 0;
              filterModel.columnName = null;
              filterModel.filterColumnsString =
              "[\"fromDate--2023/7/17\",\"toDate--2023/8/28\",\"isDetailed--false\",\"branchId--0\",\"ledgerId--2,23,25\"]";
              filterModel.pageRowCount = _rowPerPage;
              filterModel.currentPageNumber = _currentPage;
              filterModel.strListNames = "";

              FilterAnyModel2 fModel = FilterAnyModel2();
              fModel.dataFilterModel = filterModel;
              fModel.mainInfoModel = bankCashReportModel;


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
                              SizedBox(
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
                                  ref.read(itemProvider).updateBranch2(value);
                                  ref.read(itemProvider.notifier).updateIndex2(branches.indexOf(value));
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Group',style: TextStyle(color: ColorManager.primary,fontWeight: FontWeight.bold),),
                                ),
                              ),
                              MultiSelectDialogField(

                                initialValue: _selectedGroups,
                                buttonText: Text(ref.watch(itemProvider).selectedList.length == groups.length?'All':ref.watch(itemProvider).selectedList.isNotEmpty?'${ref.watch(itemProvider).selectedList.length} items':'Select items'),
                                chipDisplay: MultiSelectChipDisplay.none(),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                searchable: true,

                                items: groups.map((e) => MultiSelectItem(e['value'],e['text'])).toList(),
                                listType: MultiSelectListType.LIST,
                                onConfirm: (values) {
                                  ref.read(itemProvider.notifier).updateSelectedList(values);
                                  ledgerList();
                                  print(getLedgerListModel.toJson());
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(_selectedGroups.length == groups.length?'Unselect All':'Select All'),
                                    Checkbox(
                                      value: _selectedGroups.length == groups.length,
                                      onChanged: (value) {
                                        if (value!) {
                                          // Select all items
                                          ref.read(itemProvider.notifier).updateSelectedList(groups.map((e) => e['value']).toList());
                                          ledgerList();
                                          print(getLedgerListModel.toJson());

                                        } else {
                                          // Unselect all items
                                          ref.read(itemProvider.notifier).updateSelectedList([]);
                                          ledgerList();
                                        }


                                      },
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(
                                height: 20,
                              ),



                              const SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                onPressed:

                                    () async {
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

                                    final scaffoldMessage = ScaffoldMessenger.of(context);
                                    if (toDate.isBefore(fromDate)) {
                                      scaffoldMessage.showSnackBar(
                                        SnackbarUtil.showFailureSnackbar(
                                          message: 'From date is greater than To date',
                                          duration: const Duration(milliseconds: 1400),
                                        ),
                                      );
                                    }
                                    else if(data[0][branchItemData]==null){
                                      scaffoldMessage.showSnackBar(
                                        SnackbarUtil.showFailureSnackbar(
                                          message: 'Select a branch',
                                          duration: const Duration(milliseconds: 1400),
                                        ),
                                      );
                                    }
                                    else if(_selectedGroups.isEmpty){
                                      scaffoldMessage.showSnackBar(
                                        SnackbarUtil.showFailureSnackbar(
                                          message: 'Please select a group',
                                          duration: const Duration(milliseconds: 1400),
                                        ),
                                      );


                                    }


                                    else{
                                      ref.read(bankCashProvider.notifier).fetchTableData(fModel);
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
                        bankCash.when(
                          data: (data) {
                            if(_isChecked == false){
                              List<BankCashModel> newList = <BankCashModel>[];
                              if (data.isNotEmpty) {
                                final tableReport = ReportData.fromJson(data[1]);
                                _totalPages = tableReport.totalPages!;
                                for (var e in data[0]) {
                                  newList.add(BankCashModel.fromJson(e));
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
                                      Row(
                                        children: [
                                          DataTable(
                                            headingRowHeight: 60,
                                            columns: [
                                              buildDataColumn(60, 'S.N', TextAlign.center),
                                              buildDataColumn(200, 'Date', TextAlign.center),
                                              buildDataColumn(200, 'Voucher No', TextAlign.center),
                                              buildDataColumn(160, 'Ref No', TextAlign.center),
                                              buildDataColumn(200, 'Voucher Type', TextAlign.center),
                                            ],
                                            rows: List.generate(data.length, (index) => buildBankCashRow(index, newList[index])),
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
                                                    'Cash',
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
                                                  buildDataColumn(200, 'Dr.', TextAlign.center),
                                                  buildDataColumn(200, 'Cr.', TextAlign.center),
                                                  buildDataColumn(200, 'Balance', TextAlign.center),
                                                ],
                                                rows: List.generate(data.length, (index) => buildBankCashRow1(index, newList[index])),
                                                columnSpacing: 0,
                                                horizontalMargin: 0,
                                              ),
                                            ],
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
                                                    'Bank',
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
                                                  buildDataColumn(200, 'Dr.', TextAlign.center),
                                                  buildDataColumn(200, 'Cr.', TextAlign.center),
                                                  buildDataColumn(200, 'Balance', TextAlign.center),
                                                ],
                                                rows: List.generate(data.length, (index) => buildBankCashRow2(index, newList[index])),
                                                columnSpacing: 0,
                                                horizontalMargin: 0,
                                              ),
                                            ],
                                          ),
                                          DataTable(
                                            headingRowHeight: 60,
                                            columns: [
                                              buildDataColumn(60, 'View', TextAlign.center),
                                            ],
                                            rows: List.generate(data.length, (index) => buildBankCashRow3(index, newList[index])),
                                            columnSpacing: 0,
                                            horizontalMargin: 0,
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
                            }
                            else{
                              List<BankCashDetailedModel> newList = <BankCashDetailedModel>[];
                              if (data.isNotEmpty) {
                                final tableReport = ReportData.fromJson(data[1]);
                                _totalPages = tableReport.totalPages!;
                                for (var e in data[0]) {
                                  newList.add(BankCashDetailedModel.fromJson(e));
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
                                      Row(
                                        children: [
                                          DataTable(
                                            headingRowHeight: 60,
                                            columns: [
                                              buildDataColumn(60, 'S.N', TextAlign.center),
                                              buildDataColumn(200, 'Date', TextAlign.center),
                                              buildDataColumn(200, 'Voucher No', TextAlign.center),
                                              buildDataColumn(160, 'Ref No', TextAlign.center),
                                              buildDataColumn(200, 'Voucher Type', TextAlign.center),
                                              buildDataColumn(200, 'Particulars', TextAlign.center),
                                            ],
                                            rows: List.generate(data.length, (index) => buildBankCashRow(index, data[index])),
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
                                                    'Cash',
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
                                                  buildDataColumn(200, 'Dr.', TextAlign.center),
                                                  buildDataColumn(200, 'Cr.', TextAlign.center),
                                                  buildDataColumn(200, 'Balance', TextAlign.center),
                                                ],
                                                rows: List.generate(data.length, (index) => buildBankCashDetailedRow1(index, newList[index])),
                                                columnSpacing: 0,
                                                horizontalMargin: 0,
                                              ),
                                            ],
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
                                                    'Bank',
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
                                                  buildDataColumn(200, 'Dr.', TextAlign.center),
                                                  buildDataColumn(200, 'Cr.', TextAlign.center),
                                                  buildDataColumn(200, 'Balance', TextAlign.center),
                                                ],
                                                rows: List.generate(data.length, (index) => buildBankCashDetailedRow2(index, newList[index])),
                                                columnSpacing: 0,
                                                horizontalMargin: 0,
                                              ),
                                            ],
                                          ),
                                          DataTable(
                                            headingRowHeight: 60,
                                            columns: [
                                              buildDataColumn(60, 'View', TextAlign.center),
                                            ],
                                            rows: List.generate(data.length, (index) => buildBankCashDetailedRow3(index, newList[index])),
                                            columnSpacing: 0,
                                            horizontalMargin: 0,
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
