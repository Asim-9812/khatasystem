class Api {






  // static const baseUrl = 'http://202.51.74.138:88'; // LIVE KHATA SYSTEM

  static const baseUrl = 'http://202.51.74.138:5017'; // DEMO KHATA SYSTEM


  static const userLogin = '$baseUrl/api/LoginAPI/Login';
  static const inquiryForm = '$baseUrl/api/LoginAPI/Inquiry';
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

  //POS (khata inventory)....
  static const baseInventoryUrl = 'http://202.51.74.138:5009/api/Sales'; // DEMO KHATA INVENTORY
  static const getPOSSettings = '$baseInventoryUrl/GetPOSSettings';
  static const getProductList = '$baseInventoryUrl/GetProductByCodePOS';
  static const getBatchOfProduct = '$baseInventoryUrl/GetProductByCode';
  static const getUnitByBatch = '$baseInventoryUrl/GetUnitByBatch';
  static const getRateByBatch = '$baseInventoryUrl/GetUnitByBatch';
  static const getReceivedLedgerList = '$baseInventoryUrl/RecievedLedger';
  static const getCustomerList = '$baseInventoryUrl/Customer';
  static const getVoucherNo = '$baseInventoryUrl/GetSuffixPrefix';
  static const getConversionFactor = '$baseInventoryUrl/GetMissingUnitConversionFact';
  static const addDraftPOS = '$baseInventoryUrl/AddSalesMasterDetailsPOS';
  static const loadSalesDraft = '$baseInventoryUrl/AddSalesMasterDetailsPOS';
  static const addTransactionSalesLedgerPOS = '$baseInventoryUrl/AddTransactionSalesLedgerPOS';
  static const addSalesAllocation = '$baseInventoryUrl/AddSalesItemAllocation';
  static const loadDraftPOS = '$baseInventoryUrl/LoadSalesMasterDetails';
  static const delDraftPOS = '$baseInventoryUrl/DeleteSalesDraftTable';
  static const deleteDraftItems = '$baseInventoryUrl/DeleteSalesMasterDraftEntry';
  static const insertReceivedAmount = '$baseInventoryUrl/InsertSalesTransactionDraft';
  static const getReceivedAmount = '$baseInventoryUrl/GetSalesTransactionList';
  static const delReceivedAmount = '$baseInventoryUrl/DeleteTransactionSalesLedger';
  static const insertCustomerInfo = '$baseInventoryUrl/InsertSalesInfoDrafts';
  static const finalSavePOS = '$baseInventoryUrl/AddAllMasterTablePOS';
  static const updateSalesMasterEntry = '$baseInventoryUrl/UpdateSalesEntryMaster';
  static const loadSMDFStockPosting = '$baseInventoryUrl/LoadSalesMasterDetailsforStockPosting';
  static const getSalesTransactionCrDrList = '$baseInventoryUrl/GetSalesTransactionCrDrList';
  static const getSuffixPrefix = '$baseInventoryUrl/GetSuffixPrefix';
  static const salesLedgerTransactionPosting = '$baseInventoryUrl/SalesLedgerTransactionPosting';
  static const printPOS = '$baseInventoryUrl/PrintPOSReceipt';



}


/// swagger demo inventory = "http://202.51.74.138:5009/swagger/index.html"