
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khatasystem/core/api.dart';

import 'package:khatasystem/model/filter%20model/filter_any_model.dart';

import '../../../../../main.dart';
import '../../../../dashboard/presentation/home_screen.dart';


final voucherIndividualReportProvider = FutureProvider.family((ref, FilterAnyModel filterModel) => VoucherIndividualDataProvider().getTableData(filterModel));

class VoucherIndividualDataProvider {
  Future<List<dynamic>> getTableData(FilterAnyModel filterModel) async{
    final dio = Dio();
    
    dio.options.headers["Authorization"] = "Bearer ${userToken}";

    try{
      final jsonData = jsonEncode(filterModel.toJson());
      final response = await dio.post(Api.getTable, data: jsonData);
      if(response.statusCode == 200){
        final result = response.data as List<dynamic>;
        return result;
      }else{
        return [];
      }
    }on DioException catch(err){
      throw err;
    }
  }
}





