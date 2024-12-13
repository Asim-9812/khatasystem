
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khata_app/core/api.dart';
import 'package:khata_app/core/api_exception.dart';
import 'package:khata_app/model/filter%20model/filter_any_model.dart';

import '../../../../../main.dart';
import '../../../../dashboard/presentation/home_screen.dart';


final customerLedgerReportProvider = StateNotifierProvider<CustomerLedgerReportProvider, AsyncValue<List<dynamic>>>((ref) =>CustomerLedgerReportProvider());

class CustomerLedgerReportProvider extends StateNotifier<AsyncValue<List<dynamic>>>{
  CustomerLedgerReportProvider() : super(const AsyncValue.data([]));

  Future<void> getTableValues(FilterAnyModel2 filterModel) async{
    final dio = Dio();
    
    dio.options.headers["Authorization"] = "Bearer $userToken";

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


