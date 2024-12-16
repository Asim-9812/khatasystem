
class TableData {
  String? sno;
  int? ledgerId;
  int? accountGroupId;
  String? ledgerName;
  String? accountGroupName;
  String? nature;
  String? strOpening;
  String? strDebit;
  String? strCredit;
  String? strClosing;
  int? branchId;
  bool? isPageFooter;
  bool? isBold;
  bool? isItalic;

  TableData({
    this.sno,
    this.ledgerId,
    this.accountGroupId,
    this.ledgerName,
    this.accountGroupName,
    this.nature,
    this.strOpening,
    this.strDebit,
    this.strCredit,
    this.strClosing,
    this.branchId,
    this.isPageFooter,
    this.isBold,
    this.isItalic,
  });

  factory TableData.fromJson(Map<String, dynamic> json) {
    return TableData(
        sno: json['sno'],
        ledgerId: json['ledgerId'],
        accountGroupId: json['accountGroupId'],
        ledgerName: json['ledgerName'],
        accountGroupName: json['accountGroupName'],
        nature: json['nature'],
        strOpening: json['strOpening'],
        strDebit: json['strDebit'],
        strCredit: json['strCredit'],
        strClosing: json['strClosing'],
        branchId: json['branchId'],
        isPageFooter: json['isPageFooter'],
        isBold: json['isBold'],
        isItalic: json['isItalic'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sno'] = sno;
    data['ledgerId'] = ledgerId;
    data['accountGroupId'] = accountGroupId;
    data['ledgerName'] = ledgerName;
    data['accountGroupName'] = accountGroupName;
    data['nature'] = nature;
    data['strOpening'] = strOpening;
    data['strDebit'] = strDebit;
    data['strCredit'] = strCredit;
    data['strClosing'] = strClosing;
    data['branchId'] = branchId;
    data['isPageFooter'] = isPageFooter;
    data['isBold'] = isBold;
    data['isItalic'] = isItalic;
    return data;
  }
}



class LedgerVoucherModel {
  String? sno;
  int? ledgerId;
  int? mainledgerId;
  int? subledgerId;
  String? ledgerName;
  String? drCr;
  String? dr;
  String? cr;
  String? chequeNo;
  String? chequeDate;
  int? voucherTypeId;
  String? narration;
  bool? isSubLedger;
  bool? hasChild;
  int? masterId;

  LedgerVoucherModel({
    this.sno,
    this.ledgerId,
    this.mainledgerId,
    this.subledgerId,
    this.ledgerName,
    this.drCr,
    this.dr,
    this.cr,
    this.chequeNo,
    this.chequeDate,
    this.voucherTypeId,
    this.narration,
    this.isSubLedger,
    this.hasChild,
    this.masterId,
  });

  factory LedgerVoucherModel.fromJson(Map<String, dynamic> json) {
    return LedgerVoucherModel(
      sno: json['sno'] as String?,
      ledgerId: json['ledgerId'] as int?,
      mainledgerId: json['mainledgerId'] as int?,
      subledgerId: json['subledgerId'] as int?,
      ledgerName: json['ledgerName'] as String?,
      drCr: json['drCr'] as String?,
      dr: json['dr'] as String?,
      cr: json['cr'] as String?,
      chequeNo: json['chequeNo'] as String?,
      chequeDate: json['chequeDate'] as String?,
      voucherTypeId: json['voucherTypeId'] as int?,
      narration: json['narration'] as String?,
      isSubLedger: json['isSubLedger'] as bool?,
      hasChild: json['hasChild'] as bool?,
      masterId: json['masterId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sno': sno,
      'ledgerId': ledgerId,
      'mainledgerId': mainledgerId,
      'subledgerId': subledgerId,
      'ledgerName': ledgerName,
      'drCr': drCr,
      'dr': dr,
      'cr': cr,
      'chequeNo': chequeNo,
      'chequeDate': chequeDate,
      'voucherTypeId': voucherTypeId,
      'narration': narration,
      'isSubLedger': isSubLedger,
      'hasChild': hasChild,
      'masterId': masterId,
    };
  }
}
