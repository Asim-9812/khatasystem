



import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khata_app/core/api.dart';
import 'package:khata_app/features/dashboard/presentation/home_screen.dart';
import 'package:khata_app/features/fiscalYear/model/fiscal_year_model.dart';




final fiscalYearProvider = FutureProvider((ref) => FiscalYearProvider().getFiscalYearList());
class FiscalYearProvider{

  Future<List<FiscalYearModel>> getFiscalYearList() async{
    final dio = Dio();
    dio.options.headers["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6WyJLaGF0YWNfMDAwMDEiLCJTVEtTIl0sInJvbGUiOiJhZG1pbiIsIm5iZiI6MTY4NjYzNDI3MSwiZXhwIjoxNzAyNDQ1NDcxLCJpYXQiOjE2ODY2MzQyNzF9.dtRLX7YD-SvTKHlPXyOVEOKZTO7L4CACexqqxBsJuqo";


    try{
      print(mainInfo.toJson());
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
    }on DioError catch(err){
      throw err.message;
    }
  }
}