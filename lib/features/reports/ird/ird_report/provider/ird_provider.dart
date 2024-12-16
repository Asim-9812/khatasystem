

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:khatasystem/core/api.dart';
import '../../../../dashboard/presentation/home_screen.dart';
import '../model/ird_model.dart';



final irdProvider = FutureProvider.family((ref,Map<String,dynamic> data) => IRDProvider.getIRDReport(data: data));
final irdDetailProvider = FutureProvider.family((ref,Map<String,dynamic> data) => IRDProvider.getIRDDetails(data: data));



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
      
    }on DioException catch(err){
      throw err;
    }
    
}

  static Future<List<SalesData>> getIRDDetails({required Map<String,dynamic> data}) async{
    final dio = Dio();



    dio.options.headers["Authorization"] = "Bearer ${userToken}";

    try{
      final masterId = data['masterId'];
      final isSale = data['isSale'];

      if(isSale){
        final response = await dio.get('${Api.getIRDDetails}/$masterId');
        if(response.statusCode == 200){
          List<dynamic> result = response.data as List<dynamic>;

          List<SalesData> salesList = result.map((e) => SalesData.fromJson(e)).toList();

          if(salesList.isEmpty || salesList == []){
            return [];
          }else{
            return salesList;
          }

        }else{
          throw 'Something went wrong';
        }
      }
      else{
        final response = await dio.get('${Api.getIRDDetailsPurchase}',
          queryParameters: {
          'id':masterId
          }
        );
        if(response.statusCode == 200){
          List<dynamic> result = response.data as List<dynamic>;

          List<SalesData> salesList = result.map((e) => SalesData.fromJson(e)).toList();

          if(salesList.isEmpty || salesList == []){
            return [];
          }else{
            return salesList;
          }

        }else{
          throw 'Something went wrong';
        }
      }



    }on DioException catch(err){
      throw err;
    }

}

  static Future<Either<String, ReprintModel>> getReprint({required int masterId,required int count,required int type,required String voucherNo}) async{
    final dio = Dio();

    dio.options.headers["Authorization"] = "Bearer ${userToken}";

    int voucherTypeId = type == 0 ? 19 : type == 1 ? 20 : type == 2 ? 13 : 14; //  purchase(13 return : 14) sales(19 return : 20)
    final date = DateFormat('yyyy-MM-ddThh:mm:ss').format(DateTime.now());


    var reprintData = {
      "id": 0,
      "masterID": masterId,
      "billNO": "$voucherNo",
      "voucherTypeID": voucherTypeId,
      "printBY": userId2,
      "printTime": date,
      "printCount": count,
      "extra1": "string",
      "extra2": "string",
      "extra3": "string"
    };


    try{
      if(type == 0){
        final response = await dio.get('${Api.salesReprint}',
            queryParameters: {
              'id' : masterId,
              'count' : count
            }
        );
        if(response.statusCode == 200){
          final data = ReprintModel.fromJson(response.data);

          if(data.alreadyPrint!){
            reprintData.addAll({
              'flag' : 'UPDATEIRD'
            });
            print(reprintData);
            await dio.post('${Api.updatePrint}',
                data: reprintData
            );
          }
          else{
            reprintData.addAll({
              'flag' : 'INSERTIRD'
            });
            print(reprintData);
            await dio.post('${Api.insertPrint}',
                data: reprintData
            );
          }

          return Right(data);

        }else{
          return Left('Something went wrong');
        }
      }
      else if(type ==1){
        final response = await dio.get('${Api.salesReturnReprint}',
            queryParameters: {
              'id' : masterId,
              'count' : count,
              'sInvoice':voucherNo
            }
        );
        if(response.statusCode == 200){
          final data = ReprintModel.fromJson(response.data);
          if(data.alreadyPrint!){
            reprintData.addAll({
              'flag' : 'UPDATEIRD'
            });
            await dio.post('${Api.updatePrint}',
                data: reprintData
            );
          }
          else{
            reprintData.addAll({
              'flag' : 'INSERTIRD'
            });
            await dio.post('${Api.insertPrint}',
                data: reprintData
            );
          }
          return Right(data);

        }else{
          return Left('Something went wrong');
        }
      }
      else if(type ==2){
        final response = await dio.get('${Api.purchaseReprint}',
            queryParameters: {
              'id' : masterId,
            }
        );
        if(response.statusCode == 200){
          final data = ReprintModel.fromJson(response.data);
          if(data.alreadyPrint!){
            reprintData.addAll({
              'flag' : 'UPDATEIRD'
            });
            await dio.post('${Api.updatePrint}',
                data: reprintData
            );
          }
          else{
            reprintData.addAll({
              'flag' : 'INSERTIRD'
            });
            await dio.post('${Api.insertPrint}',
                data: reprintData
            );
          }
          return Right(data);

        }else{
          return Left('Something went wrong');
        }
      }
      else{
        final response = await dio.get('${Api.purchaseReturnReprint}',
            queryParameters: {
              'id' : masterId,
            }
        );
        if(response.statusCode == 200){
          final data = ReprintModel.fromJson(response.data);
          if(data.alreadyPrint!){
            reprintData.addAll({
              'flag' : 'UPDATEIRD'
            });
            await dio.post('${Api.updatePrint}',
                data: reprintData
            );
          }
          else{
            reprintData.addAll({
              'flag' : 'INSERTIRD'
            });
            await dio.post('${Api.insertPrint}',
                data: reprintData
            );
          }
          return Right(data);

        }else{
          return Left('Something went wrong');
        }
      }




    }on DioException catch(err){
      print(err);
      return Left(err.toString());
      throw err;
    }

    }
}