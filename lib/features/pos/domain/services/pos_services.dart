




import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khata_app/core/api.dart';
import 'package:khata_app/core/api_exception.dart';
import 'package:khata_app/features/pos/domain/model/pos_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../main.dart';
import '../../../dashboard/presentation/home_screen.dart';


final voucherProvider = FutureProvider((ref) => POSServices().getVoucherNo());
final posSettingsProvider = FutureProvider((ref) => POSServices().getPOSSettings());
final receivedLedgerProvider = FutureProvider((ref) => POSServices().getReceivedLedgerList());
final customerListProvider = FutureProvider((ref) => POSServices().getCustomerList());
final productProvider = FutureProvider.family((ref,String id) => POSServices().getProductList(locationId: id));
final receivedAmountProvider = FutureProvider.family((ref,int id) => POSServices().getReceivedAmount(salesMasterId: id));
final receivedTotalAmountProvider = FutureProvider.family((ref,int id) => POSServices().getReceivedTotalAmount(salesMasterId: id));
final draftProvider = FutureProvider.family((ref,String voucherNo) => POSServices().loadPosDraft(voucherNo: voucherNo));
final receiptProvider = FutureProvider.family((ref,int id) => POSServices().printReceipt(masterId: id));


class POSServices{

  final dio = Dio();



  Future<String> getVoucherNo() async {
    dio.options.headers["Authorization"] = "Bearer $userToken";
    try{
      final response = await dio.get(Api.getVoucherNo,
      queryParameters: {
        'vid' : 19,
        'branchId' : branchId,
        'financialYearId' : financialYearId
      }
      );
      if(response.statusCode == 200){
        final data = response.data.toString();
        return data;
      }
      else{
        throw Exception('${response.statusCode}: Something went wrong');
      }
    }on DioException catch(e){
      throw Exception(e);
    }

  }

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
    required String locationId
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

          var batchResponse = await dio.get('${Api.getBatchOfProduct}/3/$branchId/$productCode');

          if(batchResponse.statusCode == 200){


            final batchList = batchResponse.data['result'].toList().where((element) => element['batch'] != "0").toList();
            final batch = batchList.isEmpty ? 'N/A' :batchList[0]['batch'];
            final skuUnit = batchList.isEmpty ? 'N/A' :batchList[0]['skuunit'];

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
              var unitId = unitResponse.data['result'].toList().isEmpty? 0 : unitResponse.data['result'][0]['fromUnitId'] ;
              var baseUnit =unitResponse.data['result'].toList().isEmpty? 'N/A' : unitResponse.data['result'][0]['baseunit'];
              var mainUnit =unitResponse.data['result'].toList().isEmpty? 'N/A' : unitResponse.data['result'][0]['mainunit'];
              var qty =unitResponse.data['result'].toList().isEmpty? 0 : unitResponse.data['result'][0]['qty'];
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
                final rateList = rateResponse.data['result'].toList();
                var productUnitID =rateList.isEmpty ? 0: rateResponse.data['result'][0]['productUnitID'];
                var mrp = rateList.isEmpty ? 0: rateResponse.data['result'][0]['mrp'].toDouble();
                var salesRate = rateList.isEmpty ? 0 : rateResponse.data['result'][0]['salesRate'];
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
                  final conversionList = conversionFactor.data['result'].toList();
                  var factor =conversionList.isEmpty? 0 : conversionFactor.data['result'][0]['conversionFactor'];
                  ProductModel newProduct = ProductModel(
                      qty: qty.toDouble(),
                      productId: productId,
                      productCode:productCode,
                      productName: productName,
                      productUnitID: productUnitID,
                      conversionFactor:factor.toDouble(),
                      fromUnitId:unitId,
                      branchId: 0,
                      baseQty: 0.0,
                      batch: batch,
                      isvatable: false,
                      expirydate: expiryDate,
                      baseunit: baseUnit,
                      mainunit: mainUnit,
                      locationId: 0,
                      mrp: mrp.toDouble(),
                      salesRate: salesRate.toDouble(),
                      skuunit: skuUnit
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
      print(e);
      throw '$e';
    }

  }



  Future<Either<String,String>> addSalesDraftPos({
    DraftModel? newDraft
}) async {

    if(newDraft != null){
      dio.options.headers["Authorization"] = "Bearer $userToken";
      final data = newDraft.toJson();
      try{
        final response = await dio.post(Api.addDraftPOS,
          data: data
        );
        if(response.statusCode == 200){
          return const Right('Draft added');
        }
        else{
          return Left('${response.statusCode} : Something went Wrong');
        }
      }on DioException catch(e){
        return Left('$e');
      }
    } else{
      return const Left('No Draft to add');
    }
}


  Future<List<DraftModel>> loadPosDraft({
    required String voucherNo
}) async {

    dio.options.headers["Authorization"] = "Bearer $userToken";
    try{

      final response = await dio.get(Api.loadDraftPOS,
          queryParameters: {
              'voucherNo' : voucherNo
          }
      );
      if(response.statusCode == 200){
        final data = (response.data['result'] as List<dynamic>).map((e) => DraftModel.fromJson(e)).toList();
        return data;
      }
      else{
        throw Exception('${response.statusCode} : Something went wrong');
      }
    }on DioException catch(e){
      throw Exception(e);
    }
  }

  Future<Either<String,String>> deleteDraftItems({
    required int id
  }) async {

    dio.options.headers["Authorization"] = "Bearer $userToken";
    try{
      // final data = receivedAmount.toJson();
      final response = await dio.get(Api.deleteDraftItems,
          queryParameters: {
            'id' : id //salesDraftId
          }
      );
      if(response.statusCode == 200){
        return const Right('Product removed');
      }
      else{
        return Left('${response.statusCode}: Something went wrong.');
      }
    }on DioException catch(e){
      return Left('$e');
    }

  }

  Future<Either<String,String>> deleteDraftTable({
    required int id
  }) async {

    dio.options.headers["Authorization"] = "Bearer $userToken";
    try{
      // final data = receivedAmount.toJson();
      final response = await dio.get(Api.delDraftPOS,
          queryParameters: {
            'draftMasterId' : id //salesDraftId
          }
      );
      if(response.statusCode == 200){
        return const Right('Draft deleted removed');
      }
      else{
        return Left('${response.statusCode}: Something went wrong.');
      }
    }on DioException catch(e){
      return Left('$e');
    }

  }


  Future<List<POSLedgerModel>> getReceivedLedgerList() async {

    dio.options.headers["Authorization"] = "Bearer $userToken";

    try {
      final response = await dio.get(Api.getReceivedLedgerList, queryParameters: {
        'flag' : 14,
        'branchId': branchId
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['result'] as List<dynamic>;
        List<POSLedgerModel> list = data.map((item) => POSLedgerModel.fromJson(item)).toList();

        return list;
      } else {
        throw Exception('Something went wrong');
      }
    } catch (e) {
      print(e);
      throw Exception('$e');
    }
  }

  Future<List<POSLedgerModel>> getCustomerList() async {

    dio.options.headers["Authorization"] = "Bearer $userToken";

    try {
      final response = await dio.get(Api.getCustomerList, queryParameters: {
        'flag' : 9,
        'branchId': branchId
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['result'] as List<dynamic>;
        List<POSLedgerModel> list = data.map((item) => POSLedgerModel.fromJson(item)).toList();

        return list;
      } else {
        throw Exception('Something went wrong');
      }
    } catch (e) {
      print(e);
      throw Exception('$e');
    }
  }
  
  Future<Either<String,String>> addReceivedAmount({
    required ReceivedAmountModel receivedAmount
}) async {

    dio.options.headers["Authorization"] = "Bearer $userToken";
    try{
      final data = receivedAmount.toJson();
      final response = await dio.post(Api.insertReceivedAmount,
      data: data
      );
      if(response.statusCode == 200){
        return const Right('Received amount added');
      }
      else{
        return Left('${response.statusCode}: Something went wrong.');
      }
    }on DioException catch(e){
      return Left('$e');
    }
    
  }


  Future<List<ReceivedAmountModel>> getReceivedAmount({
    required int salesMasterId
}) async {

    dio.options.headers["Authorization"] = "Bearer $userToken";

    try {
      final response = await dio.get(Api.getReceivedAmount, queryParameters: {
        'id' : salesMasterId,
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['result'] as List<dynamic>;
        List<ReceivedAmountModel> list = data.map((item) => ReceivedAmountModel.fromJson(item)).toList();

        return list;
      } else {
        throw Exception('Something went wrong');
      }
    } catch (e) {
      print(e);
      throw Exception('$e');
    }
  }

  Future<double> getReceivedTotalAmount({
    required int salesMasterId
  }) async {

    dio.options.headers["Authorization"] = "Bearer $userToken";
    double total = 0;

    try {
      final response = await dio.get(Api.getReceivedAmount, queryParameters: {
        'id' : salesMasterId,
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['result'] as List<dynamic>;
        List<ReceivedAmountModel> list = data.map((item) => ReceivedAmountModel.fromJson(item)).toList();

        for(int i = 0; i< list.length;i ++){
          total += list[i].drAmt;
        }

        return total;

      } else {
        throw Exception('Something went wrong');
      }
    } catch (e) {
      print(e);
      throw Exception('$e');
    }
  }



  Future<Either<String,String>> saveCustomerInfo({
    required CustomerInfoModel customerInfo
  }) async {

    dio.options.headers["Authorization"] = "Bearer $userToken";
    try{
      final data = customerInfo.toJson();
      final response = await dio.post(Api.insertCustomerInfo,
          data: data
      );
      if(response.statusCode == 200){
        return const Right('Customer Saved');
      }
      else{
        return Left('${response.statusCode}: Something went wrong.');
      }
    }on DioException catch(e){
      return Left('$e');
    }

  }


  Future<Either<String,String>> deleteReceivedAmount({
    required ReceivedAmountModel receivedAmount
  }) async {

    dio.options.headers["Authorization"] = "Bearer $userToken";
    try{
      final data = receivedAmount.toJson();
      final response = await dio.post(Api.delReceivedAmount,
          data: data
      );
      if(response.statusCode == 200){
        return const Right('Amount deleted');
      }
      else{
        return Left('${response.statusCode}: Something went wrong.');
      }
    }on DioException catch(e){
      return Left('$e');
    }

  }


  Future<Either<String,dynamic>> finalSavePOS({
    required int id
  }) async {

    dio.options.headers["Authorization"] = "Bearer $userToken";
    try{
      final response = await dio.post(Api.finalSavePOS,
          data: {
            "masterId": id,
            "financialId": 0,
            "branchId": 0,
            "detailsId": 0
          }
      );
      if(response.statusCode == 200){
        return Right(response.data['result']);
      }
      else{
        return Left('${response.statusCode}: Something went wrong.');
      }
    }on DioException catch(e){
      return Left('$e');
    }

  }


  Future<Either<String,ReceiptPOSModel>> printReceipt({
    required int masterId
}) async {

    dio.options.headers["Authorization"] = "Bearer $userToken";
    try{
      final response = await dio.get(Api.printPOS,
          queryParameters: {
            'masterId' : masterId
          });
      if(response.statusCode == 200){
        final data = response.data as Map<String,dynamic>;
        final receipt = ReceiptPOSModel.fromJson(data);
        // print(data);
        return Right(receipt);
      }
      else{
        return Left('${response.statusCode} : Something went wrong');
      }
    }on DioException catch(e){
      return Left('$e');
    }

  }



}