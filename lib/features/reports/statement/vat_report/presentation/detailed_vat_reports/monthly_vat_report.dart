import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:khatasystem/features/reports/statement/ledger_report/provider/report_provider.dart';
import 'package:khatasystem/features/reports/statement/vat_report/model/vat_report_model.dart';
import 'package:khatasystem/features/reports/statement/vat_report/provider/vat_provider.dart';
import 'package:khatasystem/features/reports/statement/vat_report/widgets/vatRow.dart';
import 'package:khatasystem/model/filter%20model/data_filter_model.dart';
import 'package:khatasystem/model/filter%20model/filter_any_model.dart';
import 'package:khatasystem/model/list%20model/get_list_model.dart';
import 'package:khatasystem/features/dashboard/presentation/home_screen.dart';
import 'package:pager/pager.dart';
import '../../../../../../../common/colors.dart';
import '../../../../common_widgets/build_report_table.dart';


class MonthlyVatReportTab extends StatelessWidget {
  final MonthlyModel vatData;
  final String branchName;
  MonthlyVatReportTab({required this.vatData,required this.branchName});

  @override
  Widget build(BuildContext context) {
    GetListModel modelRef = GetListModel();
    modelRef.refName = 'VatReport';
    modelRef.isSingleList = 'false';
    modelRef.singleListNameStr = '';
    modelRef.listNameId = "[\"vat_branch\"]";
    modelRef.mainInfoModel = mainInfo;
    modelRef.conditionalValues = '';

    DataFilterModel filterModel = DataFilterModel();
    filterModel.tblName = "VatReport";
    filterModel.strName = "";
    filterModel.underColumnName = null;
    filterModel.underIntID = 0;
    filterModel.columnName = null;
    filterModel.filterColumnsString =
    "[\"branchId--${vatData.branchId}\",\"fromDate--${vatData.monthFromDate}\",\"toDate--${vatData.monthToDate}\"]";
    filterModel.pageRowCount = 25;
    filterModel.currentPageNumber = 1;
    filterModel.strListNames = "";

    FilterAnyModel fModel = FilterAnyModel();
    fModel.dataFilterModel = filterModel;
    fModel.mainInfoModel = mainInfo;


    return Consumer(
      builder: (context, ref, child) {
        final res = ref.watch(vatMonthlyProvider(fModel));


        return WillPopScope(
          onWillPop: () async {
            ref.invalidate(vatReportProvider);

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
                    ref.invalidate(vatReportProvider);
                    Navigator.pop(context, true);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
                title: const Text('Vat Report'),
                titleTextStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                toolbarHeight: 70,
              ),
              body: SafeArea(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Vat Report for ${vatData.month}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                              const SizedBox(
                                height: 20,
                              ),
                              // ElevatedButton(
                              //   onPressed: () async {
                              //     ref.read(vatReportProvider.notifier).getTableValues(fModel);
                              //
                              //
                              //   },
                              //   style: ElevatedButton.styleFrom(
                              //     backgroundColor: ColorManager.green,
                              //     minimumSize: const Size(200, 50),
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(10),
                              //     ),
                              //   ),
                              //   child: const FaIcon(
                              //     FontAwesomeIcons.arrowsRotate,
                              //     color: Colors.white,
                              //     size: 25,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        res.when(
                          data: (data) {
                            List<VatReportModel> newList = <VatReportModel>[];

                            if (data.isNotEmpty) {
                              for (var e in data) {
                                newList.add(VatReportModel.fromJson(e));
                              }
                            } else {
                              return Container();
                            }

                            print(newList);
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
                                                (index) => buildVatRow2(index, newList[index],'branchId--${vatData.branchId}','fromDate--${DateFormat('yyyy/MM/dd').format(vatData.monthFromDate)}','toDate--${DateFormat('yyyy/MM/dd').format(vatData.monthToDate)}', context),
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
                                                    (index) => buildVatRowMonthly(index, newList[index],'branchId--${vatData.branchId}','fromDate--${DateFormat('yyyy/MM/dd').format(vatData.monthFromDate)}','toDate--${DateFormat('yyyy/MM/dd').format(vatData.monthToDate)}', context),
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
                                                (index) => buildVatRowMonthly2(index, newList[index],'branchId--${vatData.branchId}','fromDate--${DateFormat('yyyy/MM/dd').format(vatData.monthFromDate)}','toDate--${DateFormat('yyyy/MM/dd').format(vatData.monthToDate)}', context),
                                          ),
                                          columnSpacing: 0,
                                          horizontalMargin: 0,
                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                            );
                          },
                          error: (error, stackTrace) =>
                              Center(child: Text('$error')),
                          loading: () => Center(
                              child: Image.asset("assets/gif/loading-img2.gif", height: 120, width: 120,)
                          ),),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        );
      },
    );
  }
}

