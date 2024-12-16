import 'dart:convert';

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
import '../../../../../../main.dart';
import '../../../../common_widgets/build_report_table.dart';


class DetailedVatReport extends StatefulWidget {
  final String branchId;
  final String dateFrom;
  final String dateTo;
  final String rowName;
  final int voucherTypeId;
  DetailedVatReport({required this.rowName,required this.voucherTypeId,required this.branchId,required this.dateTo,required this.dateFrom});

  @override
  State<DetailedVatReport> createState() => _DetailedVatReportState();
}

class _DetailedVatReportState extends State<DetailedVatReport> {

  late MainInfoModel2 vatReportMainInfo;

  @override
  Widget build(BuildContext context) {

    var result = sessionBox.get('userReturn');
    var res = jsonDecode(result);

    String selectedBranch = branchBox.get('selectedBranch');
    int branchId = branchBox.get('selectedBranchId');
    final branchDepartmentId = branchBox.get('selectedBranchDepId');



    userId = "${res["userReturn"]["intUserId"]}-${res["ownerCompanyList"]["databaseName"]}";

    String companyName = res["ownerCompanyList"]["companyName"];
    String fiscalYear = res["fiscalYearInfo"]["fiscalYear"];

    vatReportMainInfo = MainInfoModel2(
      userId: res["userReturn"]["intUserId"],
      fiscalID: res["fiscalYearInfo"]["financialYearId"],
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
      startDate: res["fiscalYearInfo"]["fromDate"],
      endDate: res["fiscalYearInfo"]["toDate"],
      sessionId: res["userReturn"]["sessionId"],
      id: widget.voucherTypeId
    );

    DataFilterModel filterModel = DataFilterModel();
    filterModel.tblName = "VatReport";
    filterModel.strName = "";
    filterModel.underColumnName = null;
    filterModel.underIntID = 0;
    filterModel.columnName = null;
    filterModel.filterColumnsString =
    "[\"${widget.branchId}\",\"${widget.dateFrom}\",\"${widget.dateTo}\"]";
    filterModel.pageRowCount = 10;
    filterModel.currentPageNumber = 1;
    filterModel.strListNames = "";

    FilterAnyModel2 fModel = FilterAnyModel2();
    fModel.dataFilterModel = filterModel;
    fModel.mainInfoModel = vatReportMainInfo;

    return Consumer(
      builder: (context, ref, child) {
        final res = ref.watch(vatReportIndividualProvider(fModel));


        return WillPopScope(
          onWillPop: () async {
            ref.invalidate(vatReportIndividualProvider);

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
                    ref.invalidate(vatReportIndividualProvider);
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
                              Text('Vat details of ${widget.rowName}',style:const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                              const SizedBox(
                                height: 10,
                              ),
                              Text('For the period of ${widget.dateFrom} ${widget.dateTo}',style:const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                              const SizedBox(
                                height: 20,
                              ),
                              // ElevatedButton(
                              //   onPressed: () async {
                              //     ref.read(vatReportDetailProvider.notifier).getTableValues2(fModel);
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
                            List<VatReportDetailModel> newList = <VatReportDetailModel>[];

                            if (data.isNotEmpty) {
                              for (var e in data[0]) {
                                newList.add(VatReportDetailModel.fromJson(e));
                              }
                            } else {
                              return Container();
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
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
                                                buildDataColumn(200, 'Invoice Date', TextAlign.center),
                                                buildDataColumn(200, 'Total Amount', TextAlign.center),
                                                buildDataColumn(200, 'Total Taxable Amount', TextAlign.center),
                                              ],
                                              rows: List.generate(
                                                newList.length,
                                                    (index) => buildVatDetailRow(index, newList[index], context),
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
                                                        (index) => buildVatDetailRow2(index, newList[index], context),
                                                  ),
                                                  columnSpacing: 0,
                                                  horizontalMargin: 0,
                                                ),
                                              ],
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
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Text('Total Amount: ${newList.last.allTotalAmount}',style:const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text('Taxable Amount: ${newList.last.allTaxableAmount}',style:const TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text('VAT Amount Dr: ${newList.last.allVATAmountDr}',style:const TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text('VAT Amount Cr: ${newList.last.allVATAmountCr}',style:const TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                              ],
                            );
                          },
                          error: (error, stackTrace) =>
                              Center(child: Text('$error')),
                          loading: () => Center(
                              child: Image.asset("assets/gif/loading-img2.gif", height: 120, width: 120,)
                          ),
                        ),
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

  @override
  void dispose() {
    super.dispose();
  }
}

