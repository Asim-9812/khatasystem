import 'package:khatasystem/model/filter%20model/data_filter_model.dart';
import 'package:khatasystem/model/list%20model/get_list_model.dart';

class FilterAnyModel{
  DataFilterModel? dataFilterModel;
  MainInfoModel? mainInfoModel;


  FilterAnyModel({this.dataFilterModel, this.mainInfoModel});

  FilterAnyModel.fromJson(Map<String, dynamic> json){
    dataFilterModel = json["dataFilterModel"] != null ? DataFilterModel.fromJson(json["dataFilterModel"]) : null;
    mainInfoModel = json["mainInfoModel"] != null ? MainInfoModel.fromJson(json["mainInfoModel"]) : null;

  }


  Map<String, dynamic> toJson(){
    final Map<String, dynamic>  data = <String, dynamic>{};
    if (mainInfoModel != null) {
      data['mainInfoModel'] = mainInfoModel!.toJson();
    }
    if (dataFilterModel != null) {
      data['dataFilterModel'] = dataFilterModel!.toJson();
    }

     return data;
  }



}

class FilterAnyModel2{
  DataFilterModel? dataFilterModel;
  MainInfoModel2? mainInfoModel;


  FilterAnyModel2({this.dataFilterModel, this.mainInfoModel});

  FilterAnyModel2.fromJson(Map<String, dynamic> json){
    dataFilterModel = json["dataFilterModel"] != null ? DataFilterModel.fromJson(json["dataFilterModel"]) : null;
    mainInfoModel = json["mainInfoModel"] != null ? MainInfoModel2.fromJson(json["mainInfoModel"]) : null;

  }


  Map<String, dynamic> toJson(){
    final Map<String, dynamic>  data = <String, dynamic>{};
    if (mainInfoModel != null) {
      data['mainInfoModel'] = mainInfoModel!.toJson();
    }
    if (dataFilterModel != null) {
      data['dataFilterModel'] = dataFilterModel!.toJson();
    }

    return data;
  }



}