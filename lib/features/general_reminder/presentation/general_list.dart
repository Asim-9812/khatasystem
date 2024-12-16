


import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:khatasystem/features/general_reminder/presentation/widget/create_general_reminder.dart';
import '../../../common/colors.dart';
import '../../../main.dart';
import '../model/general_reminder_model.dart';
import 'generalDetails.dart';



class GeneralReminders extends ConsumerStatefulWidget {
  const GeneralReminders({super.key});



  @override
  ConsumerState<GeneralReminders> createState() => _MedRemindersState();
}

class _MedRemindersState extends ConsumerState<GeneralReminders> {



  late Box<GeneralReminderModel> reminderBox;
  late ValueListenable<Box<GeneralReminderModel>> reminderBoxListenable;

  @override
  void initState() {



    super.initState();
    // notificationServices.initializeNotifications();

    // Open the Hive box
    reminderBox = Hive.box<GeneralReminderModel>('general_reminder_box');

    // Create a ValueListenable for the box
    reminderBoxListenable = reminderBox.listenable();

    // Add a listener to update the UI when the box changes
    reminderBoxListenable.addListener(_onHiveBoxChanged);

    _deleteOnce();
  }

  void _onHiveBoxChanged() {
    // This function will be called whenever the Hive box changes.
    // You can update your UI or refresh the data here.
    setState(() {
      // Update your data or UI as needed
    });
  }


  void _deleteOnce(){

    final isOnceReminders = reminderBox.values.toList().where((element) => element.reminderPattern.reminderPatternId == 1).toList();

    for(int i = 0 ; i < isOnceReminders.length ; i++){
      DateTime isBefore = DateTime(isOnceReminders[i].startDate.year,isOnceReminders[i].startDate.month,isOnceReminders[i].startDate.day,DateFormat('hh:mm a').parse(isOnceReminders[i].time).hour, DateFormat('hh:mm a').parse(isOnceReminders[i].time).minute);


      if(isBefore.isBefore(DateTime.now())){
        final int indexToDelete = reminderBox.values.toList().indexWhere((element) => element.reminderId == isOnceReminders[i].reminderId);

        reminderBox.deleteAt(indexToDelete);
      }

    }

  }

  @override
  void dispose() {
    // Be sure to remove the listener when the widget is disposed.
    reminderBoxListenable.removeListener(_onHiveBoxChanged);
    super.dispose();
  }






  @override
  Widget build(BuildContext context) {
    var result = sessionBox.get('userReturn');
    var res = jsonDecode(result);

    final userId = "${res["userReturn"]["intUserId"]}-${res["ownerCompanyList"]["databaseName"]}";

    final reminderList = Hive.box<GeneralReminderModel>('general_reminder_box').values.where((element) => element.userId == userId).toList();



    if (reminderList.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorManager.primary,
          // automaticallyImplyLeading: false,
          leading: IconButton(onPressed:()=> Get.back(), icon: Icon(Icons.chevron_left,color: ColorManager.white,)),
          title: Text('Personal Notes',style: TextStyle(color: ColorManager.white),),
          actions: [
            IconButton(onPressed: ()=>Get.to(()=>CreateGeneralReminder()), icon: Icon(Icons.add_circle_outline,color: ColorManager.white,))
          ],
        ),
        body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 18,right: 18,bottom: 150),
        itemCount: reminderList.length,
        itemBuilder: (context, index) {

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorManager.white,
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              onTap: ()async{
                // NotificationService().scheduleNotification();
                Get.to(()=>GeneralDetails(reminderList[index]));
              },
              // leading: CircleAvatar(
              //   backgroundColor:reminder.startDate.difference(DateTime.now()) <= Duration(days: 0) ? ColorManager.primaryDark : ColorManager.dotGrey,
              //   child: FaIcon(medicineType.firstWhere((element) => element.id == reminder.medicineType).icon,color: ColorManager.white.withOpacity(0.5),),
              // ),
              title: Text(
                reminderList[index].title,
                style: TextStyle(color: ColorManager.black, fontSize: 20),
              ),
              subtitle: Text(reminderList[index].reminderPattern.patternName == 'Specific Days'
                  ? '${reminderList[index].reminderPattern.daysOfWeek!.map((e) => e.substring(0,3))}'
                  :reminderList[index].reminderPattern.patternName,
                style: TextStyle(
                    color: ColorManager.black.withOpacity(0.7), fontSize: 12),
              ),
              trailing: Container(
                decoration: BoxDecoration(
                  color: reminderList[index].startDate.difference(DateTime.now()) <= const Duration(days: 0) ? ColorManager.primary.withOpacity(0.8):ColorManager.textGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Text(
                  reminderList[index].time,
                  style: TextStyle(color: ColorManager.white, fontSize: 12),
                ),
              ),
            ),
          );
        },
            ),
      );
    } else {
      return Scaffold(
        backgroundColor: ColorManager.white,
        appBar: AppBar(
          backgroundColor: ColorManager.primary,
          // automaticallyImplyLeading: false,
          leading: IconButton(onPressed:()=> Get.back(), icon: Icon(Icons.chevron_left,color: ColorManager.white,)),
          title: Text('Personal Notes',style: TextStyle(color: ColorManager.white),),
          actions: [
            IconButton(onPressed: ()=>Get.to(()=>CreateGeneralReminder()), icon: Icon(Icons.add_circle_outline,color: ColorManager.white,))
          ],
        ),
        body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.rotate(

                angle: pi*(0.5/4),
                child: FaIcon(FontAwesomeIcons.calendarXmark,color: ColorManager.textGrey.withOpacity(0.5),size: 50,)),
            const SizedBox(height: 20,),
            Text('No Reminders',style: TextStyle(color: ColorManager.textGrey.withOpacity(0.5)),),

          ],
        ),
            ),
      );
    }
  }
}
