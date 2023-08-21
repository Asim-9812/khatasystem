


import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khata_app/core/api.dart';
import 'package:khata_app/core/api_exception.dart';
import 'package:khata_app/model/filter%20model/filter_any_model.dart';

final balanceSheetReportProvider = StateNotifierProvider<BalanceSheetReportProvider, AsyncValue<List<dynamic>>>((ref) => BalanceSheetReportProvider());

class BalanceSheetReportProvider extends StateNotifier<AsyncValue<List<dynamic>>>{
  BalanceSheetReportProvider() : super(const AsyncValue.data([]));

  Future<void> getTableData(FilterAnyModel filterModel) async{
    final dio = Dio();
    try{
      final jsonData = jsonEncode(filterModel.toJson());
      final response = await dio.post(Api.getTable, data: jsonData);
      if(response.statusCode == 200){
        final result = response.data as List<dynamic>;
        state = AsyncValue.data(result);
      }else{
        print(response.statusCode);
      }
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
  }
}