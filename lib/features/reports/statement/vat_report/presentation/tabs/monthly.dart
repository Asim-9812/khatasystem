import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:khata_app/common/shimmer_loading.dart';
import 'package:khata_app/features/reports/statement/ledger_report/provider/report_provider.dart';
import 'package:khata_app/features/reports/statement/vat_report/model/vat_report_model.dart';
import 'package:khata_app/features/reports/statement/vat_report/provider/vat_provider.dart';
import 'package:khata_app/features/reports/statement/vat_report/widgets/vatRow.dart';
import 'package:khata_app/model/filter%20model/data_filter_model.dart';
import 'package:khata_app/model/filter%20model/filter_any_model.dart';
import 'package:khata_app/model/list%20model/get_list_model.dart';
import 'package:khata_app/features/dashboard/presentation/home_screen.dart';
import 'package:pager/pager.dart';

import '../../../../../../common/colors.dart';
import '../../../../../../common/common_provider.dart';
import '../../../../../../common/snackbar.dart';
import '../../../customer_ledger_report/widget/table_widget.dart';


class Monthly extends StatefulWidget {
  const Monthly({Key? key}) : super(key: key);

  @override
  State<Monthly> createState() => _MonthlyState();
}

class _MonthlyState extends State<Monthly> {
  TextEditingController dateFrom = TextEditingController();
  TextEditingController dateTo = TextEditingController();
  late int _currentPage;
  late int _rowPerPage;
  List<int> rowPerPageItems = [5, 10, 15, 20, 25, 50];
  late int _totalPages;
  String name = '';

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
    modelRef.refName = 'MonthlyVATReport';
    modelRef.isSingleList = 'false';
    modelRef.singleListNameStr = '';
    modelRef.listNameId = "[\"monthly_branch\"]";
    mainInfo.dbName = mainInfo.dbName;
    modelRef.mainInfoModel = mainInfo;
    modelRef.conditionalValues = '';

    return Consumer(
      builder: (context, ref, child) {
        final fromDate = ref.watch(itemProvider).fromDate;
        final toDate = ref.watch(itemProvider).toDate;
        final outCome = ref.watch(monthlyProvider(modelRef));
        final res = ref.watch(vatReportProvider2);
        return WillPopScope(
          onWillPop: () async {
            ref.invalidate(vatReportProvider2);

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

                  List<String> branches = [];


                  data[0].forEach((key, _) {
                    branches.add(key);
                  });

                  String branchItem = branches[0];

                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    ref.read(itemProvider).updateBranch2(branchItem);
                  });


                  final branchItemData = ref.watch(itemProvider).branchItem2;




                  String getBranchValue(String branchVal) {
                    if (branchVal == "ALL") {
                      return 'BranchId--0';
                    } else {
                      return 'BranchId--${data[0][branchItemData]}';
                    }
                  }



                  DataFilterModel filterModel = DataFilterModel();
                  filterModel.tblName = "MonthlyVATReport";
                  filterModel.strName = "";
                  filterModel.underColumnName = null;
                  filterModel.underIntID = 0;
                  filterModel.columnName = null;
                  filterModel.filterColumnsString =
                  "[\"${getBranchValue(branchItemData)}\"]";
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
                                        name=value;
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if(data[0][branchItemData]==null){
                                        final scaffoldMessage = ScaffoldMessenger.of(context);
                                        scaffoldMessage.showSnackBar(
                                          SnackbarUtil.showFailureSnackbar(
                                            message: 'Select a branch',
                                            duration: const Duration(milliseconds: 1400),
                                          ),
                                        );
                                      }else{
                                        ref.read(vatReportProvider2.notifier).getTableValues(fModel);
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
                                List<MonthlyModel> newList = <MonthlyModel>[];
                                List<String> reportTotal = <String>[];
                                if (data.isNotEmpty) {
                                  for (var e in data) {
                                    newList.add(MonthlyModel.fromJson(e));
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
                                            buildDataColumn(200, 'Month',
                                                TextAlign.center),
                                            buildDataColumn(
                                                200, 'Opening', TextAlign.center),
                                            buildDataColumn(
                                                160, 'Debit', TextAlign.center),
                                            buildDataColumn(
                                                160, 'Credit', TextAlign.center),
                                            buildDataColumn(200, 'Balance',
                                                TextAlign.center),
                                            buildDataColumn(
                                                80, 'View', TextAlign.center),
                                          ],
                                          rows: List.generate(
                                            newList.length,
                                                (index) => buildMonthlyRow(index, newList[index], allList,name, context),
                                          ),
                                          columnSpacing: 0,
                                          horizontalMargin: 0,
                                        ),
                                        // /// Pager package used for pagination
                                        // _totalPages == 0 ? const Text('No records to show', style: TextStyle(fontSize: 16, color: Colors.red),) : Pager(
                                        //   currentItemsPerPage: _rowPerPage,
                                        //   currentPage: _currentPage,
                                        //   totalPages: _totalPages,
                                        //   onPageChanged: (page) {
                                        //     _currentPage = page;
                                        //     /// updates current page number of filterModel, because it does not update on its own
                                        //     fModel.dataFilterModel!.currentPageNumber = _currentPage;
                                        //     ref.read(vatReportProvider2.notifier).getTableValues(fModel);
                                        //   },
                                        //   showItemsPerPage: true,
                                        //   onItemsPerPageChanged: (itemsPerPage) {
                                        //     _rowPerPage = itemsPerPage;
                                        //     _currentPage = 1;
                                        //     /// updates row per page of filterModel, because it does not update on its own
                                        //     fModel.dataFilterModel!.pageRowCount = _rowPerPage;
                                        //     ref.read(tableDataProvider.notifier).getTableValues(fModel);
                                        //   },
                                        //   itemsPerPageList: rowPerPageItems,
                                        // ),
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
