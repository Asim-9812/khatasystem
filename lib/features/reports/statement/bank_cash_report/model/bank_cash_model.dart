class BankCashModel {
  String sno;
  String date;
  String voucherNo;
  String refNo;
  int voucherType;
  String voucherName;
  double cashDr;
  String strCashDr;
  double cashCr;
  String strCashCr;
  double cashBalance;
  String strCashBalance;
  double bankDr;
  String strBankDr;
  double bankCr;
  String strBankCr;
  double bankBalance;
  String strBankBalance;
  double bankclosingBalance;
  double cashclosingBalance;

  BankCashModel({
    required this.sno,
    required this.date,
    required this.voucherNo,
    required this.refNo,
    required this.voucherType,
    required this.voucherName,
    required this.cashDr,
    required this.strCashDr,
    required this.cashCr,
    required this.strCashCr,
    required this.cashBalance,
    required this.strCashBalance,
    required this.bankDr,
    required this.strBankDr,
    required this.bankCr,
    required this.strBankCr,
    required this.bankBalance,
    required this.strBankBalance,
    required this.bankclosingBalance,
    required this.cashclosingBalance,
  });

  factory BankCashModel.fromJson(Map<String, dynamic> json) {
    return BankCashModel(
      sno: json['sno'] ?? "",
      date: json['date'] ?? "",
      voucherNo: json['voucherNo'] ?? "",
      refNo: json['refNo'] ?? "",
      voucherType: json['voucherType'] ?? 0,
      voucherName: json['voucherName'] ?? "",
      cashDr: (json['cashDr'] ?? 0).toDouble(), // Parse as double
      strCashDr: json['strCashDr'] ?? "",
      cashCr: (json['cashCr'] ?? 0).toDouble(), // Parse as double
      strCashCr: json['strCashCr'] ?? "",
      cashBalance: (json['cashBalance'] ?? 0.0000).toDouble(), // Parse as double
      strCashBalance: json['strCashBalance'] ?? "<b>0.0000</b>",
      bankDr: (json['bankDr'] ?? 0).toDouble(), // Parse as double
      strBankDr: json['strBankDr'] ?? "",
      bankCr: (json['bankCr'] ?? 0).toDouble(), // Parse as double
      strBankCr: json['strBankCr'] ?? "",
      bankBalance: (json['bankBalance'] ?? 0.0000).toDouble(), // Parse as double
      strBankBalance: json['strBankBalance'] ?? "<b>0.0000</b>",
      bankclosingBalance: (json['bankclosing_balance'] ?? 0.0000).toDouble(), // Parse as double
      cashclosingBalance: (json['cashclosing_balance'] ?? 0.0000).toDouble(), // Parse as double
    );
  }
}


class BankCashDetailedModel {
  String sno;
  String date;
  String voucherNo;
  String refNo;
  int voucherType;
  String voucherName;
  String particulars;
  double cashDr;
  String strCashDr;
  double cashCr;
  String strCashCr;
  double cashBalance;
  String strCashBalance;
  double bankDr;
  String strBankDr;
  double bankCr;
  String strBankCr;
  double bankBalance;
  String strBankBalance;
  double debitTotal;
  double creditTotal;
  double bankclosingBalance;
  double cashclosingBalance;
  String? chequeNo;
  String? chequeDate;
  String? narration;

  BankCashDetailedModel({
    required this.sno,
    required this.date,
    required this.voucherNo,
    required this.refNo,
    required this.voucherType,
    required this.voucherName,
    required this.particulars,
    required this.cashDr,
    required this.strCashDr,
    required this.cashCr,
    required this.strCashCr,
    required this.cashBalance,
    required this.strCashBalance,
    required this.bankDr,
    required this.strBankDr,
    required this.bankCr,
    required this.strBankCr,
    required this.bankBalance,
    required this.strBankBalance,
    required this.debitTotal,
    required this.creditTotal,
    required this.bankclosingBalance,
    required this.cashclosingBalance,
    this.chequeNo,
    this.chequeDate,
    this.narration,
  });

  factory BankCashDetailedModel.fromJson(Map<String, dynamic> json) {
    return BankCashDetailedModel(
      sno: json['sno'] ?? "",
      date: json['date'] ?? "",
      voucherNo: json['voucherNo'] ?? "",
      refNo: json['refNo'] ?? "",
      voucherType: json['voucherType'] ?? 0,
      voucherName: json['voucherName'] ?? "",
      particulars: json['particulars'] ?? "",
      cashDr: (json['cashDr'] ?? 0).toDouble(), // Parse as double
      strCashDr: json['strCashDr'] ?? "",
      cashCr: (json['cashCr'] ?? 0).toDouble(), // Parse as double
      strCashCr: json['strCashCr'] ?? "",
      cashBalance: (json['cashBalance'] ?? 0.0000).toDouble(), // Parse as double
      strCashBalance: json['strCashBalance'] ?? "<b> 0.0000</b>",
      bankDr: (json['bankDr'] ?? 0).toDouble(), // Parse as double
      strBankDr: json['strBankDr'] ?? "",
      bankCr: (json['bankCr'] ?? 0).toDouble(), // Parse as double
      strBankCr: json['strBankCr'] ?? "",
      bankBalance: (json['bankBalance'] ?? 0.0000).toDouble(), // Parse as double
      strBankBalance: json['strBankBalance'] ?? "<b> 0.0000 </b>",
      debitTotal: (json['debitTotal'] ?? 0).toDouble(), // Parse as double
      creditTotal: (json['creditTotal'] ?? 0).toDouble(), // Parse as double
      bankclosingBalance: (json['bankclosing_balance'] ?? 0.0000).toDouble(), // Parse as double
      cashclosingBalance: (json['cashclosing_balance'] ?? 0.0000).toDouble(), // Parse as double
      chequeNo: json['chequeNo'],
      chequeDate: json['chequeDate'],
      narration: json['narration'],
    );
  }
}
