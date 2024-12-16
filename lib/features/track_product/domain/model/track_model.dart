
class TrackBranchModel {
  int branchId;
  String branchCode;
  String branchName;
  dynamic flag;

  TrackBranchModel({
    required this.branchId,
    required this.branchCode,
    required this.branchName,
    this.flag,
  });

  factory TrackBranchModel.fromJson(Map<String, dynamic> json) {
    return TrackBranchModel(
      branchId: json['branchId'],
      branchCode: json['branchCode'],
      branchName: json['branchName'],
      flag: json['flag'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['branchId'] = this.branchId;
    data['branchCode'] = this.branchCode;
    data['branchName'] = this.branchName;
    data['flag'] = this.flag;
    return data;
  }
}





class TokenModel {
  int branchId;
  int trackingId;
  String tokenNumber;
  dynamic flag;

  TokenModel({
    required this.branchId,
    required this.trackingId,
    required this.tokenNumber,
    this.flag,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      branchId: json['branchId'],
      trackingId: json['trackingId'],
      tokenNumber: json['tokenNumber'],
      flag: json['flag'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['branchId'] = this.branchId;
    data['trackingId'] = this.trackingId;
    data['tokenNumber'] = this.tokenNumber;
    data['flag'] = this.flag;
    return data;
  }
}



class TrackModel {
  int divisionId;
  String batchName;
  List<Division> division;

  TrackModel({
    required this.divisionId,
    required this.batchName,
    required this.division,
  });

  factory TrackModel.fromJson(Map<String, dynamic> json) {
    var list = json['division'] as List;
    List<Division> divisionList = list.map((division) => Division.fromJson(division)).toList();

    return TrackModel(
      divisionId: json['divisionId'],
      batchName: json['batchName'],
      division: divisionList,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['divisionId'] = this.divisionId;
    data['batchName'] = this.batchName;
    data['division'] = this.division.map((division) => division.toJson()).toList();
    return data;
  }
}

class Division {
  String divisionName;
  int status;
  String statusClass;
  int trackingDetailsId;
  String entryDate;
  String estimatedTime;
  String verifiedDate;
  String verifiedBy;

  Division({
    required this.divisionName,
    required this.status,
    required this.statusClass,
    required this.trackingDetailsId,
    required this.entryDate,
    required this.estimatedTime,
    required this.verifiedDate,
    required this.verifiedBy,
  });

  factory Division.fromJson(Map<String, dynamic> json) {
    return Division(
      divisionName: json['divisionName'],
      status: json['status'],
      statusClass: json['statusClass'],
      trackingDetailsId: json['trackingDetailsId'],
      entryDate: json['entryDate'],
      estimatedTime: json['estimatedTime'],
      verifiedDate: json['verifiedDate'],
      verifiedBy: json['verifiedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['divisionName'] = this.divisionName;
    data['status'] = this.status;
    data['statusClass'] = this.statusClass;
    data['trackingDetailsId'] = this.trackingDetailsId;
    data['entryDate'] = this.entryDate;
    data['estimatedTime'] = this.estimatedTime;
    data['verifiedDate'] = this.verifiedDate;
    data['verifiedBy'] = this.verifiedBy;
    return data;
  }
}