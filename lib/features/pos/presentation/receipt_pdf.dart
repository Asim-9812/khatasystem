



import 'package:flutter/material.dart';
import 'package:khata_app/common/colors.dart';

class ReceiptPdf extends StatelessWidget {
  const ReceiptPdf({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Company Name'),
          Text('Company Address'),
          const SizedBox(height: 20,),
          Text('VAT Number'),
          Text('ABBREVIATED TAX INVOICE'),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bill No'),
                    Text('Bill No'),
                    Text('Bill No'),
                    Text('Bill No'),
                    Text('Bill No'),
                    Text('Bill No'),
                    Text('Bill No'),
                    Text('Bill No'),
                  ],
                ),
                const SizedBox(width: 20,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(': Bill No'),
                    Text(': Bill No'),
                    Text(': Bill No'),
                    Text(': Bill No'),
                    Text(': Bill No'),
                    Text(': Bill No'),
                    Text(': Bill No'),
                    Text(': Bill No'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20,),
          DataTable(
            columnSpacing: 50,
            // headingTextStyle: const TextStyle(fontWeight: FontWeight.bold),
                columns: [
                  DataColumn(label: Text('S.N.')),
                  DataColumn(label: Text('Paritculars')),
                  DataColumn(label: Text('Qty')),
                  DataColumn(label: Text('Rate')),
                  DataColumn(label: Text('Amount')),
                ],
              rows: [
                DataRow(cells: [
                  DataCell(Text('1')),
                  DataCell(Text('Curtains')),
                  DataCell(Text('1')),
                  DataCell(Text('619.54')),
                  DataCell(Text('619.54')),
                ])
              ]
          ),
          Text('-------------------------------------',style: TextStyle(letterSpacing: 5),),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Gross Amount',style: TextStyle(fontWeight: FontWeight.w500),),
                    Text('Discount',style: TextStyle(fontWeight: FontWeight.w500),),
                    Text('Net Amount',style: TextStyle(fontWeight: FontWeight.w500),),

                  ],
                ),
                const SizedBox(width: 20,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(': 619.54',style: TextStyle(fontWeight: FontWeight.w500),),
                    Text(': 0.00',style: TextStyle(fontWeight: FontWeight.w500),),
                    Text(': 619.54',style: TextStyle(fontWeight: FontWeight.w500),),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10,),
          Text('-------------------------------------',style: TextStyle(letterSpacing: 5),),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                Text('Six Hundred Twenty Rupees Only.',style: TextStyle(fontWeight: FontWeight.w500),),
                Divider(),
                Text('Customer ID : 2',style: TextStyle(fontWeight: FontWeight.w500),),
                const SizedBox(height: 10,),
                Text('Thank you for visiting us',style: TextStyle(fontWeight: FontWeight.w500),),
                Divider(),
                Text('Cashier: 1126',style: TextStyle(fontWeight: FontWeight.w500),),

              ],
            ),
          ),

        ],
      ),
    );
  }
}
