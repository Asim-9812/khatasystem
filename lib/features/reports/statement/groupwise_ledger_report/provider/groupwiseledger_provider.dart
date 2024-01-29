
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khata_app/core/api.dart';
import 'package:khata_app/core/api_exception.dart';
import 'package:khata_app/model/filter%20model/filter_any_model.dart';

import '../../../../../main.dart';
import '../../../../dashboard/presentation/home_screen.dart';


final groupWiseLedgerProvider = StateNotifierProvider<GroupWiseLedgerReportProvider, AsyncValue<List<dynamic>>>((ref) =>GroupWiseLedgerReportProvider());

class GroupWiseLedgerReportProvider extends StateNotifier<AsyncValue<List<dynamic>>>{
  GroupWiseLedgerReportProvider() : super(const AsyncValue.data([]));

  Future<void> getTableValues(FilterAnyModel filterModel) async{
    final dio = Dio();
    
    dio.options.headers["Authorization"] = "Bearer ${userToken}";

    try{
      final jsonData = jsonEncode(filterModel.toJson());
      print(jsonData);
      final response = await dio.post(Api.getTable, data: jsonData);
      if(response.statusCode == 200){
        final result = response.data as List<dynamic>;

        state = AsyncValue.data(result);

      }
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
  }

}



final groupWiseDetailProvider = StateNotifierProvider<GroupWiseDetailReportProvider, AsyncValue<List<dynamic>>>((ref) =>GroupWiseDetailReportProvider());

class GroupWiseDetailReportProvider extends StateNotifier<AsyncValue<List<dynamic>>>{
  GroupWiseDetailReportProvider() : super(const AsyncValue.data([]));

  Future<void> getTableValues(FilterAnyModel2 filterModel) async{
    final dio = Dio();
    
    dio.options.headers["Authorization"] = "Bearer ${userToken}";

    try{
      final jsonData = jsonEncode(filterModel.toJson());

      final response = await dio.post(Api.getTable, data: jsonData);
      if(response.statusCode == 200){
        final result = response.data as List<dynamic>;

        state = AsyncValue.data(result);

      }
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
  }

}

final ledgerDetailGroupWiseProvider = StateNotifierProvider<LedgerDetailGroupWiseProvider, AsyncValue<List<dynamic>>>((ref) =>LedgerDetailGroupWiseProvider());

class LedgerDetailGroupWiseProvider extends StateNotifier<AsyncValue<List<dynamic>>>{
  LedgerDetailGroupWiseProvider() : super(const AsyncValue.data([]));

  Future<void> getTableValues(FilterAnyModel2 filterModel) async{
    final dio = Dio();
    
    dio.options.headers["Authorization"] = "Bearer ${userToken}";

    try{
      final jsonData = jsonEncode(filterModel.toJson());

      final response = await dio.post(Api.getTable, data: jsonData);
      if(response.statusCode == 200){
        final result = response.data as List<dynamic>;


        state = AsyncValue.data(result);

      }
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
  }

}



final ledgerDetailIndividualProvider = FutureProvider.family((ref, FilterAnyModel2 filterModel) => LedgerDetailIndividualProvider().getTableData(filterModel));

class LedgerDetailIndividualProvider {
  Future<List<dynamic>> getTableData(FilterAnyModel2 filterModel) async{
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
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
  }
}

