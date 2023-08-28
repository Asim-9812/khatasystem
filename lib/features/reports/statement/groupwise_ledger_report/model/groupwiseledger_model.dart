class GroupwiseLedgerReportModel {
  final String? sno;
  final int? id;
  final String? accountGroup;
  final String? type;
  final double? openingBalance;
  final String? strOpeningBalance;
  final double? debitAmount;
  final double? creditAmount;
  final double? closingBalance;
  final String? strClosingBalance;

  GroupwiseLedgerReportModel({
    this.sno,
    this.id,
    this.accountGroup,
    this.type,
    this.openingBalance,
    this.strOpeningBalance,
    this.debitAmount,
    this.creditAmount,
    this.closingBalance,
    this.strClosingBalance,
  });

  factory GroupwiseLedgerReportModel.fromJson(Map<String, dynamic> json) {
    return GroupwiseLedgerReportModel(
      sno: json['sno'],
      id: json['id'],
      accountGroup: json['accountGroup'],
      type: json['type'],
      openingBalance: (json['openingBalance'] as num?)?.toDouble(),
      strOpeningBalance: json['strOpeningBalance'],
      debitAmount: (json['debitAmount'] as num?)?.toDouble(),
      creditAmount: (json['creditAmount'] as num?)?.toDouble(),
      closingBalance: (json['closingBalance'] as num?)?.toDouble(),
      strClosingBalance: json['strClosingBalance'],
    );
  }
}
