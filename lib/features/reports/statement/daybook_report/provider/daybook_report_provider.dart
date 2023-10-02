
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khata_app/core/api.dart';
import 'package:khata_app/core/api_exception.dart';
import 'package:khata_app/model/filter%20model/filter_any_model.dart';

import '../../../../../model/list model/get_list_model.dart';
import '../../../../../model/list model/list_model.dart';



final dayBookProvider = StateNotifierProvider<DayBookReportProvider, AsyncValue<List<dynamic>>>((ref) =>DayBookReportProvider());
final dayBookListProvider = FutureProvider.family.autoDispose((ref, GetListModel model) => DayBookReportProvider().getDayBookList(model));


class DayBookReportProvider extends StateNotifier<AsyncValue<List<dynamic>>>{
  DayBookReportProvider() : super(const AsyncValue.data([]));

  Future<void> fetchTableData(FilterAnyModel filterModel) async{
    final dio = Dio();
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

  Future<List<Map<dynamic, dynamic>>> getDayBookList(GetListModel getListModel) async {
    final dio = Dio();
    final jsonData = jsonEncode(getListModel.toJson());
    List<Map<dynamic, dynamic>> myList = [];
    try{
      final response = await dio.post(Api.getSubList, data: jsonData);

      if(response.statusCode == 200){
        final responseList = response.data as List<dynamic>;
        var branch = {};
        var voucher = {};
        var ledger = {};
        var date = responseList[3];

        for(final e in responseList[0]){
          branch[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        for(final e in responseList[1]){
          voucher[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        for(final e in responseList[2]){
          ledger[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        myList = [branch,voucher, ledger,date];
      }else{
      }
      print(myList);
      return myList;
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
  }




}



final dayBookViewProvider = FutureProvider.family((ref, FilterAnyModel filterModel) => DayBookViewPro().getTableData(filterModel));

class DayBookViewPro {
  Future<List<dynamic>> getTableData(FilterAnyModel filterModel) async{
    final dio = Dio();
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

