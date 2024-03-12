




import 'dart:convert';

import 'package:dartz/dartz_unsafe.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:khata_app/core/api.dart';
import 'package:khata_app/core/api_exception.dart';
import 'package:khata_app/features/pos/domain/model/pos_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../main.dart';
import '../../../dashboard/presentation/home_screen.dart';


final voucherProvider = FutureProvider((ref) => POSServices().getVoucherNo());
final posSettingsProvider = FutureProvider.family((ref,String pToken) => POSServices().getPOSSettings(posToken: pToken));
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

  Future<List<PosSettingsModel>> getPOSSettings({required String posToken}) async {

    dio.options.headers["Authorization"] = "Bearer $posToken";

    // print('userToken');


    try {
      final response = await dio.get(Api.getPOSSettings, queryParameters: {'branchId': branchId});

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        List<PosSettingsModel> list = data.map((item) => PosSettingsModel.fromJson(item)).toList();

        return list;
      } else {
        throw Exception('${response.statusCode} : Something went wrong');
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

          // print('${Api.getBatchOfProduct}/3/$branchId/$productCode');

          var batchResponse = await dio.get('${Api.getBatchOfProduct}/3/$branchId/$productCode');
          var companyResponse = await dio.get(Api.companyInfo);

          if(batchResponse.statusCode == 200 && companyResponse.statusCode == 200){

            final companyPanVat = (companyResponse.data['result'] as List<dynamic>)[0]['companyVatOrPan'] == 1;

            final batchList = (batchResponse.data['result'] as List<dynamic>).where((element) => element['batch'] != "0").toList();
            for(var b in batchList){
              final batch = b['batch'];
              final skuUnit = b['skuunit'];
              final isvatable = b['isvatable'];

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
              if(unitResponse.statusCode == 200 && (unitResponse.data['result'] as List<dynamic>).isNotEmpty){

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
                        isvatable: isvatable && companyPanVat,
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
    required String voucherNo,
    required int salesLedgerId,
    required DraftModel newDraft,
    required SalesItemAllocationModel itemAllocation
}) async {

    dio.options.headers["Authorization"] = "Bearer $userToken";
    final data = newDraft.toJson();
    final item = itemAllocation.toJson();
    print(item);
    try{
      final allocateResponse = await dio.post(Api.addSalesAllocation,
          data: item
      );
      if(allocateResponse.statusCode == 200){
        final response = await dio.post(Api.addDraftPOS,
            data: data
        );
        if(response.statusCode == 200) {
          final draftResponse = await dio.get(Api.loadDraftPOS,
              queryParameters: {
                'voucherNo' : voucherNo
              }
          );
          if(draftResponse.statusCode == 200){
            final data = (draftResponse.data['result'] as List<dynamic>).map((e) => DraftModel.fromJson(e)).toList();
            double grossAmt = 0.0;
            double vatAmt = 0.0;
           for(var i in data){
             grossAmt += i.grossAmt;
             vatAmt = (newDraft.vat == 1 ? i.vatAmt : 0.0) + vatAmt;
           }

            final transactionResponse = await dio.post(Api.addTransactionSalesLedgerPOS,
              data: {
                "voucherTypeID": 19,
                "masterID": data.first.salesMasterID,
                "ledgerID": salesLedgerId,
                "drAmt": 0,
                "crAmt": grossAmt,
                "userID": userId2,
                "extra1": voucherNo
              }
            );
            if(transactionResponse.statusCode == 200){
              print(newDraft.vat);
              if(newDraft.vat == 1){
                final addTaxAmtResponse = await dio.post(Api.addTransactionSalesLedgerPOS,
                    data: {
                      "voucherTypeID": 19,
                      "masterID": data.first.salesMasterID,
                      "ledgerID": 7,
                      "drAmt": 0,
                      "crAmt": vatAmt,
                      "userID": userId2,
                      "extra1": voucherNo
                    }
                );
                if(addTaxAmtResponse.statusCode==200){
                  return const Right('Draft added');
                }
                else{
                  return Left('${addTaxAmtResponse.statusCode} : Something went Wrong');
                }
              }
              else{
                return const Right('Draft added');
              }

            }
            else{
              return Left('${response.statusCode} : Something went Wrong');
            }

          }
          else{
            return Left('${response.statusCode} : Something went Wrong');
          }


        }else{
          return Left('${response.statusCode} : Something went Wrong');
        }
      }
      else{
        return Left('${allocateResponse.statusCode} : Something went Wrong');
      }
    }on DioException catch(e){
      return Left('$e');
    }
}


  Future<List<DraftModel>> loadPosDraft({
    required String voucherNo
}) async {

    dio.options.headers["Authorization"] = "Bearer $userToken";
    print('voucher no : $voucherNo');
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
    required int id,
    required String voucherNo
  }) async {

    dio.options.headers["Authorization"] = "Bearer $userToken";
    try{
      final pos = {
        "masterId": id,
        "financialId": 0,
        "branchId": 0,
        "detailsId": 0
      };

      print('add : $pos');
      final response = await dio.post(Api.finalSavePOS,
          data: {
            "masterId": id,
            "financialId": 0,
            "branchId": 0,
            "detailsId": 0,
            "salesType": 3,
            "narration" : ""
          }
      );
      if(response.statusCode == 200){
        final masterId = response.data['result']['masterId'];

        final update = {
          "branchId": branchId,
          "yearId": financialYearId, //financialId
          "salesMasterId": masterId, //allmastertable
          "salesMasterIdDraft": id, //loaddraft
          "userId": userId2,
          "entryMasterId": 0
        };
        print('update : $update');

        final salesMasterEntryResponse = await dio.post(Api.updateSalesMasterEntry,
          data: {
            "branchId": branchId,
            "yearId": financialYearId, //financialId
            "salesMasterId": masterId, //allmastertable
            "salesMasterIdDraft": id, //loaddraft
            "userId": userId2,
            "entryMasterId": 0,
            "narration" : ""
          }
        );
        if(salesMasterEntryResponse.statusCode == 200){
          final load ={
            'omasterId': masterId,
            'branchId': branchId,
            'fiscalId': financialYearId,
            'userId': userId2
          };
          print('load: $load');
          final entryMasterId = salesMasterEntryResponse.data['entryMasterId'];
          final loadSalesStockPostingResponse = await dio.get(Api.loadSMDFStockPosting,
            queryParameters: {
              'omasterId': masterId,
              'branchId': branchId,
              'fiscalId': financialYearId,
              'userId': userId2
            }
          );
          if(loadSalesStockPostingResponse.statusCode == 200){
            final getSalesTransactionCrDrResponse = await dio.get(Api.getSalesTransactionCrDrList,
              queryParameters: {
                'id' : id //loadSalesMasterId
              }
            );
            if(getSalesTransactionCrDrResponse.statusCode == 200){
              final salesResponse = getSalesTransactionCrDrResponse.data['result'] as List<dynamic>;
              print(salesResponse);
              final extra1 = voucherNo;
              bool isExecuted = true;
              for(var transaction in salesResponse){


                final salesLedgerPosting = await dio.post(Api.salesLedgerTransactionPosting,
                    data: {
                      "ledgerPosting_DraftID": 0,
                      "voucherDate": DateFormat('yyyy-MM-ddThh:mm:ss').format(DateTime.now()),
                      "voucherTypeID": 19,
                      "entryMasterID": entryMasterId,
                      "ledgerId": transaction['ledgerID'],
                      "drCr": transaction['drCr'],
                      "debit": transaction['drAmt'],
                      "credit": transaction['crAmt'],
                      "yearId": financialYearId,
                      "branchId": branchId,
                      "userId": userId2,
                      "invoiceNo": 0,
                      "voucherNo": "0",
                      "isSubLedger": false,
                      "hasChild": false,
                      "isBalance": false,
                      "extra1": extra1
                    }
                );
                if(salesLedgerPosting.statusCode != 200){
                  isExecuted = false;
                }
              }

              if(isExecuted){
                return Right(response.data['result']);
              }
              else{
                return Left('Something went wrong.');
              }

            }
            else{
              return Left('${getSalesTransactionCrDrResponse.statusCode}: Something went wrong.');
            }
          }
          else{
            return Left('${loadSalesStockPostingResponse.statusCode}: Something went wrong.');
          }
        }
        else{
          return Left('${salesMasterEntryResponse.statusCode}: Something went wrong.');
        }


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