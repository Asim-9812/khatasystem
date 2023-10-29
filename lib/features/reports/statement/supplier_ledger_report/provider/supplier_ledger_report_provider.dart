
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khata_app/core/api.dart';
import 'package:khata_app/core/api_exception.dart';
import 'package:khata_app/model/filter%20model/filter_any_model.dart';


final supplierLedgerReportProvider = StateNotifierProvider<SupplierLedgerReportProvider, AsyncValue<List<dynamic>>>((ref) =>SupplierLedgerReportProvider());

class SupplierLedgerReportProvider extends StateNotifier<AsyncValue<List<dynamic>>>{
  SupplierLedgerReportProvider() : super(const AsyncValue.data([]));

  Future<void> fetchTableData(FilterAnyModel filterModel) async{
    final dio = Dio();
    dio.options.headers["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6WyJLaGF0YWNfMDAwMDEiLCJTVEtTIl0sInJvbGUiOiJhZG1pbiIsIm5iZiI6MTY4NjYzNDI3MSwiZXhwIjoxNzAyNDQ1NDcxLCJpYXQiOjE2ODY2MzQyNzF9.dtRLX7YD-SvTKHlPXyOVEOKZTO7L4CACexqqxBsJuqo";

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