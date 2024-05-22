import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khata_app/features/reports/statement/daybook_report/provider/daybook_report_provider.dart';
import 'package:khata_app/model/filter%20model/data_filter_model.dart';
import 'package:khata_app/model/filter%20model/filter_any_model.dart';
import 'package:khata_app/features/dashboard/presentation/home_screen.dart';
import '../../../../../common/colors.dart';
import '../../customer_ledger_report/widget/table_widget.dart';
import '../model/daybook_model.dart';
import '../widget/daybook_dataRow.dart';



class DayBookReportView extends StatelessWidget {
  final String voucherTypeId;
  final String voucherNo;
  final int ledgerId;
  final String date;
  final String branchId;
  final String refNo;
  DayBookReportView({required this.refNo,required this.voucherNo,required this.date,required this.branchId,required this.ledgerId,required this.voucherTypeId});

  @override
  Widget build(BuildContext context) {


    DataFilterModel filterModel = DataFilterModel();
    filterModel.tblName = "DayBookReport";
    filterModel.strName = "";
    filterModel.underColumnName = null;
    filterModel.underIntID = 0;
    filterModel.columnName = null;
    filterModel.filterColumnsString =
    "[\"$branchId\",\"currentDate--$date\",\"voucherType--$voucherTypeId\",\"LedgerId--$ledgerId\",\"isDetailed--true\"]";
    filterModel.pageRowCount = 10;
    filterModel.currentPageNumber = 1;
    filterModel.strListNames = "";

    FilterAnyModel fModel = FilterAnyModel();
    fModel.dataFilterModel = filterModel;
    fModel.mainInfoModel = mainInfo;




    return Consumer(
        builder: (context, ref, child){

          final res = ref.watch(dayBookViewProvider(fModel));
          return WillPopScope(
            onWillPop: () async {
              ref.invalidate(dayBookViewProvider);

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
                      ref.invalidate(dayBookViewProvider);
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
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text('Voucher No:',style: TextStyle(fontWeight: FontWeight.bold),),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(voucherNo)
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('Date:',style: TextStyle(fontWeight: FontWeight.bold),),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(date)
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Text('Ref No:',style: TextStyle(fontWeight: FontWeight.bold),),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(refNo)
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          res.when(
                            data: (data) {
                              List<DayBookDetailedModel> newList = <DayBookDetailedModel>[];
                              if (data.isNotEmpty) {
                                for (var e in data[0]) {
                                  newList.add(DayBookDetailedModel.fromJson(e));
                                }
                              } else {
                                return Container();
                              }
                              return Column(
                                children: [
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
                                                  60, 'S.N', TextAlign.start),
                                              buildDataColumn(200, 'Particulars',
                                                  TextAlign.start),
                                              buildDataColumn(200, 'Ref No',
                                                  TextAlign.start),
                                              buildDataColumn(
                                                  200, 'Dr', TextAlign.start),
                                              buildDataColumn(
                                                  160, 'Cr', TextAlign.end),
                                              buildDataColumn(
                                                  160, 'Cheque No', TextAlign.end),
                                              buildDataColumn(160, 'Cheque Date',
                                                  TextAlign.end),
                                              buildDataColumn(200, 'Narration',
                                                  TextAlign.end),
                                            ],
                                            rows: List.generate(
                                              newList.length,
                                                  (index) => buildDayBookViewRow(index, newList[index],'','', context),
                                            ),
                                            columnSpacing: 0,
                                            horizontalMargin: 0,
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(

                                        children: [
                                          Text('Narration:',style: TextStyle(fontWeight: FontWeight.bold),),
                                          Text('${newList.last.mainNarration}')
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Row(

                                            children: [
                                              Text('Dr:',style: TextStyle(fontWeight: FontWeight.bold),),
                                              Text('${newList.last.strDebit}')
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Row(

                                            children: [
                                              Text('Cr:',style: TextStyle(fontWeight: FontWeight.bold),),
                                              Text('${newList.last.strCredit}')
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
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
        }

    );
  }
}


