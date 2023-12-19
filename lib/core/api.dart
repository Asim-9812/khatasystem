class Api {





  static const baseUrl = 'http://202.51.74.138:88';

  static const userLogin = '$baseUrl/api/LoginAPI/Login';
  static const getMenu = '$baseUrl/api/Menu/GetMenuOfAppbyId';
  static const getList = '$baseUrl/api/CommonReport/GetallList_Rep';
  static const getTrialProfitBlcList = '$baseUrl/api/GetList/GetListForTBPLBS';
  static const getSupplierLedgerList = '$baseUrl/api/GetList/GetSupplierLedgerList';
  static const getCustomerLedgerList = '$baseUrl/api/GetList/GetCustomerLedgerList';
  static const getLedgerReportList = '$baseUrl/api/GetList/GetLedgerReportList';
  static const getVoucherList = '$baseUrl/api/GetList/GetVoucherReportList';
  static const getTable = '$baseUrl/api/CommonReport/GetFilterAnyDataPaginationReport';
  static const getModalTable = '$baseUrl/api/CommonReport/GetFilterAnyDataPaginationReport';
  static const getLoginActivities = '$baseUrl/api/ActivityLog/GetLoginActivity';
  static const getTransactionActivities = '$baseUrl/api/ActivityLog/GetEntryMasterLog';
  static const getDashBoardAmount = '$baseUrl/api/MyFunction/DashBoardAccountGroupwithsub';
  static const getSubList = '$baseUrl/api/MyFunction/GetList_Report';
  static const getNotification = '$baseUrl/api/GlobalNotification';
  static const getFiscalYear = '$baseUrl/api/FiscalYear/Getall';
  static const getLedgerList = '$baseUrl/api/BankCash/LedgerList_BankCash';
}
