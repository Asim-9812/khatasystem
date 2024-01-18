




import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khata_app/core/api.dart';
import 'package:khata_app/core/api_exception.dart';
import 'package:khata_app/features/pos/domain/model/pos_model.dart';

import '../../../dashboard/presentation/home_screen.dart';


final posSettingsProvider = FutureProvider((ref) => POSServices().getPOSSettings());
final productProvider = FutureProvider.family((ref,int id) => POSServices().getProductList(locationId: id));


class POSServices{

  final dio = Dio();

  Future<List<PosSettingsModel>> getPOSSettings() async {
    dio.options.headers["Authorization"] = "Bearer $userToken";

    try {
      final response = await dio.get(Api.getPOSSettings, queryParameters: {'branchId': branchId});

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        List<PosSettingsModel> list = data.map((item) => PosSettingsModel.fromJson(item)).toList();

        return list;
      } else {
        throw Exception('Something went wrong');
      }
    } catch (e) {
      print(e);
      throw Exception('$e');
    }
  }




  Future<List<ProductModel>> getProductList({
    required int locationId
}) async {
    dio.options.headers["Authorization"] = "Bearer $userToken";
    List<ProductModel> newProductList =[];

    try{
      final productResponse = await dio.get('${Api.getProductList}/1/$branchId/null/$locationId');
      if(productResponse.statusCode == 200){
        final products = productResponse.data['result'].toList();

        for(int i =0; i< products.length; i++){
          var productId = products[i]['productId'];
          var productCode = products[i]['productCode'];
          var productName = products[i]['productName'];
          var expiryDate = products[i]['expirydate'];
          var qty = products[i]['qty'];
          var batchResponse = await dio.get('${Api.getBatchOfProduct}/3/$branchId/$productCode');
          if(batchResponse.statusCode == 200){
            final batch = batchResponse.data['result'][0]['batch'];
            final unitResponse = await dio.post(Api.getUnitByBatch,
                data:{
                  "branch": branchId,
                  "flag": 9,
                  "productCode": productCode,
                  "batch": batch,
                  "productId": productId,
                  "unit": 0
                }
            );
            if(unitResponse.statusCode == 200){
              var unitId = unitResponse.data['result'][0]['fromUnitId'];
              var baseUnit = unitResponse.data['result'][0]['baseunit'];
              var mainUnit = unitResponse.data['result'][0]['mainunit'];
              final rateResponse = await dio.post(Api.getUnitByBatch,
                  data:{
                    "branch": branchId,
                    "flag": 5,
                    "productCode": 'N/A',
                    "batch": batch,
                    "productId": productId,
                    "unit": unitId
                  }
              );
              if(rateResponse.statusCode==200){
                var productUnitID = rateResponse.data['result'][0]['productUnitID'];
                var mrp = rateResponse.data['result'][0]['mrp'];
                var salesRate = rateResponse.data['result'][0]['salesRate'];
                final conversionFactor = await dio.post(Api.getConversionFactor,
                    data:{
                      "branch": branchId,
                      "flag": 5,
                      "productCode": 'N/A',
                      "batch": batch,
                      "productId": productId,
                      "unit": unitId
                    }
                );
                if(conversionFactor.statusCode == 200){
                  var factor = conversionFactor.data['result'][0]['conversionFactor'];
                  ProductModel newProduct = ProductModel(
                      qty: qty,
                      productId: productId,
                      productCode:productCode,
                      productName: productName,
                      productUnitID: productUnitID,
                      conversionFactor:factor,
                      fromUnitId:unitId,
                      branchId: 0,
                      baseQty: 0,
                      batch: batch,
                      isvatable: false,
                      expirydate: expiryDate,
                      baseunit: baseUnit,
                      mainunit: mainUnit,
                      locationId: 0,
                      mrp: mrp,
                      salesRate: salesRate
                  );
                  newProductList.add(newProduct);
                }
              }
            }
          }
        }

        return newProductList;
      }
      else{
        throw 'Something went wrong';
      }

    }on DioException catch(e){
      throw '$e';
    }

  }



}