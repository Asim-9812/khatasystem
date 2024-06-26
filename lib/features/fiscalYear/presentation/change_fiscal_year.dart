import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:khata_app/common/common_provider.dart';
import 'package:khata_app/features/fiscalYear/provider/fiscal_year_provider.dart';
import '../../../common/colors.dart';

class FiscalYear extends ConsumerStatefulWidget {
  const FiscalYear({super.key});

  @override
  ConsumerState<FiscalYear> createState() => _FiscalYearState();
}

class _FiscalYearState extends ConsumerState<FiscalYear> {
  int? selectedRowIndex;

  @override
  Widget build(BuildContext context) {
    final fiscalYearList = ref.watch(fiscalYearProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.primary,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 28,
            color: Colors.white,
          ),
        ),
        title: const Text('Change Fiscal Year'),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        toolbarHeight: 70,
      ),
      body:  fiscalYearList.when(
        data: (data){
          return Column(
            children: [

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 80,
                  showCheckboxColumn: false, // Remove the checkbox column
                  headingRowColor: MaterialStateColor.resolveWith((states) => ColorManager.primary),
                  headingTextStyle: const TextStyle(color: Colors.white),
                  columns: [
                    DataColumn(label: Text('S.N')),
                    DataColumn(label: Text('Fiscal Year')),
                    DataColumn(label: Text('From Date')),
                    DataColumn(label: Text('To Date')),
                  ],
                  rows: data.map((e){

                    int index = data.indexOf(e) + 1;
                    return DataRow(
                        cells: [
                          DataCell(Text(index.toString())),
                          DataCell(Text(e.fiscalYear)),
                          DataCell(Text(e.fromDate.toString())),
                          DataCell(Text(e.toDate.toString())),
                        ],
                      onSelectChanged: (isSelected) {
                        setState(() {
                          selectedRowIndex = isSelected! ? index-1 : null;
                        });
                      },
                      color: MaterialStateColor.resolveWith((states) =>
                      selectedRowIndex == index-1 ? ColorManager.primary.withOpacity(0.5) : Colors.transparent),
                    );
                  }).toList(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedRowIndex != null) {
                    final selectedData = data[selectedRowIndex!];

                    final outputDateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
                    final formattedFromDate = outputDateFormat.format(selectedData.fromDate);
                    final formattedToDate = outputDateFormat.format(selectedData.toDate);
                    final fiscalYear = selectedData.fiscalYear;

                    ref.read(itemProvider.notifier).updateFromDate(formattedFromDate);
                    ref.read(itemProvider.notifier).updateToDate(formattedToDate);
                    ref.read(itemProvider.notifier).updateFiscalYear(fiscalYear);
                    ref.read(itemProvider.notifier).updateFiscalId(selectedData.financialYearId);
                    setState(() {
                      selectedRowIndex = null;
                    });
                    Fluttertoast.showToast(
                      msg: 'Fiscal Year changed to $fiscalYear',
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: ColorManager.primary.withOpacity(0.9),
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );

                  } else {
                    Fluttertoast.showToast(
                      msg: 'No date selected',
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: ColorManager.red.withOpacity(0.9),
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                },
                child: Text('Select'),
              ),
            ],
          );
        },
        error: (error,stack) {
          // print(error);
          return const Center(child: Text('error'));
          },
        loading: ()=> Center(
            child: Image.asset("assets/gif/loading-img2.gif", height: 80, width: 80,)
        ),
      ),
    );
  }
}
