class BalanceSheetReportModel {
  String? sno;
  int? accountGroupId;
  int? accountGroupId2;
  String? accountGroupName;
  String? accountGroupName2;

  String? strDebit;
  String? strCredit;
  double? debit;
  double? credit;
  int? layerPosition;
  String? nature;

  BalanceSheetReportModel({
    this.sno,
    this.accountGroupId,
    this.accountGroupId2,
    this.accountGroupName,
    this.accountGroupName2,
    this.strDebit,
    this.strCredit,
    this.debit,
    this.credit,
    this.layerPosition,
    this.nature,
  });

  BalanceSheetReportModel.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    accountGroupId = json['accountGroupId'];
    accountGroupId2 = json['accountGroupId2'];
    accountGroupName = json['accountGroupName'];
    accountGroupName2 = json['accountGroupName2'];
    strDebit = json['strDebit'];
    strCredit = json['strCredit'];
    debit = json['debit'] != null ? (json['debit'] as num).toDouble() : null;
    credit = json['credit'] != null ? (json['credit'] as num).toDouble() : null;
    layerPosition = json['layerPosition'];
    nature = json['nature'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sno'] = sno;
    data['accountGroupId'] = accountGroupId;
    data['accountGroupId2'] = accountGroupId2;
    data['accountGroupName'] = accountGroupName;
    data['accountGroupName2'] = accountGroupName2;
    data['strDebit'] = strDebit;
    data['strCredit'] = strCredit;
    data['debit'] = debit;
    data['credit'] = credit;
    data['layerPosition'] = layerPosition;
    data['nature'] = nature;
    return data;
  }
}
