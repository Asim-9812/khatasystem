


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



List dummy_data = [
  {"s.n": 1, "fiscal year": "FY-22/23", "from date": "01/04/2022", "to date": "31/03/2023"},
  {"s.n": 2, "fiscal year": "FY-23/24", "from date": "01/04/2023", "to date": "31/03/2024"},
  {"s.n": 3, "fiscal year": "FY-24/25", "from date": "01/04/2024", "to date": "31/03/2025"},
  {"s.n": 4, "fiscal year": "FY-25/26", "from date": "01/04/2025", "to date": "31/03/2026"},
  {"s.n": 5, "fiscal year": "FY-26/27", "from date": "01/04/2026", "to date": "31/03/2027"}
];

