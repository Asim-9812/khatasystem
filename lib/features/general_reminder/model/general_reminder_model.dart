


import 'package:hive/hive.dart';
part 'general_reminder_model.g.dart'; // Generated file by Hive

@HiveType(typeId: 10) // Match the typeId with the TypeAdapter
class GeneralReminderModel {
  @HiveField(0)
  int reminderId;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  String time;

  @HiveField(4)
  DateTime startDate;

  @HiveField(5)
  InitialReminder? initialReminder;

  @HiveField(6)
  ReminderPattern reminderPattern; // Use your frequency model class

  @HiveField(7)
  String userId;

  @HiveField(8)
  List<int>? contentIdList;

  GeneralReminderModel({
    required this.reminderId,
    required this.title,
    required this.description,
    required this.time,
    required this.startDate,
    this.initialReminder,
    required this.reminderPattern,
    required this.userId,
    this.contentIdList,
  });
}


@HiveType(typeId: 11) // Choose a unique typeId for InitialReminder
class InitialReminder {
  @HiveField(0)
  int initialReminderTypeId;

  @HiveField(1)
  String initialReminderTypeName;

  @HiveField(2)
  int initialReminder;

  InitialReminder({
    required this.initialReminderTypeId,
    required this.initialReminderTypeName,
    required this.initialReminder,
  });
}



@HiveType(typeId: 12)
class ReminderPattern {
  @HiveField(0)
  int reminderPatternId;
  @HiveField(1)
  String patternName;
  @HiveField(2)
  int? interval;
  @HiveField(3)
  List<String>? daysOfWeek;

  ReminderPattern({
    required this.reminderPatternId,
    required this.patternName,
    this.interval,
    this.daysOfWeek,
  });
}




class ReminderPatternModel{
  final int id;
  final String patternName;

  ReminderPatternModel({
    required this.id,
    required this.patternName
  });

}

