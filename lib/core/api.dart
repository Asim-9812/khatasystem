class Api {


  // static const baseUrl = 'https://api.khatasystem.com'; // LIVE KHATA SYSTEM
  static const baseUrl = 'http://202.51.74.138:88'; // LIVE KHATA SYSTEM

  // static const baseUrl = 'http://202.51.74.138:5017'; // DEMO KHATA SYSTEM


  static const userLogin = '$baseUrl/api/LoginAPI/Login';
  static const companyInfo = '$baseUrl/api/CompanyInfo/ListCompany';
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
  static const getLoginActivities = '$baseUrl/api/ActivityLog/GetUserLoginLog';
  static const getTransactionActivities = '$baseUrl/api/ActivityLog/GetEntryMasterLog';
  static const getDashBoardAmount = '$baseUrl/api/MyFunction/DashBoardAccountGroupwithsub';
  static const getSubList = '$baseUrl/api/MyFunction/GetList_Report';
  static const getNotification = '$baseUrl/api/GlobalNotification';
  static const getFiscalYear = '$baseUrl/api/FiscalYear/Getall';
  static const getLedgerList = '$baseUrl/api/BankCash/LedgerList_BankCash';




  //POS (khata inventory)....
  static const baseInventoryUrl = 'https://inventory.khatasystem.com/api'; // LIVE KHATA INVENTORY
  // static const baseInventoryUrl = 'http://202.51.74.138:6200/api/Sales'; // LIVE KHATA INVENTORY
  // static const baseInventoryUrl = 'http://202.51.74.138:5018/api/Sales'; // DEMO KHATA INVENTORY


  static const getPOSSettings = '$baseInventoryUrl/Sales/GetPOSSettings';
  static const getProductList = '$baseInventoryUrl/Sales/GetProductByCodePOS';
  static const getBatchOfProduct = '$baseInventoryUrl/Sales/GetProductByCode';
  static const getUnitByBatch = '$baseInventoryUrl/Sales/GetUnitByBatch';
  static const getRateByBatch = '$baseInventoryUrl/Sales/GetUnitByBatch';
  static const getReceivedLedgerList = '$baseInventoryUrl/Sales/RecievedLedger';
  static const getCustomerList = '$baseInventoryUrl/Sales/Customer';
  static const getVoucherNo = '$baseInventoryUrl/Sales/GetSuffixPrefix';
  static const getConversionFactor = '$baseInventoryUrl/Sales/GetMissingUnitConversionFact';
  static const addDraftPOS = '$baseInventoryUrl/Sales/AddSalesMasterDetailsPOS';
  static const loadSalesDraft = '$baseInventoryUrl/Sales/AddSalesMasterDetailsPOS';
  static const addTransactionSalesLedgerPOS = '$baseInventoryUrl/Sales/AddTransactionSalesLedgerPOS';
  static const addSalesAllocation = '$baseInventoryUrl/Sales/AddSalesItemAllocation';
  static const loadDraftPOS = '$baseInventoryUrl/Sales/LoadSalesMasterDetails';
  static const delDraftPOS = '$baseInventoryUrl/Sales/DeleteSalesDraftTable';
  static const deleteDraftItems = '$baseInventoryUrl/Sales/DeleteSalesMasterDraftEntry';
  static const insertReceivedAmount = '$baseInventoryUrl/Sales/InsertSalesTransactionDraft';
  static const getReceivedAmount = '$baseInventoryUrl/Sales/GetSalesTransactionList';
  static const delReceivedAmount = '$baseInventoryUrl/Sales/DeleteTransactionSalesLedger';
  static const insertCustomerInfo = '$baseInventoryUrl/Sales/InsertSalesInfoDrafts';
  static const finalSavePOS = '$baseInventoryUrl/Sales/AddAllMasterTablePOS';
  static const updateSalesMasterEntry = '$baseInventoryUrl/Sales/UpdateSalesEntryMaster';
  static const loadSMDFStockPosting = '$baseInventoryUrl/Sales/LoadSalesMasterDetailsforStockPosting';
  static const getSalesTransactionCrDrList = '$baseInventoryUrl/Sales/GetSalesTransactionCrDrList';
  static const getSuffixPrefix = '$baseInventoryUrl/Sales/GetSuffixPrefix';
  static const salesLedgerTransactionPosting = '$baseInventoryUrl/Sales/SalesLedgerTransactionPosting';
  static const printCountPOS = '$baseUrl/api/MasterPrint/InsertMasterPrintIRD';
  static const printPOS = '$baseInventoryUrl/Sales/PrintPOSReceipt';




  //track product....
  static const baseTrackUrl = 'https://inventory.khatasystem.com/api'; // LIVE KHATA INVENTORY

  // static const baseTrackUrl = 'http://202.51.74.138:5018/api'; // DEMO KHATA INVENTORY


  static const getBranchList = '$baseTrackUrl/TrackProduct/GetAllBranchList';
  static const getTokenList = '$baseTrackUrl/TrackProduct/GetTokenList';
  static const getTrackList = '$baseTrackUrl/TrackProduct/GetTrackProductList';



  //IRD REPORT...
  static const getIRDReport = '$baseInventoryUrl/SalesBook/GetSalesBook';
  static const getIRDDetails = '$baseInventoryUrl/SalesBook/GetIRDBookDetails';
  static const getIRDDetailsPurchase = '$baseInventoryUrl/SalesBook/GetIRDDetailsPurchase';
  static const salesReprint = '$baseInventoryUrl/SalesBook/PrintSalesReport';
  static const salesReturnReprint = '$baseInventoryUrl/SalesBook/PrintSalesReturnReport';
  static const purchaseReprint = '$baseInventoryUrl/SalesBook/PrintPurchaseReport';
  static const purchaseReturnReprint = '$baseInventoryUrl/SalesBook/PrintPurchaseReturnReport';



}


/// swagger demo inventory = "http://202.51.74.138:5009/swagger/index.html"