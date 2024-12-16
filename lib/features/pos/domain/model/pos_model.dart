
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
  final String updateDate;
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
      updateDate: (json['updateDate']),
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
  String? vcode;
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
  String? expiryDate;
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
    this.expiryDate,
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

class SalesItemAllocationModel {
  final int locationDetailsID;
  final int voucherTypeID;
  final int masterID;
  final int detailsID;
  final int productID;
  final int locationID;
  final double qty;
  final int unitID;
  final String batch;
  String? expiryDate;
  final double stockQty;
  final String extra1;
  final int flag;
  final int userID;
  final String entryDate;

  SalesItemAllocationModel({
    required this.locationDetailsID,
    required this.voucherTypeID,
    required this.masterID,
    required this.detailsID,
    required this.productID,
    required this.locationID,
    required this.qty,
    required this.unitID,
    required this.batch,
    this.expiryDate,
    required this.stockQty,
    required this.extra1,
    required this.flag,
    required this.userID,
    required this.entryDate,
  });

  factory SalesItemAllocationModel.fromJson(Map<String, dynamic> json) {
    return SalesItemAllocationModel(
      locationDetailsID: json['locationDetailsID'] ?? 0,
      voucherTypeID: json['voucherTypeID'] ?? 0,
      masterID: json['masterID'] ?? 0,
      detailsID: json['detailsID'] ?? 0,
      productID: json['productID'] ?? '',
      locationID: json['locationID'] ?? 0,
      qty: json['qty'] ?? 0,
      unitID: json['unitID'] ?? 0,
      batch: json['batch'] ?? 'N/A',
      expiryDate: json['expiryDate'] ?? '',
      stockQty: json['stockQty'] ?? 0,
      extra1: json['extra1'] ?? '',
      flag: json['flag'] ?? 0,
      userID: json['userID'] ?? 0,
      entryDate: json['entryDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'locationDetailsID': locationDetailsID,
      'voucherTypeID': voucherTypeID,
      'masterID': masterID,
      'detailsID': detailsID,
      'productID': productID,
      'locationID': locationID,
      'qty': qty,
      'unitID': unitID,
      'batch': batch,
      'expiryDate': expiryDate,
      'stockQty': stockQty,
      'extra1': extra1,
      'flag': flag,
      'userID': userID,
      'entryDate': entryDate,
    };
  }
}



class ReceivedAmountModel {
  int transactionDetailsID;
  int voucherTypeID;
  int masterID;
  int ledgerID;
  String ledgerName;
  double drAmt;
  double crAmt;
  int userID;
  String entryDate;
  int updatedBy;
  String updatedDate;
  String extra1;
  String extra2;
  int flag;
  String drCr;

  ReceivedAmountModel({
    required this.transactionDetailsID,
    required this.voucherTypeID,
    required this.masterID,
    required this.ledgerID,
    required this.ledgerName,
    required this.drAmt,
    required this.crAmt,
    required this.userID,
    required this.entryDate,
    required this.updatedBy,
    required this.updatedDate,
    required this.extra1,
    required this.extra2,
    required this.flag,
    required this.drCr,
  });

  factory ReceivedAmountModel.fromJson(Map<String, dynamic> json) {
    return ReceivedAmountModel(
      transactionDetailsID: json['transactionDetailsID'],
      voucherTypeID: json['voucherTypeID'],
      masterID: json['masterID'],
      ledgerID: json['ledgerID'],
      ledgerName: json['ledgerName'],
      drAmt: json['drAmt'].toDouble(),
      crAmt: json['crAmt'].toDouble(),
      userID: json['userID'],
      entryDate: (json['entryDate']),
      updatedBy: json['updatedBy'],
      updatedDate: (json['updatedDate']),
      extra1: json['extra1'],
      extra2: json['extra2'],
      flag: json['flag'],
      drCr: json['drCr'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionDetailsID': transactionDetailsID,
      'voucherTypeID': voucherTypeID,
      'masterID': masterID,
      'ledgerID': ledgerID,
      'ledgerName': ledgerName,
      'drAmt': drAmt,
      'crAmt': crAmt,
      'userID': userID,
      'entryDate': entryDate,
      'updatedBy': updatedBy,
      'updatedDate': updatedDate,
      'extra1': extra1,
      'extra2': extra2,
      'flag': flag,
      'drCr': drCr,
    };
  }


}


class CustomerInfoModel {
  int salesInfoID;
  int salesMasterID;
  int customerID;
  String customerName;
  String customerAddress;
  String mailingName;
  String pan;
  String email;
  int creditPeriod;
  String receiptMode;
  String dispatchedDate;
  String dispatchedThrough;
  String destination;
  String carrierAgent;
  String vehicleNo;
  String orginalInvoiceNo;
  String orginalInvoiceDate;
  String orderChallanNo;
  String lR_RRNO_BillOfLanding;
  String remarks;
  int userID;
  String entryDate;
  int updatedBy;
  String updatedDate;
  String extra1;
  String extra2;
  int flag;

  CustomerInfoModel({
    required this.salesInfoID,
    required this.salesMasterID,
    required this.customerID,
    required this.customerName,
    required this.customerAddress,
    required this.mailingName,
    required this.pan,
    required this.email,
    required this.creditPeriod,
    required this.receiptMode,
    required this.dispatchedDate,
    required this.dispatchedThrough,
    required this.destination,
    required this.carrierAgent,
    required this.vehicleNo,
    required this.orginalInvoiceNo,
    required this.orginalInvoiceDate,
    required this.orderChallanNo,
    required this.lR_RRNO_BillOfLanding,
    required this.remarks,
    required this.userID,
    required this.entryDate,
    required this.updatedBy,
    required this.updatedDate,
    required this.extra1,
    required this.extra2,
    required this.flag,
  });

  factory CustomerInfoModel.fromJson(Map<String, dynamic> json) {
    return CustomerInfoModel(
      salesInfoID: json['salesInfoID'],
      salesMasterID: json['salesMasterID'],
      customerID: json['customerID'],
      customerName: json['customerName'],
      customerAddress: json['customerAddress'],
      mailingName: json['mailingName'],
      pan: json['pan'],
      email: json['email'],
      creditPeriod: json['creditPeriod'],
      receiptMode: json['receiptMode'],
      dispatchedDate: (json['dispatchedDate']),
      dispatchedThrough: json['dispatchedThrough'],
      destination: json['destination'],
      carrierAgent: json['carrierAgent'],
      vehicleNo: json['vehicleNo'],
      orginalInvoiceNo: json['orginalInvoiceNo'],
      orginalInvoiceDate: (json['orginalInvoiceDate']),
      orderChallanNo: json['orderChallanNo'],
      lR_RRNO_BillOfLanding: json['lR_RRNO_BillOfLanding'],
      remarks: json['remarks'],
      userID: json['userID'],
      entryDate: (json['entryDate']),
      updatedBy: json['updatedBy'],
      updatedDate: (json['updatedDate']),
      extra1: json['extra1'],
      extra2: json['extra2'],
      flag: json['flag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'salesInfoID': salesInfoID,
      'salesMasterID': salesMasterID,
      'customerID': customerID,
      'customerName': customerName,
      'customerAddress': customerAddress,
      'mailingName': mailingName,
      'pan': pan,
      'email': email,
      'creditPeriod': creditPeriod,
      'receiptMode': receiptMode,
      'dispatchedDate': dispatchedDate,
      'dispatchedThrough': dispatchedThrough,
      'destination': destination,
      'carrierAgent': carrierAgent,
      'vehicleNo': vehicleNo,
      'orginalInvoiceNo': orginalInvoiceNo,
      'orginalInvoiceDate': orginalInvoiceDate,
      'orderChallanNo': orderChallanNo,
      'lR_RRNO_BillOfLanding': lR_RRNO_BillOfLanding,
      'remarks': remarks,
      'userID': userID,
      'entryDate': entryDate,
      'updatedBy': updatedBy,
      'updatedDate': updatedDate,
      'extra1': extra1,
      'extra2': extra2,
      'flag': flag,
    };
  }
}


class ReceiptPOSModel {
  Item1 item1;
  Item2 item2;
  List<Item3> item3;

  ReceiptPOSModel({
    required this.item1,
    required this.item2,
    required this.item3,
  });

  factory ReceiptPOSModel.fromJson(Map<String, dynamic> json) {
    return ReceiptPOSModel(
      item1: Item1.fromJson(json['item1']),
      item2: Item2.fromJson(json['item2']),
      item3: List<Item3>.from(json['item3'].map((x) => Item3.fromJson(x))),
    );
  }
}

class Item1 {
  int salesMasterID;
  String billDate;
  String printDate;
  String companyImageUrl;
  String companyName;
  String companyAddress;
  String companyPhone;
  String buyersPanVat;
  String vendorName;
  String vendorsPan;
  String voucherNo;
  double totalAmount;
  double itemDiscount;
  double billDiscountAmt;
  double otherTaxAmt;
  double chargeAmt;
  int additionalCostAmt;
  int effectiveAdditionalCostAmt;
  double billAdjustment;
  double taxableAmount;
  double nonTaxableAmount;
  double vatAmount;
  double grandTotalAmount;
  String salesInvoice;
  String customerSignatureusername;
  String narration;
  String vendorAddress;
  dynamic amountinWord;
  int transactionMode;
  dynamic paymentMode;
  String companyReg;
  int customerID;
  int userID;

  Item1({
    required this.salesMasterID,
    required this.billDate,
    required this.printDate,
    required this.companyImageUrl,
    required this.companyName,
    required this.companyAddress,
    required this.companyPhone,
    required this.buyersPanVat,
    required this.vendorName,
    required this.vendorsPan,
    required this.voucherNo,
    required this.totalAmount,
    required this.itemDiscount,
    required this.billDiscountAmt,
    required this.otherTaxAmt,
    required this.chargeAmt,
    required this.additionalCostAmt,
    required this.effectiveAdditionalCostAmt,
    required this.billAdjustment,
    required this.taxableAmount,
    required this.nonTaxableAmount,
    required this.vatAmount,
    required this.grandTotalAmount,
    required this.salesInvoice,
    required this.customerSignatureusername,
    required this.narration,
    required this.vendorAddress,
    required this.amountinWord,
    required this.transactionMode,
    required this.paymentMode,
    required this.companyReg,
    required this.customerID,
    required this.userID,
  });

  factory Item1.fromJson(Map<String, dynamic> json) {
    return Item1(
      salesMasterID: json['salesMasterID'],
      billDate: json['billDate'],
      printDate: json['printDate'],
      companyImageUrl: json['companyImageUrl'],
      companyName: json['companyName'],
      companyAddress: json['companyAddress'],
      companyPhone: json['companyPhone'],
      buyersPanVat: json['buyersPanVat'],
      vendorName: json['vendorName'],
      vendorsPan: json['vendorsPan'],
      voucherNo: json['voucherNo'],
      totalAmount: json['totalAmount'],
      itemDiscount: json['itemDiscount'],
      billDiscountAmt: json['billDiscountAmt'],
      otherTaxAmt: json['otherTaxAmt'],
      chargeAmt: json['chargeAmt'],
      additionalCostAmt: json['additionalCostAmt'],
      effectiveAdditionalCostAmt: json['effectiveAdditionalCostAmt'],
      billAdjustment: json['billAdjustment'],
      taxableAmount: json['taxableAmount'],
      nonTaxableAmount: json['nonTaxableAmount'],
      vatAmount: json['vatAmount'],
      grandTotalAmount: json['grandTotalAmount'],
      salesInvoice: json['salesInvoice'],
      customerSignatureusername: json['customerSignatureusername'],
      narration: json['narration'],
      vendorAddress: json['vendorAddress'],
      amountinWord: json['amountinWord'],
      transactionMode: json['transactionMode'],
      paymentMode: json['paymentMode'],
      companyReg: json['companyReg'],
      customerID: json['customerID'],
      userID: json['userID'],
    );
  }
}

class Item2 {
  int printFormatID;
  String category;
  String formatName;
  String reportHTML;
  String pageHTML;
  String detailHTML;
  bool isDefault;
  bool isActive;
  int updatedBy;
  String updateDate;
  String extra1;
  String extra2;
  int voucherTypeId;
  int totalDisplayRow;
  bool hasCompanyHeading;
  bool hasCompanyHeadingAllPage;

  Item2({
    required this.printFormatID,
    required this.category,
    required this.formatName,
    required this.reportHTML,
    required this.pageHTML,
    required this.detailHTML,
    required this.isDefault,
    required this.isActive,
    required this.updatedBy,
    required this.updateDate,
    required this.extra1,
    required this.extra2,
    required this.voucherTypeId,
    required this.totalDisplayRow,
    required this.hasCompanyHeading,
    required this.hasCompanyHeadingAllPage,
  });

  factory Item2.fromJson(Map<String, dynamic> json) {
    return Item2(
      printFormatID: json['printFormatID'],
      category: json['category'],
      formatName: json['formatName'],
      reportHTML: json['reportHTML'],
      pageHTML: json['pageHTML'],
      detailHTML: json['detailHTML'],
      isDefault: json['isDefault'],
      isActive: json['isActive'],
      updatedBy: json['updatedBy'],
      updateDate: json['updateDate'],
      extra1: json['extra1'],
      extra2: json['extra2'],
      voucherTypeId: json['voucherTypeId'],
      totalDisplayRow: json['totalDisplayRow'],
      hasCompanyHeading: json['hasCompanyHeading'],
      hasCompanyHeadingAllPage: json['hasCompanyHeadingAllPage'],
    );
  }
}

class Item3 {
  int sno;
  int productID;
  String particulars;
  double qty;
  double rate;
  double discount;
  double billDiscountAmt;
  double taxableAmt;
  double nonTaxableAmt;
  double vatAmt;
  double otherTaxAmt;
  double chargeAmt;
  int effectiveAdditionalCostAmt;
  double totalAmount;
  int salesMasterId;

  Item3({
    required this.sno,
    required this.productID,
    required this.particulars,
    required this.qty,
    required this.rate,
    required this.discount,
    required this.billDiscountAmt,
    required this.taxableAmt,
    required this.nonTaxableAmt,
    required this.vatAmt,
    required this.otherTaxAmt,
    required this.chargeAmt,
    required this.effectiveAdditionalCostAmt,
    required this.totalAmount,
    required this.salesMasterId,
  });

  factory Item3.fromJson(Map<String, dynamic> json) {
    return Item3(
      sno: json['sno'],
      productID: json['productID'],
      particulars: json['particulars'],
      qty: json['qty'],
      rate: json['rate'],
      discount: json['discount'],
      billDiscountAmt: json['billDiscountAmt'],
      taxableAmt: json['taxableAmt'],
      nonTaxableAmt: json['nonTaxableAmt'],
      vatAmt: json['vatAmt'],
      otherTaxAmt: json['otherTaxAmt'],
      chargeAmt: json['chargeAmt'],
      effectiveAdditionalCostAmt: json['effectiveAdditionalCostAmt'],
      totalAmount: json['totalAmount'],
      salesMasterId: json['salesMasterId'],
    );
  }
}
