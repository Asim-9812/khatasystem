



import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:khata_app/features/dashboard/presentation/home_screen.dart';
import 'package:khata_app/features/pos/presentation/received_amount_table.dart';
import 'package:khata_app/features/pos/presentation/receipt_page.dart';
import '../../../../common/colors.dart';
import '../../../../common/snackbar.dart';
import '../domain/model/pos_model.dart';
import '../domain/services/pos_services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';



class POS extends ConsumerStatefulWidget {
  final List<PosSettingsModel> posSettings;
  POS({required this.posSettings});

  @override
  ConsumerState<POS> createState() => _POSState();
}

class _POSState extends ConsumerState<POS> {


  final  _productFormKey = GlobalKey<FormState>();
  final _customerFormKey = GlobalKey<FormState>();
  final _receivedFormKey = GlobalKey<FormState>();


  final TextEditingController _productCodeController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _netTotalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _receivedAmountController = TextEditingController();


  ///customer details...
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  String customerName = 'Cash';

  ///customer details...end


  String? productCode;
  String? productName;
  double? productRate;
  String? productUnit;

  double? quantityValue;
  double? netTotalValue;

  double? totalBill;

  ProductModel? addProduct ;

  bool isPostingDraft = false;
  bool isPostingReceivedAmount = false;
  bool isPostingFinalData = false;


  List<Map<String, dynamic>> addedProducts = [];

  bool disabledFields = true;

  Map<String,dynamic> setCustomerInfo = {};

  late String locationId;
  late String salesAccountId;

  late List<PosSettingsModel> posSettingsModel;
  
  
  late PosSettingsModel posSettingsLocation;
  late PosSettingsModel posSettingsSales;
  late PosSettingsModel posSettingsReceivedLedger;

  POSLedgerModel? selectedReceivedLedger;

  
  @override
  void initState(){
    super.initState();
    posSettingsModel = widget.posSettings;
    posSettingsLocation = posSettingsModel.firstWhere((element) => element.fieldName.toLowerCase() == 'location');
    posSettingsSales = posSettingsModel.firstWhere((element) => element.fieldName.toLowerCase() == 'sales ledger');
    posSettingsReceivedLedger = posSettingsModel.firstWhere((element) => element.fieldName.toLowerCase() == 'received ledger');
    locationId = posSettingsLocation.defaultValue;
    salesAccountId = posSettingsSales.defaultValue;
    _customerNameController.text = customerName;

  }





  double calculateTotalRate(List<DraftModel> addedProduct,double amount) {
    double totalRate = 0.0;

    for (var product in addedProduct) {
      totalRate += product.netAmt;
    }

    totalBill = totalRate;



    return totalRate.toPrecision(2);
  }




  void _exitDialog() async {
    await showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Confirm Exit',style: TextStyle(color: ColorManager.black),),
            backgroundColor: ColorManager.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Do you want to exit?',style: TextStyle(fontSize: 16),),
                const SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.primary
                      ),
                        onPressed: (){
                        ref.invalidate(voucherProvider);
                        Navigator.pop(context);
                        Navigator.pop(context,true);
                        },
                        child: Text('Yes',style: TextStyle(color: ColorManager.white),)
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.errorRed
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text('No',style: TextStyle(color: ColorManager.white),)
                    )
                  ],
                )

              ],
            ),
          );
        }
    );
  }




  @override
  Widget build(BuildContext context) {

    final productList = ref.watch(productProvider(locationId));
    final voucherData = ref.watch(voucherProvider);
    final receivedLedgerData = ref.watch(receivedLedgerProvider);
    final customerListData = ref.watch(customerListProvider);



    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async {
          _exitDialog();
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorManager.primary,
            centerTitle: true,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
             _exitDialog();
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 28,
                color: Colors.white,
              ),
            ),
            title: const Text('POS'),
            titleTextStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            toolbarHeight: 70,
          ),
          body: voucherData.when(
              data: (voucherNo){
                final loadDraftData = ref.watch(draftProvider(voucherNo));
                return productList.when(
                    data: (data){
                      if(data.isEmpty){
                        return Center(
                          child: Text('No Products found',style: TextStyle(color: ColorManager.black,fontWeight: FontWeight.bold),),
                        );
                      }
                      else{
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:const EdgeInsets.symmetric(horizontal: 10),
                                child: Form(
                                  key: _productFormKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _productCodeController,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color: ColorManager.primary
                                                )
                                            ),

                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color: ColorManager.primary
                                                )
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color: ColorManager.primary
                                                )
                                            ),
                                            labelText: 'Product Code',
                                            labelStyle: TextStyle(color: ColorManager.primary)
                                        ),
                                        onChanged: (value){
                                          setState(() {
                                            _productCodeController.text = value;
                                            productCode = value;
                                          });
                                        },
                                        onFieldSubmitted: (value){
                                          final scaffoldMessage = ScaffoldMessenger.of(context);
                                          final product = data.firstWhereOrNull((element) => element.productCode!.toLowerCase() == _productCodeController.text.toLowerCase().trim());
                                          if(product != null){
                                            setState(() {
                                              addProduct = product;
                                              productName = '${product.productName} (${(product.qty! < 0? 0 : product.qty)} ${product.mainunit})';
                                              productRate = product.salesRate;
                                              productUnit = product.mainunit;
                                              productCode = product.productCode;
                                              _productCodeController.text = product.productCode!;
                                              _rateController.text = product.salesRate.toString();
                                              _unitController.text = product.mainunit!;
                                              disabledFields = false;
                                            });
                                          }
                                          else{

                                            scaffoldMessage.showSnackBar(
                                              SnackbarUtil.showFailureSnackbar(
                                                message: 'Product not found.',
                                                duration: const Duration(milliseconds: 1400),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                      const SizedBox(
                                        height: 18,
                                      ),
                                      DropdownSearch<String>(

                                        items: data.map((e) => '${e.productName} (${(e.qty! < 0? 0 : e.qty)} ${e.mainunit})'.toString()).toList(),
                                        selectedItem: productName,
                                        dropdownDecoratorProps:
                                        DropDownDecoratorProps(

                                          baseStyle: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                          dropdownSearchDecoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color: ColorManager.primary
                                                )
                                            ),

                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color: ColorManager.primary
                                                )
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color: ColorManager.primary
                                                )
                                            ),
                                            contentPadding: const EdgeInsets.all(15),

                                            floatingLabelStyle: TextStyle(
                                                color: ColorManager.primary),
                                            labelText: 'Product Name',
                                            labelStyle: TextStyle(color: ColorManager.primary),
                                          ),
                                        ),
                                        validator: (value){
                                          if(value== null){
                                            return 'Please select a product';
                                          }
                                          return null;
                                        },
                                        autoValidateMode: AutovalidateMode.onUserInteraction,
                                        popupProps: const PopupProps.menu(
                                          showSearchBox: true,
                                          fit: FlexFit.loose,
                                          constraints: BoxConstraints(maxHeight: 250),
                                          showSelectedItems: true,
                                          searchFieldProps: TextFieldProps(
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        onChanged: (dynamic value) {
                                          if(value != null){
                                            final product = data.firstWhere((e) => '${e.productName} (${(e.qty! < 0? 0 : e.qty) } ${e.mainunit})'==value);
                                            setState(() {
                                              addProduct = product;
                                              productName = value;
                                              productRate = product.salesRate!.toPrecision(2);
                                              productUnit = product.mainunit;
                                              productCode = product.productCode;
                                              _productCodeController.text = product.productCode!;
                                              _rateController.text = product.salesRate!.toPrecision(2).toString();
                                              _unitController.text = product.mainunit.toString();
                                              disabledFields = false;
                                              _quantityController.clear();
                                              _netTotalController.clear();

                                            });
                                          }

                                        },
                                      ),
                                      const SizedBox(
                                        height: 18,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: AbsorbPointer(
                                              child: TextFormField(
                                                controller: _rateController,
                                                decoration: InputDecoration(
                                                    fillColor: ColorManager.black.withOpacity(0.1),
                                                    filled: true,
                                                    border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        borderSide: BorderSide(
                                                            color: ColorManager.primary
                                                        )
                                                    ),

                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        borderSide: BorderSide(
                                                            color: ColorManager.primary
                                                        )
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        borderSide: BorderSide(
                                                            color: ColorManager.primary
                                                        )
                                                    ),
                                                    labelText: 'Rate',
                                                    labelStyle: TextStyle(color: ColorManager.primary)
                                                ),

                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text('per',style: TextStyle(color: ColorManager.black,fontSize: 18),),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: AbsorbPointer(
                                              child: TextFormField(
                                                controller: _unitController,
                                                decoration: InputDecoration(
                                                    fillColor: ColorManager.black.withOpacity(0.1),
                                                    filled: true,
                                                    border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        borderSide: BorderSide(
                                                            color: ColorManager.primary
                                                        )
                                                    ),

                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        borderSide: BorderSide(
                                                            color: ColorManager.primary
                                                        )
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        borderSide: BorderSide(
                                                            color: ColorManager.primary
                                                        )
                                                    ),
                                                    labelText: 'Unit',
                                                    labelStyle: TextStyle(color: ColorManager.primary)
                                                ),

                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 18,
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: AbsorbPointer(
                                              absorbing: disabledFields,
                                              child: TextFormField(
                                                controller: _quantityController,
                                                decoration: InputDecoration(

                                                    fillColor: disabledFields ? ColorManager.black.withOpacity(0.1) :ColorManager.white,
                                                    filled: true,
                                                    border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        borderSide: BorderSide(
                                                            color: ColorManager.primary
                                                        )
                                                    ),

                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        borderSide: BorderSide(
                                                            color: ColorManager.primary
                                                        )
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        borderSide: BorderSide(
                                                            color: ColorManager.primary
                                                        )
                                                    ),
                                                    labelText: 'Quantity',
                                                    labelStyle: TextStyle(color: ColorManager.primary)
                                                ),

                                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return 'Please enter a quantity';
                                                  }
                                                  // Try parsing as int
                                                  try {
                                                    int.parse(value);
                                                    return null; // Return null if it's a valid integer
                                                  } catch (e) {
                                                    // If parsing as int fails, try parsing as double
                                                    try {
                                                      double.parse(value);
                                                      return null; // Return null if it's a valid double
                                                    } catch (e) {
                                                      return 'Enter a valid number';
                                                    }
                                                  }
                                                },

                                                onChanged:(value){
                                                  if(productRate !=null){
                                                    double total = double.parse(value) * productRate!;
                                                    setState(() {
                                                      _netTotalController.text = total.toPrecision(2).toString();
                                                      netTotalValue = total;
                                                      quantityValue = double.parse(value);
                                                    });
                                                  }



                                                },

                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: AbsorbPointer(
                                              absorbing: disabledFields,
                                              child: TextFormField(
                                                  controller: _netTotalController,
                                                  decoration: InputDecoration(

                                                      fillColor: disabledFields ? ColorManager.black.withOpacity(0.1) :ColorManager.white,
                                                      filled: true,
                                                      border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                          borderSide: BorderSide(
                                                              color: ColorManager.primary
                                                          )
                                                      ),

                                                      enabledBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                          borderSide: BorderSide(
                                                              color: ColorManager.primary
                                                          )
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                          borderSide: BorderSide(
                                                              color: ColorManager.primary
                                                          )
                                                      ),
                                                      labelText: 'Net Total',
                                                      labelStyle: TextStyle(color: ColorManager.primary)
                                                  ),

                                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                                  validator: (value) {
                                                    if (value == null || value.isEmpty) {
                                                      return 'Please enter a quantity';
                                                    }

                                                    // Try parsing as int
                                                    try {
                                                      int.parse(value);
                                                      return null; // Return null if it's a valid integer
                                                    } catch (e) {
                                                      // If parsing as int fails, try parsing as double
                                                      try {
                                                        double.parse(value);
                                                        return null; // Return null if it's a valid double
                                                      } catch (e) {
                                                        return 'Enter a valid number';
                                                      }
                                                    }
                                                  },

                                                  onChanged:(value){
                                                    if(productRate !=null){
                                                      double quantity = double.parse(value) / productRate!;
                                                      setState(() {
                                                        _quantityController.text = quantity.toPrecision(1).toString();
                                                        quantityValue = quantity;
                                                        netTotalValue = double.parse(value);
                                                      });

                                                    }


                                                  }

                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          loadDraftData.when(
                                              data: (loadDrafts){
                                                if(loadDrafts.isNotEmpty){
                                                  final id = loadDrafts.first.salesMasterID;
                                                  final amountReceived = ref.watch(receivedTotalAmountProvider(id));
                                                  return amountReceived.when(
                                                      data: (isAmountReceived){
                                                        return Row(
                                                          children: [
                                                            IconButton(
                                                                style: IconButton.styleFrom(
                                                                    backgroundColor: ColorManager.primary,
                                                                    disabledBackgroundColor: ColorManager.textGray,
                                                                    shape: ContinuousRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(10)
                                                                    )
                                                                ),
                                                                onPressed:isAmountReceived > 0 ? null : isPostingDraft? null :() async {
                                                                  // final scaffoldMessage = ScaffoldMessenger.of(context);
                                                                  if(_productFormKey.currentState!.validate()) {

                                                                    if(addProduct !=null){
                                                                      setState(() {
                                                                        isPostingDraft = true;
                                                                      });
                                                                      DraftModel addDraft = DraftModel(
                                                                          additionalIncomeAmt: 0,
                                                                          batch: addProduct!.batch!,
                                                                          billAdjustment: 0,
                                                                          billDiscAmt: 0,
                                                                          billDiscountAmt: 0,
                                                                          billDiscountPercent: 0,
                                                                          branchID: branchId,
                                                                          challanDetailsID: 0,
                                                                          challanMasterID: 0,
                                                                          chargeAmt: 0,
                                                                          customerID: 2,
                                                                          customerName: '',
                                                                          entryDate: DateFormat('yyyy-MM-ddThh:mm:ss').format(DateTime.now()),
                                                                          expiryDate: addProduct?.expirydate,
                                                                          extra1: '0',
                                                                          extra2: '0',
                                                                          financialYearID: financialYearId,
                                                                          grossAmt: double.parse(_netTotalController.text.trim()),
                                                                          isDraft: false,
                                                                          isExport: false,
                                                                          itemDiscount: 0,
                                                                          itemDiscountAmt: 0,
                                                                          itemDiscountPercent: 0,
                                                                          manualRefNo: '0',
                                                                          netAmt: double.parse(_netTotalController.text.trim()),
                                                                          netBillAmt: double.parse(_netTotalController.text.trim()),
                                                                          narration: "0",
                                                                          nonTaxableAmt: 0,
                                                                          orderDetailsID: 0,
                                                                          otherTaxAmt: 0,
                                                                          pricingLevelID: 0,
                                                                          productID: addProduct!.productId!,
                                                                          productUnitID: 0,
                                                                          qty: double.parse(_quantityController.text.trim()),
                                                                          rate: addProduct!.salesRate!,
                                                                          refererID: 0,
                                                                          salesAccountID: int.parse(salesAccountId),
                                                                          salesDetailsDraftID: 0,
                                                                          salesMasterID: 0,
                                                                          salesOrderMasterID: 0,
                                                                          sku: addProduct!.fromUnitId!,
                                                                          skuUnitCost: 0,
                                                                          status: true,
                                                                          stockqty: (int.parse(_quantityController.text.trim()) * addProduct!.conversionFactor!),
                                                                          taxableAmt: double.parse(_netTotalController.text.trim()),
                                                                          transactionMode: 1,
                                                                          transactionUnitCost: double.parse(_netTotalController.text.trim()),
                                                                          transactionUnitID: addProduct!.fromUnitId!,
                                                                          updatedBy: 0,
                                                                          updatedDate: DateFormat('yyyy-MM-ddThh:mm:ss').format(DateTime.now()),
                                                                          userID: userId2,
                                                                          vat: 0,
                                                                          vatAmt: 0,
                                                                          voucherDate: DateFormat('yyyy-MM-ddThh:mm:ss').format(DateTime.now()),
                                                                          voucherNo: voucherNo,
                                                                          vouchertypeID: 19
                                                                      );
                                                                      SalesItemAllocationModel item = SalesItemAllocationModel(
                                                                          locationDetailsID: 0,
                                                                          voucherTypeID: 19,
                                                                          masterID: 0,
                                                                          detailsID: 0,
                                                                          productID: addProduct!.productId!,
                                                                          locationID: int.parse(locationId),
                                                                          qty: double.parse(_quantityController.text.trim()),
                                                                          unitID: addProduct!.fromUnitId!,
                                                                          batch: addProduct!.batch!,
                                                                          expiryDate: addProduct?.expirydate,
                                                                          stockQty: (int.parse(_quantityController.text.trim()) * addProduct!.conversionFactor!),
                                                                          extra1: voucherNo,
                                                                          flag: 2,
                                                                          userID: 0,
                                                                          entryDate: DateFormat('yyyy-MM-ddThh:mm:ss').format(DateTime.now())
                                                                      );

                                                                      final response = await POSServices().addSalesDraftPos(newDraft: addDraft,itemAllocation: item,voucherNo: voucherNo,salesLedgerId: int.parse(salesAccountId));

                                                                      if(response.isLeft()){
                                                                        final leftValue = response.fold((l) => l, (r) => null);
                                                                        Fluttertoast.showToast(
                                                                          msg: '$leftValue',
                                                                          gravity: ToastGravity.BOTTOM,
                                                                          backgroundColor: ColorManager.errorRed.withOpacity(0.9),
                                                                          textColor: Colors.white,
                                                                          fontSize: 16.0,
                                                                        );
                                                                        setState(() {
                                                                          isPostingDraft = false;
                                                                        });
                                                                      }
                                                                      else{
                                                                        ref.refresh(draftProvider(voucherNo));
                                                                        ref.refresh(productProvider(locationId));
                                                                        Fluttertoast.showToast(
                                                                          msg: 'Draft added',
                                                                          gravity: ToastGravity.BOTTOM,
                                                                          backgroundColor: ColorManager.green.withOpacity(0.9),
                                                                          textColor: Colors.white,
                                                                          fontSize: 16.0,
                                                                        );


                                                                        setState(() {
                                                                          isPostingDraft = false;
                                                                          addProduct = null;
                                                                          productName = null;
                                                                          productRate = null;
                                                                          productUnit = null;
                                                                          quantityValue = null;
                                                                          netTotalValue = null;
                                                                          productCode = null;
                                                                          _rateController.clear();
                                                                          _unitController.clear();
                                                                          _rateController.clear();
                                                                          _unitController.clear();
                                                                          _quantityController.clear();
                                                                          _netTotalController.clear();
                                                                          _productCodeController.clear();
                                                                          _receivedAmountController.clear();
                                                                          disabledFields = true;
                                                                        });


                                                                        await Future.delayed(const Duration(milliseconds: 100));

                                                                        _productFormKey.currentState!.reset();
                                                                      }

                                                                    }
                                                                    // Map<String, dynamic> newProduct = {
                                                                    //   'productCode': productCode,
                                                                    //   'productName': productName,
                                                                    //   'rate': productRate,
                                                                    //   'unit': productUnit,
                                                                    //   'quantity': quantityValue,
                                                                    //   'netTotal': netTotalValue
                                                                    // };
                                                                    //





                                                                  }
                                                                },
                                                                icon: isPostingDraft? CircularProgressIndicator(color: ColorManager.primary,):FaIcon(Icons.add,color: ColorManager.white,)
                                                            ),

                                                            IconButton(
                                                                style: IconButton.styleFrom(
                                                                    backgroundColor: ColorManager.errorRed,
                                                                    shape: ContinuousRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(10)
                                                                    )
                                                                ),
                                                                onPressed:() async {
                                                                  setState(() {
                                                                    addProduct = null;
                                                                    productName = null;
                                                                    productRate = null;
                                                                    productUnit = null;
                                                                    quantityValue = null;
                                                                    netTotalValue = null;
                                                                    productCode = null;
                                                                    _rateController.clear();
                                                                    _unitController.clear();
                                                                    _rateController.clear();
                                                                    _unitController.clear();
                                                                    _quantityController.clear();
                                                                    _netTotalController.clear();
                                                                    _productCodeController.clear();
                                                                    _receivedAmountController.clear();
                                                                    disabledFields = true;
                                                                  });

                                                                  await Future.delayed(const Duration(milliseconds: 100));

                                                                  _productFormKey.currentState!.reset();





                                                                },
                                                                icon: FaIcon(Icons.refresh,color: ColorManager.white,)
                                                            )
                                                          ],
                                                        );
                                                      },
                                                      error: (error,stack)=>const SizedBox(),
                                                      loading: ()=>CircularProgressIndicator(color: ColorManager.primary,)
                                                  );
                                                }
                                                else{
                                                  return Row(
                                                    children: [
                                                      IconButton(
                                                          style: IconButton.styleFrom(
                                                              backgroundColor: ColorManager.primary,
                                                              disabledBackgroundColor: ColorManager.textGray,
                                                              shape: ContinuousRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(10)
                                                              )
                                                          ),
                                                          onPressed:isPostingDraft? null :() async {
                                                            // final scaffoldMessage = ScaffoldMessenger.of(context);
                                                            if(_productFormKey.currentState!.validate()) {

                                                              if(addProduct !=null){
                                                                setState(() {
                                                                  isPostingDraft = true;
                                                                });
                                                                print('this is ${addProduct!.productId!}');
                                                                DraftModel addDraft = DraftModel(
                                                                    additionalIncomeAmt: 0,
                                                                    batch: addProduct!.batch!,
                                                                    billAdjustment: 0,
                                                                    billDiscAmt: 0,
                                                                    billDiscountAmt: 0,
                                                                    billDiscountPercent: 0,
                                                                    branchID: branchId,
                                                                    challanDetailsID: 0,
                                                                    challanMasterID: 0,
                                                                    chargeAmt: 0,
                                                                    customerID: 2,
                                                                    customerName: '',
                                                                    entryDate: DateFormat('yyyy-MM-ddThh:mm:ss').format(DateTime.now()),
                                                                    expiryDate: DateFormat('yyyy-MM-ddThh:mm:ss').format(DateTime.now()),
                                                                    extra1: '0',
                                                                    extra2: '0',
                                                                    financialYearID: financialYearId,
                                                                    grossAmt: double.parse(_netTotalController.text.trim()),
                                                                    isDraft: false,
                                                                    isExport: false,
                                                                    itemDiscount: 0,
                                                                    itemDiscountAmt: 0,
                                                                    itemDiscountPercent: 0,
                                                                    manualRefNo: '0',
                                                                    netAmt: double.parse(_netTotalController.text.trim()),
                                                                    netBillAmt: double.parse(_netTotalController.text.trim()),
                                                                    narration: "0",
                                                                    nonTaxableAmt: 0,
                                                                    orderDetailsID: 0,
                                                                    otherTaxAmt: 0,
                                                                    pricingLevelID: 0,
                                                                    productID: addProduct!.productId!,
                                                                    productUnitID: 0,
                                                                    qty: double.parse(_quantityController.text.trim()),
                                                                    rate: addProduct!.salesRate!,
                                                                    refererID: 0,
                                                                    salesAccountID: int.parse(salesAccountId),
                                                                    salesDetailsDraftID: 0,
                                                                    salesMasterID: 0,
                                                                    salesOrderMasterID: 0,
                                                                    sku: addProduct!.fromUnitId!,
                                                                    skuUnitCost: 0,
                                                                    status: true,
                                                                    stockqty: (double.parse(_quantityController.text.trim()) * addProduct!.conversionFactor!),
                                                                    taxableAmt: double.parse(_netTotalController.text.trim()),
                                                                    transactionMode: 1,
                                                                    transactionUnitCost: double.parse(_netTotalController.text.trim()),
                                                                    transactionUnitID: addProduct!.fromUnitId!,
                                                                    updatedBy: 0,
                                                                    updatedDate: DateFormat('yyyy-MM-ddThh:mm:ss').format(DateTime.now()),
                                                                    userID: userId2,
                                                                    vat: 0,
                                                                    vatAmt: 0,
                                                                    voucherDate: DateFormat('yyyy-MM-ddThh:mm:ss').format(DateTime.now()),
                                                                    voucherNo: voucherNo,
                                                                    vouchertypeID: 19
                                                                );

                                                                SalesItemAllocationModel item = SalesItemAllocationModel(
                                                                    locationDetailsID: 0,
                                                                    voucherTypeID: 19,
                                                                    masterID: 0,
                                                                    detailsID: 0,
                                                                    productID: addProduct!.productId!,
                                                                    locationID: int.parse(locationId),
                                                                    qty: double.parse(_quantityController.text.trim()),
                                                                    unitID: addProduct!.fromUnitId!,
                                                                    batch: addProduct!.batch!,
                                                                    expiryDate: addProduct!.expirydate,
                                                                    stockQty: (int.parse(_quantityController.text.trim()) * addProduct!.conversionFactor!),
                                                                    extra1: voucherNo,
                                                                    flag: 2,
                                                                    userID: userId2,
                                                                    entryDate: DateFormat('yyyy-MM-ddThh:mm:ss').format(DateTime.now())
                                                                );

                                                                final response = await POSServices().addSalesDraftPos(newDraft: addDraft,itemAllocation: item,voucherNo: voucherNo,salesLedgerId: int.parse(salesAccountId));

                                                                if(response.isLeft()){
                                                                  final leftValue = response.fold((l) => l, (r) => null);
                                                                  Fluttertoast.showToast(
                                                                    msg: '$leftValue',
                                                                    gravity: ToastGravity.BOTTOM,
                                                                    backgroundColor: ColorManager.errorRed.withOpacity(0.9),
                                                                    textColor: Colors.white,
                                                                    fontSize: 16.0,
                                                                  );
                                                                  setState(() {
                                                                    isPostingDraft = false;
                                                                  });
                                                                }
                                                                else{
                                                                  ref.refresh(draftProvider(voucherNo));
                                                                  ref.refresh(productProvider(locationId));
                                                                  Fluttertoast.showToast(
                                                                    msg: 'Draft added',
                                                                    gravity: ToastGravity.BOTTOM,
                                                                    backgroundColor: ColorManager.green.withOpacity(0.9),
                                                                    textColor: Colors.white,
                                                                    fontSize: 16.0,
                                                                  );

                                                                  setState(() {
                                                                    isPostingDraft = false;
                                                                    addProduct = null;
                                                                    productName = null;
                                                                    productRate = null;
                                                                    productUnit = null;
                                                                    quantityValue = null;
                                                                    netTotalValue = null;
                                                                    productCode = null;
                                                                    _rateController.clear();
                                                                    _unitController.clear();
                                                                    _rateController.clear();
                                                                    _unitController.clear();
                                                                    _quantityController.clear();
                                                                    _netTotalController.clear();
                                                                    _productCodeController.clear();
                                                                    _receivedAmountController.clear();
                                                                    disabledFields = true;
                                                                  });


                                                                  await Future.delayed(const Duration(milliseconds: 100));

                                                                  _productFormKey.currentState!.reset();
                                                                }

                                                              }
                                                              // Map<String, dynamic> newProduct = {
                                                              //   'productCode': productCode,
                                                              //   'productName': productName,
                                                              //   'rate': productRate,
                                                              //   'unit': productUnit,
                                                              //   'quantity': quantityValue,
                                                              //   'netTotal': netTotalValue
                                                              // };
                                                              //





                                                            }
                                                          },
                                                          icon: isPostingDraft? CircularProgressIndicator(color: ColorManager.primary,):FaIcon(Icons.add,color: ColorManager.white,)
                                                      ),

                                                      IconButton(
                                                          style: IconButton.styleFrom(
                                                              backgroundColor: ColorManager.errorRed,
                                                              shape: ContinuousRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(10)
                                                              )
                                                          ),
                                                          onPressed:() async {
                                                            setState(() {
                                                              addProduct = null;
                                                              productName = null;
                                                              productRate = null;
                                                              productUnit = null;
                                                              quantityValue = null;
                                                              netTotalValue = null;
                                                              productCode = null;
                                                              _rateController.clear();
                                                              _unitController.clear();
                                                              _rateController.clear();
                                                              _unitController.clear();
                                                              _quantityController.clear();
                                                              _netTotalController.clear();
                                                              _productCodeController.clear();
                                                              _receivedAmountController.clear();
                                                              disabledFields = true;
                                                            });

                                                            await Future.delayed(const Duration(milliseconds: 100));

                                                            _productFormKey.currentState!.reset();





                                                          },
                                                          icon: FaIcon(Icons.refresh,color: ColorManager.white,)
                                                      )
                                                    ],
                                                  );
                                                }

                                              },
                                              error: (error,stack)=>const SizedBox(),
                                              loading: ()=>CircularProgressIndicator(color: ColorManager.primary,)
                                          ),


                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              loadDraftData.when(
                                  data: (drafts){
                                    if(drafts.isEmpty){
                                      return const SizedBox();
                                    }
                                    else{
                                      // final receivedAmountData = ref.watch(receivedAmountProvider(drafts.first.salesMasterID));
                                      final receivedTotalAmountData = ref.watch(receivedTotalAmountProvider(drafts.first.salesMasterID));
                                      return Column(
                                        children: [


                                          receivedTotalAmountData.when(
                                              data: (amount){
                                                return Column(
                                                  children: [
                                                    SingleChildScrollView(
                                                      scrollDirection: Axis.horizontal,
                                                      physics: const ClampingScrollPhysics(),
                                                      child: DataTable(
                                                          headingRowColor: MaterialStateColor.resolveWith((states) => ColorManager.primary),
                                                          headingTextStyle: TextStyle(color: ColorManager.white,fontWeight: FontWeight.bold),
                                                          columns: const [
                                                            DataColumn(label: Text('S.N.')),
                                                            DataColumn(label: Text('Item')),
                                                            DataColumn(label: Text('Quantity')),
                                                            DataColumn(label: Text('Rate')),
                                                            DataColumn(label: Text('Net Total')),
                                                            DataColumn(label: Text('Actions')),
                                                          ],
                                                          rows: drafts.map((e){
                                                            int index = drafts.indexOf(e) +1 ;
                                                            return DataRow(
                                                                cells: [
                                                                  DataCell(Text('$index')),
                                                                  DataCell(Text('${e.productName}')),
                                                                  DataCell(Text('${e.qty.toPrecision(1)}')),
                                                                  DataCell(Text('${e.rate.toPrecision(2)}')),
                                                                  DataCell(Text('${e.netAmt.toPrecision(2)}')),
                                                                  DataCell(Row(
                                                                    children: [
                                                                      IconButton(

                                                                        onPressed:amount> 0? null : () async {
                                                                          final product = data.firstWhere((element) => element.productName!.toLowerCase()==e.productName!.toLowerCase());
                                                                          final response = await POSServices().deleteDraftItems(id: e.salesDetailsDraftID);
                                                                          if(response.isLeft()){
                                                                            final leftValue = response.fold((l) => l, (r) => null);
                                                                            Fluttertoast.showToast(
                                                                              msg: '$leftValue',
                                                                              gravity: ToastGravity.BOTTOM,
                                                                              backgroundColor: ColorManager.errorRed.withOpacity(0.9),
                                                                              textColor: Colors.white,
                                                                              fontSize: 16.0,
                                                                            );
                                                                          }
                                                                          else{

                                                                            setState(() {
                                                                              addProduct = product;
                                                                              productName = product.productName;
                                                                              productRate = product.salesRate!.toPrecision(2);
                                                                              productUnit = product.mainunit;
                                                                              productCode = product.productCode;
                                                                              _productCodeController.text = product.productCode!;
                                                                              _rateController.text = product.salesRate!.toPrecision(2).toString();
                                                                              _unitController.text = product.mainunit.toString();
                                                                              disabledFields = false;
                                                                              _quantityController.text = e.qty.toString();
                                                                              _netTotalController.text = e.netAmt.toString();

                                                                            });
                                                                            ref.refresh(draftProvider(voucherNo));
                                                                            ref.refresh(productProvider(locationId));
                                                                          }
                                                                        }, icon: Icon(FontAwesomeIcons.penToSquare,color: ColorManager.primary,),
                                                                      ),
                                                                      IconButton(

                                                                        onPressed: amount> 0? null : () async {
                                                                          final response = await POSServices().deleteDraftItems(id: e.salesDetailsDraftID);
                                                                          if(response.isLeft()){
                                                                            final leftValue = response.fold((l) => l, (r) => null);
                                                                            Fluttertoast.showToast(
                                                                              msg: '$leftValue',
                                                                              gravity: ToastGravity.BOTTOM,
                                                                              backgroundColor: ColorManager.errorRed.withOpacity(0.9),
                                                                              textColor: Colors.white,
                                                                              fontSize: 16.0,
                                                                            );
                                                                          }
                                                                          else{
                                                                            Fluttertoast.showToast(
                                                                              msg: 'Product removed',
                                                                              gravity: ToastGravity.BOTTOM,
                                                                              backgroundColor: ColorManager.errorRed.withOpacity(0.9),
                                                                              textColor: Colors.white,
                                                                              fontSize: 16.0,
                                                                            );
                                                                            ref.refresh(productProvider(locationId));
                                                                            ref.refresh(draftProvider(voucherNo));
                                                                          }
                                                                        }, icon: Icon(Icons.delete,color: ColorManager.errorRed,),
                                                                      )
                                                                    ],
                                                                  )),
                                                                ]
                                                            );
                                                          }).toList()
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 50,
                                                      color: ColorManager.primary,
                                                      padding: const EdgeInsets.symmetric(horizontal: 30),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text('Total',style: TextStyle(color: ColorManager.white,fontWeight: FontWeight.bold),),
                                                          Text('Rs. ${calculateTotalRate(drafts,receivedTotalAmountData.value ?? 0.0)}',style: TextStyle(color: ColorManager.white,fontWeight: FontWeight.bold),),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                                      child: Row(
                                                        children: [
                                                          receivedLedgerData.when(
                                                              data: (receivedLedgerList){
                                                                String defaultItem = receivedLedgerList.firstWhere((element) => element.value == int.parse(posSettingsReceivedLedger.defaultValue)).text;
                                                                return Expanded(
                                                                  child: DropdownSearch<String>(

                                                                    items: receivedLedgerList.map((e) => e.text).toList(),
                                                                    // enabled: false,
                                                                    dropdownDecoratorProps:
                                                                    DropDownDecoratorProps(

                                                                      baseStyle: const TextStyle(
                                                                          fontSize: 18,
                                                                          fontWeight: FontWeight.w500),
                                                                      dropdownSearchDecoration: InputDecoration(
                                                                        border: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(10),
                                                                            borderSide: BorderSide(
                                                                                color: ColorManager.black
                                                                            )
                                                                        ),
                                                                        contentPadding: const EdgeInsets.all(15),

                                                                        floatingLabelStyle: TextStyle(
                                                                            color: ColorManager.primary),
                                                                        labelText: 'Received Ledger',
                                                                        labelStyle: TextStyle(color: ColorManager.primary),
                                                                      ),
                                                                    ),
                                                                    selectedItem: selectedReceivedLedger?.text ?? defaultItem,
                                                                    popupProps: const PopupProps.menu(
                                                                      showSearchBox: true,
                                                                      fit: FlexFit.loose,
                                                                      constraints: BoxConstraints(maxHeight: 250),
                                                                      showSelectedItems: true,
                                                                      searchFieldProps: TextFieldProps(
                                                                        style: TextStyle(
                                                                          fontSize: 18,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    onChanged: (value) {
                                                                      final newReceivedLedger = receivedLedgerList.firstWhere((element) => element.text == value);
                                                                      setState(() {
                                                                        selectedReceivedLedger = newReceivedLedger;
                                                                      });
                                                                    },
                                                                  ),
                                                                );
                                                              },
                                                              error: (error,stack)=> Center(child: Text('$error'),),
                                                              loading: ()=> Center(child: CircularProgressIndicator(color: ColorManager.primary,),)
                                                          ),

                                                          const SizedBox(
                                                            width: 10,
                                                          ),

                                                          customerListData.when(
                                                              data: (customerList){

                                                                return Expanded(
                                                                  child: ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                                                          backgroundColor: ColorManager.primary,
                                                                          disabledBackgroundColor: Colors.grey.withOpacity(0.5),
                                                                          shape: ContinuousRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(20)
                                                                          )
                                                                      ),
                                                                      onPressed: amount > 0 ? _readOnlyDialog : () => _showDialog(customerList),
                                                                      child: Text('Customer Details',style: TextStyle(color: ColorManager.white,fontWeight: FontWeight.bold),)
                                                                  ),
                                                                );
                                                              },
                                                              error: (error,stack)=> Center(child: Text('$error'),),
                                                              loading: ()=> Center(child: CircularProgressIndicator(color: ColorManager.primary,),)
                                                          ),


                                                        ],
                                                      ),
                                                    ),


                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Expanded(
                                                            child: Form(
                                                              key:_receivedFormKey,
                                                              child: AbsorbPointer(
                                                                absorbing: amount == totalBill!,
                                                                child: TextFormField(
                                                                  controller: _receivedAmountController,
                                                                  decoration: InputDecoration(
                                                                      border: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(10),
                                                                          borderSide: BorderSide(
                                                                              color: ColorManager.primary
                                                                          )
                                                                      ),
                                                                      filled: amount == totalBill!,
                                                                      fillColor: amount == totalBill ? Colors.grey.withOpacity(0.5) : ColorManager.white,
                                                                      labelText: 'Received amount (Rs. $amount received)',
                                                                      labelStyle: TextStyle(color: ColorManager.primary),

                                                                  ),
                                                                  validator: (value){
                                                                    if(value!.trim().isEmpty){
                                                                      return 'Amount is required';
                                                                    }

                                                                    try {
                                                                      double.parse(value);
                                                                      if(double.parse(value) > (totalBill! - amount)){
                                                                        return 'Ledger amount cannot be more than bill amount';
                                                                      }
                                                                    } catch (e) {
                                                                      return 'Please enter a valid number';
                                                                    }


                                                                    return null;
                                                                  },
                                                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                  onChanged: (value){},
                                                                ),
                                                              ),
                                                            ),
                                                          ),

                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          IconButton(
                                                              style: IconButton.styleFrom(
                                                                  backgroundColor: ColorManager.primary,
                                                                  disabledBackgroundColor: ColorManager.textGray,
                                                                  shape: ContinuousRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(20)
                                                                  )
                                                              ),
                                                              onPressed:amount == totalBill! ? null : isPostingReceivedAmount?null: () async {
                                                                if(_receivedFormKey.currentState!.validate()){
                                                                  bool isGreater = (amount + double.parse(_receivedAmountController.text)) > totalBill!;

                                                                  if(isGreater){
                                                                    Fluttertoast.showToast(
                                                                      msg: 'Ledger Amount greater than bill amount',
                                                                      gravity: ToastGravity.BOTTOM,
                                                                      backgroundColor: ColorManager.errorRed.withOpacity(0.9),
                                                                      textColor: Colors.white,
                                                                      fontSize: 16.0,
                                                                    );
                                                                  }

                                                                  else{
                                                                    setState(() {
                                                                      isPostingReceivedAmount = true;
                                                                    });
                                                                    final customerInfo = CustomerInfoModel(
                                                                        salesInfoID: 0,
                                                                        salesMasterID: drafts.first.salesMasterID,
                                                                        customerID: 0,
                                                                        customerName: _customerNameController.text,
                                                                        customerAddress: _addressController.text,
                                                                        mailingName: '',
                                                                        pan: _panController.text,
                                                                        email: '',
                                                                        creditPeriod: 0,
                                                                        receiptMode: 'Cash',
                                                                        dispatchedDate: DateFormat('yyyy-MM-ddThh:mm:ss').format(DateTime.now()),
                                                                        dispatchedThrough: '',
                                                                        destination: '',
                                                                        carrierAgent: '',
                                                                        vehicleNo: '',
                                                                        orginalInvoiceNo: 'N/A',
                                                                        orginalInvoiceDate: DateFormat('yyyy-MM-ddThh:mm:ss').format(DateTime.now()),
                                                                        orderChallanNo: '',
                                                                        lR_RRNO_BillOfLanding: '',
                                                                        remarks: '',
                                                                        userID: userId2,
                                                                        entryDate: DateFormat('yyyy-MM-ddThh:mm:ss').format(DateTime.now()),
                                                                        updatedBy: 0,
                                                                        updatedDate: DateFormat('yyyy-MM-ddThh:mm:ss').format(DateTime.now()),
                                                                        extra1: voucherNo,
                                                                        extra2: 'string',
                                                                        flag: 0
                                                                    );
                                                                    final customerResponse = await POSServices().saveCustomerInfo(customerInfo: customerInfo);
                                                                    if(customerResponse.isLeft()){
                                                                      final leftValue = customerResponse.fold((l) => l, (r) => null);
                                                                      Fluttertoast.showToast(
                                                                        msg: 'Customer error : $leftValue',
                                                                        gravity: ToastGravity.BOTTOM,
                                                                        backgroundColor: ColorManager.errorRed.withOpacity(0.9),
                                                                        textColor: Colors.white,
                                                                        fontSize: 16.0,
                                                                      );
                                                                    }
                                                                    else{
                                                                      final receivingAmount = double.parse(_receivedAmountController.text.trim());
                                                                      ReceivedAmountModel receivedAmount = ReceivedAmountModel(
                                                                          transactionDetailsID: 0,
                                                                          voucherTypeID: 19,
                                                                          masterID: drafts.first.salesMasterID,
                                                                          ledgerID: selectedReceivedLedger?.value ?? int.parse(posSettingsReceivedLedger.defaultValue),
                                                                          ledgerName: selectedReceivedLedger?.text ?? posSettingsReceivedLedger.fieldName,
                                                                          drAmt: receivingAmount,
                                                                          crAmt: 0.0,
                                                                          userID: userId2,
                                                                          entryDate: DateFormat('yyyy-MM-ddThh:mm:ss').format(DateTime.now()),
                                                                          updatedBy: 0,
                                                                          updatedDate: DateFormat('yyyy-MM-ddThh:mm:ss').format(DateTime.now()),
                                                                          extra1: "1",
                                                                          extra2: "string",
                                                                          flag: 0,
                                                                          drCr: ""
                                                                      );
                                                                      final response = await POSServices().addReceivedAmount(receivedAmount: receivedAmount);
                                                                      if(response.isLeft()){
                                                                        final leftValue = response.fold((l) => l, (r) => null);
                                                                        Fluttertoast.showToast(
                                                                          msg: '$leftValue',
                                                                          gravity: ToastGravity.BOTTOM,
                                                                          backgroundColor: ColorManager.errorRed.withOpacity(0.9),
                                                                          textColor: Colors.white,
                                                                          fontSize: 16.0,
                                                                        );

                                                                      }else{
                                                                        Fluttertoast.showToast(
                                                                          msg: 'Received Amount added',
                                                                          gravity: ToastGravity.BOTTOM,
                                                                          backgroundColor: ColorManager.green.withOpacity(0.9),
                                                                          textColor: Colors.white,
                                                                          fontSize: 16.0,
                                                                        );
                                                                        setState(() {
                                                                          isPostingReceivedAmount = false;
                                                                          _receivedAmountController.clear();
                                                                        });
                                                                        ref.refresh(receivedAmountProvider(drafts.first.salesMasterID));
                                                                        ref.refresh(receivedTotalAmountProvider(drafts.first.salesMasterID));
                                                                        ref.refresh(productProvider(locationId));
                                                                        await Future.delayed(const Duration(milliseconds: 100));

                                                                        _receivedFormKey.currentState!.reset();
                                                                      }
                                                                    }

                                                                  }

                                                                }
                                                              },
                                                              icon:isPostingReceivedAmount?CircularProgressIndicator(color: ColorManager.primary,): Icon(Icons.add,color: ColorManager.white,)
                                                          ),

                                                          if(amount>0)
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                          if(amount>0)
                                                            IconButton(
                                                                style: IconButton.styleFrom(
                                                                    backgroundColor: ColorManager.green,
                                                                    shape: ContinuousRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(20)
                                                                    )
                                                                ),
                                                                onPressed: ()=>Get.to(()=>ReceivedAmountTable(id: drafts.first.salesMasterID,)),
                                                                icon:Icon(Icons.remove_red_eye,color: ColorManager.white,)
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                                      child: Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: Text('Amount Left : ${totalBill! - amount}/-',style: const TextStyle(fontWeight: FontWeight.w500,fontStyle: FontStyle.italic),)),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                    backgroundColor:amount != totalBill!? Colors.grey: ColorManager.primary,
                                                                  disabledBackgroundColor: ColorManager.textGray.withOpacity(0.5)
                                                                ),
                                                                onPressed:isPostingFinalData ? null : () async {
                                                                  if(amount<0){
                                                                    Fluttertoast.showToast(
                                                                      msg: 'No amount received',
                                                                      gravity: ToastGravity.BOTTOM,
                                                                      backgroundColor: ColorManager.errorRed.withOpacity(0.9),
                                                                      textColor: Colors.white,
                                                                      fontSize: 16.0,
                                                                    );
                                                                  }
                                                                  else{
                                                                    setState(() {
                                                                      isPostingFinalData = true;
                                                                    });
                                                                    await showDialog(
                                                                      barrierDismissible: false,
                                                                        context: context,
                                                                        builder: (context){

                                                                          return AlertDialog(
                                                                            contentPadding: EdgeInsets.zero,
                                                                            content: Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                Container(
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: const BorderRadius.only(
                                                                                        topRight: Radius.circular(20),
                                                                                        topLeft: Radius.circular(20),
                                                                                    ),
                                                                                    color: ColorManager.primary,
                                                                                  ),
                                                                                  width: double.infinity,
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 12),

                                                                                  child: Text('Posting Confirmation',style: TextStyle(color: ColorManager.white,fontWeight: FontWeight.w500),),
                                                                                ),
                                                                                const SizedBox(height: 10,),
                                                                                Container(
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      const Text('Are you sure you want to post?'),
                                                                                      const SizedBox(height: 10,),
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                        children: [
                                                                                          ElevatedButton(
                                                                                            style: ElevatedButton.styleFrom(
                                                                                              backgroundColor: ColorManager.green
                                                                                            ),
                                                                                              onPressed: ()async {
                                                                                                final response = await POSServices().finalSavePOS(id: drafts.first.salesMasterID,voucherNo: voucherNo);
                                                                                                if(response.isLeft()){
                                                                                                  final leftValue = response.fold((l) => l, (r) => null );
                                                                                                  Fluttertoast.showToast(
                                                                                                    msg: 'Final Save error : $leftValue',
                                                                                                    gravity: ToastGravity.BOTTOM,
                                                                                                    backgroundColor: ColorManager.errorRed.withOpacity(0.9),
                                                                                                    textColor: Colors.white,
                                                                                                    fontSize: 16.0,
                                                                                                  );
                                                                                                }
                                                                                                else{

                                                                                                  final right = response.fold((l) => null, (r) => r);
                                                                                                  final salesMasterId = right['masterId'];
                                                                                                  // print(right);
                                                                                                  Fluttertoast.showToast(
                                                                                                    msg: 'Draft added',
                                                                                                    gravity: ToastGravity.BOTTOM,
                                                                                                    backgroundColor: ColorManager.green.withOpacity(0.9),
                                                                                                    textColor: Colors.white,
                                                                                                    fontSize: 16.0,
                                                                                                  );
                                                                                                  final printResponse = await POSServices().printReceipt(masterId: salesMasterId);
                                                                                                  if(printResponse.isLeft()){
                                                                                                    Fluttertoast.showToast(
                                                                                                      msg: 'Printing error',
                                                                                                      gravity: ToastGravity.BOTTOM,
                                                                                                      backgroundColor: ColorManager.errorRed.withOpacity(0.9),
                                                                                                      textColor: Colors.white,
                                                                                                      fontSize: 16.0,
                                                                                                    );
                                                                                                  }
                                                                                                  else{
                                                                                                    Navigator.pop(context);
                                                                                                    final printReceipt = printResponse.fold((l) => null, (r) => r);
                                                                                                    await POSServices().deleteDraftTable(id: drafts.first.salesMasterID);
                                                                                                    _printReceipt(printReceipt!);

                                                                                                  }

                                                                                                }
                                                                                              },
                                                                                              child: Text('Yes',style: TextStyle(color: ColorManager.white),)),
                                                                                          ElevatedButton(
                                                                                            style: ElevatedButton.styleFrom(
                                                                                              backgroundColor: ColorManager.errorRed
                                                                                            ),
                                                                                              onPressed: (){
                                                                                                setState(() {
                                                                                                  isPostingFinalData = false;
                                                                                                });
                                                                                              Navigator.pop(context);
                                                                                              },
                                                                                              child: Text('No',style: TextStyle(color: ColorManager.white),)),
                                                                                        ],
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(height: 10,),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        }
                                                                    );

                                                                  }
                                                                },
                                                                child: isPostingFinalData ? CircularProgressIndicator(color: ColorManager.primary,): Text('Save',style: TextStyle(color: ColorManager.white),)
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            child: ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                    backgroundColor: ColorManager.errorRed,
                                                                  disabledBackgroundColor: ColorManager.textGray
                                                                ),
                                                                onPressed:amount>0? null : () async {
                                                                  await showDialog(
                                                                  barrierDismissible: false,
                                                                  context: context,
                                                                  builder: (context){

                                                                    return AlertDialog(
                                                                      contentPadding: EdgeInsets.zero,
                                                                      content: Column(
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                          Container(
                                                                            decoration: BoxDecoration(
                                                                              borderRadius: const BorderRadius.only(
                                                                                topRight: Radius.circular(20),
                                                                                topLeft: Radius.circular(20),
                                                                              ),
                                                                              color: ColorManager.primary,
                                                                            ),
                                                                            width: double.infinity,
                                                                            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 12),

                                                                            child: Text('Reset Confirmation',style: TextStyle(color: ColorManager.white,fontWeight: FontWeight.w500),),
                                                                          ),
                                                                          const SizedBox(height: 10,),
                                                                          Container(
                                                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                            child: Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                const Text('Are you sure you want to reset the draft?'),
                                                                                const SizedBox(height: 10,),
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                  children: [
                                                                                    ElevatedButton(
                                                                                        style: ElevatedButton.styleFrom(
                                                                                            backgroundColor: ColorManager.errorRed
                                                                                        ),
                                                                                        onPressed: () async {
                                                                                          final deleteResponse = await POSServices().deleteDraftTable(id: drafts.first.salesMasterID);
                                                                                          if(deleteResponse.isLeft()){
                                                                                            final leftValue = deleteResponse.fold((l) => l, (r) => null);
                                                                                            Fluttertoast.showToast(
                                                                                              msg: '$leftValue',
                                                                                              gravity: ToastGravity.BOTTOM,
                                                                                              backgroundColor: ColorManager.errorRed.withOpacity(0.9),
                                                                                              textColor: Colors.white,
                                                                                              fontSize: 16.0,
                                                                                            );
                                                                                          }else{
                                                                                            Fluttertoast.showToast(
                                                                                              msg: 'Draft deleted',
                                                                                              gravity: ToastGravity.BOTTOM,
                                                                                              backgroundColor: ColorManager.green.withOpacity(0.9),
                                                                                              textColor: Colors.white,
                                                                                              fontSize: 16.0,
                                                                                            );
                                                                                            ref.refresh(draftProvider(voucherNo));
                                                                                            ref.refresh(productProvider(locationId));
                                                                                            Navigator.pop(context);
                                                                                            setState(() {
                                                                                              selectedReceivedLedger=null;
                                                                                              _customerNameController.text = customerName;
                                                                                            });
                                                                                          }

                                                                                        },
                                                                                        child: Text('Yes',style: TextStyle(color: ColorManager.white),)),
                                                                                    ElevatedButton(
                                                                                        style: ElevatedButton.styleFrom(
                                                                                            backgroundColor: ColorManager.textGrey
                                                                                        ),
                                                                                        onPressed: (){

                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                        child: Text('No',style: TextStyle(color: ColorManager.white),)),
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          const SizedBox(height: 10,),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  }
                                                                  );
                                                                },
                                                                child: Text('Reset',style: TextStyle(color: ColorManager.white),)
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                              error: (error,stack) => Center(child: Text('$error')),
                                              loading: ()=>Center(child: CircularProgressIndicator(color: ColorManager.primary,),)
                                          ),











                                        ],
                                      );
                                    }

                                  },
                                  error: (error,stack)=>  Center(child: Text('$error'),) ,
                                  loading: ()=>Center(child: CircularProgressIndicator(color: ColorManager.primary,))
                              ),



                            ],
                          ),
                        );
                      }

                    },
                    error: (error,stack)=> Center(child: Text('$error'),),
                    loading: ()=>Center(child: CircularProgressIndicator(color: ColorManager.primary,),)
                );
              },
              error: (error,stack)=> Center(child: Text('$error'),),
              loading: ()=>Center(child: CircularProgressIndicator(color: ColorManager.primary,),)
          ),
        ),
      ),
    );
  }


  void _showDialog(List<POSLedgerModel> customerList) async {


    // bool isCustomer = true;



    await showDialog(context: context, builder: (context){
      return StatefulBuilder(
          builder: (context,setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ColorManager.primary
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text('Customer Details',style: TextStyle(color: ColorManager.white,fontWeight: FontWeight.bold,fontSize: 20),),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: ColorManager.white,
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)
                            )
                        ),
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                          key: _customerFormKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TypeAheadField<String>(
                                suggestionsCallback: (search) => _customerNameController.text == 'Cash'
                                    ?customerList.map((e) => e.text.toString()).toList()
                                    : customerList.map((e) => e.text.toString())
                                    .where((element) =>
                                    element.toLowerCase().contains(search.toLowerCase()))
                                    .toList(),
                                builder: (context, controller, focusNode) {
                                  return TextFormField(
                                    controller: _customerNameController,
                                    focusNode: focusNode,
                                    autofocus: false,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: ColorManager.primary
                                            )
                                        ),

                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: ColorManager.primary
                                            )
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: ColorManager.primary
                                            )
                                        ),
                                        labelText: 'Name',
                                        labelStyle: TextStyle(color: ColorManager.primary)
                                    ),
                                    validator: (value){
                                      if(value!.trim().isEmpty){
                                        return 'Name is required';
                                      }
                                      return null;
                                    },
                                    autovalidateMode: AutovalidateMode.onUserInteraction,

                                  );
                                },
                                controller: _customerNameController,
                                constraints: const BoxConstraints.tightFor(height: 250),
                                itemBuilder: (context, data) {
                                  return ListTile(
                                    title: Text(data),
                                  );
                                },
                                onSelected: (value) {
                                  final customerInfo = customerList.firstWhere((element) => element.text == value);
                                  _customerNameController.text =customerInfo.text;
                                  // _panController.clear();
                                  // _addressController.clear();
                                  // _paymentModeController.clear();
                                  // _remarksController.clear();
                                },
                                retainOnLoading: false,
                                hideOnEmpty: true,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _panController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: ColorManager.primary
                                        )
                                    ),

                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: ColorManager.primary
                                        )
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: ColorManager.primary
                                        )
                                    ),
                                    labelText: 'PAN',
                                    labelStyle: TextStyle(color: ColorManager.primary)
                                ),
                                onChanged: (value){},

                                validator: (value){
                                  if(value!.trim().isEmpty){
                                    return 'PAN is required';
                                  }
                                  return null;
                                },
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _addressController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: ColorManager.primary
                                        )
                                    ),

                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: ColorManager.primary
                                        )
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: ColorManager.primary
                                        )
                                    ),
                                    labelText: 'Address',
                                    labelStyle: TextStyle(color: ColorManager.primary)
                                ),
                                onChanged: (value){},
                                validator: (value){
                                  if(value!.trim().isEmpty){
                                    return 'Address is required';
                                  }
                                  return null;
                                },
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _remarksController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: ColorManager.primary
                                        )
                                    ),

                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: ColorManager.primary
                                        )
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: ColorManager.primary
                                        )
                                    ),
                                    labelText: 'Remarks',
                                    labelStyle: TextStyle(color: ColorManager.primary)
                                ),
                                onChanged: (value){},
                                validator: (value){
                                  if(value!.trim().isEmpty){
                                    return 'Remarks is required';
                                  }
                                  return null;
                                },
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          backgroundColor: ColorManager.primary,
                                          shape: ContinuousRectangleBorder(
                                              borderRadius: BorderRadius.circular(20)
                                          )
                                      ),
                                      onPressed: (){
                                        Navigator.pop(context);
                                        // if(_customerFormKey.currentState!.validate()){
                                        //   String name = _customerNameController.text.trim();
                                        //   String pan = _panController.text.trim();
                                        //   String address = _addressController.text.trim();
                                        //   String paymentMode = _paymentModeController.text.trim();
                                        //   String remarks = _remarksController.text.trim();
                                        //
                                        //   setCustomerInfo ={
                                        //     'name' : name,
                                        //     'pan' : pan,
                                        //     'address' : address,
                                        //     'paymentMode' : paymentMode,
                                        //     'remarks' : remarks
                                        //   };
                                        //
                                        //   Navigator.pop(context);
                                        //
                                        // }
                                      },
                                      child: Text('OK',style: TextStyle(color: ColorManager.white,fontWeight: FontWeight.bold),)
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          backgroundColor: ColorManager.errorRed,
                                          shape: ContinuousRectangleBorder(
                                              borderRadius: BorderRadius.circular(20)
                                          )
                                      ),
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel',style: TextStyle(color: ColorManager.white,fontWeight: FontWeight.bold),)
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )

                    ],
                  ),
                ),
              ),

            );
          }
      );
    });


  }


  void _readOnlyDialog() async {


    // bool isCustomer = true;



    await showDialog(context: context, builder: (context){
      return StatefulBuilder(
          builder: (context,setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ColorManager.primary
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text('Customer Details',style: TextStyle(color: ColorManager.white,fontWeight: FontWeight.bold,fontSize: 20),),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: ColorManager.white,
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)
                            )
                        ),
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: _customerNameController,
                              enabled: false,
                              autofocus: false,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: ColorManager.primary
                                      )
                                  ),

                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: ColorManager.primary
                                      )
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: ColorManager.primary
                                      )
                                  ),
                                  labelText: 'Name',
                                  labelStyle: TextStyle(color: ColorManager.primary)
                              ),
                              validator: (value){
                                if(value!.trim().isEmpty){
                                  return 'Name is required';
                                }
                                return null;
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,

                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              enabled: false,
                              controller: _panController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: ColorManager.primary
                                      )
                                  ),

                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: ColorManager.primary
                                      )
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: ColorManager.primary
                                      )
                                  ),
                                  labelText: 'PAN',
                                  labelStyle: TextStyle(color: ColorManager.primary)
                              ),
                              onChanged: (value){},

                              validator: (value){
                                if(value!.trim().isEmpty){
                                  return 'PAN is required';
                                }
                                return null;
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              enabled: false,
                              controller: _addressController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: ColorManager.primary
                                      )
                                  ),

                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: ColorManager.primary
                                      )
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: ColorManager.primary
                                      )
                                  ),
                                  labelText: 'Address',
                                  labelStyle: TextStyle(color: ColorManager.primary)
                              ),
                              onChanged: (value){},
                              validator: (value){
                                if(value!.trim().isEmpty){
                                  return 'Address is required';
                                }
                                return null;
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              enabled: false,
                              controller: _remarksController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: ColorManager.primary
                                      )
                                  ),

                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: ColorManager.primary
                                      )
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: ColorManager.primary
                                      )
                                  ),
                                  labelText: 'Remarks',
                                  labelStyle: TextStyle(color: ColorManager.primary)
                              ),
                              onChanged: (value){},
                              validator: (value){
                                if(value!.trim().isEmpty){
                                  return 'Remarks is required';
                                }
                                return null;
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        backgroundColor: ColorManager.primary,
                                        shape: ContinuousRectangleBorder(
                                            borderRadius: BorderRadius.circular(20)
                                        )
                                    ),
                                    onPressed: (){
                                      Navigator.pop(context);

                                    },
                                    child: Text('OK',style: TextStyle(color: ColorManager.white,fontWeight: FontWeight.bold),)
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        backgroundColor: ColorManager.errorRed,
                                        shape: ContinuousRectangleBorder(
                                            borderRadius: BorderRadius.circular(20)
                                        )
                                    ),
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel',style: TextStyle(color: ColorManager.white,fontWeight: FontWeight.bold),)
                                ),
                              ],
                            ),
                          ],
                        ),
                      )

                    ],
                  ),
                ),
              ),

            );
          }
      );
    });


  }



  void _printReceipt(ReceiptPOSModel receipt) async {


    final doc = pw.Document();

    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return generatePdf(receipt: receipt); // Center
        })); // Page

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());

    setState(() {
      isPostingFinalData = false;
      selectedReceivedLedger=null;
      _customerNameController.text = customerName;
    });
    ref.invalidate(voucherProvider);
    ref.invalidate(draftProvider);
    ref.invalidate(receivedTotalAmountProvider);
    ref.invalidate(receivedAmountProvider);
    ref.refresh(voucherProvider);
    ref.refresh(productProvider(locationId));

  }

}
