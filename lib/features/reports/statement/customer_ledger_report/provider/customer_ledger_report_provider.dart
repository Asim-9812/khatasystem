
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khata_app/core/api.dart';
import 'package:khata_app/core/api_exception.dart';
import 'package:khata_app/model/filter%20model/filter_any_model.dart';


final customerLedgerReportProvider = StateNotifierProvider<CustomerLedgerReportProvider, AsyncValue<List<dynamic>>>((ref) =>CustomerLedgerReportProvider());

class CustomerLedgerReportProvider extends StateNotifier<AsyncValue<List<dynamic>>>{
  CustomerLedgerReportProvider() : super(const AsyncValue.data([]));

  Future<void> getTableValues(FilterAnyModel filterModel) async{
    final dio = Dio();
    dio.options.headers["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6WyJLaGF0YWNfMDAwMDEiLCJTVEtTIl0sInJvbGUiOiJhZG1pbiIsIm5iZiI6MTY4NjYzNDI3MSwiZXhwIjoxNzAyNDQ1NDcxLCJpYXQiOjE2ODY2MzQyNzF9.dtRLX7YD-SvTKHlPXyOVEOKZTO7L4CACexqqxBsJuqo";

    try{
      final jsonData = jsonEncode(filterModel.toJson());
      print(jsonData);
      final response = await dio.post(Api.getTable, data: jsonData);
      if(response.statusCode == 200){
        final result = response.data as List<dynamic>;
        state = AsyncValue.data(result);
      }
    }on DioError catch(err){
      Fluttertoast.showToast(
          msg: "No data found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      throw DioException().getDioError(err);
    }
  }
}


