
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:khata_app/features/general_reminder/presentation/widget/edit_general_page.dart';
import '../../../common/colors.dart';
import '../../notification_controller/notification_controller.dart';
import '../model/general_reminder_model.dart';

class GeneralDetails extends StatefulWidget {
  final GeneralReminderModel reminder;

  GeneralDetails(this.reminder);

  @override
  State<GeneralDetails> createState() => _GeneralDetailsState();
}

class _GeneralDetailsState extends State<GeneralDetails> {

  GlobalKey<_GeneralDetailsState> refreshKey = GlobalKey();



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
    reminderBoxListenable.addListener(onHiveBoxChanged);
  }

  void onHiveBoxChanged() {
    // This function will be called whenever the Hive box changes.
    // You can update your UI or refresh the data here.
    setState(() {
      // Update your data or UI as needed
    });
  }

  @override
  void dispose() {
    // Be sure to remove the listener when the widget is disposed.
    reminderBoxListenable.removeListener(onHiveBoxChanged);
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {


    final reminder = Hive.box<GeneralReminderModel>('general_reminder_box');

    final int index = reminder.values.toList().indexWhere((element) => element.reminderId == widget.reminder.reminderId);

    final reminderBox = reminder.getAt(index)!;



     return Scaffold(
       backgroundColor: ColorManager.white,
       appBar: AppBar(
         backgroundColor: ColorManager.primary,
         elevation: 0,
         toolbarHeight: 100,
         centerTitle: true,
         titleSpacing: 0,
         automaticallyImplyLeading: false,
         title: Container(
             width: double.infinity,
             height: 100,

             child: Stack(
               children: [
                 Positioned(
                     top: 20,
                     right: 60,

                     child: Transform.rotate(
                         angle: 320 * 3.14159265358979323846 / 180,
                         child: FaIcon(CupertinoIcons.alarm,color: ColorManager.white.withOpacity(0.3),size: 70,))
                 ),
                 Positioned(
                     top: 20,
                     left: 50,
                     child: Transform.rotate(
                         angle: 30 * 3.14159265358979323846 / 180,
                         child: FaIcon(FontAwesomeIcons.notesMedical,color: ColorManager.white.withOpacity(0.3),size: 80,))
                 ),
                 Align(
                   alignment: Alignment.centerLeft,
                   child: InkWell(
                     onTap: () => Get.back(),
                     child: FaIcon(Icons.chevron_left, color: ColorManager.white,size: 30,
                     ),
                   ),
                 ),
                 Center(child: Text('Reminder',style: TextStyle(color: ColorManager.white),)),
               ],
             )),

       ),
       body: Container(
         decoration: BoxDecoration(
             color: ColorManager.white,
             borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30))
         ),
         padding: EdgeInsets.symmetric(horizontal: 18),
         child: Column(
           children: [
             const SizedBox(height: 20,),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                     Text('${reminderBox.title}',style: TextStyle(color: ColorManager.black,fontSize: 32),),
                     const SizedBox(height: 10,),
                     Text('${reminderBox.reminderPattern.patternName}',style: TextStyle(color: ColorManager.black,fontSize: 16),),
                   ],
                 ),
                 Text('${reminderBox.time}',style: TextStyle(color: ColorManager.black,fontSize: 16),),
               ],
             ),
             const SizedBox(height: 20,),
             Container(
               width: double.infinity,
               decoration: BoxDecoration(
                 color: ColorManager.primary,
                 borderRadius: BorderRadius.circular(10),
               ),
               padding: EdgeInsets.symmetric(horizontal: 18,vertical: 18),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text('Description',style: TextStyle(color: ColorManager.white,fontSize: 18),),
                   const SizedBox(height: 10,),
                   Text('${reminderBox.description}',style: TextStyle(color: ColorManager.white,fontSize: 18),)



                 ],
               ),
             ),

             const SizedBox(height: 20,),
             Container(
               width: double.infinity,
               decoration: BoxDecoration(
                 color: ColorManager.primary,
                 borderRadius: BorderRadius.circular(10),
               ),
               padding: EdgeInsets.symmetric(horizontal: 18,vertical: 18),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text('Start Date',style: TextStyle(color: ColorManager.white,fontSize: 18),),
                   const SizedBox(height: 10,),
                   Text('${DateFormat('yyyy-MM-dd').format(reminderBox.startDate)}',style: TextStyle(color: ColorManager.white,fontSize: 18),),

                 ],
               ),
             ),
             const SizedBox(height: 20,),
             Row(
               children: [

                 Expanded(
                   child: ElevatedButton(
                     style: ElevatedButton.styleFrom(
                       backgroundColor: ColorManager.primary,
                       elevation: 0
                     ),
                       onPressed: ()=>Get.to(()=>EditGeneralReminder(reminderBox)),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: [
                           FaIcon(FontAwesomeIcons.penToSquare,color: ColorManager.white,size: 16,),
                           const SizedBox(width: 10,),
                           Text('Edit',style: TextStyle(color: ColorManager.white,fontSize: 18),),
                         ],
                       ) ),
                 ),
                 const SizedBox(width: 10,),
                 Expanded(
                   child: ElevatedButton(
                       style: ElevatedButton.styleFrom(
                           backgroundColor: ColorManager.red.withOpacity(0.7),
                           elevation: 0
                       ),
                       onPressed: () async {
                         int back = 0;
                         await showDialog(
                             context: context,
                             builder: (context){
                               return AlertDialog(
                                 content: Text('Do you want to delete this reminder?',style: TextStyle(color: ColorManager.black,fontSize: 20),),
                                 actions: [
                                   ElevatedButton(
                                       style: ElevatedButton.styleFrom(
                                           backgroundColor: ColorManager.primary
                                       ),
                                       onPressed: ()async{


                                         reminder.deleteAt(index);
                                         setState(() {
                                           back = 1;
                                         });
                                         Navigator.pop(context);

                                         for(int i = 0 ; i < reminderBox.contentIdList!.length ; i++){
                                           await NotificationController.cancelNotifications(id: reminderBox.contentIdList![i]);
                                         }


                                       }, child: Text('Yes',style: TextStyle(color: ColorManager.white),)),
                                   ElevatedButton(
                                       style: ElevatedButton.styleFrom(
                                           elevation: 0,
                                           backgroundColor: ColorManager.textGrey
                                       ),
                                       onPressed: (){

                                         Navigator.pop(context);

                                       }, child: Text('No',style: TextStyle(color: ColorManager.white),)),
                                 ],
                                 actionsAlignment: MainAxisAlignment.center,
                               );
                             }
                         );
                         if(back == 1){
                           Get.back();
                         }
                       },
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: [
                           FaIcon(Icons.delete,color: ColorManager.white,size: 16,),
                           const SizedBox(width: 10,),
                           Text('Delete',style: TextStyle(color: ColorManager.white,fontSize: 18),),
                         ],
                       ) ),
                 ),
               ],
             )

           ],
         ),
       ),
     );
  }
}