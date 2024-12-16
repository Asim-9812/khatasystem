class GetListModel {
  MainInfoModel? mainInfoModel;
  String? refName;
  String? listNameId;
  String? conditionalValues;
  String? isSingleList;
  String? singleListNameStr;

  GetListModel(
      {this.mainInfoModel,
        this.refName,
        this.listNameId,
        this.conditionalValues,
        this.isSingleList,
        this.singleListNameStr});

  GetListModel.fromJson(Map<String, dynamic> json) {
    mainInfoModel = json['mainInfoModel'] != null
        ? MainInfoModel.fromJson(json['mainInfoModel'])
        : null;
    refName = json['refName'];
    listNameId = json['listNameId'];
    conditionalValues = json['conditionalValues'];
    isSingleList = json['isSingleList'];
    singleListNameStr = json['singleListNameStr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (mainInfoModel != null) {
      data['mainInfoModel'] = mainInfoModel!.toJson();
    }
    data['refName'] = refName;
    data['listNameId'] = listNameId;
    data['conditionalValues'] = conditionalValues;
    data['isSingleList'] = isSingleList;
    data['singleListNameStr'] = singleListNameStr;
    return data;
  }
}
class GetListModel2 {
  MainInfoModel2? mainInfoModel;
  String? refName;
  String? listNameId;
  String? conditionalValues;
  String? isSingleList;
  String? singleListNameStr;

  GetListModel2(
      {this.mainInfoModel,
        this.refName,
        this.listNameId,
        this.conditionalValues,
        this.isSingleList,
        this.singleListNameStr});

  GetListModel2.fromJson(Map<String, dynamic> json) {
    mainInfoModel = json['mainInfoModel'] != null
        ? MainInfoModel2.fromJson(json['mainInfoModel'])
        : null;
    refName = json['refName'];
    listNameId = json['listNameId'];
    conditionalValues = json['conditionalValues'];
    isSingleList = json['isSingleList'];
    singleListNameStr = json['singleListNameStr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (mainInfoModel != null) {
      data['mainInfoModel'] = mainInfoModel!.toJson();
    }
    data['refName'] = refName;
    data['listNameId'] = listNameId;
    data['conditionalValues'] = conditionalValues;
    data['isSingleList'] = isSingleList;
    data['singleListNameStr'] = singleListNameStr;
    return data;
  }
}

class MainInfoModel {
  int? userId;
  int? fiscalID;
  int? branchDepartmentId;
  int? branchId;
  bool? isEngOrNepaliDate;
  bool? isMenuVerified;
  int? filterId;
  int? refId;
  int? mainId;
  String? dbName;
  String? decimalPlace;
  String? startDate;
  String? endDate;
  String? strId;
  String? sessionId;
  String? fromDate;
  String? toDate;

  MainInfoModel({
    this.userId,
    this.fiscalID,
    this.branchDepartmentId,
    this.branchId,
    this.isEngOrNepaliDate,
    this.isMenuVerified,
    this.filterId,
    this.refId,
    this.mainId,
    this.dbName,
    this.decimalPlace,
    this.startDate,
    this.endDate,
    this.strId,
    this.sessionId,
    this.fromDate,
    this.toDate,
  });

  MainInfoModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    fiscalID = json['fiscalID'];
    branchDepartmentId = json['branchDepartmentId'];
    branchId = json['branchId'];
    isEngOrNepaliDate = json['isEngOrNepaliDate'];
    isMenuVerified = json['isMenuVerified'];
    filterId = json['filterId'];
    refId = json['refId'];
    mainId = json['mainId'];
    dbName = json['dbName'];
    decimalPlace = json['decimalPlace'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    strId = json['strId'];
    sessionId = json['sessionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['fiscalID'] = fiscalID;
    data['branchDepartmentId'] = branchDepartmentId;
    data['branchId'] = branchId;
    data['isEngOrNepaliDate'] = isEngOrNepaliDate;
    data['isMenuVerified'] = isMenuVerified;
    data['filterId'] = filterId;
    data['refId'] = refId;
    data['mainId'] = mainId;
    data['dbName'] = dbName;
    data['decimalPlace'] = decimalPlace;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['strId'] = strId;
    data['sessionId'] = sessionId;
    data['fromDate'] = fromDate;
    data['toDate'] = toDate;
    return data;
  }
}

class MainInfoModel2 {
  int? userId;
  int? fiscalID;
  int? branchDepartmentId;
  int? branchId;
  bool? isEngOrNepaliDate;
  bool? isMenuVerified;
  int? filterId;
  int? refId;
  int? mainId;
  String? dbName;
  String? decimalPlace;
  String? startDate;
  String? endDate;
  String? strId;
  String? sessionId;
  int? id;
  String? searchText;

  MainInfoModel2({
    this.userId,
    this.fiscalID,
    this.branchDepartmentId,
    this.branchId,
    this.isEngOrNepaliDate,
    this.isMenuVerified,
    this.filterId,
    this.refId,
    this.mainId,
    this.dbName,
    this.decimalPlace,
    this.startDate,
    this.endDate,
    this.strId,
    this.sessionId,
    this.id,
    this.searchText
  });

  MainInfoModel2.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    fiscalID = json['fiscalID'];
    branchDepartmentId = json['branchDepartmentId'];
    branchId = json['branchId'];
    isEngOrNepaliDate = json['isEngOrNepaliDate'];
    isMenuVerified = json['isMenuVerified'];
    filterId = json['filterId'];
    refId = json['refId'];
    mainId = json['mainId'];
    dbName = json['dbName'];
    decimalPlace = json['decimalPlace'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    strId = json['strId'];
    sessionId = json['sessionId'];
    id = json['id'];
    searchText=json['searchtext'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['fiscalID'] = fiscalID;
    data['branchDepartmentId'] = branchDepartmentId;
    data['branchId'] = branchId;
    data['isEngOrNepaliDate'] = isEngOrNepaliDate;
    data['isMenuVerified'] = isMenuVerified;
    data['filterId'] = filterId;
    data['refId'] = refId;
    data['mainId'] = mainId;
    data['dbName'] = dbName;
    data['decimalPlace'] = decimalPlace;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['strId'] = strId;
    data['sessionId'] = sessionId;
    data['id'] = id;
    data['searchtext']=searchText;
    return data;
  }
}



class GetLedgerListModel {
  MainInfoModel2? mainInfoModel;
  int? branchId;
  List? accountGroupId;

  GetLedgerListModel(
      {this.mainInfoModel,
        this.branchId,
        this.accountGroupId,});

  GetLedgerListModel.fromJson(Map<String, dynamic> json) {
    mainInfoModel = json['mainInfo'] != null
        ? MainInfoModel2.fromJson(json['mainInfo'])
        : null;
    branchId = json['branchid'];
    accountGroupId = json['accountgroupid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (mainInfoModel != null) {
      data['mainInfo'] = mainInfoModel!.toJson();
    }
    data['branchid'] = branchId;
    data['accountgroupid'] = accountGroupId;
    return data;
  }
}