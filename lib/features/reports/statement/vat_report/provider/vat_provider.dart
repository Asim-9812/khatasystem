
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khata_app/core/api.dart';
import 'package:khata_app/core/api_exception.dart';
import 'package:khata_app/model/filter%20model/filter_any_model.dart';

import '../../../../../model/list model/get_list_model.dart';
import '../../../../../model/list model/list_model.dart';

final vatListProvider = FutureProvider.family.autoDispose((ref, GetListModel model) => VatListProvider().getVatReportList(model));
final aboveLakhProvider = FutureProvider.family.autoDispose((ref, GetListModel model) => VatListProvider().getAboveLakhList(model));
final monthlyProvider = FutureProvider.family.autoDispose((ref, GetListModel model) => VatListProvider().getMonthlyList(model));

final vatReportProvider = StateNotifierProvider<VatReportProvider, AsyncValue<List<dynamic>>>((ref) =>VatReportProvider());
final vatReportProvider2 = StateNotifierProvider<VatReportProvider2, AsyncValue<List<dynamic>>>((ref) =>VatReportProvider2());
final vatReportProvider3 = StateNotifierProvider<VatReportProvider3, AsyncValue<List<dynamic>>>((ref) =>VatReportProvider3());
final vatReportDetailProvider = StateNotifierProvider<VatReportDetailProvider, AsyncValue<List<dynamic>>>((ref) =>VatReportDetailProvider());

class VatReportDetailProvider extends StateNotifier<AsyncValue<List<dynamic>>>{
  VatReportDetailProvider() : super(const AsyncValue.data([]));


  Future<void> getTableValues2(FilterAnyModel2 filterModel) async{
    final dio = Dio();
    try{
      final jsonData = jsonEncode(filterModel.toJson());
      print(jsonData);
      final response = await dio.post(Api.getTable, data: jsonData);
      if(response.statusCode == 200){
        final result = response.data[0] as List<dynamic>;
        state = AsyncValue.data(result);
        print(result);

      }
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
  }
}
class VatReportProvider extends StateNotifier<AsyncValue<List<dynamic>>>{
  VatReportProvider() : super(const AsyncValue.data([]));

  Future<void> getTableValues(FilterAnyModel filterModel) async{
    final dio = Dio();
    try{
      final jsonData = jsonEncode(filterModel.toJson());
      print(jsonData);
      final response = await dio.post(Api.getTable, data: jsonData);
      if(response.statusCode == 200){
        final result = response.data as List<dynamic>;
        state = AsyncValue.data(result);
        print(result);

      }
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
  }

  Future<void> getTableValues2(FilterAnyModel2 filterModel) async{
    final dio = Dio();
    try{
      final jsonData = jsonEncode(filterModel.toJson());
      print(jsonData);
      final response = await dio.post(Api.getTable, data: jsonData);
      if(response.statusCode == 200){
        final result = response.data as List<dynamic>;
        state = AsyncValue.data(result);
        print(result);

      }
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
  }
}
class VatReportProvider2 extends StateNotifier<AsyncValue<List<dynamic>>>{
  VatReportProvider2() : super(const AsyncValue.data([]));

  Future<void> getTableValues(FilterAnyModel filterModel) async{
    final dio = Dio();
    try{
      final jsonData = jsonEncode(filterModel.toJson());
      print(jsonData);
      final response = await dio.post(Api.getTable, data: jsonData);
      if(response.statusCode == 200){
        final result = response.data as List<dynamic>;
        state = AsyncValue.data(result);
        print(result);

      }
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
  }
}
class VatReportProvider3 extends StateNotifier<AsyncValue<List<dynamic>>>{
  VatReportProvider3() : super(const AsyncValue.data([]));

  Future<void> getTableValues(FilterAnyModel filterModel) async{
    final dio = Dio();
    try{
      final jsonData = jsonEncode(filterModel.toJson());
      print(jsonData);
      final response = await dio.post(Api.getTable, data: jsonData);
      if(response.statusCode == 200){
        final result = response.data as List<dynamic>;
        state = AsyncValue.data(result);
        print(result);

      }
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
  }
}


class VatListProvider {
  Future<List<Map<String, dynamic>>> getVatReportList(GetListModel getListModel) async {
    final dio = Dio();
    final jsonData = jsonEncode(getListModel.toJson());

    try {
      final response = await dio.post(Api.getSubList, data: jsonData);

      final responseList = response.data as List<dynamic>;
      List<Map<String, dynamic>> myList = [];

      if (responseList.isNotEmpty && responseList[0] is List<dynamic>) {
        // Handle the first element, which is an array of objects
        final firstElement = responseList[0] as List<dynamic>;
        var branch = <String, dynamic>{};

        for (final e in firstElement) {
          final parsedItem = e as Map<String, dynamic>;
          branch[parsedItem['text'] as String] = parsedItem['value'];
        }

        myList.add(branch);
      }

      if (responseList.length > 1 && responseList[1] is Map<String, dynamic>) {
        // Handle the second element, which is a single object
        final secondElement = responseList[1] as Map<String, dynamic>;

        // You can access the "fromDate" and "toDate" properties like this:
        final fromDate = secondElement['fromDate'] as String;
        final toDate = secondElement['toDate'] as String;

        // Do something with fromDate and toDate if needed
      }

      return myList;

    } catch (err) {
      throw Exception('$err');
    }
  }
  Future<List<Map<String, dynamic>>> getAboveLakhList(GetListModel getListModel) async {
    final dio = Dio();
    final jsonData = jsonEncode(getListModel.toJson());
    List<Map<String, dynamic>> myList = [];

    try {
      final response = await dio.post(Api.getSubList, data: jsonData);

      final responseList = response.data as List<dynamic>;
      List<Map<String, dynamic>> myList = [];

      if (responseList.isNotEmpty && responseList[0] is List<dynamic>) {
        // Handle the first element, which is an array of objects
        final firstElement = responseList[0] as List<dynamic>;
        final secondElement = responseList[1] as List<dynamic>;
        var branch = <String, dynamic>{};
        var particulars = <String, dynamic>{};

        for (final e in firstElement) {
          final parsedItem = e as Map<String, dynamic>;
          branch[parsedItem['text'] as String] = parsedItem['value'];
        }

        for (final a in secondElement) {
          final parsedItem = a as Map<String, dynamic>;
          particulars[parsedItem['text'] as String] = parsedItem['value'];
        }

        myList.add(branch);
        myList.add(particulars);
      }



      return myList;

    } catch (err) {
      throw Exception('$err');
    }
  }
  Future<List<Map<String, dynamic>>> getMonthlyList(GetListModel getListModel) async {
    final dio = Dio();
    final jsonData = jsonEncode(getListModel.toJson());
    List<Map<String, dynamic>> myList = [];

    try {
      final response = await dio.post(Api.getSubList, data: jsonData);
      print(jsonData);
      Map<String, dynamic> branch = {};

      if (response.statusCode == 200) {
        final responseList = response.data as List<dynamic>;

        for (final item in responseList) {
          if (item is Map<String, dynamic>) {
            branch[ListModel.fromJson(item).text!] = ListModel.fromJson(item).value!;
          }
        }
        myList = [branch];
      } else {
        // Handle the case where the response status code is not 200
      }

      return myList;
    } on DioError catch (err) {
      throw DioException().getDioError(err);
    }
  }


}







