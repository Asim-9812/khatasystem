import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

import 'common/colors.dart';
import 'common/route_manager.dart';
import 'features/general_reminder/model/general_reminder_model.dart';
import 'features/notification_controller/notification_controller.dart';

import 'package:timezone/data/latest.dart' as tz;

late Box sessionBox;
late Box branchBox;
final boxA = Provider((ref) => []);
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    )
  );

  await NotificationController.initializeLocalNotifications();
  await NotificationController.initializeIsolateReceivePort();

  // await SunmiPrinter.bindingPrinter();

  tz.initializeTimeZones();
  await Hive.initFlutter();
  Hive.registerAdapter<ReminderPattern>(ReminderPatternAdapter());
  Hive.registerAdapter(GeneralReminderModelAdapter());
  Hive.registerAdapter(InitialReminderAdapter());
  sessionBox = await Hive.openBox('loginSession');
  await Hive.openBox<GeneralReminderModel>('general_reminder_box');
  branchBox = await Hive.openBox('branchInfo');
  final userBox = await Hive.openBox('userLoginData');
  runApp(
     ProviderScope(
      overrides: [
        boxA.overrideWithValue(userBox.values.toList()),
      ],
      child: const KhataApp(),
    ),
  );
}

class KhataApp extends StatefulWidget {
  const KhataApp({Key? key}) : super(key: key);
  @override
  State<KhataApp> createState() => _KhataAppState();
}

class _KhataAppState extends State<KhataApp> {

  @override
  void initState() {
    NotificationController.startListeningNotificationEvents();
    super.initState();
  }

  //default constructor
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ColorManager.primary)
      ),
      builder: (context, child) => ResponsiveWrapper.builder(
        BouncingScrollWrapper.builder(context, child!),
        maxWidth: 926,
        minWidth: 428,
        defaultScale: true,

        breakpoints: [
          const ResponsiveBreakpoint.resize(428, name: MOBILE),
          const ResponsiveBreakpoint.autoScale(700, name: TABLET),
          const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
        ],
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.getRoute,
      initialRoute: Routes.splashRoute,
    );
  }

}
