import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loadingProvider = StateNotifierProvider.autoDispose<LoadingProvider, bool>((ref) => LoadingProvider(false));

class LoadingProvider extends StateNotifier<bool>{
  LoadingProvider(super.state);
  void toggle(){
    state = !state;
  }
}


final setListProvider = ChangeNotifierProvider((ref) => LedgerProvider());

class LedgerProvider extends ChangeNotifier{

  List<String> setList(String groupIndex, List<String> data, List<String> newData) {
    switch (groupIndex) {
      case 'All':
        return newData;
      default:
        return data;
    }
  }
}

final checkProvider = ChangeNotifierProvider((ref) => BoolProvider());

class BoolProvider extends ChangeNotifier{
  bool isChecked = false;

  void updateCheck(){
    isChecked = !isChecked;
    notifyListeners();
  }

}


final dashBoardTypeProvider = StateNotifierProvider((ref) => DashboardType());

class DashboardType extends StateNotifier<String> {
  DashboardType() : super('Financial'); /// Set the initial state to 'Financial'

  void changeDashboardType(String boardType) {
    state = boardType; /// Update the state with the new string
  }
}



final itemProvider = ChangeNotifierProvider.autoDispose((ref) => GroupItem());
final ledgerIProvider = ChangeNotifierProvider.autoDispose((ref) => GroupItem());
final branchIProvider = ChangeNotifierProvider.autoDispose((ref) => GroupItem());
final updateLedgerProvider = ChangeNotifierProvider.autoDispose((ref) => GroupItem());
final updateTypeProvider = ChangeNotifierProvider.autoDispose((ref) => GroupItem());

class GroupItem extends ChangeNotifier{
  int mainIndex = 0;
  int index = 0;
  int ledgerIndex = 0;
  String trialBalanceType = "Group";
  String item = 'All';
  String ledgerItem = 'All';
  String ledgerItem2 = 'ALL';
  String updateLedgerItem = 'All';
  String updateLedgerItem2 = 'ALL';
  String branchItem = 'All';
  String branchItem3 = 'Select a branch';
  String branchItem2 = 'ALL';
  String voucherTypeItem = 'All';
  String statusType = 'All';
  String particularTypeItem = 'All';
  String fromDate = '';
  String toDate = '';
  String search = '';
  String fiscalYear = '';
  int fiscalId = 0;
  int typeData = 1;
  List filteredList = [];
  bool isDetailed = false;
  bool selected = false;
  List selectedList = [];

  void updateIndex(int text){
    mainIndex = text;
    notifyListeners();
  }
  void updateIndex2(int text){
    index = text;
    notifyListeners();
  }

  void updateIndex3(int text){
    ledgerIndex = text;
    notifyListeners();
  }


  void updateTrialBalanceType(String text){
    trialBalanceType = text;
    notifyListeners();
  }
  void updateIsDetailed(bool isChecked){
    isDetailed = isChecked;
    notifyListeners();
  }

  void updateSelected(bool isChecked){
    selected = isChecked;
    notifyListeners();
  }

  void updateSelectedList(List list){
    selectedList = list;
    notifyListeners();
  }




  void updateTypeData(int text){
    typeData = text;
    notifyListeners();
  }

  void updateSearch(String text){
    search = text;
    notifyListeners();
  }

  void updateFiscalYear(String text){
    fiscalYear = text;
    notifyListeners();
  }

  void updateFiscalId(int text){
    fiscalId = text;
    notifyListeners();
  }

  void updateFromDate(String text){
    fromDate = text;
    notifyListeners();
  }

  void updateToDate(String text){
    toDate = text;
    notifyListeners();
  }

  void updateList(List list){
    filteredList = list;
    notifyListeners();
  }


  void updateStatusType(String text){
    statusType = text;
    notifyListeners();
  }

  void updateVoucherType(String text){
    voucherTypeItem = text;
    notifyListeners();
  }

  void updateParticularType(String text){
    particularTypeItem = text;
    notifyListeners();
  }


  void updateItem(String text){
    item = text;
    notifyListeners();
  }

  void updateLedger(String text){
    ledgerItem = text;
    notifyListeners();
  }

  void updateLedger2(String text){
    ledgerItem2 = text;
    notifyListeners();
  }

  void updateBranch(String text){
    branchItem= text;
    notifyListeners();
  }
  void updateBranch2(String text){
    branchItem2= text;
    notifyListeners();
  }

  void updateBranch3(String text){
    branchItem3= text;
    notifyListeners();
  }

  void changeItem(String value){
    updateLedgerItem = value;
    notifyListeners();
  }

}

