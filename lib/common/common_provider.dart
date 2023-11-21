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

  void updateCheck(bool value){
    isChecked = value;
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
  String item2 = 'Primary';
  String ledgerItem = 'All';
  String ledgerItem2 = 'ALL';
  String updateLedgerItem = 'All';
  String updateLedgerItem2 = 'ALL';
  String branchItem = 'All';
  String branchItem3 = 'All';
  String branchItem2 = 'ALL';
  String voucherTypeItem = 'All';
  String statusType = 'All';
  String particularTypeItem = '';
  String fromDate = '';
  String toDate = '';
  String search = '';
  String fiscalYear = '';
  String searchQuery = '';
  int fiscalId = 0;
  int typeData = 1;
  List filteredList = [];
  bool isDetailed = false;
  bool selected = false;
  bool isLoading = false;
  List selectedBankCashList = [];
  List selectedDayBookList = [];
  List selectedVatReportList = [];

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
  void updateSearch(String text){
    searchQuery = text;
    notifyListeners();
  }
  void updateIsDetailed(bool isChecked){
    isDetailed = isChecked;
    notifyListeners();
  }

  void updateIsLoading(bool value){
    isLoading = value;
    notifyListeners();
  }



  void updateSelected(bool isChecked){
    selected = isChecked;
    notifyListeners();
  }

  void updateSelectedBankCashList(List list){
    selectedBankCashList = list;
    notifyListeners();
  }

  void updateSelectedDayBookList(List list){
    selectedDayBookList = list;
    notifyListeners();
  }

  void updateSelectedVatList(List list){
    selectedVatReportList = list;
    notifyListeners();
  }



  void updateTypeData(int text){
    typeData = text;
    notifyListeners();
  }

  void updateSearchText(String text){
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

  void updateItem2(String text){
    item2 = text;
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

