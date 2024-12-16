

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khatasystem/core/api.dart';

import 'package:khatasystem/features/track_product/domain/model/track_model.dart';
import '../../../dashboard/presentation/home_screen.dart';



final getBranches = FutureProvider((ref) => TrackServices.getBranchList());
final getTokenList = FutureProvider.family((ref,int id) => TrackServices.getTokenList(branch: id));
final getAllTokenList = FutureProvider((ref) => TrackServices.getAllTokenList());


class TrackServices{

  static final dio = Dio();

  static Future<List<TrackBranchModel>> getBranchList()async{
    try{
      dio.options.headers["Authorization"] = "Bearer $userToken";


      print('${Api.getBranchList}/$branchId');


      final response = await dio.get('${Api.getBranchList}/$branchId');

      if(response.statusCode == 200){
        return (response.data['result'] as List<dynamic>).map((e) => TrackBranchModel.fromJson(e)).toList();
      }
      else{
        throw Exception('${response.statusCode} : Something went wrong');
      }


    } on DioException catch(e){
      print(e);
      throw Exception('${e}');
    }

  }


  static Future<List<TokenModel>> getTokenList({required int branch})async{
    try{
      if(branch == 0){
        return [];
      }

      dio.options.headers["Authorization"] = "Bearer $userToken";

      final response = await dio.get('${Api.getTokenList}/$branch');

      final data = (response.data['result'] as List<dynamic>).map((e) => TokenModel.fromJson(e)).toList();

      if(response.statusCode == 200){
        return data;
      }
      else{
        return [];
      }

    } on DioException catch(e){
      return [];
    }

  }


  static Future<Either<String, List<TrackModel>>> getTrackingList({required TokenModel tokenData})async{
    try{
      dio.options.headers["Authorization"] = "Bearer $userToken";

      final tokenMap = tokenData.toJson();

      final response = await dio.post('${Api.getTrackList}', data: tokenMap);

      final data = (response.data['result'] as List<dynamic>).map((e) {
        final divisionList = e['division'] as List<dynamic>;
        final divisionData = divisionList.map((e) => Division.fromJson(e)).toList();

        // Convert the outer list item to TrackModel
        return TrackModel(
          divisionId: e['divisionId'],
          batchName: e['batchName'],
          division: divisionData,
        );
      }).toList();


      if(response.statusCode == 200){
        return Right(data);
      }
      else{
        return Left('${response.statusCode} : Something went wrong');
      }


    } on DioException catch(e){
      return Left('${e}');
    }

  }


  static Future<List<TokenModel>> getAllTokenList() async {
    try {
      List<TokenModel> tokenList = [];

      dio.options.headers["Authorization"] = "Bearer $userToken";

      final branchResponse = await dio.get('${Api.getBranchList}/$branchId');

      if (branchResponse.statusCode == 200) {
        final branches =
        (branchResponse.data['result'] as List<dynamic>).map((e) => TrackBranchModel.fromJson(e)).toList();
        for (var i in branches) {
          final newBranchId = i.branchId;
          try {
            final response = await dio.get('${Api.getTokenList}/$newBranchId');

            if (response.statusCode == 200) {
              final data =
              (response.data['result'] as List<dynamic>).map((e) => TokenModel.fromJson(e)).toList();
              tokenList = [...tokenList, ...data];
            } else {
              throw Exception('${response.statusCode} : Something went wrong');
            }
          } on DioException catch (e) {

            if(e.response?.statusCode == 400){
              continue;
            }
            else{
              break;
            }

          }
        }
        return tokenList;
      } else {
        throw Exception('${branchResponse.statusCode} : Something went wrong');
      }
    } on DioException catch (e) {
      throw Exception('$e');
    }
  }





}