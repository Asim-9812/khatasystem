class SalesBookBrief {
  int? totalRecords;
  int? currentPageNumber;
  int? pageSize;
  int? totalPages;
  bool? hasNextPage;
  bool? hasPreviousPage;
  int? totalfilterRecord;
  int? pageStartIndex;
  List<SalesData>? data;

  SalesBookBrief({
    this.totalRecords,
    this.currentPageNumber,
    this.pageSize,
    this.totalPages,
    this.hasNextPage,
    this.hasPreviousPage,
    this.totalfilterRecord,
    this.pageStartIndex,
    this.data,
  });

  factory SalesBookBrief.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List?;
    List<SalesData>? dataList = list?.map((i) => SalesData.fromJson(i)).toList();
    return SalesBookBrief(
      totalRecords: json['totalRecords'],
      currentPageNumber: json['currentPageNumber'],
      pageSize: json['pageSize'],
      totalPages: json['totalPages'],
      hasNextPage: json['hasNextPage'],
      hasPreviousPage: json['hasPreviousPage'],
      totalfilterRecord: json['totalfilterRecord'],
      pageStartIndex: json['pageStartIndex'],
      data: dataList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalRecords': totalRecords,
      'currentPageNumber': currentPageNumber,
      'pageSize': pageSize,
      'totalPages': totalPages,
      'hasNextPage': hasNextPage,
      'hasPreviousPage': hasPreviousPage,
      'totalfilterRecord': totalfilterRecord,
      'pageStartIndex': pageStartIndex,
      'data': data?.map((v) => v.toJson()).toList(),
    };
  }
}

class CompanyInfo {
  String? companyPanVat;
  String? companyName;
  String? gridFor;

  CompanyInfo({
    this.companyPanVat,
    this.companyName,
    this.gridFor,
  });

  factory CompanyInfo.fromJson(Map<String, dynamic> json) {
    return CompanyInfo(
      companyPanVat: json['companyPanVat'],
      companyName: json['companyName'],
      gridFor: json['gridFor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyPanVat': companyPanVat,
      'companyName': companyName,
      'gridFor': gridFor,
    };
  }
}

class SalesData {
  int? salesMasterId;
  int? salesDetailsId;
  int? purchaseMasterId;
  String? entryDate;
  String? voucherNo;
  String? customerName;
  String? pan;
  String? productName;
  String? unit;
  int? qty;
  double? grossAmt;
  double? nonTaxableAmt;
  double? taxableAmt;
  double? vatAmt;
  double? netAmt;
  String? extra1;
  String? extra2;

  SalesData({
    this.salesMasterId,
    this.salesDetailsId,
    this.purchaseMasterId,
    this.entryDate,
    this.voucherNo,
    this.customerName,
    this.pan,
    this.productName,
    this.unit,
    this.qty,
    this.grossAmt,
    this.nonTaxableAmt,
    this.taxableAmt,
    this.vatAmt,
    this.netAmt,
    this.extra1,
    this.extra2,
  });

  factory SalesData.fromJson(Map<String, dynamic> json) {
    return SalesData(
      salesMasterId: json['salesMasterId'],
      salesDetailsId: json['salesDetailsId'],
      purchaseMasterId: json['purchaseMasterId'],
      entryDate: json['entryDate'],
      voucherNo: json['voucherNo'],
      customerName: json['customerName'],
      pan: json['pan'],
      productName: json['productName'],
      unit: json['unit'],
      qty: json['qty'],
      grossAmt: (json['grossAmt'] as num?)?.toDouble(),
      nonTaxableAmt: (json['nonTaxableAmt'] as num?)?.toDouble(),
      taxableAmt: (json['taxableAmt'] as num?)?.toDouble(),
      vatAmt: (json['vatAmt'] as num?)?.toDouble(),
      netAmt: (json['netAmt'] as num?)?.toDouble(),
      extra1: json['extra1'],
      extra2: json['extra2'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'salesMasterId': salesMasterId,
      'salesDetailsId': salesDetailsId,
      'purchaseMasterId': purchaseMasterId,
      'entryDate': entryDate,
      'voucherNo': voucherNo,
      'customerName': customerName,
      'pan': pan,
      'productName': productName,
      'unit': unit,
      'qty': qty,
      'grossAmt': grossAmt,
      'nonTaxableAmt': nonTaxableAmt,
      'taxableAmt': taxableAmt,
      'vatAmt': vatAmt,
      'netAmt': netAmt,
      'extra1': extra1,
      'extra2': extra2,
    };
  }
}


class ReprintModel {
  String? code;
  String? message;
  String? result;
  int? printCount;
  bool? alreadyPrint;

  ReprintModel({
    this.code,
    this.message,
    this.result,
    this.printCount,
    this.alreadyPrint,
  });

  factory ReprintModel.fromJson(Map<String, dynamic> json) {
    return ReprintModel(
      code: json['code'],
      message: json['message'],
      result: json['result'],
      printCount: json['printCount'],
      alreadyPrint: json['alreadyPrint'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'result': result,
      'printCount': printCount,
      'alreadyPrint': alreadyPrint,
    };
  }
}
