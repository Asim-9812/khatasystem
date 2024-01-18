


class ProductModel {
  int? qty;
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
      qty: json['qty'] as int?,
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
      mrp: json['mrp'] as double?,
      salesRate: json['salesRate'] as double?,
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


