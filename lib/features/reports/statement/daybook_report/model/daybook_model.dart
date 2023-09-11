class DayBookDetailedModel {
  final int? masterEntryID;
  final String? sno;
  final String? voucherNo;
  final String? voucherDate;
  final String? refNo;
  final String? chequeNo;
  final String? voucherID;
  final String? voucherName;
  final int? ledgerID;
  final String? particulars;
  final String? drcr;
  final double? debit;
  final String? strDebit;
  final double? credit;
  final String? strCredit;
  final String? narration;
  final String? chequeDate;
  final double? debitTotal;
  final double? creditTotal;
  final String? mainNarration;

  DayBookDetailedModel({
    this.masterEntryID,
    this.sno,
    this.voucherNo,
    this.voucherDate,
    this.refNo,
    this.chequeNo,
    this.voucherID,
    this.voucherName,
    this.ledgerID,
    this.particulars,
    this.drcr,
    this.debit,
    this.strDebit,
    this.credit,
    this.strCredit,
    this.narration,
    this.chequeDate,
    this.debitTotal,
    this.creditTotal,
    this.mainNarration,
  });

  factory DayBookDetailedModel.fromJson(Map<String, dynamic> json) {
    return DayBookDetailedModel(
      masterEntryID: json['masterEntryID'],
      sno: json['sno'],
      voucherNo: json['voucherNo'],
      voucherDate: json['voucherDate'],
      refNo: json['refNo'],
      chequeNo: json['chequeNo'],
      voucherID: json['voucherID'],
      voucherName: json['voucherName'],
      ledgerID: json['ledgerID'],
      particulars: json['particulars'],
      drcr: json['drcr'],
      debit: json['debit']?.toDouble(),
      strDebit: json['strDebit'],
      credit: json['credit']?.toDouble(),
      strCredit: json['strCredit'],
      narration: json['narration'],
      chequeDate: json['chequeDate'],
      debitTotal: json['debitTotal']?.toDouble(),
      creditTotal: json['creditTotal']?.toDouble(),
      mainNarration: json['mainNarration'],
    );
  }
}



class DayBookModel {
  final int? masterEntryID;
  final String? voucherNo;
  final String? refNo;
  final double? totalAmount;
  final String? narration;
  final String? voucherTypeId;
  final String? voucherTypeName;
  final String? voucherDate;
  final int? ledgerId;

  DayBookModel({
    this.masterEntryID,
    this.voucherNo,
    this.refNo,
    this.totalAmount,
    this.narration,
    this.voucherTypeId,
    this.voucherTypeName,
    this.voucherDate,
    this.ledgerId,
  });

  factory DayBookModel.fromJson(Map<String, dynamic> json) {
    return DayBookModel(
      masterEntryID: json['masterEntryID'],
      voucherNo: json['voucherNo'],
      refNo: json['refNo'],
      totalAmount: double.parse(json['totalAmount'].toString()),
      narration: json['narration'],
      voucherTypeId: json['voucherID'],
      voucherTypeName: json['voucherName'],
      voucherDate: json['voucherDate'],
      ledgerId: json['ledgerID'],
    );
  }
}
