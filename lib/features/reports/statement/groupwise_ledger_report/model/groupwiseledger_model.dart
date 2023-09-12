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


class GroupWiseDetailModel {
  final String sno;
  final int ledgerId;
  final int accountGroupId;
  final String accountLedger;
  final String accountGroup;
  final double openingBalance;
  final String strOpeningBalance;
  final double debitAmount;
  final double creditAmount;
  final double closingBalance;
  final String strClosingBalance;

  GroupWiseDetailModel({
    required this.sno,
    required this.ledgerId,
    required this.accountGroupId,
    required this.accountLedger,
    required this.accountGroup,
    required this.openingBalance,
    required this.strOpeningBalance,
    required this.debitAmount,
    required this.creditAmount,
    required this.closingBalance,
    required this.strClosingBalance,
  });

  factory GroupWiseDetailModel.fromJson(Map<String, dynamic> json) {
    return GroupWiseDetailModel(
      sno: json['sno'],
      ledgerId: json['ledgerId'],
      accountGroupId: json['accountGroupId'],
      accountLedger: json['accountLedger'],
      accountGroup: json['accountGroup'],
      openingBalance: json['openingBalance'].toDouble(),
      strOpeningBalance: json['strOpeningBalance'],
      debitAmount: json['debitAmount'].toDouble(),
      creditAmount: json['creditAmount'].toDouble(),
      closingBalance: json['closingBalance'].toDouble(),
      strClosingBalance: json['strClosingBalance'],
    );
  }
}



class LedgerDetailGroupWiseModel {
  final String? sno;
  final String? voucherDate;
  final bool? isSubLedger;
  final int? voucherTypeId;
  final String? voucherTypeName;
  final String? voucherNo;
  final int? invoiceNo;
  final String? refNo;
  final String? chequeNo;
  final int? ledgerId;
  final String? ledgerName;
  final dynamic? particular;
  final double? debit;
  final String? strDebit;
  final double? credit;
  final String? strCredit;
  final double? balance;
  final String? strBalance;
  final int? masterId;
  final String? narration;
  final bool? topLedger;

  LedgerDetailGroupWiseModel({
    this.sno,
    this.voucherDate,
    this.isSubLedger,
    this.voucherTypeId,
    this.voucherTypeName,
    this.voucherNo,
    this.invoiceNo,
    this.refNo,
    this.chequeNo,
    this.ledgerId,
    this.ledgerName,
    this.particular,
    this.debit,
    this.strDebit,
    this.credit,
    this.strCredit,
    this.balance,
    this.strBalance,
    this.masterId,
    this.narration,
    this.topLedger,
  });

  factory LedgerDetailGroupWiseModel.fromJson(Map<String, dynamic> json) {
    return LedgerDetailGroupWiseModel(
      sno: json['sno'],
      voucherDate: json['voucherDate'],
      isSubLedger: json['isSubLedger'],
      voucherTypeId: json['voucherTypeId'],
      voucherTypeName: json['voucherTypeName'],
      voucherNo: json['voucherNo'],
      invoiceNo: json['invoiceNo'],
      refNo: json['refNo'],
      chequeNo: json['chequeNo'],
      ledgerId: json['ledgerId'],
      ledgerName: json['ledgerName'],
      particular: json['particular'],
      debit: json['debit']?.toDouble(),
      strDebit: json['strDebit'],
      credit: json['credit']?.toDouble(),
      strCredit: json['strCredit'],
      balance: json['balance']?.toDouble(),
      strBalance: json['strBalance'],
      masterId: json['masterId'],
      narration: json['narration'],
      topLedger: json['topLedger'],
    );
  }
}


