



import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:khata_app/core/api_exception.dart';
import 'package:khata_app/features/inquiry/domain/model/model.dart';

import '../../../../core/api.dart';

class InquiryServices{

  final dio = Dio();

  Future<Either<String,String>> submitInquiry({required InquiryModel inquiry}) async{

    // dio.options.headers['Authorization'] = 'Bearer $token';

    try{
      final data = inquiry.toJson();
      final response = await dio.post(Api.inquiryForm,
          data: data);

      if(response.statusCode == 200){
        return Right('Form submitted');
      }
      else{
        return Left('${response.statusCode} : Something went wrong');
      }

    }on DioException catch(e){
      return Left('Something went wrong');
    }

  }
}