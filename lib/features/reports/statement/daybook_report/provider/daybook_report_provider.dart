
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khatasystem/core/api.dart';

import 'package:khatasystem/model/filter%20model/filter_any_model.dart';

import '../../../../../main.dart';
import '../../../../../model/list model/get_list_model.dart';
import '../../../../../model/list model/list_model.dart';
import '../../../../dashboard/presentation/home_screen.dart';



final dayBookProvider = StateNotifierProvider<DayBookReportProvider, AsyncValue<List<dynamic>>>((ref) =>DayBookReportProvider());
final dayBookListProvider = FutureProvider.family.autoDispose((ref, GetListModel2 model) => DayBookReportProvider().getDayBookList(model));


class DayBookReportProvider extends StateNotifier<AsyncValue<List<dynamic>>>{
  DayBookReportProvider() : super(const AsyncValue.data([]));

  Future<void> fetchTableData(FilterAnyModel2 filterModel) async{
    final dio = Dio();
    
    dio.options.headers["Authorization"] = "Bearer ${userToken}";

    try{
      final jsonData = jsonEncode(filterModel.toJson());

      // print(jsonData);

      final response = await dio.post(Api.getTable, data: jsonData);
      if(response.statusCode == 200){
        print(response.data);
        final result = response.data as List<dynamic>;
        state = AsyncValue.data(result);
      }
    }on DioException catch(err){
      throw err;
    }
  }

  Future<List<Map<dynamic, dynamic>>> getDayBookList(GetListModel2 getListModel) async {
    final dio = Dio();
    
    dio.options.headers["Authorization"] = "Bearer ${userToken}";

    final jsonData = jsonEncode(getListModel.toJson());
    // print(jsonData);
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
          voucher[ListModel.fromJson(e).text?? 'N/A'] = ListModel.fromJson(e).value!;
        }
        for(final e in responseList[2]){
          ledger[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }

        myList = [branch,voucher, ledger,date];


      }
      else{
      }

      return myList;
    }on DioException catch(err){
      throw err;
    }
  }




}



final dayBookViewProvider = FutureProvider.family((ref, FilterAnyModel filterModel) => DayBookViewPro().getTableData(filterModel));

class DayBookViewPro {
  Future<List<dynamic>> getTableData(FilterAnyModel filterModel) async{
    final dio = Dio();

    dio.options.headers["Authorization"] = "Bearer ${userToken}";
    try{
      final jsonData = jsonEncode(filterModel.toJson());
      print(filterModel.toJson()['mainInfoModel']);

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

