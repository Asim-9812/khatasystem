import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:khata_app/common/shimmer_loading.dart';
import 'package:khata_app/features/reports/common_widgets/date_input_formatter.dart';
import 'package:khata_app/features/reports/statement/customer_ledger_report/model/customer_ledger_report_model.dart';
import 'package:khata_app/features/reports/statement/customer_ledger_report/provider/customer_ledger_report_provider.dart';
import 'package:khata_app/features/reports/statement/ledger_report/provider/report_provider.dart';
import 'package:khata_app/features/reports/statement/vat_report/presentation/tabs/above_lakh.dart';
import 'package:khata_app/features/reports/statement/vat_report/presentation/tabs/monthly.dart';
import 'package:khata_app/features/reports/statement/vat_report/presentation/tabs/vat_report_tab.dart';
import 'package:khata_app/model/filter%20model/data_filter_model.dart';
import 'package:khata_app/model/filter%20model/filter_any_model.dart';
import 'package:khata_app/model/list%20model/get_list_model.dart';
import 'package:khata_app/features/reports/statement/ledger_report/model/report_model.dart';
import 'package:khata_app/features/dashboard/presentation/home_screen.dart';
import 'package:pager/pager.dart';

import '../../../../../common/colors.dart';
import '../../../../../common/common_provider.dart';
import '../../../../../common/snackbar.dart';
import '../../customer_ledger_report/widget/table_widget.dart';

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
            ref.invalidate(customerLedgerReportProvider);
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
              Tab(text: 'Monthly'),
            ]),
      ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children:const [
                // Content for the 'Vat Report' tab
                VatReportTab(),
                // Content for the 'Transaction above one lakh' tab
                AboveLakhTab(),
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
