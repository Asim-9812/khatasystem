import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:khata_app/common/common_provider.dart';

import '../../../common/colors.dart';
import '../model/fiscal_year_model.dart';

class FiscalYear extends ConsumerStatefulWidget {
  const FiscalYear({super.key});

  @override
  ConsumerState<FiscalYear> createState() => _FiscalYearState();
}

class _FiscalYearState extends ConsumerState<FiscalYear> {
  int? selectedRowIndex;
  @override
  Widget build(BuildContext context) {

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
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              showCheckboxColumn: true, // Add this line to hide the checkbox in the heading row
              headingRowColor: MaterialStateColor.resolveWith((states) => ColorManager.primary),
              headingTextStyle: const TextStyle(color: Colors.white),
              columns: [
                DataColumn(label: Text('S.N')),
                DataColumn(label: Text('Fiscal Year')),
                DataColumn(label: Text('From Date')),
                DataColumn(label: Text('To Date')),
              ],
              rows: dummy_data.asMap().entries.map((entry) {
                final int index = entry.key;
                final Map<String, dynamic> data = entry.value;
                return DataRow(
                  selected: selectedRowIndex == index,
                  onSelectChanged: (isSelected) {
                    setState(() {
                      selectedRowIndex = isSelected! ? index : null;
                    });
                  },
                  cells: [
                    DataCell(Text(data['s.n'].toString())),
                    DataCell(Text(data['fiscal year'])),
                    DataCell(Text(data['from date'])),
                    DataCell(Text(data['to date'])),
                  ],
                );
              }).toList(),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (selectedRowIndex != null) {
                final selectedData = dummy_data[selectedRowIndex!];
                // Parse the date in "dd/MM/yyyy" format
                final inputDateFormat = DateFormat('dd/MM/yyyy');
                final fromDate = inputDateFormat.parse(selectedData['from date']);
                final toDate = inputDateFormat.parse(selectedData['to date']);

// Format the date as "yyyy/MM/dd"
                final outputDateFormat = DateFormat('yyyy/MM/dd');
                final formattedFromDate = outputDateFormat.format(fromDate);
                final formattedToDate = outputDateFormat.format(toDate);
                final fiscalYear = selectedData['fiscal year'];

                print(formattedFromDate);
                
                ref.read(itemProvider.notifier).updateFromDate(formattedFromDate);
                ref.read(itemProvider.notifier).updateToDate(formattedToDate);
                ref.read(itemProvider.notifier).updateFiscalYear(fiscalYear);
                print("S.N: ${selectedData['s.n']}, Fiscal Year: ${selectedData['fiscal year']}, From Date: ${selectedData['from date']}, To Date: ${selectedData['to date']}");
              } else {
                print("No date selected.");
              }
            },
            child: Text('Select'),
          ),
        ],
      ),
    );
  }
}
