
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khata_app/core/api.dart';
import 'package:khata_app/core/api_exception.dart';
import 'package:khata_app/model/filter%20model/filter_any_model.dart';

import '../../../../../model/list model/get_list_model.dart';
import '../../../../../model/list model/list_model.dart';



final bankCashProvider = StateNotifierProvider<BankCashReport, AsyncValue<List<dynamic>>>((ref) =>BankCashReport());
final bankCashProvider2 = StateNotifierProvider<BankCashReport, AsyncValue<List<dynamic>>>((ref) =>BankCashReport());
final bankCashListProvider = FutureProvider.family.autoDispose((ref, GetListModel model) => BankCashReport().getBankCashList(model));
final bankCashLedgerListProvider = FutureProvider.family.autoDispose((ref, GetLedgerListModel model) => BankCashReport().getBankCashLedgerList(model));


class BankCashReport extends StateNotifier<AsyncValue<List<dynamic>>>{
  BankCashReport() : super(const AsyncValue.data([]));

  Future<void> fetchTableData(FilterAnyModel2 filterModel) async{
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




  Future<List<Map<dynamic, dynamic>>> getBankCashList(GetListModel getListModel) async {
    final dio = Dio();
    final jsonData = jsonEncode(getListModel.toJson());
    List<Map<dynamic, dynamic>> myList = [];
    try{
      final response = await dio.post(Api.getSubList, data: jsonData);

      if(response.statusCode == 200){
        final responseList = response.data as List<dynamic>;
        var branch = {};
        var group = {};
        var ledger = {};
        var date = responseList[3];

        for(final e in responseList[0]){
          branch[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        for(final e in responseList[1]){
          group[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        for(final e in responseList[2]){
          ledger[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        myList = [branch,group, ledger,date];
      }else{
      }

      return myList;
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
  }



  Future<List<dynamic>> getBankCashLedgerList(GetLedgerListModel getListModel) async {
    final dio = Dio();



    if(getListModel.accountGroupId?.length == 0){
      throw 'Please select a group';
    }

    else{

      try{
        final jsonData = jsonEncode(getListModel.toJson());
        final response = await dio.post(Api.getLedgerList, data: jsonData);


        if(response.statusCode == 200){
          final responseList = response.data as List<dynamic>;
          return responseList;
        }else{
          throw Exception('Something went wrong');
        }


      }on DioError catch(err){

        throw DioException().getDioError(err);
      }
    }






  }



}




final bankCashIndividualProvider = FutureProvider.family((ref, FilterAnyModel2 filterModel) => BankCashIndividualProvider().getTableData(filterModel));

class BankCashIndividualProvider {
  Future<List<dynamic>> getTableData(FilterAnyModel2 filterModel) async{
    final dio = Dio();
    try{
      final jsonData = jsonEncode(filterModel.toJson());
  ;
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

