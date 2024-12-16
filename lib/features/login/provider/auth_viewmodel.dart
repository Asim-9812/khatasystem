import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:khatasystem/core/api.dart';



import '../../../main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';


final userLoginProvider = StateProvider((ref) => UserLogin());


class UserLogin {
  final dio = Dio();

  Future<String> login({required String databseId, required String username, required String password}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
      try {
        final response = await dio.post(
          Api.userLogin,
          data: {
            "name": username,
            "password": password,
            "databseId": databseId,
          },
        );
        if (response.statusCode == 200 && response.data["userReturn"] != null && response.data["ownerCompanyList"] != null) {

          if(sessionBox.isEmpty){
            sessionBox.put('userReturn', jsonEncode(response.data));
          }
          // print(response.data["userReturn"]);
          // final companyInfo = response.data["ownerCompanyList"];
          // final userData = response.data["userReturn"];
          await sessionBox.flush();

          return 'success';
        }
        else{
          return response.data["authResult"]["errors"];
        }
      } on DioException catch (err) {
        throw err;
      }
    }else{
      return 'No Internet Connection!!';
    }
  }
}

