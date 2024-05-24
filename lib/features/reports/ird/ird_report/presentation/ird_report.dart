


import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:htmltopdfwidgets/htmltopdfwidgets.dart' as html;
import 'package:intl/intl.dart';
import 'package:khata_app/features/reports/ird/ird_report/model/ird_model.dart';
import 'package:khata_app/features/reports/ird/ird_report/presentation/ird_details.dart';
import 'package:khata_app/features/reports/ird/ird_report/provider/ird_provider.dart';
import 'package:pager/pager.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../common/colors.dart';
import '../../../../../common/common_provider.dart';
import '../../../../../common/snackbar.dart';
import '../../../../../main.dart';
import '../../../../dashboard/presentation/home_screen.dart';

class IRDReport extends ConsumerStatefulWidget {
  const IRDReport({super.key});

  @override
  ConsumerState<IRDReport> createState() => _IRDReportState();
}

class _IRDReportState extends ConsumerState<IRDReport> {

  List<String> typeList = ['Sales Book','Sales Return Book','Purchase Book','Purchase Return Book'];
  List<String> typeTitle = ['बिक्री खाता','बिक्री फिर्ता खाता','खरिद खाता','खरिद फिर्ता खाता'];

  TextEditingController dateFrom = TextEditingController();
  TextEditingController dateTo = TextEditingController();

  Map<String, dynamic> data ={};

  String selectedType ='Sales Book';
  bool isDetailed = false;

  int selectedPage = 1;
  int items = 10;
  List<int> rowPerPageItems = [5, 10, 15, 20, 25, 50];

  final _printKey = GlobalKey<FormState>();
  final TextEditingController _printCountController = TextEditingController();

  @override
  void initState(){
    super.initState();
    dateFrom.text = DateFormat('yyyy-MM-dd').format(DateTime.parse(mainInfo.startDate!));
    dateTo.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _printCountController.text = '1';
  }

  @override
  Widget build(BuildContext context) {

    var result = sessionBox.get('userReturn');
    var res = jsonDecode(result);
    
    final getIrdReport = ref.watch(irdProvider(data));
    final fy = ref.watch(itemProvider).fiscalYear;

    String fiscalYear = fy == ''? res["fiscalYearInfo"]["fiscalYear"] : fy;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.primary,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            ref.invalidate(irdProvider);
            Navigator.pop(context, true);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 28,
            color: Colors.white,
          ),
        ),
        title: const Text('IRD Report'),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        toolbarHeight: 70,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
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
                                    DateFormat('yyyy-MM-dd')
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
                                    DateFormat('yyyy-MM-dd')
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
              const SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(
                    child: DropdownSearch<String>(
                      items: typeList,
                      selectedItem: selectedType,
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
                          labelText: 'Book Type',
                          labelStyle:
                          const TextStyle(fontSize: 18),
                        ),
                      ),
                      popupProps: const PopupProps.menu(
                        showSearchBox: false,
                        fit: FlexFit.loose,
                        constraints:
                        BoxConstraints(maxHeight: 200),
                        showSelectedItems: true,
                        searchFieldProps: TextFieldProps(
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      onChanged: (dynamic value) {
                        // setState(() {
                          selectedType = value;
                        // });
                        print(selectedType);
                      },
                    ),
                  ),
                  const SizedBox(width: 05,),
                  SizedBox(
                    width: 150,
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        isDense:true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: ColorManager.black
                            )
                          ),
                        hintText: 'Detailed',
                        suffixIcon: Checkbox(
                            value: isDetailed,
                            onChanged: (value){
                              setState(() {
                                isDetailed = !isDetailed;
                              });
                            }
                        )
                      ),
                      onTap: (){
                        setState(() {
                          isDetailed = !isDetailed;
                        });
                      },
                    ),
                  ),

                ],
              ),
              const SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () {
                  DateTime fromDate = DateFormat('yyyy-MM-dd').parse(dateFrom.text);
                  DateTime toDate = DateFormat('yyyy-MM-dd').parse(dateTo.text);
                  String from = DateFormat('yyyy-MM-ddThh:mm:ssZ').format(fromDate);
                  String to = DateFormat('yyyy-MM-ddThh:mm:ssZ').format(toDate);
                  if(fromDate.isAfter(toDate)){
                    final scaffoldMessage = ScaffoldMessenger.of(context);
                    scaffoldMessage.showSnackBar(
                      SnackbarUtil.showFailureSnackbar(
                        message: 'From date is after To date',
                        duration: const Duration(milliseconds: 1400),
                      ),
                    );
                  }
                  else{
                    setState(() {
                      data = {
                        "pageNo": selectedPage,
                        "pageSize": items,
                        "viewType": "${isDetailed}",
                        "bookType": typeList.indexOf(selectedType) + 1,
                        "fiscalId": mainInfo.fiscalID,
                        "fromDate": from,
                        "toDate": to
                      };
                    });
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
              const SizedBox(height: 40,),
              if(data.entries.isNotEmpty)
              getIrdReport.when(
                  data: (report){
                    if(report.isEmpty){
                      final scaffoldMessage = ScaffoldMessenger.of(context);
                      scaffoldMessage.showSnackBar(
                        SnackbarUtil.showFailureSnackbar(
                          message: 'No Data Available',
                          duration: const Duration(milliseconds: 1400),
                        ),
                      );
                      return SizedBox();
                    }

                    SalesBookBrief records = report[0];
                    CompanyInfo company = report[1];
                    List<SalesData> reports = report[2];
                    final title = typeTitle[typeList.indexOf(selectedType)];
                    final group = (typeList.indexOf(selectedType) == 0 || typeList.indexOf(selectedType) == 1)? 'ज' : 'छ';
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(title,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 50),),
                        const SizedBox(height: 10,),
                        Text('(नियम २३ को उपनियम (१) को खण्ड ($group) सँग सम्बन्धित )',style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
                        Visibility(
                          visible: typeList.indexOf(selectedType) != 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 10,),
                              Text('करदाता दर्ता नं (PAN) : ${company.companyPanVat}',style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
                              const SizedBox(height: 10,),
                              Text('करदाताको नाम : ${company.companyName} | साल : $fiscalYear',style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
                              const SizedBox(height: 10,),
                              Text('कर अवधि: ${dateFrom.text} देखी ${dateTo.text}',style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20,),
                        _dataTable(reports),
                        const SizedBox(height: 20,),
                        Pager(
                            totalPages: records.totalPages!,
                            onPageChanged: (page){
                              DateTime fromDate = DateFormat('yyyy-MM-dd').parse(dateFrom.text);
                              DateTime toDate = DateFormat('yyyy-MM-dd').parse(dateTo.text);
                              String from = DateFormat('yyyy-MM-ddThh:mm:ssZ').format(fromDate);
                              String to = DateFormat('yyyy-MM-ddThh:mm:ssZ').format(toDate);
                              setState(() {
                                selectedPage = page;
                                data = {
                                  "pageNo": page,
                                  "pageSize": items,
                                  "viewType": "${isDetailed}",
                                  "bookType": typeList.indexOf(selectedType) + 1,
                                  "fiscalId": mainInfo.fiscalID,
                                  "fromDate": from,
                                  "toDate": to
                                };
                              });
                            },
                          showItemsPerPage: true,
                          onItemsPerPageChanged: (itemsPerPage) {
                              print(itemsPerPage);
                            setState(() {
                              DateTime fromDate = DateFormat('yyyy-MM-dd').parse(dateFrom.text);
                              DateTime toDate = DateFormat('yyyy-MM-dd').parse(dateTo.text);
                              String from = DateFormat('yyyy-MM-ddThh:mm:ssZ').format(fromDate);
                              String to = DateFormat('yyyy-MM-ddThh:mm:ssZ').format(toDate);
                              items = itemsPerPage;
                              selectedPage = 1;
                              data = {
                                "pageNo": selectedPage,
                                "pageSize": items,
                                "viewType": "${isDetailed}",
                                "bookType": typeList.indexOf(selectedType) + 1,
                                "fiscalId": mainInfo.fiscalID,
                                "fromDate": from,
                                "toDate": to
                              };
                            });
                          },
                          currentItemsPerPage: items,
                          itemsPerPageList: rowPerPageItems,
                          currentPage: selectedPage,
                          itemsPerPageText: 'Showing ${records.pageSize} of ${records.totalRecords} :',
                        )
                      ],
                    );
                  },
                error: (error, stackTrace) => Text('$error'),
                loading: () => Center(
                    child: Image.asset("assets/gif/loading-img2.gif", height: 80, width: 80,)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dataTable(List<SalesData> salesData){

    if(typeList.indexOf(selectedType) == 0){
      return _salesBook(salesData);
    }
    else if(typeList.indexOf(selectedType) == 1){
      return _salesReturnBook(salesData);
    }
    else if(typeList.indexOf(selectedType) == 2){
      return _purchaseBook(salesData);
    }

    else{
      return _purchaseReturnBook(salesData);
    }


  }

  Widget _salesBook(List<SalesData> salesData){
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 840,
                    height: 50,
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
                        'बीजक',
                        style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 20
                        ),
                      ),
                    ),
                  ),
                  DataTable(
                    headingRowHeight: 80,

                    columns: [
                      irdColumn(100, 'मिति', TextAlign.center),
                      irdColumn(140, 'बीजक नम्बर', TextAlign.center),
                      irdColumn(120, 'खरिदकर्ताको\nनाम', TextAlign.center),
                      irdColumn(120, 'खरिदकर्ताको\nस्थायी लेखा\nनम्बर', TextAlign.center),
                      irdColumn(160, 'वस्तु वा सेवाको\nनाम', TextAlign.center),
                      irdColumn(100, 'वस्तु वा \nसेवाको \nपारीमाण', TextAlign.center),
                      irdColumn(100, 'वस्तु वा सेवाको \nपरिमाण मापन \nगर्ने इकाइ', TextAlign.center),
                    ],
                    rows: List.generate(salesData.length, (index) {
                      DateTime date = DateFormat('yyyy-MM-ddThh:mm:ss').parse(salesData[index].entryDate!);
                      String salesDate = DateFormat('yyyy-MM-dd').format(date);
                      return  DataRow(cells: [
                        buildCell(100, salesDate, TextAlign.center, false),
                        buildCell(140, salesData[index].voucherNo!, TextAlign.center, false),
                        buildCell(120, salesData[index].customerName!, TextAlign.center, false),
                        buildCell(120, salesData[index].pan ?? '', TextAlign.center, false),
                        buildCell(160, salesData[index].productName ?? '', TextAlign.center, false),
                        buildCell(100, '${salesData[index].qty ?? ''}', TextAlign.center, false),
                        buildCell(100, '${salesData[index].unit ?? ''}', TextAlign.center, false),
                      ]);
                    }),
                    columnSpacing: 0,
                    horizontalMargin: 0,
                  ),
                ],
              ),
              DataTable(
                headingRowHeight: 130,
                columnSpacing: 0,
                horizontalMargin: 0,
                columns: [
                  irdColumn2(120, 'जम्मा बिक्री/\nनिकासी (रु)', TextAlign.center),
                  irdColumn2(120, 'स्थानीय कर छुटको\nबिक्री मुल्य (रु)', TextAlign.center),],
                rows: List.generate(salesData.length, (index) {
                  final grossAmt = isDetailed? salesData[index].grossAmt : salesData[index].taxableAmt == 0 ? salesData[index].nonTaxableAmt : salesData[index].taxableAmt;

                  return  DataRow(cells: [
                    buildCell(120, '${grossAmt?.toStringAsFixed(2)}', TextAlign.center, false),
                    buildCell(120, '${salesData[index].nonTaxableAmt ?? 0}', TextAlign.center, false),
                  ],);
                }),
              ),
              Column(
                children: [
                  Container(
                    width: 180,
                    height: 50,
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
                        'करयोग्य बिक्री',
                        style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 20
                        ),
                      ),
                    ),
                  ),
                  DataTable(
                    headingRowHeight: 80,

                    columns: [
                      irdColumn(100, 'मुल्य (रु)', TextAlign.center),
                      irdColumn(80, 'कर (रु)', TextAlign.center),
                    ],
                    rows: List.generate(salesData.length, (index) {
                      DateTime date = DateFormat('yyyy-MM-ddThh:mm:ss').parse(salesData[index].entryDate!);
                      String salesDate = DateFormat('yyyy-MM-dd').format(date);
                      return  DataRow(cells: [
                        buildCell(80, '${salesData[index].taxableAmt?.toStringAsFixed(2)}', TextAlign.center, false),
                        buildCell(80, '${salesData[index].vatAmt}', TextAlign.center, false),
                      ]);
                    }),
                    columnSpacing: 0,
                    horizontalMargin: 0,
                  ),

                ],
              ),
              Column(
                children: [
                  Container(
                    width: 400,
                    height: 50,
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
                        'निकसी',
                        style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 20
                        ),
                      ),
                    ),
                  ),
                  DataTable(
                    headingRowHeight: 80,

                    columns: [
                      irdColumn(100, 'निकसी गरेको \nवस्तु वा सेवाको \nमुल्य(रु)', TextAlign.center),
                      irdColumn(100, 'निकासी \nगरेको देश', TextAlign.center),
                      irdColumn(100, 'ननिकसी \nप्रग्यापनपत्र \nनम्बर', TextAlign.center),
                      irdColumn(100, 'ननिकसी \nप्रग्यापनपत्र \nमिति', TextAlign.center),
                    ],
                    rows: List.generate(salesData.length, (index) {
                      DateTime date = DateFormat('yyyy-MM-ddThh:mm:ss').parse(salesData[index].entryDate!);
                      String salesDate = DateFormat('yyyy-MM-dd').format(date);
                      return  DataRow(cells: [
                        buildCell(100, '0', TextAlign.center, false),
                        buildCell(100, '0', TextAlign.center, false),
                        buildCell(100, '0', TextAlign.center, false),
                        buildCell(100, '0', TextAlign.center, false),
                      ]);
                    }),
                    columnSpacing: 0,
                    horizontalMargin: 0,
                  ),

                ],
              ),
              if(!isDetailed)
              DataTable(
                headingRowHeight: 130,
                columnSpacing: 0,
                horizontalMargin: 0,
                columns: [
                  irdColumn2(120, 'Action', TextAlign.center),],
                rows: List.generate(salesData.length, (index) {

                  return  DataRow(cells: [
                    DataCell(
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: (){
                                _routeToDetails(salesData[index].salesMasterId!);
                              },
                              icon: Icon(Icons.remove_red_eye,color: ColorManager.primary,),
                            ),
                            IconButton(
                              onPressed: (){
                                _printCountDialog(masterId: salesData[index].salesMasterId!);
                              },
                              icon: Icon(Icons.print,color: ColorManager.logoOrange,),
                            ),

                          ],
                        )
                    ),

                  ],);
                }),
              ),
            ],
          ),
        ),

      ],
    );
  }

  Widget _salesReturnBook(List<SalesData> salesData){
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 840,
                    height: 50,
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
                        'बीजक',
                        style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 20
                        ),
                      ),
                    ),
                  ),
                  DataTable(
                    headingRowHeight: 80,

                    columns: [
                      irdColumn(100, 'मिति', TextAlign.center),
                      irdColumn(140, 'बीजक नम्बर', TextAlign.center),
                      irdColumn(120, 'खरिदकर्ताको\nनाम', TextAlign.center),
                      irdColumn(120, 'खरिदकर्ताको\nस्थायी लेखा\nनम्बर', TextAlign.center),
                      irdColumn(160, 'वस्तु वा सेवाको\nनाम', TextAlign.center),
                      irdColumn(100, 'वस्तु वा \nसेवाको \nपारीमाण', TextAlign.center),
                      irdColumn(100, 'वस्तु वा सेवाको \nपरिमाण मापन \nगर्ने इकाइ', TextAlign.center),
                    ],
                    rows: List.generate(salesData.length, (index) {
                      DateTime date = DateFormat('yyyy-MM-ddThh:mm:ss').parse(salesData[index].entryDate!);
                      String salesDate = DateFormat('yyyy-MM-dd').format(date);
                      return  DataRow(cells: [
                        buildCell(100, salesDate, TextAlign.center, false),
                        buildCell(140, salesData[index].voucherNo!, TextAlign.center, false),
                        buildCell(120, salesData[index].customerName!, TextAlign.center, false),
                        buildCell(120, salesData[index].pan ?? '', TextAlign.center, false),
                        buildCell(160, salesData[index].productName ?? '', TextAlign.center, false),
                        buildCell(100, '${salesData[index].qty ?? ''}', TextAlign.center, false),
                        buildCell(100, '${salesData[index].unit ?? ''}', TextAlign.center, false),
                      ]);
                    }),
                    columnSpacing: 0,
                    horizontalMargin: 0,
                  ),
                ],
              ),
              DataTable(
                headingRowHeight: 130,
                columnSpacing: 0,
                horizontalMargin: 0,
                columns: [
                  irdColumn2(120, 'जम्मा \nफिर्ता (रु)', TextAlign.center),
                  irdColumn2(120, 'स्थानीय कर छुटको\nफिर्ता मुल्य (रु)', TextAlign.center),],
                rows: List.generate(salesData.length, (index) {
                  final grossAmt = isDetailed? salesData[index].grossAmt : salesData[index].taxableAmt == 0 ? salesData[index].nonTaxableAmt : salesData[index].taxableAmt;

                  return  DataRow(cells: [
                    buildCell(120, '${grossAmt?.toStringAsFixed(2)}', TextAlign.center, false),
                    buildCell(120, '${salesData[index].nonTaxableAmt ?? 0}', TextAlign.center, false),
                  ],);
                }),
              ),
              Column(
                children: [
                  Container(
                    width: 180,
                    height: 50,
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
                        'करयोग्य फिर्ता',
                        style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 20
                        ),
                      ),
                    ),
                  ),
                  DataTable(
                    headingRowHeight: 80,

                    columns: [
                      irdColumn(100, 'मुल्य (रु)', TextAlign.center),
                      irdColumn(80, 'कर (रु)', TextAlign.center),
                    ],
                    rows: List.generate(salesData.length, (index) {
                      DateTime date = DateFormat('yyyy-MM-ddThh:mm:ss').parse(salesData[index].entryDate!);
                      String salesDate = DateFormat('yyyy-MM-dd').format(date);
                      return  DataRow(cells: [
                        buildCell(100, '${salesData[index].taxableAmt?.toStringAsFixed(2)}', TextAlign.center, false),
                        buildCell(80, '${salesData[index].vatAmt?.toStringAsFixed(2)}', TextAlign.center, false),
                      ]);
                    }),
                    columnSpacing: 0,
                    horizontalMargin: 0,
                  ),

                ],
              ),
              if(!isDetailed)
              DataTable(
                headingRowHeight: 130,
                columnSpacing: 0,
                horizontalMargin: 0,
                columns: [
                  irdColumn2(120, 'Action', TextAlign.center),],
                rows: List.generate(salesData.length, (index) {

                  return  DataRow(cells: [
                    DataCell(
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: (){
                                _routeToDetails(salesData[index].salesMasterId!);
                              },
                              icon: Icon(Icons.remove_red_eye,color: ColorManager.primary,),
                            ),
                            IconButton(
                              onPressed: (){
                                _printCountDialog(masterId: salesData[index].salesMasterId!);
                              },
                              icon: Icon(Icons.print,color: ColorManager.logoOrange,),
                            ),

                          ],
                        )
                    ),

                  ],);
                }),
              ),
            ],
          ),
        ),

      ],
    );
  }

  Widget _purchaseBook(List<SalesData> salesData){
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 1060,
                    height: 50,
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
                        'बीजक / प्रज्ञापनपत्र नम्बर',
                        style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 20
                        ),
                      ),
                    ),
                  ),
                  DataTable(
                    headingRowHeight: 100,

                    columns: [
                      irdPurchaseColumn(100, 'मिति', TextAlign.center),
                      irdPurchaseColumn(140, 'बीजक नम्बर', TextAlign.center),
                      irdPurchaseColumn(140, 'प्रज्ञापनपत्र नम्बर', TextAlign.center),
                      irdPurchaseColumn(160, 'आपूर्तिकर्ताको\nनाम', TextAlign.center),
                      irdPurchaseColumn(120, 'आपूर्तिकर्ताको \nस्थायी लेखा \nनम्बर', TextAlign.center),
                      irdPurchaseColumn(200, 'खरिद/पैठारी \nगरिएका वस्तु \nवा सेवाको \nविवरण', TextAlign.center),
                      irdPurchaseColumn(100, 'खरिद/पैठारी \nगरिएका वस्तु \nवा सेवाको \nपरिमाण', TextAlign.center),
                      irdPurchaseColumn(100, 'खरिद/पैठारी \nगरिएका वस्तु \nवा सेवा मापन \nगर्ने इकाइ', TextAlign.center),
                    ],
                    rows: List.generate(salesData.length, (index) {
                      DateTime date = DateFormat('yyyy-MM-ddThh:mm:ss').parse(salesData[index].entryDate!);
                      String salesDate = DateFormat('yyyy-MM-dd').format(date);
                      return  DataRow(cells: [
                        buildCell(100, salesDate, TextAlign.center, false),
                        buildCell(140, salesData[index].voucherNo!, TextAlign.center, false),
                        buildCell(140, '', TextAlign.center, false),
                        buildCell(160, salesData[index].customerName!, TextAlign.center, false),
                        buildCell(120, salesData[index].pan ?? '', TextAlign.center, false),
                        buildCell(200, salesData[index].productName ?? '', TextAlign.center, false),
                        buildCell(100, '${salesData[index].qty ?? ''}', TextAlign.center, false),
                        buildCell(100, '${salesData[index].unit ?? ''}', TextAlign.center, false),
                      ]);
                    }),
                    columnSpacing: 0,
                    horizontalMargin: 0,
                  ),
                ],
              ),
              DataTable(
                headingRowHeight: 150,
                columnSpacing: 0,
                horizontalMargin: 0,
                columns: [
                  irdPurchaseColumn2(120, 'जम्मा खरिद \nमूल्य (रु)', TextAlign.center),
                  irdPurchaseColumn2(120, 'कर छुट हुने \nवस्तु वा सेवाको \nखरिद/पैठारी \nमूल्य (रु)', TextAlign.center),],
                rows: List.generate(salesData.length, (index) {
                  final grossAmt = isDetailed? salesData[index].grossAmt : salesData[index].taxableAmt == 0 ? salesData[index].nonTaxableAmt : salesData[index].taxableAmt;

                  return  DataRow(cells: [
                    buildCell(120, '${grossAmt?.toStringAsFixed(2)}', TextAlign.center, false),
                    buildCell(120, '${salesData[index].nonTaxableAmt ?? 0}', TextAlign.center, false),
                  ],);
                }),
              ),
              Column(
                children: [
                  Container(
                    width: 200,
                    height: 70,
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
                        'करयोग्य खरिद\n(पूंजीगत बाहेक)',
                        style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 20
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataTable(
                    headingRowHeight: 80,

                    columns: [
                      irdPurchaseColumn(100, 'मुल्य (रु)', TextAlign.center),
                      irdPurchaseColumn(100, 'कर (रु)', TextAlign.center),
                    ],
                    rows: List.generate(salesData.length, (index) {
                      DateTime date = DateFormat('yyyy-MM-ddThh:mm:ss').parse(salesData[index].entryDate!);
                      String salesDate = DateFormat('yyyy-MM-dd').format(date);
                      return  DataRow(cells: [
                        buildCell(100, '${salesData[index].taxableAmt?.toStringAsFixed(2)}', TextAlign.center, false),
                        buildCell(100, '${salesData[index].vatAmt?.toStringAsFixed(2)}', TextAlign.center, false),
                      ]);
                    }),
                    columnSpacing: 0,
                    horizontalMargin: 0,
                  ),

                ],
              ),
              Column(
                children: [
                  Container(
                    width: 200,
                    height: 70,
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
                        'करयोग्य पैठारी \n(पूंजीगत बाहेक)',
                        style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 20
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataTable(
                    headingRowHeight: 80,

                    columns: [
                      irdPurchaseColumn(100, 'मुल्य (रु)', TextAlign.center),
                      irdPurchaseColumn(100, 'कर  (रु)', TextAlign.center),
                    ],
                    rows: List.generate(salesData.length, (index) {
                      DateTime date = DateFormat('yyyy-MM-ddThh:mm:ss').parse(salesData[index].entryDate!);
                      String salesDate = DateFormat('yyyy-MM-dd').format(date);
                      return  DataRow(cells: [
                        buildCell(100, '0', TextAlign.center, false),
                        buildCell(100, '0', TextAlign.center, false),
                      ]);
                    }),
                    columnSpacing: 0,
                    horizontalMargin: 0,
                  ),

                ],
              ),
              Column(
                children: [
                  Container(
                    width: 200,
                    height: 70,
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
                        'पूंजीगत करयोग्य \nखरिद / पैठारी',
                        style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 20
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataTable(
                    headingRowHeight: 80,

                    columns: [
                      irdPurchaseColumn(100, 'मुल्य (रु)', TextAlign.center),
                      irdPurchaseColumn(100, 'कर  (रु)', TextAlign.center),
                    ],
                    rows: List.generate(salesData.length, (index) {
                      DateTime date = DateFormat('yyyy-MM-ddThh:mm:ss').parse(salesData[index].entryDate!);
                      String salesDate = DateFormat('yyyy-MM-dd').format(date);
                      return  DataRow(cells: [
                        buildCell(100, '0', TextAlign.center, false),
                        buildCell(100, '0', TextAlign.center, false),
                      ]);
                    }),
                    columnSpacing: 0,
                    horizontalMargin: 0,
                  ),

                ],
              ),
              if(!isDetailed)
              DataTable(
                headingRowHeight: 150,
                columnSpacing: 0,
                horizontalMargin: 0,
                columns: [
                  irdPurchaseColumn2(120, 'Action', TextAlign.center),],
                rows: List.generate(salesData.length, (index) {

                  return  DataRow(cells: [
                    DataCell(
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: (){
                                _routeToDetails(salesData[index].salesMasterId!);
                              },
                              icon: Icon(Icons.remove_red_eye,color: ColorManager.primary,),
                            ),
                            IconButton(
                              onPressed: (){
                                _printCountDialog(masterId: salesData[index].salesMasterId!);
                              },
                              icon: Icon(Icons.print,color: ColorManager.logoOrange,),
                            ),

                          ],
                        )
                    ),

                  ],);
                }),
              ),
            ],
          ),
        ),

      ],
    );
  }

  Widget _purchaseReturnBook(List<SalesData> salesData){
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 1060,
                    height: 50,
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
                        'बीजक / प्रज्ञापनपत्र नम्बर',
                        style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 20
                        ),
                      ),
                    ),
                  ),
                  DataTable(
                    headingRowHeight: 100,

                    columns: [
                      irdPurchaseColumn(100, 'मिति', TextAlign.center),
                      irdPurchaseColumn(140, 'बीजक नम्बर', TextAlign.center),
                      irdPurchaseColumn(140, 'प्रज्ञापनपत्र नम्बर', TextAlign.center),
                      irdPurchaseColumn(160, 'आपूर्तिकर्ताको\nनाम', TextAlign.center),
                      irdPurchaseColumn(120, 'आपूर्तिकर्ताको \nस्थायी लेखा \nनम्बर', TextAlign.center),
                      irdPurchaseColumn(200, 'खरिद/पैठारी \nफिर्ता गरिएका \nवस्तु वा सेवाको \nविवरण', TextAlign.center),
                      irdPurchaseColumn(100, 'खरिद/पैठारी \nफिर्ता गरिएका \nवस्तु वा सेवाको \nपरिमाण', TextAlign.center),
                      irdPurchaseColumn(100, 'वस्तु वा सेवाको \nएकाई', TextAlign.center),
                    ],
                    rows: List.generate(salesData.length, (index) {
                      DateTime date = DateFormat('yyyy-MM-ddThh:mm:ss').parse(salesData[index].entryDate!);
                      String salesDate = DateFormat('yyyy-MM-dd').format(date);
                      return  DataRow(cells: [
                        buildCell(100, salesDate, TextAlign.center, false),
                        buildCell(140, salesData[index].voucherNo!, TextAlign.center, false),
                        buildCell(140, '', TextAlign.center, false),
                        buildCell(160, salesData[index].customerName!, TextAlign.center, false),
                        buildCell(120, salesData[index].pan ?? '', TextAlign.center, false),
                        buildCell(200, salesData[index].productName ?? '', TextAlign.center, false),
                        buildCell(100, '${salesData[index].qty ?? ''}', TextAlign.center, false),
                        buildCell(100, '${salesData[index].unit ?? ''}', TextAlign.center, false),
                      ]);
                    }),
                    columnSpacing: 0,
                    horizontalMargin: 0,
                  ),
                ],
              ),
              DataTable(
                headingRowHeight: 150,
                columnSpacing: 0,
                horizontalMargin: 0,
                columns: [
                  irdPurchaseColumn2(120, 'जम्मा फिर्ता \nमूल्य (रु)', TextAlign.center),
                  irdPurchaseColumn2(120, 'कर छुट हुने \nवस्तु वा सेवाको \nफिर्ता मूल्य (रु)', TextAlign.center),],
                rows: List.generate(salesData.length, (index) {
                  final grossAmt = isDetailed? salesData[index].grossAmt : salesData[index].taxableAmt == 0 ? salesData[index].nonTaxableAmt : salesData[index].taxableAmt;

                  return  DataRow(cells: [
                    buildCell(120, '${grossAmt?.toStringAsFixed(2)}', TextAlign.center, false),
                    buildCell(120, '${salesData[index].nonTaxableAmt ?? 0}', TextAlign.center, false),
                  ],);
                }),
              ),
              Column(
                children: [
                  Container(
                    width: 200,
                    height: 70,
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
                        'करयोग्य फिर्ता \n(पूंजीगत बाहेक)',
                        style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 20
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataTable(
                    headingRowHeight: 80,

                    columns: [
                      irdPurchaseColumn(100, 'मुल्य (रु)', TextAlign.center),
                      irdPurchaseColumn(100, 'कर (रु)', TextAlign.center),
                    ],
                    rows: List.generate(salesData.length, (index) {
                      DateTime date = DateFormat('yyyy-MM-ddThh:mm:ss').parse(salesData[index].entryDate!);
                      String salesDate = DateFormat('yyyy-MM-dd').format(date);
                      return  DataRow(cells: [
                        buildCell(100, '${salesData[index].taxableAmt?.toStringAsFixed(2)}', TextAlign.center, false),
                        buildCell(100, '${salesData[index].vatAmt?.toStringAsFixed(2)}', TextAlign.center, false),
                      ]);
                    }),
                    columnSpacing: 0,
                    horizontalMargin: 0,
                  ),

                ],
              ),
              Column(
                children: [
                  Container(
                    width: 200,
                    height: 70,
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
                        'करयोग्य फिर्ता \n(पूंजीगत बाहेक)',
                        style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 20
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataTable(
                    headingRowHeight: 80,

                    columns: [
                      irdPurchaseColumn(100, 'मुल्य (रु)', TextAlign.center),
                      irdPurchaseColumn(100, 'कर  (रु)', TextAlign.center),
                    ],
                    rows: List.generate(salesData.length, (index) {
                      DateTime date = DateFormat('yyyy-MM-ddThh:mm:ss').parse(salesData[index].entryDate!);
                      String salesDate = DateFormat('yyyy-MM-dd').format(date);
                      return  DataRow(cells: [
                        buildCell(100, '0', TextAlign.center, false),
                        buildCell(100, '0', TextAlign.center, false),
                      ]);
                    }),
                    columnSpacing: 0,
                    horizontalMargin: 0,
                  ),

                ],
              ),
              Column(
                children: [
                  Container(
                    width: 200,
                    height: 70,
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
                        'पूंजीगत करयोग्य \n फिर्ता',
                        style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 20
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataTable(
                    headingRowHeight: 80,

                    columns: [
                      irdPurchaseColumn(100, 'मुल्य (रु)', TextAlign.center),
                      irdPurchaseColumn(100, 'कर  (रु)', TextAlign.center),
                    ],
                    rows: List.generate(salesData.length, (index) {
                      DateTime date = DateFormat('yyyy-MM-ddThh:mm:ss').parse(salesData[index].entryDate!);
                      String salesDate = DateFormat('yyyy-MM-dd').format(date);
                      return  DataRow(cells: [
                        buildCell(100, '0', TextAlign.center, false),
                        buildCell(100, '0', TextAlign.center, false),
                      ]);
                    }),
                    columnSpacing: 0,
                    horizontalMargin: 0,
                  ),

                ],
              ),
              if(!isDetailed)
              DataTable(
                headingRowHeight: 150,
                columnSpacing: 0,
                horizontalMargin: 0,
                columns: [
                  irdPurchaseColumn2(120, 'Action', TextAlign.center),],
                rows: List.generate(salesData.length, (index) {

                  return  DataRow(cells: [
                    DataCell(
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: (){
                                _routeToDetails(salesData[index].salesMasterId!);
                              },
                              icon: Icon(Icons.remove_red_eye,color: ColorManager.primary,),
                            ),
                            IconButton(
                              onPressed: (){
                                _printCountDialog(masterId: salesData[index].salesMasterId!);
                              },
                              icon: Icon(Icons.print,color: ColorManager.logoOrange,),
                            ),

                          ],
                        )
                    ),

                  ],);
                }),
              ),
            ],
          ),
        ),

      ],
    );
  }

  DataColumn irdColumn(double colWidth, String colName, TextAlign alignTxt) {
    return DataColumn(
      label: Container(
        height: 80,
        width: colWidth,
        decoration: BoxDecoration(
            color: ColorManager.primary,
            border: const Border(
                right: BorderSide(
                  color: Colors.white,
                  width: 1,
                ))),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            colName,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: alignTxt,
          ),
        ),
      ),
    );
  }

  DataColumn irdColumn2(double colWidth, String colName, TextAlign alignTxt) {
    return DataColumn(
      label: Container(
        height: 140,
        width: colWidth,
        decoration: BoxDecoration(
            color: ColorManager.primary,
            border: const Border(
                right: BorderSide(
                  color: Colors.white,
                  width: 1,
                ))),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Text(
              colName,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: alignTxt,
            ),
          ),
        ),
      ),
    );
  }

  DataColumn irdPurchaseColumn(double colWidth, String colName, TextAlign alignTxt) {
    return DataColumn(
      label: Container(
        height: 100,
        width: colWidth,
        decoration: BoxDecoration(
            color: ColorManager.primary,
            border: const Border(
                right: BorderSide(
                  color: Colors.white,
                  width: 1,
                ))),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            colName,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: alignTxt,
          ),
        ),
      ),
    );
  }

  DataColumn irdPurchaseColumn2(double colWidth, String colName, TextAlign alignTxt) {
    return DataColumn(
      label: Container(
        height: 160,
        width: colWidth,
        decoration: BoxDecoration(
            color: ColorManager.primary,
            border: const Border(
                right: BorderSide(
                  color: Colors.white,
                  width: 1,
                ))),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Text(
              colName,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: alignTxt,
            ),
          ),
        ),
      ),
    );
  }

  DataCell buildCell(double cellWidth, String cellText, TextAlign cellTextAlign,bool lastRow) {
    return DataCell(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: cellWidth,
        child: Center(
          child: Text(cellText),
        ),
      ),
    );
  }

  void _routeToDetails(int masterId){
    Navigator.push(context, MaterialPageRoute(builder: (context) => IRDDetails(masterId: masterId)));
  }

  void _printCountDialog({
    required int masterId,

  }) async {


    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context){
          return StatefulBuilder(
              builder: (context,setState){
                return AlertDialog(
                  title: Text('Bill Print'),
                  content: Form(
                    key: _printKey,
                    child: TextFormField(
                      controller: _printCountController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        labelText: 'Copies',
                      ),
                      validator: (value){
                        if(value ==null || value.trim().isEmpty){
                          return 'No. of print is required';
                        }
                        else{
                          try{
                            final num = int.parse(value);
                            if(num<1){
                              return 'Invalid Value';
                            }
                          }catch(e){
                            return 'Invalid character';
                          }
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: ColorManager.primary,
                            shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            )
                        ),
                        onPressed: () async {
                          if(_printKey.currentState!.validate()){

                            final count = int.parse(_printCountController.text.trim());


                            final reprint = await IRDProvider.getReprint(masterId: masterId, count: count);
                            if(reprint.isLeft()){
                              Fluttertoast.showToast(
                                msg: 'Printing error',
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: ColorManager.errorRed.withOpacity(0.9),
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              Navigator.pop(context);
                            }
                            else{
                              final rightValue = reprint.fold((l) => null, (r) => r);
                              Navigator.pop(context);


                              if(rightValue != null){
                                print('not null');
                              }
                              try{
                                await Printing.layoutPdf(
                                    dynamicLayout: false,
                                    format: html.PdfPageFormat(2480,3508),
                                    onLayout: (PdfPageFormat format) async {
                                  var body = '${rightValue?.result}';

                                  final pdf = pw.Document();
                                  final widgets = await html.HTMLToPdf().convert(body);
                                  pdf.addPage(pw.MultiPage(build: (context) => widgets));
                                  return await pdf.save();
                                });

                              } catch(e){
                                print(' error : $e');
                              }


                              // await Printing.layoutPdf(
                              //     onLayout: (PdfPageFormat format) async => doc.save());
                            }



                          }

                        },
                        child: Text('Print',style: TextStyle(color: ColorManager.white,fontWeight: FontWeight.bold),)
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: ColorManager.errorRed,
                            shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            )
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text('Cancel',style: TextStyle(color: ColorManager.white,fontWeight: FontWeight.bold),)
                    ),
                  ],
                );
              }
          );
        }
    );

    _printCountController.clear();

  }

}


