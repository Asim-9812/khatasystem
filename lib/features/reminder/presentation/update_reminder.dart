
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:khata_app/features/reminder/model/reminder_model.dart';
import 'package:khata_app/features/reminder/provider/reminder_provider.dart';
import 'package:khata_app/features/reminder/service/notification_service.dart';
import 'package:khata_app/features/reminder/widget/display_date_time.dart';
import 'package:khata_app/features/reminder/widget/snackbar.dart';


import '../../../common/colors.dart';



class UpdateReminderPage extends StatefulWidget {
  final ReminderModel reminder;
  const UpdateReminderPage({Key? key, required this.reminder}) : super(key: key);

  @override
  State<UpdateReminderPage> createState() => _UpdateReminderPageState();
}

class _UpdateReminderPageState extends State<UpdateReminderPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController dateFrom = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();

  List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  late List<bool> checkedDays;


  bool isRepeat = true;
  
  
  final MaterialStateProperty<Icon?> thumbIcon =
  MaterialStateProperty.resolveWith<Icon?>(
        (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  @override
  void initState() {
    super.initState();
    titleController.text = widget.reminder.title;
    detailController.text = widget.reminder.description!;
    isRepeat = widget.reminder.repeat;
    selectedTime = widget.reminder.timeOfDay;
    checkedDays = List.generate(7, (index) => widget.reminder.dateList?.contains(days[index])??true);

    titleController.addListener(() {
      setState(() {

      });
    });
    detailController.addListener(() {
      setState(() {

      });
    });

  }

  bool checkIsTimeValid(TimeOfDay reminderTime, TimeOfDay selectedTime){
    return reminderTime.hour >= TimeOfDay.now().hour || reminderTime.minute >= TimeOfDay.now().minute ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    final reminderItem = widget.reminder;
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
        )
    );
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10,),
                        const Text('Title',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: ColorManager.background.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: TextField(
                            controller: titleController,
                            maxLines: 1,
                            decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: 'Enter text',
                              hintStyle: TextStyle(decoration: TextDecoration.none),
                            ),
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                        ),
                        const SizedBox(height: 20,),
                        const Text('Description',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: ColorManager.background.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: TextField(
                            controller: detailController,
                            maxLines: 8,
                            decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: 'Enter detail information here',
                              hintStyle: TextStyle(decoration: TextDecoration.none),
                            ),
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                        ),
                        const SizedBox(height: 20,),
                        const Text('Time',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              height: 50,
                              width: 200,
                              decoration: BoxDecoration(
                                  color: ColorManager.background.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text('${DateFormat('EEE, dd MMM').format(selectedDate)} ${selectedTime.hour}:${selectedTime.minute} ${selectedTime.period.name}'),
                              ),
                            ),
                            const SizedBox(width: 30,),
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: () async {
                                    final DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: selectedDate,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(const Duration(days: 365)),
                                    );
                                    if (pickedDate != null) {
                                      setState(() {
                                        selectedDate = pickedDate;
                                      });
                                    }

                                    final TimeOfDay? timeOfDay = await showTimePicker(
                                      context: context,
                                      initialTime: selectedTime,
                                      initialEntryMode: TimePickerEntryMode.dial,
                                    );
                                    if (timeOfDay != null) {
                                      setState(() {
                                        selectedTime = timeOfDay;
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(double.infinity, 50),
                                    textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    elevation: 0,
                                    backgroundColor: ColorManager.primary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.more_time, size: 26, color: Colors.white,),
                                      SizedBox(width: 10,),
                                      Text('Pick Time'),
                                    ],
                                  )
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          children: [
                            const Text('Repeat',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 15,),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 90),
                              transitionBuilder: (Widget child, Animation<double> animation) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: child,
                                );
                              },
                              child: CupertinoSwitch(
                                key: ValueKey<bool>(isRepeat),
                                value: isRepeat,
                                onChanged: (value) {
                                  setState(() {
                                    isRepeat = value; // Update the switch value
                                  });
                                },
                                activeColor: ColorManager.primary,
                                trackColor: Colors.grey.shade300,
                              ),
                            ),
                          ],
                        ),

                        if(isRepeat)
                          const SizedBox(height: 20,),

                        if(isRepeat)
                          const Text('Select days',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                        if(isRepeat)
                        const SizedBox(height: 20,),

                        if(isRepeat)
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics() ,
                            shrinkWrap: true,
                            itemCount: days.length,
                            itemBuilder: (context, index) {
                              return CheckboxListTile(
                                shape: Border(
                                  top: BorderSide(
                                    color: ColorManager.black
                                  )
                                ),
                                activeColor: ColorManager.primary,
                                title: Text(days[index],style: TextStyle(fontSize: 16),),
                                value: isRepeat && checkedDays[index],
                                onChanged: isRepeat ? (bool? value) {
                                  setState(() {
                                    checkedDays[index] = value ?? false;
                                  });
                                } : null,
                              );
                            },
                          )

                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      style: OutlinedButton.styleFrom(
                          minimumSize: const Size(160, 50),
                          foregroundColor: Colors.black,
                          textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          )
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                        child: Consumer(
                          builder: (context, ref, child) {
                            return ElevatedButton(
                              onPressed:  titleController.text.isEmpty ? null : () async{
                                final scaffoldMessage = ScaffoldMessenger.of(context);
                                final navigate = Navigator.of(context);
                                DateTime checkDate = DateTime(selectedDate.year,selectedDate.month,selectedDate.day,selectedTime.hour,selectedTime.minute);

                                if(checkDate.isBefore(DateTime.now())){
                                  scaffoldMessage.showSnackBar(
                                      SnackBarUtil.customErrorSnackBar('Date is set before current time.')
                                  );
                                }
                                else{
                                  List<String> selectedDays = [];
                                  for (int i = 0; i < days.length; i++) {
                                    if (checkedDays[i]) {
                                      selectedDays.add(days[i]);
                                    }
                                  }

                                  ReminderModel reminder =  ReminderModel(
                                      id: reminderItem.id,
                                      title: titleController.text.trim(),
                                      description: detailController.text.trim(),
                                      timeOfDay: selectedTime,
                                      repeat: isRepeat,
                                      dateList: isRepeat == false ? null : selectedDays
                                  );
                                  await ref.read(reminderProvider.notifier).updateReminder(
                                      reminder
                                  );
                                  NotificationServices().scheduleNotification(
                                      reminder
                                  );
                                  scaffoldMessage.showSnackBar(
                                      SnackBarUtil.customSnackBar('Reminder Updated')
                                  );
                                  navigate.pop(true);
                                }

                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                                textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white
                                ),
                                backgroundColor: ColorManager.primary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                disabledBackgroundColor: ColorManager.primary.withOpacity(0.5),
                                disabledForegroundColor: Colors.white.withOpacity(0.5),
                              ),
                              child: const Text('Update'),
                            );
                          },
                        )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

}
