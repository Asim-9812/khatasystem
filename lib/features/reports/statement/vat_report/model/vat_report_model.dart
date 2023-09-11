class VatReportDetailModel {
  final String? sno;
  final String? date;
  final String? invoiceNo;
  final String? supplierOrLedgerId;
  final String? cashOrParty;
  final String? pan;
  final String? strTotalAmount;
  final String? strTaxableAmount;
  final String? strVATDr;
  final String? strVATCr;
  final double? allTotalAmount;
  final double? allTaxableAmount;
  final double? allVATAmountDr;
  final double? allVATAmountCr;

  VatReportDetailModel({
    this.sno,
    this.date,
    this.invoiceNo,
    this.supplierOrLedgerId,
    this.cashOrParty,
    this.pan,
    this.strTotalAmount,
    this.strTaxableAmount,
    this.strVATDr,
    this.strVATCr,
    this.allTotalAmount,
    this.allTaxableAmount,
    this.allVATAmountDr,
    this.allVATAmountCr,
  });

  factory VatReportDetailModel.fromJson(Map<String, dynamic> json) {
    return VatReportDetailModel(
      sno: json['sno'],
      date: json['date'],
      invoiceNo: json['invoiceNo'],
      supplierOrLedgerId: json['supplierorledgerid'],
      cashOrParty: json['cashorParty'],
      pan: json['pan'],
      strTotalAmount: json['strTotalAmount'],
      strTaxableAmount: json['strTaxableAmount'],
      strVATDr: json['strVATDr'],
      strVATCr: json['strVATCr'],
      allTotalAmount: json['allTotalAmount']?.toDouble(),
      allTaxableAmount: json['allTaxableAmount']?.toDouble(),
      allVATAmountDr: json['allVATAmountDr']?.toDouble(),
      allVATAmountCr: json['allVATAmountCr']?.toDouble(),
    );
  }
}





class VatReportModel {
  final String sno;
  final int vouchertypeID;
  final String particulars;
  final double totalAmount;
  final String strTotalAmount;
  final double totalTaxableAmount;
  final String strTotalTaxableAmount;
  final double vatDr;
  final String strVATDr;
  final double vatCr;
  final String strVATCr;

  VatReportModel({
    required this.sno,
    required this.vouchertypeID,
    required this.particulars,
    required this.totalAmount,
    required this.strTotalAmount,
    required this.totalTaxableAmount,
    required this.strTotalTaxableAmount,
    required this.vatDr,
    required this.strVATDr,
    required this.vatCr,
    required this.strVATCr,
  });

  factory VatReportModel.fromJson(Map<String, dynamic> json) {
    return VatReportModel(
      sno: json['sno'],
      vouchertypeID: json['vouchertypeID'],
      particulars: json['particulars'],
      totalAmount: double.parse(json['totalAmount'].toString()),
      strTotalAmount: json['strTotalAmount'],
      totalTaxableAmount: double.parse(json['totalTaxableAmount'].toString()),
      strTotalTaxableAmount: json['strTotalTaxableAmount'],
      vatDr: double.parse(json['vatDr'].toString()),
      strVATDr: json['strVATDr'],
      vatCr: double.parse(json['vatCr'].toString()),
      strVATCr: json['strVATCr'],
    );
  }
}


class AboveLakhModel {
  final int custSupID;
  final String pan;
  final String taxPayerName;
  final String? tradeLanguage;
  final String tradeNameType;
  final String voucherType;
  final double taxableAmount;
  final double nonTaxableAmount;

  AboveLakhModel({
    required this.custSupID,
    required this.pan,
    required this.taxPayerName,
    this.tradeLanguage,
    required this.tradeNameType,
    required this.voucherType,
    required this.taxableAmount,
    required this.nonTaxableAmount,
  });

  factory AboveLakhModel.fromJson(Map<String, dynamic> json) {
    return AboveLakhModel(
      custSupID: json['custSupID'] as int,
      pan: json['pan'] as String,
      taxPayerName: json['taxPayerName'] as String,
      tradeLanguage: json['tradeLanguage'] as String?,
      tradeNameType: json['tradeNameType'] as String,
      voucherType: json['voucherType'] as String,
      taxableAmount: json['taxableAmount'] as double,
      nonTaxableAmount: json['nonTaxableAmount'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'custSupID': custSupID,
      'pan': pan,
      'taxPayerName': taxPayerName,
      'tradeLanguage': tradeLanguage,
      'tradeNameType': tradeNameType,
      'voucherType': voucherType,
      'taxableAmount': taxableAmount,
      'nonTaxableAmount': nonTaxableAmount,
    };
  }
}


class MonthlyModel {
  final String sno;
  final String month;
  final String branchId;
  final DateTime monthFromDate;
  final DateTime monthToDate;
  final double openingBalance;
  final double debitAmount;
  final double creditAmount;
  final double balance;
  final String strBalance;

  MonthlyModel({
    required this.sno,
    required this.month,
    required this.branchId,
    required this.monthFromDate,
    required this.monthToDate,
    required this.openingBalance,
    required this.debitAmount,
    required this.creditAmount,
    required this.balance,
    required this.strBalance,
  });

  factory MonthlyModel.fromJson(Map<String, dynamic> json) {
    return MonthlyModel(
      sno: json['sno'] as String,
      month: json['month'] as String,
      branchId: json['branchid'].toString(),
      monthFromDate: DateTime.parse(json['monthfromdate'] as String),
      monthToDate: DateTime.parse(json['monthTodate'] as String),
      openingBalance: double.parse(json['openingBalance'].toString()),
      debitAmount: double.parse(json['debitAmount'].toString()),
      creditAmount: double.parse(json['creditAmount'].toString()),
      balance: double.parse(json['balance'].toString()),
      strBalance: json['strBalance'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sno': sno,
      'month': month,
      'branchid': branchId,
      'monthfromdate': monthFromDate.toIso8601String(),
      'monthTodate': monthToDate.toIso8601String(),
      'openingBalance': openingBalance,
      'debitAmount': debitAmount,
      'creditAmount': creditAmount,
      'balance': balance,
      'strBalance': strBalance,
    };
  }
}

