
class ProductModel {
  double? qty;
  int? productId;
  String? productCode;
  String? productName;
  int? productUnitID;
  String? skuunit;
  String? formalName;
  double? conversionFactor;
  int? fromUnitId;
  int? branchId;
  double? baseQty;
  String? batch;
  bool? isvatable;
  String? expirydate;
  String? flag;
  String? baseunit;
  String? mainunit;
  int? locationId;
  String? locationName;
  double? mrp;
  double? salesRate;

  ProductModel({
    this.qty,
    this.productId,
    this.productCode,
    this.productName,
    this.productUnitID,
    this.skuunit,
    this.formalName,
    this.conversionFactor,
    this.fromUnitId,
    this.branchId,
    this.baseQty,
    this.batch,
    this.isvatable,
    this.expirydate,
    this.flag,
    this.baseunit,
    this.mainunit,
    this.locationId,
    this.locationName,
    this.mrp,
    this.salesRate,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      qty: json['qty'] as double?,
      productId: json['productId'] as int?,
      productCode: json['productCode'] as String?,
      productName: json['productName'] as String?,
      productUnitID: json['productUnitID'] as int?,
      skuunit: json['skuunit'] as String?,
      formalName: json['formalName'] as String?,
      conversionFactor: json['conversionFactor'] as double?,
      fromUnitId: json['fromUnitId'] as int?,
      branchId: json['branchId'] as int?,
      baseQty: json['baseQty'] as double?,
      batch: json['batch'] as String?,
      isvatable: json['isvatable'] as bool?,
      expirydate: json['expirydate'] as String?,
      flag: json['flag'] as String?,
      baseunit: json['baseunit'] as String?,
      mainunit: json['mainunit'] as String?,
      locationId: json['locationId'] as int?,
      locationName: json['locationName'] as String?,
      mrp: (json['mrp'] as num?)?.toDouble(),
      salesRate: (json['salesRate'] as num?)?.toDouble(),
    );
  }
}


class PosSettingsModel {
  final int generalPOSSettingID;
  final String fieldName;
  final String defaultValue;
  final bool isLocked;
  final int branchID;
  final String? remarks;
  final String? updatedBy;
  final DateTime updateDate;
  final bool isDefault;
  final String? extra1;
  final String? extra2;
  final String? locationName;
  final dynamic flag;

  PosSettingsModel({
    required this.generalPOSSettingID,
    required this.fieldName,
    required this.defaultValue,
    required this.isLocked,
    required this.branchID,
    this.remarks,
    this.updatedBy,
    required this.updateDate,
    required this.isDefault,
    this.extra1,
    this.extra2,
    this.locationName,
    this.flag,
  });

  factory PosSettingsModel.fromJson(Map<String, dynamic> json) {
    return PosSettingsModel(
      generalPOSSettingID: json['generalPOSSettingID'],
      fieldName: json['fieldName'],
      defaultValue: json['defaultValue'],
      isLocked: json['isLocked'],
      branchID: json['branchID'],
      remarks: json['remarks'],
      updatedBy: json['updatedBy'],
      updateDate: DateTime.parse(json['updateDate']),
      isDefault: json['isDefault'],
      extra1: json['extra1'],
      extra2: json['extra2'],
      locationName: json['locationName'],
      flag: json['flag'],
    );
  }
}


class POSLedgerModel {
  int flag;
  int value;
  String text;
  int? vcode;
  String? searchtext;
  int branchId;

  POSLedgerModel({
    required this.flag,
    required this.value,
    required this.text,
    this.vcode,
    this.searchtext,
    required this.branchId,
  });

  factory POSLedgerModel.fromJson(Map<String, dynamic> json) {
    return POSLedgerModel(
      flag: json['flag'],
      value: json['value'],
      text: json['text'],
      vcode: json['vcode'],
      searchtext: json['searchtext'],
      branchId: json['branchId'],
    );
  }
}


class DraftModel {
  int additionalIncomeAmt;
  String batch;
  double billAdjustment;
  double billDiscAmt;
  double billDiscountAmt;
  double billDiscountPercent;
  int branchID;
  int challanDetailsID;
  int challanMasterID;
  double chargeAmt;
  int customerID;
  String customerName;
  String entryDate;
  String expiryDate;
  String extra1;
  String extra2;
  int? flag;
  int financialYearID;
  String? fromDate;
  double grossAmt;
  bool isDraft;
  bool isExport;
  int? isPOS;
  double itemDiscount;
  double itemDiscountAmt;
  double itemDiscountPercent;
  int? locationId;
  String manualRefNo;
  double netAmt;
  double netBillAmt;
  String narration;
  double nonTaxableAmt;
  int orderDetailsID;
  double otherTaxAmt;
  int pricingLevelID;
  int productID;
  int productUnitID;
  String? productName;
  double qty;
  double rate;
  int refererID;
  int salesAccountID;
  int salesDetailsDraftID;
  int salesMasterID;
  int salesOrderMasterID;
  int sku;
  double skuUnitCost;
  bool status;
  double stockqty;
  String? symbol;
  double taxableAmt;
  String? toDate;
  int transactionMode;
  double transactionUnitCost;
  int transactionUnitID;
  int updatedBy;
  String updatedDate;
  int userID;
  int vat;
  double vatAmt;
  String voucherDate;
  String voucherNo;
  int vouchertypeID;

  DraftModel({
    required this.additionalIncomeAmt,
    required this.batch,
    required this.billAdjustment,
    required this.billDiscAmt,
    required this.billDiscountAmt,
    required this.billDiscountPercent,
    required this.branchID,
    required this.challanDetailsID,
    required this.challanMasterID,
    required this.chargeAmt,
    required this.customerID,
    required this.customerName,
    required this.entryDate,
    required this.expiryDate,
    required this.extra1,
    required this.extra2,
    this.flag,
    required this.financialYearID,
    this.fromDate,
    required this.grossAmt,
    required this.isDraft,
    required this.isExport,
    this.isPOS,
    required this.itemDiscount,
    required this.itemDiscountAmt,
    required this.itemDiscountPercent,
    this.locationId,
    required this.manualRefNo,
    required this.netAmt,
    required this.netBillAmt,
    required this.narration,
    required this.nonTaxableAmt,
    required this.orderDetailsID,
    required this.otherTaxAmt,
    required this.pricingLevelID,
    required this.productID,
    required this.productUnitID,
    this.productName,
    required this.qty,
    required this.rate,
    required this.refererID,
    required this.salesAccountID,
    required this.salesDetailsDraftID,
    required this.salesMasterID,
    required this.salesOrderMasterID,
    required this.sku,
    required this.skuUnitCost,
    required this.status,
    required this.stockqty,
    this.symbol,
    required this.taxableAmt,
    this.toDate,
    required this.transactionMode,
    required this.transactionUnitCost,
    required this.transactionUnitID,
    required this.updatedBy,
    required this.updatedDate,
    required this.userID,
    required this.vat,
    required this.vatAmt,
    required this.voucherDate,
    required this.voucherNo,
    required this.vouchertypeID,
  });

  factory DraftModel.fromJson(Map<String, dynamic> json) {
    return DraftModel(
      additionalIncomeAmt: json['additionalIncomeAmt'],
      batch: json['batch'],
      billAdjustment: json['billAdjustment'].toDouble(),
      billDiscAmt: json['billDiscAmt'].toDouble(),
      billDiscountAmt: json['billDiscountAmt'].toDouble(),
      billDiscountPercent: json['billDiscountPercent'].toDouble(),
      branchID: json['branchID'],
      challanDetailsID: json['challanDetailsID'],
      challanMasterID: json['challanMasterID'],
      chargeAmt: json['chargeAmt'].toDouble(),
      customerID: json['customerID'],
      customerName: json['customerName'],
      entryDate: json['entryDate'],
      expiryDate: json['expiryDate'],
      extra1: json['extra1'],
      extra2: json['extra2'],
      flag: json['flag'],
      financialYearID: json['financialYearID'],
      fromDate: json['fromDate'],
      grossAmt: json['grossAmt'].toDouble(),
      isDraft: json['isDraft'],
      isExport: json['isExport'],
      isPOS: json['isPOS'],
      itemDiscount: json['itemDiscount'].toDouble(),
      itemDiscountAmt: json['itemDiscountAmt'].toDouble(),
      itemDiscountPercent: json['itemDiscountPercent'].toDouble(),
      locationId: json['locationId'],
      manualRefNo: json['manualRefNo'],
      netAmt: json['netAmt'].toDouble(),
      netBillAmt: json['netBillAmt'].toDouble(),
      narration: json['narration'],
      nonTaxableAmt: json['nonTaxableAmt'].toDouble(),
      orderDetailsID: json['orderDetailsID'],
      otherTaxAmt: json['otherTaxAmt'].toDouble(),
      pricingLevelID: json['pricingLevelID'],
      productID: json['productID'],
      productUnitID: json['productUnitID'],
      productName: json['productName'],
      qty: json['qty'].toDouble(),
      rate: json['rate'].toDouble(),
      refererID: json['refererID'],
      salesAccountID: json['salesAccountID'],
      salesDetailsDraftID: json['salesDetailsDraftID'],
      salesMasterID: json['salesMasterID'],
      salesOrderMasterID: json['salesOrderMasterID'],
      sku: json['sku'],
      skuUnitCost: json['skuUnitCost'].toDouble(),
      status: json['status'],
      stockqty: json['stockqty'].toDouble(),
      symbol: json['symbol'],
      taxableAmt: json['taxableAmt'].toDouble(),
      toDate: json['toDate'],
      transactionMode: json['transactionMode'],
      transactionUnitCost: json['transactionUnitCost'].toDouble(),
      transactionUnitID: json['transactionUnitID'],
      updatedBy: json['updatedBy'],
      updatedDate: json['updatedDate'],
      userID: json['userID'],
      vat: json['vat'],
      vatAmt: json['vatAmt'].toDouble(),
      voucherDate: json['voucherDate'],
      voucherNo: json['voucherNo'],
      vouchertypeID: json['vouchertypeID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'additionalIncomeAmt': additionalIncomeAmt,
      'batch': batch,
      'billAdjustment': billAdjustment,
      'billDiscAmt': billDiscAmt,
      'billDiscountAmt': billDiscountAmt,
      'billDiscountPercent': billDiscountPercent,
      'branchID': branchID,
      'challanDetailsID': challanDetailsID,
      'challanMasterID': challanMasterID,
      'chargeAmt': chargeAmt,
      'customerID': customerID,
      'customerName': customerName,
      'entryDate': entryDate,
      'expiryDate': expiryDate,
      'extra1': extra1,
      'extra2': extra2,
      if (flag != null) 'flag': flag,
      'financialYearID': financialYearID,
      if (fromDate != null) 'fromDate': fromDate,
      'grossAmt': grossAmt,
      'isDraft': isDraft,
      'isExport': isExport,
      if (isPOS != null) 'isPOS': isPOS,
      'itemDiscount': itemDiscount,
      'itemDiscountAmt': itemDiscountAmt,
      'itemDiscountPercent': itemDiscountPercent,
      if (locationId != null) 'locationId': locationId,
      'manualRefNo': manualRefNo,
      'netAmt': netAmt,
      'netBillAmt': netBillAmt,
      'narration': narration,
      'nonTaxableAmt': nonTaxableAmt,
      'orderDetailsID': orderDetailsID,
      'otherTaxAmt': otherTaxAmt,
      'pricingLevelID': pricingLevelID,
      'productID': productID,
      'productUnitID': productUnitID,
      if (productName != null) 'productName': productName,
      'qty': qty,
      'rate': rate,
      'refererID': refererID,
      'salesAccountID': salesAccountID,
      'salesDetailsDraftID': salesDetailsDraftID,
      'salesMasterID': salesMasterID,
      'salesOrderMasterID': salesOrderMasterID,
      'sku': sku,
      'skuUnitCost': skuUnitCost,
      'status': status,
      'stockqty': stockqty,
      if (symbol != null) 'symbol': symbol,
      'taxableAmt': taxableAmt,
      if (toDate != null) 'toDate': toDate,
      'transactionMode': transactionMode,
      'transactionUnitCost': transactionUnitCost,
      'transactionUnitID': transactionUnitID,
      'updatedBy': updatedBy,
      'updatedDate': updatedDate,
      'userID': userID,
      'vat': vat,
      'vatAmt': vatAmt,
      'voucherDate': voucherDate,
      'voucherNo': voucherNo,
      'vouchertypeID': vouchertypeID,
    };
  }

}
