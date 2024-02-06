import 'dart:convert';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../../../../common/colors.dart';
import '../../../../common/snackbar.dart';
import '../../../../main.dart';
import '../../../notification_controller/notification_controller.dart';
import '../../data/reminder_db.dart';
import '../../model/general_reminder_model.dart';


class EditGeneralReminder extends ConsumerStatefulWidget {

  final GeneralReminderModel reminder;
  EditGeneralReminder(this.reminder);


  @override
  _EditReminderPageState createState() => _EditReminderPageState();
}

class _EditReminderPageState extends ConsumerState<EditGeneralReminder> {

  late GeneralReminderModel reminder;


  int page = 0;





  final formKey1 = GlobalKey<FormState>();


  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _intervalDurationController = TextEditingController();



  String? selectedPatternName;
  int? selectedPatternId;
  // List<String> selectedDays = [];

  DateTime? startDateIntake;

  DateTime? setTime ;

  String? selectedInitialReminderType;
  int? selectedInitialReminderTypeId;

  List<String>? days;


  List<DateTime> scheduledDate = [];

  List<int> contentList = [];


  bool isPostingData = false;





  List<bool>? isSelected;
  // List<bool> isSelected = [false, false, false, false, false, false, false];


  bool selectDaysValidation = false;




  @override
  void initState() {
    super.initState();
    reminder = widget.reminder;
    _titleController.text = reminder.title;
    _descriptionController.text = reminder.description;
    _startTimeController.text = reminder.time;
    _startDateController.text = DateFormat('yyyy-MM-dd').format(reminder.startDate);
    startDateIntake =reminder.startDate;
    selectedPatternName = reminder.reminderPattern.patternName;
    selectedPatternId = reminder.reminderPattern.reminderPatternId;
    setTime = DateFormat('hh:mm a').parse(reminder.time);
    if(reminder.reminderPattern.interval != null){
      _intervalDurationController.text = reminder.reminderPattern.interval.toString();
    }

    if(reminder.reminderPattern.daysOfWeek != null){
      days = reminder.reminderPattern.daysOfWeek;
      isSelected = [
        days!.contains('Monday'),
        days!.contains('Tuesday'),
        days!.contains('Wednesday'),
        days!.contains('Thursday'),
        days!.contains('Friday'),
        days!.contains('Saturday'),
        days!.contains('Sunday'),
      ];
    }

    contentList = reminder.contentIdList!;










  }

  void _updateReminder(GeneralReminderModel reminder) {
    final reminderBox = Hive.box<GeneralReminderModel>('general_reminder_box');
    // Get the index of the reminder to update based on its 'reminderId' (you should replace 1002 with the actual 'reminderId' you want to update)
    final int indexToUpdate = reminderBox.values.toList().indexWhere((element) => element.reminderId == reminder.reminderId);

    if (indexToUpdate != -1) {
      // If the reminder is found, update it
      reminderBox.putAt(indexToUpdate, reminder);
      Navigator.pop(context,true); // Optionally, you can navigate back to the previous screen
    } else {
      // Handle the case where the reminder is not found
      // You might want to show an error message or take appropriate action
      // based on your app's requirements.
      print('Reminder not found for update.');
    }
  }

  TimeOfDay _parseTime(String timeString) {
    final parsedTime = DateFormat('hh:mm a').parse(timeString);
    return TimeOfDay(
      hour: parsedTime.hour,
      minute: parsedTime.minute,
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTimeController.text.isNotEmpty ? _parseTime(
          _startTimeController.text) : TimeOfDay.now(),
    );

    if (picked != null) {
      var selectedTime = TimeOfDay(
        hour: picked.hour,
        minute: picked.minute,
      );

      final formattedTime = selectedTime.format(context);
      final now = DateTime.now();
      setState(() {
        setTime = DateTime(now.year,now.month,now.day,selectedTime.hour,selectedTime.minute);
      });

      _startTimeController.text = formattedTime;
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {


    DateTime date = DateFormat('hh:mm a').parse(_startTimeController.text);
    DateTime now = DateTime.now();

    date = DateTime(now.year, now.month, now.day, date.hour, date.minute);


    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate:date.isBefore(now) ? now.add(Duration(days: 1)) :DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if(selectedDate != null){
      setState(() {
        startDateIntake = selectedDate;
      });
      final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      _startDateController.text = formattedDate;
    }


  }


  @override
  Widget build(BuildContext context) {

    // TabController _tabController = TabController(length: 2, vsync: this);
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                          child: FaIcon(CupertinoIcons.alarm,color: ColorManager.white.withOpacity(0.2),size: 70,))
                  ),
                  Positioned(
                      top: 20,
                      left: 40,
                      child: Transform.rotate(
                          angle: 30 * 3.14159265358979323846 / 180,
                          child: FaIcon(FontAwesomeIcons.notesMedical,color: ColorManager.white.withOpacity(0.2),size: 80,))
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () => Get.back(),
                      child: FaIcon(Icons.chevron_left, color: ColorManager.white,size: 30,
                      ),
                    ),
                  ),
                  Center(child: Text('Set a Reminder',style: TextStyle(color: ColorManager.white),)),
                ],
              )),

        ),
        body:  Container(
          height: 900,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            color: ColorManager.white,
          ),
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: SingleChildScrollView(
            child: Form(
              key: formKey1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20,),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                       focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.black.withOpacity(0.5)
                          )
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.primary
                          )
                      ),
                      enabledBorder:  OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.primary
                          )
                      ),
                      labelText: 'Title',
                      labelStyle: TextStyle(color: ColorManager.black,fontSize: 16),

                    ),
                    validator: (value){
                      if(value!.trim().isEmpty){
                        return 'Title is required';
                      }
                      if(RegExp(r'^(?=.*?[!@#&*~])').hasMatch(value)){
                        return 'Invalid title';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (value){
                      // ref.read(itemProvider.notifier).updateMedicineName(value);
                    },

                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: null,
                    decoration: InputDecoration(
                       focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.black.withOpacity(0.5)
                          )
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.primary
                          )
                      ),
                      enabledBorder:  OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.primary
                          )
                      ),
                      labelText: 'Description',
                      labelStyle: TextStyle(color: ColorManager.black,fontSize: 16),

                    ),
                    validator: (value){
                      if(value!.trim().isEmpty){
                        return 'Description is required';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (value){
                      // ref.read(itemProvider.notifier).updateMedicineName(value);
                    },

                  ),

                  const SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectStartDate(context), // Show date picker for start date when tapped
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: _startDateController,
                              decoration: InputDecoration(
                                 focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.black.withOpacity(0.5)
                          )
                      ),
                                suffixIconConstraints: BoxConstraints.tightForFinite(),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: FaIcon(Icons.calendar_month,color: ColorManager.primary,),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ColorManager.primary)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ColorManager.primary)),
                                labelText: 'Start Date',
                                labelStyle: TextStyle(color: ColorManager.black, fontSize: 16),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please select a start date';
                                }
                                return null;
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: TextFormField(
                          controller: _startTimeController,
                          readOnly: true, // Make the field read-only
                          onTap: ()=>  _selectTime(context), // Show time picker when tapped
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: ColorManager.black.withOpacity(0.5)
                                )
                            ),
                            suffixIconConstraints: BoxConstraints.tightForFinite(),
                            suffixIcon: Padding(
                              padding: EdgeInsets.only(right: 18),
                              child: FaIcon(
                                Icons.access_time,
                                color: ColorManager.primary,
                                size: 24,
                              ),
                            ),
                            labelText: 'Schedule Time',
                            labelStyle: TextStyle(color: ColorManager.black, fontSize: 16),
                            hintText: 'hh:mm',
                            hintStyle: TextStyle(color: ColorManager.black.withOpacity(0.7),fontSize: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: ColorManager.primary,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: ColorManager.primary,
                              ),
                            ),
                          ),
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Please select a Time';
                            }
                            if(startDateIntake!.isAtSameMomentAs(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day)) && setTime!.isBefore(DateTime.now())){
                              return 'Time cannot be in the past';

                            }


                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),



                    ],
                  ),

                
                  const SizedBox(height: 10,),
                  DropdownButtonFormField(

                    menuMaxHeight: 250,
                    isDense: true,
                    decoration: InputDecoration(
                       focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.black.withOpacity(0.5)
                          )
                      ),

                        isDense: true,
                        labelText: 'Reminder Pattern',
                        labelStyle: TextStyle(color: ColorManager.black,fontSize: 16),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: ColorManager.primary
                            )
                        ),

                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: ColorManager.primary
                            )
                        )
                    ),
                    value: selectedPatternName ,

                    items: generalPatternList
                        .map(
                          (ReminderPatternModel item) => DropdownMenuItem<String>(
                        value: item.patternName,
                        child: Text(
                          item.patternName,
                          style: TextStyle(color: Colors.black,fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ).toList(),
                    onChanged: (value){
                      setState(() {
                        selectedPatternName = value!;
                        selectedPatternId = generalPatternList.firstWhere((element) => element.patternName == value).id;
                        isSelected = [false, false, false, false, false, false, false];
                        selectDaysValidation = false;
                      });

                      //ref.read(itemProvider.notifier).updatePatternId(patternList.firstWhere((element) => element.patternName == value).id);

                    },
                    validator: (value){
                      if(selectedPatternName == null){
                        return 'Reminder Pattern is required';
                      }

                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  if(selectedPatternId == 4)
                    const SizedBox(height: 10,),
                  if(selectedPatternId == 4)
                    TextFormField(
                      controller: _intervalDurationController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                         focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.black.withOpacity(0.5)
                          )
                      ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: ColorManager.primary
                            )
                        ),
                        enabledBorder:  OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: ColorManager.primary
                            )
                        ),
                        labelText: 'Interval of Days',
                        labelStyle: TextStyle(color: ColorManager.black,fontSize: 16),

                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Interval is required';
                        }
                        if (!value.contains(RegExp(r'^\d+$'))) {
                          return 'Invalid value';
                        }
                        if(int.parse(value) <= 0){
                          return 'Interval must be more than 0';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,

                    ),

                  if(selectedPatternId == 4)
                    const SizedBox(height: 10,),
                  if(selectedPatternId == 3)
                    const SizedBox(height: 10,),


                  if(selectedPatternId == 3)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: daysOfWeekMedication.asMap().entries.map((entry) {
                        final index = entry.key;
                        final day = entry.value;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              isSelected![index] = !isSelected![index];
                              selectDaysValidation = false;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                            decoration: BoxDecoration(
                              color: isSelected![index]
                                  ? ColorManager.primary
                                  : ColorManager.textGrey.withOpacity(0.5), // Selected and unselected colors
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              '${day.substring(0, 3)}',
                              style: TextStyle(
                                color: isSelected![index]
                                    ? ColorManager.white
                                    : Colors.black, // Text color when selected and unselected
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                  if(selectDaysValidation == true)
                    const SizedBox(height: 10,),

                  if(selectDaysValidation == true)
                    Text('Select at least one day',style: TextStyle(color: ColorManager.red.withOpacity(0.7)),),



                  if(selectedPatternId == 3)
                    const SizedBox(height: 10,),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: ColorManager.black.withOpacity(0.7)
                            ),
                            onPressed: ()=>Get.back(), child: Text('Cancel',style: TextStyle(color: ColorManager.white,fontSize: 16),)),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorManager.primary
                            ),
                            onPressed: ()async {

                              final scaffoldMessage = ScaffoldMessenger.of(context);
                              var result = sessionBox.get('userReturn');
                              var res = jsonDecode(result);

                              final userId = "${res["userReturn"]["intUserId"]}-${res["ownerCompanyList"]["databaseName"]}";


                              List<String> list = [];

                              // selectedDays.clear(); // Clear the list before populating it

                              if(isSelected != null){
                                for (int i = 0; i < isSelected!.length; i++) {

                                  if (isSelected![i]) {
                                    print(daysOfWeekMedication[i]);
                                    list.add(daysOfWeekMedication[i]);


                                    // selectedDays.add(daysOfWeekMedication[i]);
                                  }
                                }
                              }

                              setState(() {
                                days = list;
                              });


                              if(selectedPatternId == 3 && days!.isEmpty ){
                                setState(() {
                                  selectDaysValidation = true;
                                });
                                scaffoldMessage.showSnackBar(
                                  SnackbarUtil.showFailureSnackbar(
                                    message: 'Please select a day',
                                    duration: const Duration(milliseconds: 1400),
                                  ),
                                );
                              }
                              else{

                                for(int i = 0; i < contentList.length ; i++){
                                  await NotificationController.cancelNotifications(id: contentList[i]);
                                }

                                if(formKey1.currentState!.validate()) {
                                  setState(() {
                                    isPostingData = true;
                                  });

                                  /// FOR ONCE....
                                  if (selectedPatternId == 1) {
                                    final DateTime firstDate = DateTime(
                                        startDateIntake!.year,
                                        startDateIntake!.month,
                                        startDateIntake!.day,
                                        DateFormat('hh:mm a')
                                            .parse(_startTimeController.text)
                                            .hour, DateFormat('hh:mm a')
                                        .parse(_startTimeController.text)
                                        .minute);

                                    List<DateTime> scheduleList = [];

                                    for (int i = 0; i < 1; i++) {
                                      DateTime newDate = firstDate.add(
                                          Duration(days: i));
                                      print(newDate);
                                      DateTime notificationDates = DateTime(
                                          newDate.year, newDate.month,
                                          newDate.day, DateFormat('hh:mm a')
                                          .parse(_startTimeController.text)
                                          .hour, DateFormat('hh:mm a')
                                          .parse(_startTimeController.text)
                                          .minute);
                                      scheduleList.add(notificationDates);
                                    }

                                    print('scheduled list : ${scheduleList
                                        .length}');

                                    for (int i = 0; i <
                                        scheduleList.length; i++) {
                                      final NotificationContent content = NotificationContent(
                                        id: Random().nextInt(9999),
                                        channelKey: 'alerts_khata',
                                        title: _titleController.text.trim(),
                                        body: _descriptionController.text,
                                        notificationLayout: NotificationLayout
                                            .Default,
                                        color: Colors.black,

                                        //
                                        backgroundColor: Colors.black,
                                        // customSound: 'resource://raw/notif',
                                        payload: {
                                          'actPag': 'myAct',
                                          'actType': 'medicine'
                                        },
                                      );

                                      final NotificationCalendar schedule = NotificationCalendar(
                                          year: scheduleList[i].year,
                                          month: scheduleList[i].month,
                                          day: scheduleList[i].day,
                                          hour: scheduleList[i].hour,
                                          minute: scheduleList[i].minute
                                      );

                                      contentList.add(content.id!);

                                      await NotificationController
                                          .scheduleNotifications(
                                          context, schedule: schedule,
                                          content: content);
                                    }

                                    GeneralReminderModel reminder = GeneralReminderModel(
                                        reminderId: Random().nextInt(9999),
                                        title: _titleController.text.trim(),
                                        description: _descriptionController.text,
                                        time: _startTimeController.text.trim(),
                                        startDate: startDateIntake!,
                                        reminderPattern: ReminderPattern(
                                          reminderPatternId: selectedPatternId!,
                                          patternName: selectedPatternName!,
                                        ),
                                        userId: userId,
                                        contentIdList: contentList
                                    );


                                    _updateReminder(reminder);
                                  }

                                  /// FOR EVERYDAY....
                                  if (selectedPatternId == 2) {
                                    final DateTime firstDate = DateTime(
                                        startDateIntake!.year,
                                        startDateIntake!.month,
                                        startDateIntake!.day,
                                        DateFormat('hh:mm a')
                                            .parse(_startTimeController.text)
                                            .hour, DateFormat('hh:mm a')
                                        .parse(_startTimeController.text)
                                        .minute);

                                    List<DateTime> scheduleList = [];

                                    for (int i = 0; i < 365; i++) {
                                      DateTime newDate = firstDate.add(
                                          Duration(days: i));
                                      print(newDate);
                                      DateTime notificationDates = DateTime(
                                          newDate.year, newDate.month,
                                          newDate.day, DateFormat('hh:mm a')
                                          .parse(_startTimeController.text)
                                          .hour, DateFormat('hh:mm a')
                                          .parse(_startTimeController.text)
                                          .minute);
                                      scheduleList.add(notificationDates);
                                    }

                                    print('scheduled list : ${scheduleList
                                        .length}');

                                    for (int i = 0; i <
                                        scheduleList.length; i++) {
                                      final NotificationContent content = NotificationContent(
                                        id: Random().nextInt(9999),
                                        channelKey: 'alerts_khata',
                                        title: _titleController.text.trim(),
                                        body: _descriptionController.text,
                                        notificationLayout: NotificationLayout
                                            .Default,
                                        color: Colors.black,

                                        //
                                        backgroundColor: Colors.black,
                                        // customSound: 'resource://raw/notif',
                                        payload: {
                                          'actPag': 'myAct',
                                          'actType': 'medicine'
                                        },
                                      );

                                      final NotificationCalendar schedule = NotificationCalendar(
                                          year: scheduleList[i].year,
                                          month: scheduleList[i].month,
                                          day: scheduleList[i].day,
                                          hour: scheduleList[i].hour,
                                          minute: scheduleList[i].minute
                                      );

                                      contentList.add(content.id!);

                                      await NotificationController
                                          .scheduleNotifications(
                                          context, schedule: schedule,
                                          content: content);
                                    }

                                    GeneralReminderModel reminder = GeneralReminderModel(
                                        reminderId: Random().nextInt(9999),
                                        title: _titleController.text.trim(),
                                        description: _descriptionController.text,
                                        time: _startTimeController.text.trim(),
                                        startDate: startDateIntake!,
                                        reminderPattern: ReminderPattern(
                                          reminderPatternId: selectedPatternId!,
                                          patternName: selectedPatternName!,
                                        ),
                                        userId: userId,
                                        contentIdList: contentList
                                    );


                                    _updateReminder(reminder);
                                  }


                                  /// FOR Specific days....
                                  if (selectedPatternId == 3) {
                                    final DateTime firstDate = DateTime(
                                        startDateIntake!.year,
                                        startDateIntake!.month,
                                        startDateIntake!.day,
                                        DateFormat('hh:mm a')
                                            .parse(_startTimeController.text)
                                            .hour, DateFormat('hh:mm a')
                                        .parse(_startTimeController.text)
                                        .minute);

                                    List<DateTime> scheduleList = [];


                                    int addedDatesCount = 0;

                                    do {
                                      DateTime newDate = firstDate.add(
                                          Duration(days: addedDatesCount));

                                      bool addedDate = false; // Flag to check if notificationDates is added

                                      DateTime notificationDates = DateTime(
                                          newDate.year, newDate.month,
                                          newDate.day, DateFormat('hh:mm a')
                                          .parse(_startTimeController.text)
                                          .hour, DateFormat('hh:mm a')
                                          .parse(_startTimeController.text)
                                          .minute);

                                      print(notificationDates);

                                      if (days!.contains(
                                          DateFormat('EEEE').format(
                                              notificationDates))) {
                                        scheduleList.add(notificationDates);
                                        addedDate = true;
                                      }

                                      addedDatesCount++;
                                    } while (scheduleList.length < 100);

                                    print(scheduleList.length);

                                    for (int i = 0; i <
                                        scheduleList.length; i++) {
                                      final NotificationContent content = NotificationContent(
                                        id: Random().nextInt(9999),
                                        channelKey: 'alerts_khata',
                                        title: _titleController.text.trim(),
                                        body: _descriptionController.text,
                                        notificationLayout: NotificationLayout
                                            .Default,
                                        color: Colors.black,

                                        //
                                        backgroundColor: Colors.black,
                                        // customSound: 'resource://raw/notif',
                                        payload: {
                                          'actPag': 'myAct',
                                          'actType': 'medicine'
                                        },
                                      );


                                      final NotificationCalendar schedule = NotificationCalendar(
                                          year: scheduleList[i].year,
                                          month: scheduleList[i].month,
                                          day: scheduleList[i].day,
                                          hour: scheduleList[i].hour,
                                          minute: scheduleList[i].minute
                                      );

                                      contentList.add(content.id!);

                                      await NotificationController
                                          .scheduleNotifications(
                                          context, schedule: schedule,
                                          content: content);
                                    }

                                    GeneralReminderModel reminder = GeneralReminderModel(
                                        reminderId: Random().nextInt(1000),
                                        title: _titleController.text.trim(),
                                        description: _descriptionController.text,
                                        time: _startTimeController.text.trim(),
                                        startDate: startDateIntake!,
                                        reminderPattern: ReminderPattern(
                                            reminderPatternId: selectedPatternId!,
                                            patternName: selectedPatternName!,
                                            daysOfWeek: selectedPatternId == 3
                                                ? days
                                                : null
                                        ),
                                        userId: userId,
                                        contentIdList: contentList
                                    );


                                    _updateReminder(reminder);
                                  }


                                  /// FOR INTERVALS....
                                  if (selectedPatternId == 4) {
                                    final DateTime firstDate = DateTime(
                                        startDateIntake!.year,
                                        startDateIntake!.month,
                                        startDateIntake!.day,
                                        DateFormat('hh:mm a')
                                            .parse(_startTimeController.text)
                                            .hour, DateFormat('hh:mm a')
                                        .parse(_startTimeController.text)
                                        .minute);

                                    List<DateTime> scheduleList = [];

                                    for (int i = 0; i < 100; i++) {
                                      DateTime newDate = firstDate.add(Duration(
                                          days: i == 0 ? 0 : int.parse(
                                              _intervalDurationController.text)));


                                      DateTime notificationDates = DateTime(
                                          newDate.year, newDate.month,
                                          newDate.day, DateFormat('hh:mm a')
                                          .parse(_startTimeController.text)
                                          .hour, DateFormat('hh:mm a')
                                          .parse(_startTimeController.text)
                                          .minute);
                                      scheduleList.add(notificationDates);
                                    }

                                    for (int i = 0; i <
                                        scheduleList.length; i++) {
                                      final NotificationContent content = NotificationContent(
                                        id: Random().nextInt(9999),
                                        channelKey: 'alerts_khata',
                                        title: _titleController.text.trim(),
                                        body: _descriptionController.text,
                                        notificationLayout: NotificationLayout
                                            .Default,
                                        color: Colors.black,

                                        //
                                        backgroundColor: Colors.black,
                                        // customSound: 'resource://raw/notif',
                                        payload: {
                                          'actPag': 'myAct',
                                          'actType': 'medicine'
                                        },
                                      );


                                      final NotificationCalendar schedule = NotificationCalendar(
                                          year: scheduleList[i].year,
                                          month: scheduleList[i].month,
                                          day: scheduleList[i].day,
                                          hour: scheduleList[i].hour,
                                          minute: scheduleList[i].minute
                                      );

                                      contentList.add(content.id!);

                                      await NotificationController
                                          .scheduleNotifications(
                                          context, schedule: schedule,
                                          content: content);
                                    }

                                    GeneralReminderModel reminder = GeneralReminderModel(
                                        reminderId: Random().nextInt(1000),
                                        title: _titleController.text.trim(),
                                        description: _descriptionController.text,
                                        time: _startTimeController.text.trim(),
                                        startDate: startDateIntake!,
                                        reminderPattern: ReminderPattern(
                                          reminderPatternId: selectedPatternId!,
                                          patternName: selectedPatternName!,
                                          interval: selectedPatternId == 4
                                              ? int.parse(
                                              _intervalDurationController.text)
                                              : null,
                                        ),
                                        userId: userId,
                                        contentIdList: contentList
                                    );


                                    _updateReminder(reminder);
                                  }
                                }


                              }


                            }, child: Text('Save',style: TextStyle(color: ColorManager.white,fontSize: 16),)),
                      ),
                    ],
                  ),


                  const SizedBox(height: 100,),




                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



}


