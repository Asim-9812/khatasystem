class DayBookDetailedModel {
  final String? sno;
  final int? masterEntryID;
  final String? voucherNo;
  final String? chequeNo;
  final String? refNo;
  final double? drTotal;
  final double? crTotal;
  final String? narration;
  final int? voucherTypeId;
  final String? voucherTypeName;
  final String? particulars;
  final double? debitAmount;
  final String? strDebitAmount;
  final double? creditAmount;
  final String? strCreditAmount;
  final double? strAmount;
  final int? layerPosition;
  final bool? isSubLedger;
  final bool? isParent;
  final String? voucherDate;

  DayBookDetailedModel({
    this.sno,
    this.masterEntryID,
    this.voucherNo,
    this.chequeNo,
    this.refNo,
    this.drTotal,
    this.crTotal,
    this.narration,
    this.voucherTypeId,
    this.voucherTypeName,
    this.particulars,
    this.debitAmount,
    this.strDebitAmount,
    this.creditAmount,
    this.strCreditAmount,
    this.strAmount,
    this.layerPosition,
    this.isSubLedger,
    this.isParent,
    this.voucherDate,
  });

  factory DayBookDetailedModel.fromJson(Map<String, dynamic> json) {
    return DayBookDetailedModel(
      sno: json['sno'],
      masterEntryID: json['masterEntryID'],
      voucherNo: json['voucherNo'],
      chequeNo: json['chequeNo'],
      refNo: json['ref_No'],
      drTotal: json['drTotal'],
      crTotal: json['crTotal'],
      narration: json['narration'],
      voucherTypeId: json['voucherTypeId'],
      voucherTypeName: json['voucherTypeName'],
      particulars: json['particulars'],
      debitAmount: json['debitAmount'],
      strDebitAmount: json['strDebitAmount'],
      creditAmount: json['creditAmount'],
      strCreditAmount: json['strCreditAmount'],
      strAmount: json['strAmount'],
      layerPosition: json['layerposition'],
      isSubLedger: json['isSubLedger'],
      isParent: json['isParent'],
      voucherDate: json['voucherDate'] ,
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

  DayBookModel({
    this.masterEntryID,
    this.voucherNo,
    this.refNo,
    this.totalAmount,
    this.narration,
    this.voucherTypeId,
    this.voucherTypeName,
    this.voucherDate,
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
    );
  }
}
