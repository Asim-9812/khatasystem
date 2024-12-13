import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:khata_app/common/shimmer_loading.dart';
import 'package:khata_app/features/reports/common_widgets/date_input_formatter.dart';
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


class VatReportTab extends StatefulWidget {
  const VatReportTab({Key? key}) : super(key: key);

  @override
  State<VatReportTab> createState() => _VatReportTabState();
}

class _VatReportTabState extends State<VatReportTab> {
  TextEditingController dateFrom = TextEditingController();
  TextEditingController dateTo = TextEditingController();
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
    dateFrom.text =DateFormat('yyyy/MM/dd').format( DateTime.parse(mainInfo.startDate!)).toString();
    dateTo.text =!DateTime.parse(mainInfo.endDate!).isAfter(DateTime.now())?DateFormat('yyyy/MM/dd').format(DateTime.parse(mainInfo.endDate!)):DateFormat('yyyy/MM/dd').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    GetListModel2 modelRef = GetListModel2();
    modelRef.refName = 'VatReport';
    modelRef.isSingleList = 'false';
    modelRef.singleListNameStr = '';
    modelRef.listNameId = "[\"vat_branch\"]";
    modelRef.mainInfoModel = mainInfo2;
    modelRef.conditionalValues = '';

    return Consumer(
      builder: (context, ref, child) {
        final fromDate = ref.watch(itemProvider).fromDate;
        final toDate = ref.watch(itemProvider).toDate;
        final outCome = ref.watch(vatListProvider(modelRef));
        final res = ref.watch(vatReportProvider);
        return WillPopScope(
          onWillPop: () async {
            ref.invalidate(vatReportProvider);

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
                      return 'branchId--0';
                    } else {
                      return 'branchId--${data[0][branchItemData]}';
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
                  filterModel.tblName = "VatReport";
                  filterModel.strName = "";
                  filterModel.underColumnName = null;
                  filterModel.underIntID = 0;
                  filterModel.columnName = null;
                  filterModel.filterColumnsString =
                  "[\"${getBranchValue(branchItemData)}\",\"${getFromDate(dateFrom)}\",\"${getToDate(dateTo)}\"]";
                  filterModel.pageRowCount = _rowPerPage;
                  filterModel.currentPageNumber = _currentPage;
                  filterModel.strListNames = "";

                  FilterAnyModel2 fModel = FilterAnyModel2();
                  fModel.dataFilterModel = filterModel;
                  fModel.mainInfoModel = mainInfo2;


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
                                                  initialDate:!DateTime.parse(mainInfo.endDate!).isAfter(DateTime.now())?DateTime.parse(mainInfo.endDate!):DateTime.now(),
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
                                  SizedBox(
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
                                          if(data[0][branchItemData] == null){
                                            final scaffoldMessage = ScaffoldMessenger.of(context);
                                            scaffoldMessage.showSnackBar(
                                              SnackbarUtil.showFailureSnackbar(
                                                message: 'Please select a branch',
                                                duration: const Duration(milliseconds: 1400),
                                              ),
                                            );}
                                          else{
                                            ref.read(vatReportProvider.notifier).getTableValues(fModel);
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
                            const SizedBox(
                              height: 30,
                            ),
                            res.when(
                              data: (data) {
                                List<VatReportModel> newList = <VatReportModel>[];
                                List<String> reportTotal = <String>[];
                                if (data.isNotEmpty) {
                                  for (var e in data) {
                                    newList.add(VatReportModel.fromJson(e));
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
                                                buildDataColumn(200, 'Particulars', TextAlign.center),
                                                buildDataColumn(200, 'Total Amount', TextAlign.center),
                                                buildDataColumn(200, 'Total Taxable Amount', TextAlign.center),
                                              ],
                                              rows: List.generate(
                                                newList.length,
                                                    (index) => buildVatRow(index, newList[index],getBranchValue(branchItemData),getFromDate(dateFrom),getToDate(dateTo),allList, context),
                                              ),
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
                                                      'VAT',
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
                                                    DataColumn(
                                                      label: Container(
                                                        width: 200,
                                                        height: 30,
                                                        decoration: BoxDecoration(
                                                          color: ColorManager.primary,
                                                          border: const Border(
                                                            right: BorderSide(
                                                              color: Colors.white,
                                                              width: 1,
                                                            ),
                                                          ),
                                                        ),
                                                        child:const Padding(
                                                          padding: EdgeInsets.only(left: 10, top: 6, right: 10),
                                                          child: Text(
                                                            'Dr',
                                                            style: TextStyle(
                                                              fontFamily: 'Ubuntu',
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.white,
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Container(
                                                        width: 200,
                                                        height: 30,
                                                        decoration: BoxDecoration(
                                                          color: ColorManager.primary,
                                                          border: const Border(
                                                            right: BorderSide(
                                                              color: Colors.white,
                                                              width: 1,
                                                            ),
                                                          ),
                                                        ),
                                                        child:const Padding(
                                                          padding: EdgeInsets.only(left: 10, top: 6, right: 10),
                                                          child: Text(
                                                            'Cr',
                                                            style: TextStyle(
                                                              fontFamily: 'Ubuntu',
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.white,
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                  rows: List.generate(
                                                    newList.length,
                                                        (index) => buildVatRowVAT(index, newList[index],getBranchValue(branchItemData),getFromDate(dateFrom),getToDate(dateTo),allList, context),
                                                  ),
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
                                              rows: List.generate(
                                                newList.length,
                                                    (index) => buildVatRowView(index, newList[index],getBranchValue(branchItemData),getFromDate(dateFrom),getToDate(dateTo),allList, context),
                                              ),
                                              columnSpacing: 0,
                                              horizontalMargin: 0,
                                            ),
                                          ],
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
                                        //     ref.read(vatReportProvider.notifier).getTableValues(fModel);
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

