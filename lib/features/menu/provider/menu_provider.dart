import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khata_app/core/api_exception.dart';
import 'package:khata_app/features/menu/model/menu_model.dart';
import '../../../core/api.dart';
import '../../dashboard/presentation/home_screen.dart';


final menuProvider = FutureProvider.family((ref, String id) => MenuProvider().getMenu(id));


class MenuProvider{
  Future<List<MenuModel>> getMenu(String id) async {
    final dio = Dio();
    
    dio.options.headers["Authorization"] = "Bearer ${userToken}";

    List<MenuModel> menuList = <MenuModel>[];
    try{
      // final response = await dio.get('http://202.51.74.138:88/api/Menu/GetMenuOfAppbyId?id=1-khatac_00001');

      print(id);
      final response = await dio.get(Api.getMenu, queryParameters: {
        "id": id,
      });

      if(response.statusCode == 200){
        final responseList = response.data as List<dynamic>;

        for (var element in responseList) {
          menuList.add(MenuModel.fromJson(element));
        }

      }else{
        print(response.statusCode);
      }
      return menuList;
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
  }
}