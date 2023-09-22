import 'package:dropdown_button3/dropdown_button3.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:khata_app/common/shimmer_loading.dart';
import 'package:khata_app/features/reports/common_widgets/date_input_formatter.dart';
import 'package:khata_app/features/reports/statement/daybook_report/model/daybook_model.dart';
import 'package:khata_app/features/reports/statement/ledger_report/provider/report_provider.dart';
import 'package:khata_app/features/reports/statement/vat_report/model/vat_report_model.dart';
import 'package:khata_app/features/reports/statement/vat_report/provider/vat_provider.dart';
import 'package:khata_app/features/reports/statement/vat_report/widgets/vatRow.dart';
import 'package:khata_app/model/filter%20model/data_filter_model.dart';
import 'package:khata_app/model/filter%20model/filter_any_model.dart';
import 'package:khata_app/model/list%20model/get_list_model.dart';
import 'package:khata_app/features/reports/statement/ledger_report/model/report_model.dart';
import 'package:khata_app/features/dashboard/presentation/home_screen.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:pager/pager.dart';
import '../../../../../../common/colors.dart';
import '../../../../../../common/common_provider.dart';
import '../../../../../../common/snackbar.dart';
import '../../../../common_widgets/build_report_table.dart';
import '../../../daybook_report/widget/daybook_dataRow.dart';


class AboveLakhTab extends ConsumerStatefulWidget {
  const AboveLakhTab({Key? key}) : super(key: key);

  @override
  ConsumerState<AboveLakhTab> createState() => _DayBookReportState();
}

class _DayBookReportState extends ConsumerState<AboveLakhTab> {
  TextEditingController dateFrom = TextEditingController();
  TextEditingController dateTo = TextEditingController();
  late int _currentPage;
  late int _rowPerPage;
  List<int> rowPerPageItems = [5, 10, 15, 20, 25, 50];
  late int _totalPages;
  bool _isChecked = false;
  List _selectedParticulars = [];
  String formattedList = '';
  List _allParticulars = [];
  bool allSelected = true;

  String? formattedValue ;


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
    modelRef.refName = 'AboveLakhVATReport';
    modelRef.isSingleList = 'false';
    modelRef.singleListNameStr = '';
    modelRef.listNameId ="[\"trans_branch\",\"trans_particular\"]";
    modelRef.mainInfoModel = mainInfo;
    modelRef.conditionalValues = '';


    return Consumer(
      builder: (context, ref, child) {
        final fromDate = ref.watch(itemProvider).fromDate;
        final toDate = ref.watch(itemProvider).toDate;
        final outCome = ref.watch(aboveLakhProvider(modelRef));
        final res = ref.watch(vatReportProvider3);
        return WillPopScope(
          onWillPop: () async {
            ref.invalidate(vatReportProvider3);
            setState(() {
              _selectedParticulars = [];
            });

            // Return true to allow the back navigation, or false to prevent it
            return true;
          },
          child: Scaffold(
              body: outCome.when(
                data: (data) {
                  List<Map<dynamic, dynamic>> allList = [];

                  for (var e in data) {
                    allList.add(e);
                  }

                  List<Map<String,dynamic>> particulars = [
                    {'text': 'All', 'value': 'all'}
                  ];
                  List<String> branches = [];

                  data[0].forEach((key, _) {
                    branches.add(key);
                  });
                  data[1].forEach((key, _) {
                    particulars.add({'text': key, 'value': _});
                  });


                  Map<String,dynamic> particularItem = particulars[0];
                  String branchItem = branches[0];



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
                  filterModel.tblName = "VATReportAboveOneLakh";
                  filterModel.strName = "";
                  filterModel.underColumnName = null;
                  filterModel.underIntID = 0;
                  filterModel.columnName = null;
                  filterModel.filterColumnsString =
                  "[\"${getBranchValue(branchItemData)}\",\"${getFromDate(dateFrom)}\",\"${getToDate(dateTo)}\",\"particularType--$particularItemData\"]";
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
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  MultiSelectDialogField(
                                    initialValue: _selectedParticulars,
                                    chipDisplay: MultiSelectChipDisplay(
                                        scroll: true,
                                      scrollBar: HorizontalScrollBar(),
                                      height: 100,
                                    ),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    searchable: true,
                                    items: particulars.map((e) => MultiSelectItem(e['value'],e['text'])).toList(),
                                    listType: MultiSelectListType.LIST,
                                    onConfirm: (values) {
                                      if (values.contains("all")) {
                                        // If "All" is selected, select all items except "All"
                                        _selectedParticulars = particulars.map((e) => e['value']).toList();
                                        _selectedParticulars.remove("all");
                                        String formattedList = _selectedParticulars.map((e) => '$e').join(',');
                                        ref.read(itemProvider).updateParticularType(formattedList);
                                      } else {
                                        // Otherwise, set the selected values as usual
                                        _selectedParticulars = values;
                                        String formattedList = _selectedParticulars.map((e) => '$e').join(',');
                                        ref.read(itemProvider).updateParticularType(formattedList);
                                      }
                                    },
                                  ),

                                  const SizedBox(
                                    height: 20,
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
                                        else if(_selectedParticulars.isEmpty){
                                          scaffoldMessage.showSnackBar(
                                            SnackbarUtil.showFailureSnackbar(
                                              message: 'Please pick a particular type',
                                              duration: const Duration(milliseconds: 1400),
                                            ),
                                          );


                                        }


                                        else{
                                          ref.read(vatReportProvider3.notifier).getTableValues(fModel);
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
                                if(_isChecked == false){
                                  List<AboveLakhModel> newList = <AboveLakhModel>[];
                                  if (data.isNotEmpty) {
                                    final tableReport = ReportData.fromJson(data[1]);
                                    _totalPages = tableReport.totalPages!;
                                    for (var e in data[0]) {
                                      newList.add(AboveLakhModel.fromJson(e));
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
                                              buildDataColumn(200, 'PAN',
                                                  TextAlign.center),
                                              buildDataColumn(
                                                  200, 'Tax Payer', TextAlign.center),
                                              buildDataColumn(
                                                  160, 'Trade Name Type', TextAlign.center),
                                              buildDataColumn(
                                                  160, 'Taxable Amount', TextAlign.center),
                                              buildDataColumn(160, 'Exempted Amount',
                                                  TextAlign.center),
                                            ],
                                            rows: List.generate(
                                              newList.length,
                                                  (index) => buildAboveLakhRow(index, newList[index], allList, context),
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
                                              ref.read(vatReportProvider3.notifier).getTableValues(fModel);
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
                                else{
                                  List<AboveLakhModel> newList = <AboveLakhModel>[];
                                  if (data.isNotEmpty) {
                                    final tableReport = ReportData.fromJson(data[1]);
                                    _totalPages = tableReport.totalPages!;
                                    for (var e in data[0]) {
                                      newList.add(AboveLakhModel.fromJson(e));
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
                                              buildDataColumn(160, 'Dr',
                                                  TextAlign.center),
                                              buildDataColumn(160, 'Cr',
                                                  TextAlign.center),
                                              buildDataColumn(200, 'Narration',
                                                  TextAlign.center)
                                            ],
                                            rows: List.generate(
                                              newList.length,
                                                  (index) => buildAboveLakhRow(index, newList[index],allList, context),
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
                                              ref.read(vatReportProvider3.notifier).getTableValues(fModel);
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
