// import 'package:dropdown_button3/dropdown_button3.dart';
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:khata_app/common/shimmer_loading.dart';
// import 'package:khata_app/features/reports/common_widgets/date_input_formatter.dart';
// import 'package:khata_app/features/reports/statement/customer_ledger_report/model/customer_ledger_report_model.dart';
// import 'package:khata_app/features/reports/statement/customer_ledger_report/provider/customer_ledger_report_provider.dart';
// import 'package:khata_app/features/reports/statement/daybook_report/model/daybook_model.dart';
// import 'package:khata_app/features/reports/statement/daybook_report/model/daybook_model.dart';
// import 'package:khata_app/features/reports/statement/daybook_report/model/daybook_model.dart';
// import 'package:khata_app/features/reports/statement/daybook_report/provider/daybook_report_provider.dart';
// import 'package:khata_app/features/reports/statement/ledger_report/provider/report_provider.dart';
// import 'package:khata_app/model/filter%20model/data_filter_model.dart';
// import 'package:khata_app/model/filter%20model/filter_any_model.dart';
// import 'package:khata_app/model/list%20model/get_list_model.dart';
// import 'package:khata_app/features/reports/statement/ledger_report/model/report_model.dart';
// import 'package:khata_app/features/dashboard/presentation/home_screen.dart';
// import 'package:pager/pager.dart';
// import 'package:multi_select_flutter/multi_select_flutter.dart';
// import '../../../../../common/colors.dart';
// import '../../../../../common/common_provider.dart';
// import '../../../../../common/snackbar.dart';
//
// class Test extends StatefulWidget {
//   const Test({Key? key}) : super(key: key);
//
//   @override
//   State<Test> createState() => _TestState();
// }
//
// class _TestState extends State<Test> {
//   TextEditingController dateFrom = TextEditingController();
//   TextEditingController dateTo = TextEditingController();
//   late int _currentPage;
//   late int _rowPerPage;
//   List<int> rowPerPageItems = [5, 10, 15, 20, 25, 50];
//   late int _totalPages;
//   bool _isChecked = false;
//   List _selectedVouchers = [];
//   List _allVouchers = [];
//   String formattedList = '';
//
//   bool allSelected = true;
//
//   String? formattedValue ;
//
//   @override
//   void initState() {
//     super.initState();
//     _currentPage = 1;
//     _rowPerPage = 10;
//     _totalPages = 0;
//   }
//
//   void processSelectedItems() {
//     if (_selectedVouchers.isEmpty) {
//       print('No vouchers selected.');
//     }
//
//     else if(_selectedVouchers.any((element) => element['text']=='All')){
//       print('all');
//        formattedValue = _allVouchers
//           .map((item) => '\\\\\\"${item['value']}\\\\\\\"')
//           .join(',');
//
//       print('voucherType--[$formattedValue]');
//     }
//     else {
//         for (var item in _selectedVouchers) {
//           if (item != 'All') {
//              formattedValue = _selectedVouchers
//                 .map((item) => '\\\\\\"${item['value']}\\\\\\\"')
//                 .join(',');
//
//             print('voucherType--[$formattedValue]');
//           }
//         }
//
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     GetListModel modelRef = GetListModel();
//     modelRef.refName = 'DayBook';
//     modelRef.isSingleList = 'false';
//     modelRef.singleListNameStr = '';
//     modelRef.listNameId ="[\"branch\",\"voucherType\",\"ledger\"]";
//     modelRef.mainInfoModel = mainInfo;
//     modelRef.conditionalValues = '';
//
//
//     return Consumer(
//       builder: (context, ref, child) {
//         final outCome = ref.watch(listProvider2(modelRef));
//         final res = ref.watch(dayBookProvider);
//         return WillPopScope(
//           onWillPop: () async {
//             ref.invalidate(dayBookProvider);
//             setState(() {
//               _selectedVouchers = [];
//             });
//
//             // Return true to allow the back navigation, or false to prevent it
//             return true;
//           },
//           child: Scaffold(
//               appBar: AppBar(
//                 backgroundColor: ColorManager.primary,
//                 centerTitle: true,
//                 elevation: 0,
//                 leading: IconButton(
//                   onPressed: () {
//                     ref.invalidate(dayBookProvider);
//                     setState(() {
//                       _selectedVouchers = [];
//                     });
//                     Navigator.pop(context, true);
//                   },
//                   icon: const Icon(
//                     Icons.arrow_back_ios_new_rounded,
//                     size: 28,
//                     color: Colors.white,
//                   ),
//                 ),
//                 title: const Text('Day Book Report'),
//                 titleTextStyle: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.white,
//                 ),
//                 toolbarHeight: 70,
//               ),
//               body: outCome.when(
//                 data: (data) {
//                   List<Map<dynamic, dynamic>> allList = [];
//
//                   for (var e in data) {
//                     allList.add(e);
//                   }
//
//                   List<Map<String,dynamic>> vouchers = [
//                     {'text': 'All', 'value': 'all'}
//                   ];
//
//
//                   data[1].forEach((key, _) {
//                     vouchers.add({'text': key, 'value': _});
//                     _allVouchers.add({'text': key, 'value': _});
//                   });
//
//
//                   // data[1].forEach((key) {
//                   //   vouchers.add(key);
//                   // });
//
//                   Map<String,dynamic> voucherItem = vouchers[0];
//
//
//
//
//
//
//                   return SafeArea(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                       child: SingleChildScrollView(
//                         physics: const ClampingScrollPhysics(),
//                         child: Column(
//                           children: [
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             Container(
//                               width: double.infinity,
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 10, horizontal: 10),
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(0.8),
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                               child: Column(
//                                 children: [
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                         color: ColorManager.black.withOpacity(0.5),
//                                       ),
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: DropdownButtonHideUnderline(
//                                       child: DropdownButton2(
//                                         dropdownMaxHeight: 400,
//                                         isExpanded: true,
//                                         barrierLabel: 'Voucher Type',
//                                         hint: Align(
//                                           alignment: AlignmentDirectional.centerStart,
//                                           child: Text(
//                                             'Select Voucher Type',
//                                             style: TextStyle(
//                                               fontSize: 14,
//                                               color: ColorManager.black,
//                                             ),
//                                           ),
//                                         ),
//                                         items: vouchers.map((item) {
//                                           return DropdownMenuItem<Map<String,dynamic>>(
//                                             value: item,
//                                             child: StatefulBuilder(
//                                               builder: (context, menuSetState) {
//                                                 final isSelected = _selectedVouchers.contains(item);
//                                                 return InkWell(
//                                                   onTap: () {
//                                                     menuSetState(() {
//
//                                                       isSelected
//                                                           ? _selectedVouchers.remove(item)
//                                                           : _selectedVouchers.add(item);
//                                                     });
//                                                   },
//                                                   child: Container(
//                                                     height: double.infinity,
//                                                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                                                     child: Row(
//                                                       children: [
//                                                         isSelected
//                                                             ? const Icon(Icons.check_box_outlined)
//                                                             : const Icon(Icons.check_box_outline_blank),
//                                                         const SizedBox(width: 16),
//                                                         Text(
//                                                           item['text'],
//                                                           style: const TextStyle(
//                                                             fontSize: 14,
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 );
//                                               },
//                                             ),
//                                           );
//                                         }).toList(),
//
//                                         value: _selectedVouchers.isEmpty ? null : _selectedVouchers.first,
//
//                                         onChanged: (value) {},
//                                         selectedItemBuilder: (context) {
//                                           return [
//                                             Container(
//                                               alignment: AlignmentDirectional.centerStart,
//                                               child: Text(
//                                                 _selectedVouchers.length == 0 ? 'Select a Voucher type' : '${_selectedVouchers.length} selected',
//                                                 style: const TextStyle(
//                                                   fontSize: 14,
//                                                   overflow: TextOverflow.ellipsis,
//                                                 ),
//                                                 maxLines: 1,
//                                               ),
//                                             ),
//                                           ];
//                                         },
//                                       ),
//                                     ),
//                                   ),
//
//
//                                   const SizedBox(
//                                     height: 20,
//                                   ),
//                                   Row(
//                                     children: [
//                                       Checkbox(
//                                         value: _isChecked,
//                                         onChanged: (val) {
//                                           setState(() {
//                                             _isChecked =!_isChecked;
//                                           });
//                                         },
//                                         checkColor: Colors.white,
//                                         fillColor:
//                                         MaterialStateProperty.resolveWith(
//                                                 (states) =>
//                                                 getCheckBoxColor(states)),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(2),
//                                         ),
//                                       ),
//                                       const Text('Detailed',
//                                           style: TextStyle(
//                                             fontSize: 18,
//                                           ))
//                                     ],
//                                   ),
//                                   const SizedBox(
//                                     height: 20,
//                                   ),
//                                   ElevatedButton(
//                                     onPressed: () async {
//                                       processSelectedItems();
//                                     },
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: ColorManager.green,
//                                       minimumSize: const Size(200, 50),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                     ),
//                                     child: const FaIcon(
//                                       FontAwesomeIcons.arrowsRotate,
//                                       color: Colors.white,
//                                       size: 25,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//                 error: (error, stackTrace) => Center(
//                   child: Text('$error'),
//                 ),
//                 loading: () {
//                   return const Padding(
//                     padding: EdgeInsets.only(right: 20, left: 20, top: 20),
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.vertical,
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(child: CustomShimmer(width: double.infinity, height: 50, borderRadius: 10,)),
//                               SizedBox(width: 10,),
//                               Expanded(child: CustomShimmer(width: double.infinity, height: 50, borderRadius: 10,)),
//                             ],
//                           ),
//                           SizedBox(height: 18,),
//                           CustomShimmer(width: double.infinity, height: 50, borderRadius: 10,),
//                           SizedBox(height: 18,),
//                           CustomShimmer(width: double.infinity, height: 50, borderRadius: 10,),
//                           SizedBox(height: 18,),
//                           CustomShimmer(width: double.infinity, height: 50, borderRadius: 10,),
//                           SizedBox(height: 18,),
//                           CustomShimmer(width: 180, height: 50, borderRadius: 10,),
//                           SizedBox(height: 40,),
//                           Row(
//                             children: [
//                               Expanded(child: CustomShimmer(width: 40, height: 50,)),
//                               SizedBox(width: 1,),
//                               Expanded(child: CustomShimmer(width: 180, height: 50,)),
//                               SizedBox(width: 1,),
//                               Expanded(child: CustomShimmer(width: 120, height: 50,)),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               )),
//         );
//       },
//     );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
// }
