import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khata_app/model/filter%20model/filter_any_model.dart';


import '../../../../../core/api.dart';
import '../../../../../core/api_exception.dart';
import '../../../../../main.dart';
import '../../../../../model/list model/get_list_model.dart';
import '../../../../../model/list model/list_model.dart';
import '../../../../dashboard/presentation/home_screen.dart';



final TPBlistProvider = FutureProvider.family.autoDispose((ref, GetListModel model) => TBPLBSListProvider().getMenu(model));
final supplierListProvider = FutureProvider.family.autoDispose((ref, GetListModel model) => SupplierLedgerListProvider().getMenu(model));
final customerListProvider = FutureProvider.family.autoDispose((ref, GetListModel model) => CustomerLedgerListProvider().getMenu(model));
final ledgerListProvider = FutureProvider.family.autoDispose((ref, GetListModel2 model) => LedgerReportListProvider().getMenu(model));
final listProvider = FutureProvider.family.autoDispose((ref, GetListModel model) => ListProvider().getMenu(model));
final listProvider2 = FutureProvider.family.autoDispose((ref, GetListModel model) => ListProvider().getSubList(model));
final listProvider3 = FutureProvider.family.autoDispose((ref, GetListModel2 model) => ListProvider().getSubList2(model));

final ledgerItemProvider = FutureProvider.family((ref, GetListModel model) => LedgerProvider().getLedgerItem(model));


class LedgerReportListProvider{
  Future<List<Map<dynamic, dynamic>>> getMenu(GetListModel2 getListModel) async {
    final dio = Dio();
    
    dio.options.headers["Authorization"] = "Bearer ${userToken}";


    // print(getListModel.mainInfoModel!.fiscalID);
    // print(getListModel.mainInfoModel!.branchId);
    final jsonData = jsonEncode(getListModel.toJson());
    List<Map<dynamic, dynamic>> myList = [];
    try{
      final response = await dio.post(Api.getLedgerReportList, data: {
        "fiscalId": getListModel.mainInfoModel!.fiscalID,
        "sessionBranch": getListModel.mainInfoModel!.branchId
      });

      if(response.statusCode == 200){
        // Check if response.data[1] is a map
        if (response.data[1] is Map<String, dynamic>) {
          final responseList = [
            response.data[0] as List<dynamic>,
            response.data[2] as List<dynamic>,
            response.data[3] as List<dynamic>,
          ];

          var branch = {};
          var group = {};
          var ledger = {};

          for (final e in responseList[0]) {
            branch[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
          }
          // Note: Assuming response.data[1] is a map with String keys and dynamic values
          for (final e in responseList[1]) {
            group[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
          }

          for (final e in responseList[2]) {
            ledger[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
          }

          myList = [branch, group, ledger];
        } else {
          final responseList = [
            response.data[0] as List<dynamic>,
            response.data[1] as List<dynamic>,
            response.data[2] as List<dynamic>,
          ];

          var branch = {};
          var group = {};
          var ledger = {};

          for (final e in responseList[0]) {
            branch[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
          }
          for (final e in responseList[1]) {
            group[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
          }
          for (final e in responseList[2]) {
            ledger[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
          }

          myList = [branch, group, ledger];
        }

      }else{
      }
      return myList;
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
  }
  Future<List<Map<dynamic, dynamic>>> getSubList(GetListModel getListModel) async {
    final dio = Dio();
    
    dio.options.headers["Authorization"] = "Bearer ${userToken}";


    final jsonData = jsonEncode(getListModel.toJson());
    List<Map<dynamic, dynamic>> myList = [];
    try{
      final response = await dio.post(Api.getSubList, data: jsonData);

      if(response.statusCode == 200){
        final responseList = response.data as List<dynamic>;
        var branch = {};
        var voucher = {};
        var ledger = {};

        for(final e in responseList[0]){
          branch[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        for(final e in responseList[1]){
          voucher[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        for(final e in responseList[2]){
          ledger[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        myList = [branch, voucher, ledger];
      }else{
      }
      return myList;
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
  }
}



class CustomerLedgerListProvider{
  Future<List<Map<dynamic, dynamic>>> getMenu(GetListModel getListModel) async {
    final dio = Dio();
    
    dio.options.headers["Authorization"] = "Bearer ${userToken}";


    print(getListModel.mainInfoModel!.fiscalID);
    print(getListModel.mainInfoModel!.branchId);
    final jsonData = jsonEncode(getListModel.toJson());
    List<Map<dynamic, dynamic>> myList = [];
    try{
      final response = await dio.post(Api.getCustomerLedgerList, data: {
        "fiscalId": getListModel.mainInfoModel!.fiscalID,
        "sessionBranch": getListModel.mainInfoModel!.branchId
      });

      if(response.statusCode == 200){
        final responseList = [response.data[0] as List<dynamic>,response.data[1] as List<dynamic>,response.data[2] as List<dynamic>];

        var branch = {};
        var group = {};
        var ledger = {};


        for(final e in responseList[0]){
          branch[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        for(final e in responseList[1]){
          group[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        for(final e in responseList[2]){
          ledger[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        myList = [branch,group,ledger];
      }else{
      }
      return myList;
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
  }
  Future<List<Map<dynamic, dynamic>>> getSubList(GetListModel getListModel) async {
    final dio = Dio();
    
    dio.options.headers["Authorization"] = "Bearer ${userToken}";


    final jsonData = jsonEncode(getListModel.toJson());
    List<Map<dynamic, dynamic>> myList = [];
    try{
      final response = await dio.post(Api.getSubList, data: jsonData);

      if(response.statusCode == 200){
        final responseList = response.data as List<dynamic>;
        var branch = {};
        var voucher = {};
        var ledger = {};

        for(final e in responseList[0]){
          branch[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        for(final e in responseList[1]){
          voucher[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        for(final e in responseList[2]){
          ledger[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        myList = [branch, voucher, ledger];
      }else{
      }
      return myList;
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
  }
}


class SupplierLedgerListProvider{
  Future<List<Map<dynamic, dynamic>>> getMenu(GetListModel getListModel) async {
    final dio = Dio();
    
    dio.options.headers["Authorization"] = "Bearer ${userToken}";


    print(getListModel.mainInfoModel!.fiscalID);
    print(getListModel.mainInfoModel!.branchId);
    final jsonData = jsonEncode(getListModel.toJson());
    List<Map<dynamic, dynamic>> myList = [];
    try{
      final response = await dio.post(Api.getSupplierLedgerList, data: {
        "fiscalId": getListModel.mainInfoModel!.fiscalID,
        "sessionBranch": getListModel.mainInfoModel!.branchId
      });

      if(response.statusCode == 200){
        final responseList = [response.data[0] as List<dynamic>,response.data[1] as List<dynamic>,response.data[2] as List<dynamic>];

        var branch = {};
        var group = {};
        var ledger = {};


        for(final e in responseList[0]){
          branch[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        for(final e in responseList[1]){
          group[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        for(final e in responseList[2]){
          ledger[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        myList = [branch,group,ledger];
      }else{
      }
      return myList;
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
  }
  Future<List<Map<dynamic, dynamic>>> getSubList(GetListModel getListModel) async {
    final dio = Dio();
    
    dio.options.headers["Authorization"] = "Bearer ${userToken}";


    final jsonData = jsonEncode(getListModel.toJson());
    List<Map<dynamic, dynamic>> myList = [];
    try{
      final response = await dio.post(Api.getSubList, data: jsonData);

      if(response.statusCode == 200){
        final responseList = response.data as List<dynamic>;
        var branch = {};
        var voucher = {};
        var ledger = {};

        for(final e in responseList[0]){
          branch[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        for(final e in responseList[1]){
          voucher[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        for(final e in responseList[2]){
          ledger[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        myList = [branch, voucher, ledger];
      }else{
      }
      return myList;
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
  }
}

class TBPLBSListProvider{
  Future<List<Map<dynamic, dynamic>>> getMenu(GetListModel getListModel) async {
    final dio = Dio();
    
    dio.options.headers["Authorization"] = "Bearer ${userToken}";


    print(getListModel.mainInfoModel!.fiscalID);
    print(getListModel.mainInfoModel!.branchId);
    final jsonData = jsonEncode(getListModel.toJson());
    List<Map<dynamic, dynamic>> myList = [];
    try{
      final response = await dio.post(Api.getTrialProfitBlcList, data: {
        "fiscalId": getListModel.mainInfoModel!.fiscalID,
        "sessionBranch": getListModel.mainInfoModel!.branchId
      });

      if(response.statusCode == 200){
        final responseList = response.data[0] as List<dynamic>;

        var branch = {};


        for(final e in responseList){
          branch[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        myList = [branch];
      }else{
      }
      return myList;
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
  }
  Future<List<Map<dynamic, dynamic>>> getSubList(GetListModel getListModel) async {
    final dio = Dio();
    
    dio.options.headers["Authorization"] = "Bearer ${userToken}";


    final jsonData = jsonEncode(getListModel.toJson());
    List<Map<dynamic, dynamic>> myList = [];
    try{
      final response = await dio.post(Api.getSubList, data: jsonData);

      if(response.statusCode == 200){
        final responseList = response.data as List<dynamic>;
        var branch = {};
        var voucher = {};
        var ledger = {};

        for(final e in responseList[0]){
          branch[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        for(final e in responseList[1]){
          voucher[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        for(final e in responseList[2]){
          ledger[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        myList = [branch, voucher, ledger];
      }else{
      }
      return myList;
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
  }
}



class ListProvider{
  Future<List<Map<dynamic, dynamic>>> getMenu(GetListModel getListModel) async {
    final dio = Dio();
    
    dio.options.headers["Authorization"] = "Bearer ${userToken}";

    final jsonData = jsonEncode(getListModel.toJson());
    List<Map<dynamic, dynamic>> myList = [];
    try{
      final response = await dio.post(Api.getList, data: jsonData);

      if(response.statusCode == 200){
        final responseList = response.data as List<dynamic>;
        var group = {};
        var ledger = {};
        var branch = {};

        for(final e in responseList[0]){
          group[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        for(final e in responseList[1]){
          ledger[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        for(final e in responseList[2]){
          branch[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        myList = [group, ledger, branch];
      }else{
      }
      return myList;
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
  }
  Future<List<Map<dynamic, dynamic>>> getSubList(GetListModel getListModel) async {
    final dio = Dio();
    
    dio.options.headers["Authorization"] = "Bearer ${userToken}";


    final jsonData = jsonEncode(getListModel.toJson());
    List<Map<dynamic, dynamic>> myList = [];
    try{
      final response = await dio.post(Api.getSubList, data: jsonData);

      if(response.statusCode == 200){
        final responseList = response.data as List<dynamic>;
        var branch = {};
        var voucher = {};
        var ledger = {};

        for(final e in responseList[0]){
          branch[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        for(final e in responseList[1]){
          voucher[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        for(final e in responseList[2]){
          ledger[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        myList = [branch, voucher, ledger];
      }else{
      }
      return myList;
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
  }
  Future<List<Map<dynamic, dynamic>>> getSubList2(GetListModel2 getListModel) async {
    final dio = Dio();
    
    dio.options.headers["Authorization"] = "Bearer ${userToken}";


    final jsonData = jsonEncode(getListModel.toJson());
    List<Map<dynamic, dynamic>> myList = [];
    try{
      final response = await dio.post(Api.getSubList, data: jsonData);

      if(response.statusCode == 200){
        final responseList = [response.data[0] as List<dynamic>,response.data[1] as List<dynamic>];
        var branch = {};
        var group = {};

        for(final e in responseList[0]){
          branch[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        for(final e in responseList[1]){
          group[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
        myList = [branch, group];
      }else{
      }
      return myList;
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
  }
}

class LedgerProvider{
  Future<Map<dynamic, dynamic>> getLedgerItem(GetListModel getListModel) async {

    final dio = Dio();
    
    dio.options.headers["Authorization"] = "Bearer ${userToken}";

    final jsonData = jsonEncode(getListModel.toJson());
    var ledger = {};
    try{
      final response = await dio.post(Api.getList, data: jsonData);
      if(response.statusCode == 200){
        final responseList = response.data as List<dynamic>;
        for(final e in responseList[0]){
          ledger[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
      }else{
      }
      return ledger;
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
  }
}


final newLedgerProvider = StateNotifierProvider<NewLedgerProvider, AsyncValue<Map<dynamic, dynamic>>>((ref) => NewLedgerProvider());

class NewLedgerProvider extends StateNotifier<AsyncValue<Map<dynamic, dynamic>>>{
  NewLedgerProvider() : super(const AsyncValue.data({}));

  Future<void> getLedgerItem(GetListModel getListModel) async {

    final dio = Dio();
    
    dio.options.headers["Authorization"] = "Bearer ${userToken}";

    final jsonData = jsonEncode(getListModel.toJson());
    print(jsonData);
    Map<dynamic, dynamic>ledger = {};
    try{
      final response = await dio.post(Api.getList, data: jsonData);
      if(response.statusCode == 200){
        final responseList = response.data;
        for(final e in responseList[0]){
          ledger[ListModel.fromJson(e).text!] = ListModel.fromJson(e).value!;
        }
      }else{
      }
      state = AsyncValue.data(ledger);
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
  }
}



final tableDataProvider = StateNotifierProvider<TableDataProvider, AsyncValue<List<dynamic>>>((ref) => TableDataProvider());

class TableDataProvider extends StateNotifier<AsyncValue<List<dynamic>>>{
  TableDataProvider() : super(const AsyncValue.data([]));

  Future<void> getTableValues(FilterAnyModel2 filterModel) async{
    final dio = Dio();
    
    dio.options.headers["Authorization"] = "Bearer ${userToken}";

    try{
      final jsonData = jsonEncode(filterModel.toJson());
      print(jsonData);
      final response = await dio.post(Api.getTable, data: jsonData);
      if(response.statusCode == 200){
        final result = response.data as List<dynamic>;
        state = AsyncValue.data(result);
      }else{
        print(response.statusCode);
      }
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
  }


  Future<void> getTableValues2(FilterAnyModel2 filterModel) async{
    final dio = Dio();
    
    dio.options.headers["Authorization"] = "Bearer ${userToken}";

    try{
      final jsonData = jsonEncode(filterModel.toJson());
      print(jsonData);
      final response = await dio.post(Api.getTable, data: jsonData);
      if(response.statusCode == 200){
        final result = response.data as List<dynamic>;
        state = AsyncValue.data(result);
      }else{
        print(response.statusCode);
      }
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
  }
}


final modalDataProvider = StateNotifierProvider.autoDispose<ModalDataProvider, AsyncValue<List<dynamic>>>((ref) => ModalDataProvider());

class ModalDataProvider extends StateNotifier<AsyncValue<List<dynamic>>>{
  ModalDataProvider() : super(const AsyncValue.data([]));

  Future<void> getModalTableData(FilterAnyModel2 filterModel) async{
    final dio = Dio();
    
    dio.options.headers["Authorization"] = "Bearer ${userToken}";

    try{
      final jsonData = jsonEncode(filterModel.toJson());
      print(jsonData);
      final response = await dio.post(Api.getTable, data: jsonData);
      if(response.statusCode == 200){
        final result = response.data as List<dynamic>;
        state = AsyncValue.data(result);
      }else{
        print(response.statusCode);
      }
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
  }
}


final ledgerIndividualProvider = FutureProvider.family((ref, FilterAnyModel filterModel) => LedgerIndividualProvider().getTableData(filterModel));

class LedgerIndividualProvider {
  Future<List<dynamic>> getTableData(FilterAnyModel filterModel) async{
    final dio = Dio();
    
    dio.options.headers["Authorization"] = "Bearer ${userToken}";

    try{

      final jsonData = jsonEncode(filterModel.toJson());
      ;
      final response = await dio.post(Api.getTable, data: jsonData);
      if(response.statusCode == 200){
        final result = response.data as List<dynamic>;
        return result;
      }else{
        return [];
      }
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
  }
}






final ledgerVoucherIndividualProvider = FutureProvider.family((ref, FilterAnyModel2 filterModel) => LedgerVoucherIndividualProvider().getTableData(filterModel));

class LedgerVoucherIndividualProvider {
  Future<List<dynamic>> getTableData(FilterAnyModel2 filterModel) async{
    final dio = Dio();
    
    dio.options.headers["Authorization"] = "Bearer ${userToken}";

    try{

      final jsonData = jsonEncode(filterModel.toJson());
      ;
      final response = await dio.post(Api.getTable, data: jsonData);
      if(response.statusCode == 200){
        final result = response.data as List<dynamic>;
        return result;
      }else{
        return [];
      }
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }
  }
}













