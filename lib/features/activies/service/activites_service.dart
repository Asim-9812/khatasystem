




import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:khata_app/core/api.dart';
import 'package:khata_app/features/activies/model/logModel.dart';

import '../../dashboard/presentation/home_screen.dart';
import '../model/entry_master_model.dart';

final logProvider = StreamProvider.autoDispose<List<LogModel>>((ref) async* {
  final dio = Dio();
  dio.options.headers["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6WyJLaGF0YWNfMDAwMDEiLCJTVEtTIl0sInJvbGUiOiJhZG1pbiIsIm5iZiI6MTY4NjYzNDI3MSwiZXhwIjoxNzAyNDQ1NDcxLCJpYXQiOjE2ODY2MzQyNzF9.dtRLX7YD-SvTKHlPXyOVEOKZTO7L4CACexqqxBsJuqo";


  try{
    final response = await dio.post(Api.getLoginActivities,
      data: {
        "logid": 0,
        "ipaddress": "string",
        "macAddress": "string",
        "hostAddress": "string",
        "userId": "string",
        "statusMessage": "string",
        "status": "string",
        "contact": "string",
        "email": "string",
        "name": "string",
        "logInTime": DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(DateTime.now()),
        "sessionId": "string",
        "dbName": mainInfo.dbName
      }
    );

    if (response.statusCode == 200) {
      final result = response.data["result"] as List<dynamic>;
      final logModel = result.map((e) => LogModel.fromJson(e)).toList();
      yield logModel;
    } else {
      throw Exception('Failed to load logs');
    }
  }on DioError catch(err){
    throw err.message;
  }

});


Future<List<LogModel>> fetchLogActivities(StreamController logStreamController, String token) async {

  try{
    final dio = Dio(
        BaseOptions(
          connectTimeout: 30000,
          baseUrl: Api.getLoginActivities,
          responseType: ResponseType.json,
        ));

    dio.options.headers["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6WyJLaGF0YWNfMDAwMDEiLCJTVEtTIl0sInJvbGUiOiJhZG1pbiIsIm5iZiI6MTY4NjYzNDI3MSwiZXhwIjoxNzAyNDQ1NDcxLCJpYXQiOjE2ODY2MzQyNzF9.dtRLX7YD-SvTKHlPXyOVEOKZTO7L4CACexqqxBsJuqo";

    final response = await dio.post(Api.getLoginActivities,
        data: {
          "logid": 0,
          "ipaddress": "string",
          "macAddress": "string",
          "hostAddress": "string",
          "userId": "string",
          "statusMessage": "string",
          "status": "string",
          "contact": "string",
          "email": "string",
          "name": "string",
          "logInTime": DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(DateTime.now()),
          "sessionId": "string",
          "dbName": mainInfo.dbName
        },
    );
    if (response.statusCode == 200) {
      final result = response.data["result"] as List<dynamic>;
      final logModel = result.map((e) => LogModel.fromJson(e)).toList();
      logStreamController.add(logModel);
      return logModel;
    } else {
      throw Exception('Failed to load logs');
    }
  }on DioError catch(err){
    throw err.message;
  }
}


Future<List<EntryMaster>> fetchTransactionActivities(StreamController transactionStreamController) async {
  final dio = Dio();
  dio.options.headers["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6WyJLaGF0YWNfMDAwMDEiLCJTVEtTIl0sInJvbGUiOiJhZG1pbiIsIm5iZiI6MTY4NjYzNDI3MSwiZXhwIjoxNzAyNDQ1NDcxLCJpYXQiOjE2ODY2MzQyNzF9.dtRLX7YD-SvTKHlPXyOVEOKZTO7L4CACexqqxBsJuqo";




  try{
    final response = await dio.post(Api.getTransactionActivities,
        // data: {
        //   "name": "string",
        //   "username": "string",
        //   "voucherTypeName": "string",
        //   "voucherNo": "string",
        //   "entryDate": DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(DateTime.now()),
        //   "dbName": mainInfo.dbName
        // }
    );

    if (response.statusCode == 200) {
      final result = response.data["result"] as List<dynamic>;
      final entryMasterModel = result.map((e) => EntryMaster.fromJson(e)).toList();
      return entryMasterModel;
    } else {
      throw Exception('Failed to load logs');
    }
  }on DioError catch(err){
    throw err.message;
  }
}





final entryMasterProvider = StreamProvider<List<EntryMaster>>((ref) async* {
  final dio = Dio();
  dio.options.headers["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6WyJLaGF0YWNfMDAwMDEiLCJTVEtTIl0sInJvbGUiOiJhZG1pbiIsIm5iZiI6MTY4NjYzNDI3MSwiZXhwIjoxNzAyNDQ1NDcxLCJpYXQiOjE2ODY2MzQyNzF9.dtRLX7YD-SvTKHlPXyOVEOKZTO7L4CACexqqxBsJuqo";


  try{
    final response = await dio.post(Api.getTransactionActivities,
        // data: {
        //   "name": "string",
        //   "username": "string",
        //   "voucherTypeName": "string",
        //   "voucherNo": "string",
        //   "entryDate": DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(DateTime.now()),
        //   "dbName": mainInfo.dbName
        // }
    );

    if (response.statusCode == 200) {
      final result = response.data["result"] as List<dynamic>;
      final entryMasterModel = result.map((e) => EntryMaster.fromJson(e)).toList();
      yield entryMasterModel;
    } else {
      throw Exception('Failed to load logs');
    }
  }on DioError catch(err){
    throw err.message;
  }

});
