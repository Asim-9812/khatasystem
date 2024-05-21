



import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khata_app/core/api.dart';

import '../../../../../core/api_exception.dart';
import '../../../../dashboard/presentation/home_screen.dart';
import '../model/ird_model.dart';


final irdProvider = FutureProvider.family((ref,Map<String,dynamic> data) => IRDProvider.getIRDReport(data: data));


class IRDProvider{

  static Future<List<dynamic>> getIRDReport({required Map<String,dynamic> data}) async{
    final dio = Dio();

    dio.options.headers["Authorization"] = "Bearer ${userToken}";
    
    try{
      final response = await dio.post(Api.getIRDReport,
        data: data
      );
      if(response.statusCode == 200){
        List<dynamic> result = response.data as List<dynamic>;

        SalesBookBrief brief = SalesBookBrief.fromJson(result[0]);

        CompanyInfo companyInfo = CompanyInfo.fromJson(result[1]);

        List<SalesData> salesList = (result[2] as List<dynamic>).map((e) => SalesData.fromJson(e)).toList();

        if(salesList.isEmpty || salesList == []){
          return [];
        }else{
          return [brief,companyInfo,salesList];
        }

      }else{
        throw 'Something went wrong';
      }
      
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
    
}
}