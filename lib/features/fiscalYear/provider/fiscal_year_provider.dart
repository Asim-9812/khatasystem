



import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khatasystem/core/api.dart';
import 'package:khatasystem/features/dashboard/presentation/home_screen.dart';
import 'package:khatasystem/features/fiscalYear/model/fiscal_year_model.dart';

import '../../../main.dart';




final fiscalYearProvider = FutureProvider((ref) => FiscalYearProvider().getFiscalYearList());
class FiscalYearProvider{

  Future<List<FiscalYearModel>> getFiscalYearList() async{
    final dio = Dio();
    
    dio.options.headers["Authorization"] = "Bearer ${userToken}";


    try{
      final response = await dio.post(Api.getFiscalYear,
          data: mainInfo.toJson()
      );

      if(response.statusCode == 200){
        final result = response.data["fiscalYearDetail"] as List<dynamic>;
        final fiscalYearList = result.map((e) => FiscalYearModel.fromJson(e)).toList();
        return fiscalYearList;
      }else{
        return [];
      }
    }on DioException catch(err){
      throw err;
    }
  }
}