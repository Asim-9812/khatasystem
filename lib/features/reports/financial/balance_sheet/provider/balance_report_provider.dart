


import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khatasystem/core/api.dart';

import 'package:khatasystem/model/filter%20model/filter_any_model.dart';

import '../../../../../main.dart';
import '../../../../dashboard/presentation/home_screen.dart';

final balanceSheetReportProvider = StateNotifierProvider<BalanceSheetReportProvider, AsyncValue<List<dynamic>>>((ref) => BalanceSheetReportProvider());

class BalanceSheetReportProvider extends StateNotifier<AsyncValue<List<dynamic>>>{
  BalanceSheetReportProvider() : super(const AsyncValue.data([]));

  Future<void> getTableData(FilterAnyModel2 filterModel) async{
    final dio = Dio();
    
    dio.options.headers["Authorization"] = "Bearer ${userToken}";

    try{
      final jsonData = jsonEncode(filterModel.toJson());
      print(jsonData);
      final response = await dio.post(Api.getTable, data: jsonData);
      if(response.statusCode == 200){
        final result = response.data as List<dynamic>;
        state = AsyncValue.data(result);
      }else{
        print(response.statusCode);
      }
    }on DioException catch(err){
      throw err;
    }
  }
}