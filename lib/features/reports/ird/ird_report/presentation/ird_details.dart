


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../common/colors.dart';
import '../provider/ird_provider.dart';

class IRDDetails extends ConsumerWidget {
  final int masterId;
  IRDDetails({required this.masterId});

  @override
  Widget build(BuildContext context,ref) {
    final getIrdDetails = ref.watch(irdDetailProvider(masterId));
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
        title: const Text('IRD Details'),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        toolbarHeight: 70,
      ),
      body: getIrdDetails.when(
          data: (data){
            return SingleChildScrollView(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateColor.resolveWith((states) => ColorManager.primary),
                    headingTextStyle: TextStyle(color: ColorManager.white),
                    columns: [
                      DataColumn(label: Text('S.N')),
                      DataColumn(label: Text('Voucher No.')),
                      DataColumn(label: Text('Particulars')),
                      DataColumn(label: Text('Qty')),
                      DataColumn(label: Text('Unit')),
                      DataColumn(label: Text('Total Before Tax')),
                      DataColumn(label: Text('Non-taxable')),
                      DataColumn(label: Text('Taxable')),
                      DataColumn(label: Text('VAT')),
                    ],
                    rows: data.map((e) {
                      final index = data.indexWhere((element) => '${element.productName} ${element.qty} ${element.unit}' == '${e.productName} ${e.qty} ${e.unit}');
                      return DataRow(
                          cells: [
                        DataCell(Text('$index')),
                        DataCell(Text('${e.voucherNo}')),
                        DataCell(Text('${e.productName}')),
                        DataCell(Text('${e.qty}')),
                        DataCell(Text('${e.unit}')),
                        DataCell(Text('${e.grossAmt}')),
                        DataCell(Text('${e.nonTaxableAmt}')),
                        DataCell(Text('${e.taxableAmt}')),
                        DataCell(Text('${e.vatAmt}')),
                      ]);
                    }).toList(),

                ),
              ),
            );
          },
        error: (error, stackTrace) => Text('$error'),
        loading: () => Center(
            child: Image.asset("assets/gif/loading-img2.gif", height: 80, width: 80,)),
      ),
    );
  }
}
