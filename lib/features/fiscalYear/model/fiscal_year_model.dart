


class FiscalYearModel {
  final int financialYearId;
  final DateTime fromDate;
  final DateTime toDate;
  final String fiscalYear;
  final String shortDate;
  final DateTime createdDate;
  final int userId;
  final int bookClose;

  FiscalYearModel({
    required this.financialYearId,
    required this.fromDate,
    required this.toDate,
    required this.fiscalYear,
    required this.shortDate,
    required this.createdDate,
    required this.userId,
    required this.bookClose,
  });

  factory FiscalYearModel.fromJson(Map<String, dynamic> json) {
    return FiscalYearModel(
      financialYearId: json['financialYearId'],
      fromDate: DateTime.parse(json['fromDate']),
      toDate: DateTime.parse(json['toDate']),
      fiscalYear: json['fiscalYear'],
      shortDate: json['shortDate'],
      createdDate: DateTime.parse(json['createdDate']),
      userId: json['userId'],
      bookClose: json['bookClose'],
    );
  }
}


