import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khata_app/features/reports/statement/vat_report/presentation/tabs/above_lakh.dart';
import 'package:khata_app/features/reports/statement/vat_report/presentation/tabs/monthly.dart';
import 'package:khata_app/features/reports/statement/vat_report/presentation/tabs/test.dart';
import 'package:khata_app/features/reports/statement/vat_report/presentation/tabs/vat_report_tab.dart';
import 'package:khata_app/features/reports/statement/vat_report/provider/vat_provider.dart';
import '../../../../../common/colors.dart';

class VatReport extends ConsumerStatefulWidget {
  const VatReport({Key? key}) : super(key: key);

  @override
  ConsumerState<VatReport> createState() => _VatReportState();
}

class _VatReportState extends ConsumerState<VatReport> with TickerProviderStateMixin{
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.primary,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            ref.invalidate(vatReportProvider);
            ref.invalidate(vatReportProvider2);
            ref.invalidate(vatReportProvider3);
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
      body: Column(
        children: [
        Container(
        height: 70,
        width: 390,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15)
        ),
        padding: EdgeInsets.symmetric(vertical: 12),
        child:  TabBar(
            controller: _tabController,
            labelStyle: TextStyle(color: Colors.white),
            unselectedLabelStyle: TextStyle(color: ColorManager.black),
            isScrollable: false,
            labelColor: Colors.white,

            unselectedLabelColor: ColorManager.textGrey,
            // indicatorColor: primary,
            indicator: BoxDecoration(
                color: ColorManager.primary,
                borderRadius: BorderRadius.circular(15)),
            tabs: [
              Tab(
                text: 'Vat Report',
              ),
              Tab(text: 'Above 1 lakh'),
              Tab(text: 'Monthly Vat Report'),
            ]),
      ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children:const [
                // Content for the 'Vat Report' tab
                VatReportTab(),
                // Content for the 'Transaction above one lakh' tab
                AboveLakhTestTab(),
                // Content for the 'Monthly Vat Report' tab
                Monthly(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
