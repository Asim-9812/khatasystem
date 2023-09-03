import 'package:dropdown_button3/dropdown_button3.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:khata_app/common/shimmer_loading.dart';
import 'package:khata_app/features/reports/common_widgets/date_input_formatter.dart';
import 'package:khata_app/features/reports/statement/customer_ledger_report/model/customer_ledger_report_model.dart';
import 'package:khata_app/features/reports/statement/customer_ledger_report/provider/customer_ledger_report_provider.dart';
import 'package:khata_app/features/reports/statement/daybook_report/model/daybook_model.dart';
import 'package:khata_app/features/reports/statement/daybook_report/model/daybook_model.dart';
import 'package:khata_app/features/reports/statement/daybook_report/model/daybook_model.dart';
import 'package:khata_app/features/reports/statement/daybook_report/provider/daybook_report_provider.dart';
import 'package:khata_app/features/reports/statement/ledger_report/provider/report_provider.dart';
import 'package:khata_app/features/reports/statement/vat_report/model/vat_report_model.dart';
import 'package:khata_app/features/reports/statement/vat_report/model/vat_report_model.dart';
import 'package:khata_app/features/reports/statement/vat_report/model/vat_report_model.dart';
import 'package:khata_app/features/reports/statement/vat_report/provider/vat_provider.dart';
import 'package:khata_app/features/reports/statement/vat_report/provider/vat_provider.dart';
import 'package:khata_app/features/reports/statement/vat_report/provider/vat_provider.dart';
import 'package:khata_app/features/reports/statement/vat_report/provider/vat_provider.dart';
import 'package:khata_app/features/reports/statement/vat_report/provider/vat_provider.dart';
import 'package:khata_app/features/reports/statement/vat_report/provider/vat_provider.dart';
import 'package:khata_app/features/reports/statement/vat_report/provider/vat_provider.dart';
import 'package:khata_app/features/reports/statement/vat_report/widgets/vatRow.dart';
import 'package:khata_app/model/filter%20model/data_filter_model.dart';
import 'package:khata_app/model/filter%20model/filter_any_model.dart';
import 'package:khata_app/model/list%20model/get_list_model.dart';
import 'package:khata_app/features/reports/statement/ledger_report/model/report_model.dart';
import 'package:khata_app/features/dashboard/presentation/home_screen.dart';
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
  }

  void processSelectedItems(FilterAnyModel fModel) {
    if (_selectedParticulars.isEmpty) {
      print('No particulars selected.');
    }

    else if(_selectedParticulars.any((element) => element['text']=='All')){
      print('all');
      formattedValue = '13,14,19,20';
      ref.read(vatReportProvider.notifier).getTableValues(fModel);

    }
    else {
      for (var item in _selectedParticulars) {
        if (item != 'All') {
          formattedValue = _selectedParticulars
              .map((item) => '${item['value']}')
              .join(',');


        }


      }
      print(formattedValue);
      ref.read(vatReportProvider.notifier).getTableValues(fModel);

    }
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
        final outCome = ref.watch(aboveLakhProvider(modelRef));
        final res = ref.watch(vatReportProvider);
        return WillPopScope(
          onWillPop: () async {
            ref.invalidate(vatReportProvider);
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
                  List<String> branches = ['Select a branch'];

                  data[0].forEach((key, _) {
                    branches.add(key);
                  });
                  data[1].forEach((key, _) {
                    particulars.add({'text': key, 'value': _});
                    _allParticulars.add({'text': key, 'value': _});
                  });


                  Map<String,dynamic> particularItem = particulars[0];
                  String branchItem = branches[0];



                  final branchItemData = ref.watch(itemProvider).branchItem;




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
                  "[\"${getBranchValue(branchItemData)}\",\"${getFromDate(dateFrom)}\",\"${getToDate(dateTo)}\",\"particularType--$formattedValue\"]";
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
                                        child: TextField(
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            DateInputFormatter(),
                                            LengthLimitingTextInputFormatter(10)
                                          ],
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          controller: dateFrom,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                    color: Colors.black
                                                        .withOpacity(0.45),
                                                    width: 1,
                                                  )),
                                              contentPadding:
                                              const EdgeInsets.all(10),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                    color: ColorManager.primary,
                                                    width: 1,
                                                  )),
                                              floatingLabelStyle: TextStyle(
                                                  color: ColorManager.primary),
                                              labelText: 'From',
                                              labelStyle: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              alignLabelWithHint: true,
                                              suffixIcon: IconButton(
                                                onPressed: () async {
                                                  DateTime? pickDate =
                                                  await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
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
                                                },
                                                icon: Icon(
                                                  Icons.edit_calendar,
                                                  size: 30,
                                                  color: ColorManager.primary,
                                                ),
                                              )),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: TextField(
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            DateInputFormatter(),
                                            LengthLimitingTextInputFormatter(10)
                                          ],
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.done,
                                          controller: dateTo,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                  color: Colors.black
                                                      .withOpacity(0.45),
                                                  width: 1,
                                                )),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                  color: ColorManager.primary,
                                                  width: 1,
                                                )),
                                            floatingLabelStyle: TextStyle(
                                                color: ColorManager.primary,
                                                fontSize: 18),
                                            contentPadding:
                                            const EdgeInsets.all(15),
                                            labelText: 'To',
                                            labelStyle: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            alignLabelWithHint: true,
                                            suffixIcon: IconButton(
                                              onPressed: () async {
                                                DateTime? pickDate =
                                                await showDatePicker(
                                                    context: context,
                                                    initialDate:
                                                    DateTime.now(),
                                                    firstDate: DateTime.parse(mainInfo.startDate!),
                                                    lastDate: DateTime.now());
                                                if (pickDate != null) {
                                                  setState(() {
                                                    print(pickDate);
                                                    dateTo.text = DateFormat('yyyy/MM/dd').format(pickDate);
                                                  });
                                                }
                                              },
                                              icon: Icon(
                                                Icons.edit_calendar,
                                                size: 30,
                                                color: ColorManager.primary,
                                              ),
                                            ),
                                          ),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
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
                                      ref.read(itemProvider).updateBranch(value);
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: ColorManager.black.withOpacity(0.5),
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2(
                                        dropdownMaxHeight: 400,
                                        isExpanded: true,
                                        barrierLabel: 'Voucher Type',
                                        hint: Align(
                                          alignment: AlignmentDirectional.centerStart,
                                          child: Text(
                                            'Select Voucher Type',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: ColorManager.black,
                                            ),
                                          ),
                                        ),
                                        items: particulars.map((item) {
                                          return DropdownMenuItem<Map<String,dynamic>>(
                                            value: item,
                                            child: StatefulBuilder(
                                              builder: (context, menuSetState) {
                                                final isSelected = _selectedParticulars.contains(item);
                                                return InkWell(
                                                  onTap: () {
                                                    menuSetState(() {

                                                      isSelected
                                                          ? _selectedParticulars.remove(item)
                                                          : _selectedParticulars.add(item);
                                                    });
                                                  },
                                                  child: Container(
                                                    height: double.infinity,
                                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                                    child: Row(
                                                      children: [
                                                        isSelected
                                                            ? const Icon(Icons.check_box_outlined)
                                                            : const Icon(Icons.check_box_outline_blank),
                                                        const SizedBox(width: 16),
                                                        Text(
                                                          item['text'],
                                                          style: const TextStyle(
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        }).toList(),

                                        value: _selectedParticulars.isEmpty ? null : particularItem,

                                        onChanged: (value) {},
                                        selectedItemBuilder: (context) {
                                          return [
                                            Container(
                                              alignment: AlignmentDirectional.centerStart,
                                              child: Text(
                                                _selectedParticulars.isEmpty ? 'Select a Voucher type' : '${_selectedParticulars.length} selected',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ),
                                          ];
                                        },
                                      ),
                                    ),
                                  ),


                                  const SizedBox(
                                    height: 20,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if(dateFrom.text.isEmpty){
                                        final scaffoldMessage = ScaffoldMessenger.of(context);
                                        scaffoldMessage.showSnackBar(
                                          SnackbarUtil.showFailureSnackbar(
                                            message: 'Please pick a date',
                                            duration: const Duration(milliseconds: 1400),
                                          ),
                                        );
                                      }else{
                                        processSelectedItems(fModel);

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
                                                  60, 'S.N', TextAlign.start),
                                              buildDataColumn(200, 'PAN',
                                                  TextAlign.start),
                                              buildDataColumn(
                                                  200, 'Tax Payer', TextAlign.start),
                                              buildDataColumn(
                                                  160, 'Trade Name Type', TextAlign.end),
                                              buildDataColumn(
                                                  160, 'Taxable Amount', TextAlign.end),
                                              buildDataColumn(160, 'Exempted Amount',
                                                  TextAlign.end),
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
                                              ref.read(vatReportProvider.notifier).getTableValues(fModel);
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
                                              buildDataColumn(200, 'Voucher No.',
                                                  TextAlign.start),
                                              buildDataColumn(
                                                  200, 'Ref No', TextAlign.start),
                                              buildDataColumn(
                                                  160, 'Cheque No', TextAlign.end),
                                              buildDataColumn(
                                                  160, 'Voucher Type', TextAlign.end),
                                              buildDataColumn(160, 'Particular',
                                                  TextAlign.end),
                                              buildDataColumn(160, 'Dr',
                                                  TextAlign.end),
                                              buildDataColumn(160, 'Cr',
                                                  TextAlign.end),
                                              buildDataColumn(200, 'Narration',
                                                  TextAlign.end)
                                            ],
                                            rows: List.generate(
                                              newList.length,
                                                  (index) => buildDayBookDetailedReportRow(index, newList[index], allList, context),
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
                                              ref.read(vatReportProvider.notifier).getTableValues(fModel);
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
