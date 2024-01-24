




import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khata_app/core/api.dart';
import 'package:khata_app/core/api_exception.dart';
import 'package:khata_app/model/list%20model/get_list_model.dart';
import 'package:khata_app/model/list%20model/list_model.dart';

import '../../../../../main.dart';
import '../../../../dashboard/presentation/home_screen.dart';


final voucherListProvider = FutureProvider.family.autoDispose((ref, GetListModel model) => VoucherListProvider().getDropDownList(model));


class VoucherListProvider{
  Future<List<Map<dynamic, dynamic>>> getDropDownList(GetListModel getListModel) async {
    final dio = Dio();
    var result = sessionBox.get('userReturn');
    var res = jsonDecode(result);
    String userToken = '${res['ptoken']}';
    dio.options.headers["Authorization"] = "Bearer ${userToken}";

    final jsonData = jsonEncode(getListModel.toJson());
    List<Map<dynamic, dynamic>> myList = [];
    try{
      final response = await dio.post(Api.getVoucherList, data: {
        "fiscalId": getListModel.mainInfoModel!.fiscalID,
        "sessionBranch": getListModel.mainInfoModel!.branchId
      });

      if(response.statusCode == 200){
        final responseList = [response.data[0] as List<dynamic>,response.data[1] as List<dynamic>,response.data[2] as List<dynamic>,response.data[3] as List<dynamic>];

        var group = {};
        var ledger = {};
        var branch = {};
        var voucherType = {};

        for(final e in responseList[1]){
          group[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        for(final e in responseList[2]){
          ledger[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        for(final e in responseList[0]){
          branch[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        for(final e in responseList[3]){
          voucherType[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        myList = [group, ledger, branch, voucherType];
      }else{
      }
      return myList;
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
  }
}