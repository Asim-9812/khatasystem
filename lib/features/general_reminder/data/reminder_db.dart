import '../model/general_reminder_model.dart';

List<String> daysOfWeekMedication = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];

List<ReminderPatternModel> generalPatternList = [
  ReminderPatternModel(id: 1, patternName: 'Once'),
  ReminderPatternModel(id: 2, patternName: 'Everyday'),
  ReminderPatternModel(id: 3, patternName: 'Specific Days'),
  ReminderPatternModel(id: 4, patternName: 'Intervals (in days)'),
];


List<String> initialReminderType = ['min','hours','days'];