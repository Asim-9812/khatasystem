

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:khata_app/common/shimmer_loading.dart';
import 'package:khata_app/features/reports/common_widgets/build_report_table.dart';
import 'package:khata_app/features/reports/common_widgets/date_format.dart';
import 'package:khata_app/features/reports/common_widgets/date_input_formatter.dart';
import 'package:khata_app/features/reports/financial/balance_sheet/model/balance_sheet_model.dart';

import 'package:khata_app/features/reports/financial/balance_sheet/provider/balance_report_provider.dart';
import 'package:khata_app/features/reports/statement/ledger_report/provider/report_provider.dart';
import 'package:khata_app/model/filter%20model/data_filter_model.dart';
import 'package:khata_app/model/filter%20model/filter_any_model.dart';
import 'package:khata_app/model/list%20model/get_list_model.dart';
import 'package:khata_app/features/dashboard/presentation/home_screen.dart';

import '../../../../../../common/colors.dart';
import '../../../../../../common/common_provider.dart';
import '../../../../../common/snackbar.dart';
import '../widgets/table_widget.dart';


class BalanceSheetReportPage extends StatefulWidget {
  const BalanceSheetReportPage({Key? key}) : super(key: key);

  @override
  State<BalanceSheetReportPage> createState() => _BalanceSheetReportState();
}

class _BalanceSheetReportState extends State<BalanceSheetReportPage> {
  TextEditingController dateFrom = TextEditingController();
  TextEditingController dateTo = TextEditingController();


  @override
  void initState() {
    super.initState();
    dateFrom.text =DateFormat('yyyy/MM/dd').format( DateTime.parse(mainInfo.startDate!)).toString();
    dateTo.text = DateFormat('yyyy/MM/dd').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {

    GetListModel modelRef = GetListModel();
    modelRef.refName = 'AccountLedgerReport';
    modelRef.isSingleList = 'false';
    modelRef.singleListNameStr = '';
    modelRef.listNameId = "['underGroup', 'mainLedger-${1}', 'mainBranch-${2}']";
    modelRef.mainInfoModel = mainInfo;
    modelRef.conditionalValues = '';

    return Consumer(
      builder: (context, ref, child) {
        final fromDate = ref.watch(itemProvider).fromDate;
        final toDate = ref.watch(itemProvider).toDate;
        final outCome = ref.watch(listProvider(modelRef));
        return WillPopScope(
          onWillPop: () async {
            ref.invalidate(balanceSheetReportProvider);

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
                    ref.invalidate(balanceSheetReportProvider);
                    Navigator.pop(context, true);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
                title: const Text('Balance Sheet'),
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

                  List<String> branches = ['All'];

                  data[2].forEach((key, _) {
                    branches.add(key);
                  });

                  String branchItem = branches[0];

                  final branchItemData = ref.watch(itemProvider).branchItem;

                  GetListModel ledgerGroupListModel = GetListModel();
                  ledgerGroupListModel.refName = 'AccountLedgerReport';
                  ledgerGroupListModel.isSingleList = 'true';
                  ledgerGroupListModel.singleListNameStr = 'account';
                  ledgerGroupListModel.listNameId = "[]";
                  ledgerGroupListModel.mainInfoModel = mainInfo;
                  ledgerGroupListModel.conditionalValues = '';



                  String getBranchValue(String branchVal) {
                    if (branchVal == "All") {
                      return 'BranchId--';
                    } else {
                      return 'BranchId--${data[2][branchItemData]}';
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
                  filterModel.tblName = "BalanceSheeteReport";
                  filterModel.strName = "";
                  filterModel.underColumnName = null;
                  filterModel.underIntID = 0;
                  filterModel.columnName = null;
                  filterModel.filterColumnsString = "[\"${getFromDate(dateFrom)}\",\"${getToDate(dateTo)}\",\"isDetail--false\",\"${getBranchValue(branchItemData)}\"]";
                  filterModel.pageRowCount = 3;
                  filterModel.currentPageNumber = 1;
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
                              height: 250,
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
                                                  lastDate: DateTime.now(),
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
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.parse(mainInfo.startDate!),
                                                  lastDate: DateTime.now(),
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
                                        }
                                        else{
                                          ref.read(balanceSheetReportProvider.notifier).getTableData(fModel);
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
                              height: 20,
                            ),
                            Consumer(
                              builder: (context, ref, child) {
                                final balanceSheetReport = ref.watch(balanceSheetReportProvider);
                                return balanceSheetReport.when(
                                  data: (data) {
                                    List<BalanceSheetReportModel> reportList = <BalanceSheetReportModel>[];
                                    if (data.isNotEmpty) {
                                      for (var e in data[0]) {
                                        reportList.add(BalanceSheetReportModel.fromJson(e));
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
                                                buildDataColumn(100, 'S.N.', TextAlign.start),
                                                buildDataColumn(250, 'Liabilities', TextAlign.start),
                                                buildDataColumn(200, 'Credit', TextAlign.end),
                                                buildDataColumn(200, 'Assets', TextAlign.start),
                                                buildDataColumn(160, 'Debit', TextAlign.end),
                                              ],
                                              rows: List.generate(
                                                reportList.length,
                                                    (index) => buildBalanceSheetDataRow(index, reportList[index], allList, context),
                                              ),
                                              columnSpacing: 0,
                                              horizontalMargin: 0,
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
                                );
                              },
                            ),
                            const SizedBox(height: 50,),
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
                  return Padding(
                    padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Expanded(child: CustomShimmer(width: double.infinity, height: 50, borderRadius: 10,)),
                            SizedBox(width: 10,),
                            Expanded(child: CustomShimmer(width: double.infinity, height: 50, borderRadius: 10,)),
                          ],
                        ),
                        const SizedBox(height: 18,),
                        const CustomShimmer(width: double.infinity, height: 50, borderRadius: 10,),
                        const SizedBox(height: 18,),
                        const CustomShimmer(width: 180, height: 50, borderRadius: 10,),
                        const SizedBox(height: 40,),
                        Row(
                          children: const [
                            Expanded(child: CustomShimmer(width: 40, height: 50,)),
                            SizedBox(width: 1,),
                            Expanded(child: CustomShimmer(width: 180, height: 50,)),
                            SizedBox(width: 1,),
                            Expanded(child: CustomShimmer(width: 120, height: 50,)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

// TableRow buildRow(List<String> cells, {bool isHeader = false, int id = 0}) =>
//       TableRow(
//         decoration: BoxDecoration(
//           color: isHeader
//               ? ColorManager.drawerPrimary
//               : (id % 2 == 0 ? Colors.white : ColorManager.background),
//         ),
//         children: cells.map((cell) {
//           final style = TextStyle(
//             fontFamily: 'Ubuntu',
//             fontSize: isHeader ? 22 : 20,
//             fontWeight: isHeader ? FontWeight.w500 : FontWeight.w400,
//             color: isHeader ? Colors.white : ColorManager.textBlack,
//           );
//
//           return TableCell(
//             child: SizedBox(
//               height: 40,
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 10, top: 5),
//                 child: Text(
//                   cell,
//                   style: style,
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       );
