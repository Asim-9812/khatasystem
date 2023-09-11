
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khata_app/core/api.dart';
import 'package:khata_app/core/api_exception.dart';
import 'package:khata_app/model/filter%20model/filter_any_model.dart';


final groupWiseLedgerProvider = StateNotifierProvider<GroupWiseLedgerReportProvider, AsyncValue<List<dynamic>>>((ref) =>GroupWiseLedgerReportProvider());

class GroupWiseLedgerReportProvider extends StateNotifier<AsyncValue<List<dynamic>>>{
  GroupWiseLedgerReportProvider() : super(const AsyncValue.data([]));

  Future<void> getTableValues(FilterAnyModel filterModel) async{
    final dio = Dio();
    try{
      final jsonData = jsonEncode(filterModel.toJson());
      final response = await dio.post(Api.getTable, data: jsonData);
      if(response.statusCode == 200){
        final result = response.data as List<dynamic>;
        print(result);
        state = AsyncValue.data(result);

      }
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
  }
}