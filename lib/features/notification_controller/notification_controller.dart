import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:khata_app/features/login/presentation/status_page.dart';






///  *********************************************
///     NOTIFICATION CONTROLLER
///  *********************************************

class NotificationController {
  static ReceivedAction? initialAction;

  ///  *********************************************
  ///     INITIALIZATIONS
  ///  *********************************************
  ///
  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
        null, //'resource://drawable/res_app_icon',//
        [
          NotificationChannel(
              channelKey: 'alerts',
              channelName: 'Alerts',
              channelDescription: 'Notification tests as alerts',
              playSound: true,
              onlyAlertOnce: true,
              groupAlertBehavior: GroupAlertBehavior.Children,
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Private,
              defaultColor: Colors.deepPurple,
              ledColor: Colors.deepPurple)
        ],
        debug: true);

    // Get initial notification action is optional
    initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  static ReceivePort? receivePort;
  static Future<void> initializeIsolateReceivePort() async {
    receivePort = ReceivePort('Notification action port in main isolate')
      ..listen(
              (silentData) => onActionReceivedImplementationMethod(silentData));

    // This initialization only happens on main isolate
    IsolateNameServer.registerPortWithName(
        receivePort!.sendPort, 'notification_action_port');
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS LISTENER
  ///  *********************************************
  ///  Notifications events are only delivered after call this method
  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS
  ///  *********************************************
  ///
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if (receivedAction.actionType == ActionType.SilentAction ||
        receivedAction.actionType == ActionType.SilentBackgroundAction) {
      // For background actions, you must hold the execution until the end
      if(receivedAction.buttonKeyPressed == 'SNOOZE'){
        // final SnackBar snackBar = SnackBar(content: Text("Snoozed for 5 minutes"));
        // snackBarKey.currentState?.showSnackBar(snackBar);
        await snoozeMedNotification();

      }
      // print(
      //     'Message sent via notification input: "${receivedAction.buttonKeyInput}"');
      // await executeLongTaskInBackground();
    } else {
      // this process is only necessary when you need to redirect the user
      // to a new page or use a valid context, since parallel isolates do not
      // have valid context, so you need redirect the execution to main isolate
      if (receivePort == null) {
        print(
            'onActionReceivedMethod was called inside a parallel dart isolate.');
        SendPort? sendPort =
        IsolateNameServer.lookupPortByName('notification_action_port');

        if (sendPort != null) {
          print('Redirecting the execution to main isolate process.');
          sendPort.send(receivedAction);
          return;
        }
      }
      return onActionReceivedImplementationMethod(receivedAction);
    }
  }

  static Future<void> onActionReceivedImplementationMethod(
      ReceivedAction receivedAction) async {
    Get.to(()=>StatusPage());
  }

  ///  *********************************************
  ///     REQUESTING NOTIFICATION PERMISSIONS
  ///  *********************************************

  static Future<bool> displayNotificationRationale(BuildContext context) async {
    bool userAuthorized = false;
    // BuildContext context = MyApp.navigatorKey.currentContext!;
    await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Get Notified!',
                style: Theme.of(context).textTheme.titleLarge),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Allow Awesome Notifications to send you beautiful notifications!'),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Deny',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () async {
                    userAuthorized = true;
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Allow',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.deepPurple),
                  )),
            ],
          );
        });
    return userAuthorized &&
        await AwesomeNotifications().requestPermissionToSendNotifications();
  }







  static Future<void> scheduleNotifications(BuildContext context,{
    required NotificationSchedule schedule,
    required NotificationContent content,
  }) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) isAllowed = await displayNotificationRationale(context);
    if (!isAllowed) return;
    await myNotificationSchedules(schedule: schedule,content: content);
  }






  static Future<void> snoozeMedNotification() async {
    await snoozeAlarm(
        title: 'test',
        msg: 'test message',
        hoursFromNow: 5,
        username: 'test user',
        repeatNotif: false);
  }



  static Future<void> cancelNotifications({
    required int id
}) async {
    await AwesomeNotifications().cancel(id);
  }
}


Future<void> snoozeAlarm({
  required int hoursFromNow,
  required String username,
  required String title,
  required String msg,
  bool repeatNotif = false,
}) async {
  // var nowDate = DateTime.now().add(Duration(hours: hoursFromNow, seconds: 5));
  await AwesomeNotifications().createNotification(
    schedule: NotificationCalendar.fromDate(
       date: DateTime.now().add(const Duration(minutes: 5))),
    content: NotificationContent(
      id: -1,
      channelKey: 'alerts',
      title: '${Emojis.medical_pill} Reminder!!!',
      body: 'Time for your medicine',
      notificationLayout: NotificationLayout.Default,
      //actionType : ActionType.DisabledAction,
      color: Colors.black,
      backgroundColor: Colors.black,

      // customSound: 'resource://raw/notif',
      payload: {'actPag': 'myAct', 'actType': 'medicine', 'username': username},
    ),
    actionButtons: [
      NotificationActionButton(
          key: 'SNOOZE',
          label: 'Snooze',
          actionType: ActionType.SilentAction
      ),
      NotificationActionButton(
          key: 'DISMISS',
          label: 'Dismiss',
          actionType: ActionType.DisabledAction
      ),
    ],
  );
}





Future<void> myNotificationSchedules({
  required NotificationSchedule schedule,
  required NotificationContent content,
}) async {


  await AwesomeNotifications().createNotification(
    schedule: schedule,
    content: content,
    actionButtons: [
      NotificationActionButton(
          key: 'SNOOZE',
          label: 'Snooze',
          actionType: ActionType.SilentAction
      ),
      NotificationActionButton(
          key: 'DISMISSED',
          label: 'Dismiss',
          actionType: ActionType.DisabledAction
      ),
    ],
  );



}





