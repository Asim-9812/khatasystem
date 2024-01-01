



import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../../../common/colors.dart';
import '../../../../common/snackbar.dart';

class POS extends StatefulWidget {
  const POS({super.key});

  @override
  State<POS> createState() => _POSState();
}

class _POSState extends State<POS> {


  GlobalKey<FormState> _productFormKey = GlobalKey();

  TextEditingController _productCodeController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _netTotalController = TextEditingController();
  TextEditingController _rateController = TextEditingController();
  TextEditingController _unitController = TextEditingController();
  TextEditingController _receivedAmountController = TextEditingController();
  TextEditingController _customerNameController = TextEditingController();
  TextEditingController _panController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _remarksController = TextEditingController();
  TextEditingController _paymentModeController = TextEditingController();


  String? productCode;
  String? productName;
  double? productRate;
  String? productUnit;

  double? quantityValue;
  double? netTotalValue;


  List<Map<String, dynamic>> addedProducts = [];

  bool disabledFields = true;


  List<String> dummyStringList = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Elderberry',
    'Fig',
    'Grapes',
    'Honeydew',
    'Iguana',
    'Jackfruit',
    'Kiwi',
    'Lemon',
    'Mango',
    'Nectarine',
    'Orange',
    'Papaya',
    'Quince',
    'Raspberry',
    'Strawberry',
    'Tomato',
    'Umbrella',
    'Vanilla',
    'Watermelon',
    'Xylophone',
    'Yogurt',
    'Zucchini',
  ];






  double calculateTotalRate(List<Map<String, dynamic>> addedProduct) {
    double totalRate = 0.0;

    for (var product in addedProduct) {
      totalRate += product['netTotal'];
    }

    return totalRate.toPrecision(2);
  }


  void _resetAll() async{
    setState(() {
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
      addedProducts = [];
    });

    await Future.delayed(const Duration(milliseconds: 100));

    _productFormKey.currentState!.reset();

  }




  @override
  Widget build(BuildContext context) {

    List<Map<String, dynamic>> productList = [
      {
        'productCode': 'P001',
        'productName': 'Widget A',
        'rate': 19.99,
        'unit': 'Each',
      },
      {
        'productCode': 'P002',
        'productName': 'Gadget B',
        'rate': 29.99,
        'unit': 'Set',
      },
      {
        'productCode': 'P003',
        'productName': 'Device C',
        'rate': 39.99,
        'unit': 'Piece',
      },
      {
        'productCode': 'P004',
        'productName': 'Tool D',
        'rate': 49.99,
        'unit': 'Each',
      },
      // Add more products as needed
    ];
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorManager.primary,
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              // ref.invalidate(plReportProvider);
              // ref.read(checkProvider).updateCheck(false);
              Navigator.pop(context, true);
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
        body: SingleChildScrollView(
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
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
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
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: ColorManager.primary,
                              shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                              )
                            ),
                              onPressed: (){
                                final scaffoldMessage = ScaffoldMessenger.of(context);
                              final product = productList.firstWhereOrNull((element) => element['productCode'].toLowerCase() == _productCodeController.text.toLowerCase().trim());
                              if(product != null){
                                setState(() {
          
                                  productName = product['productName'];
                                  productRate = product['rate'];
                                  productUnit = product['unit'];
                                  productCode = product['productCode'];
                                  _productCodeController.text = product['productCode'];
                                  _rateController.text = product['rate'].toString();
                                  _unitController.text = product['unit'];
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
                              icon: FaIcon(Icons.search,color: ColorManager.white,)
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      DropdownSearch<String>(
          
                        items: productList.map((e) => e['productName'].toString()).toList(),
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
                            Map<String, dynamic> product = productList.firstWhere((element) => element['productName']==value);
                            setState(() {
                              productName = value;
                              productRate = product['rate'];
                              productUnit = product['unit'];
                              productCode = product['productCode'];
                              _productCodeController.text = product['productCode'];
                              _rateController.text = product['rate'].toString();
                              _unitController.text = product['unit'].toString();
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
                                  // Use a regular expression to check if the entered value is a valid double
                                  if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
                                    return 'Enter a valid number';
                                  }
                                  return null; // Return null if the value is valid
                                },
                                onChanged:(value){
                                  if(productRate !=null){
                                    double total = int.parse(value) * productRate!;
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
                                    // Use a regular expression to check if the entered value is a valid double
                                    if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
                                      return 'Enter a valid number';
                                    }
                                    return null; // Return null if the value is valid
                                  },
                                  onChanged:(value){
                                  if(productRate !=null){
                                    double quantity = int.parse(value) / productRate!;
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
                          IconButton(
                              style: IconButton.styleFrom(
                                  backgroundColor: ColorManager.primary,
                                  shape: ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  )
                              ),
                              onPressed:() async {
                                final scaffoldMessage = ScaffoldMessenger.of(context);
                                if(_productFormKey.currentState!.validate()) {
                                  Map<String, dynamic> newProduct = {
                                    'productCode': productCode,
                                    'productName': productName,
                                    'rate': productRate,
                                    'unit': productUnit,
                                    'quantity': quantityValue,
                                    'netTotal': netTotalValue
                                  };
          
                                  setState(() {
                                    addedProducts.add(newProduct);
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
                              },
                              icon: FaIcon(Icons.add,color: ColorManager.white,)
                          ),

                          IconButton(
                              style: IconButton.styleFrom(
                                  backgroundColor: ColorManager.logoOrange.withOpacity(0.8),
                                  shape: ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  )
                              ),
                              onPressed:() async {
                                setState(() {
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
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
          
              if(addedProducts.isNotEmpty)
                Column(
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
                          ],
                          rows: addedProducts.map((e){
                            int index = addedProducts.indexOf(e) +1 ;
                            return DataRow(
                                cells: [
                                  DataCell(Text('$index')),
                                  DataCell(Text('${e['productName']}')),
                                  DataCell(Text('${(e['quantity'] as double).toPrecision(1)}')),
                                  DataCell(Text('${(e['rate'] as double).toPrecision(2)}')),
                                  DataCell(Text('${(e['netTotal'] as double).toPrecision(2)}')),
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
                          Text('Rs. ${calculateTotalRate(addedProducts)}',style: TextStyle(color: ColorManager.white,fontWeight: FontWeight.bold),),
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
                          Expanded(
                            child: DropdownSearch<String>(

                              items: [],
                              enabled: false,
                              // selectedItem: 'Received Ledger',
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
                                  filled: true,
                                  fillColor: ColorManager.black.withOpacity(0.1),
                                  contentPadding: const EdgeInsets.all(15),

                                  floatingLabelStyle: TextStyle(
                                      color: ColorManager.primary),
                                  labelText: 'Received Ledger',
                                  labelStyle: TextStyle(color: ColorManager.primary),
                                ),
                              ),
                              // validator: (value){
                              //   if(value== null){
                              //     return 'Please select a product';
                              //   }
                              //   return null;
                              // },
                              // autoValidateMode: AutovalidateMode.onUserInteraction,
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
                              onChanged: (dynamic value) {},
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: ColorManager.primary,
                                shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                                )
                              ),
                                onPressed: _showDialog,
                                child: Text('Customer Details',style: TextStyle(color: ColorManager.white,fontWeight: FontWeight.bold),)
                            ),
                          )
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
                          Expanded(
                            child: TextFormField(
                              controller: _receivedAmountController,
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
                                  labelText: 'Received amount',
                                  labelStyle: TextStyle(color: ColorManager.primary)
                              ),
                              onChanged: (value){},
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          backgroundColor: ColorManager.primary,
                                          shape: ContinuousRectangleBorder(
                                              borderRadius: BorderRadius.circular(20)
                                          )
                                      ),
                                      onPressed: (){},
                                      child: Text('Save',style: TextStyle(color: ColorManager.white,fontWeight: FontWeight.bold),)
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          backgroundColor: ColorManager.logoOrange.withOpacity(0.8),
                                          shape: ContinuousRectangleBorder(
                                              borderRadius: BorderRadius.circular(20)
                                          )
                                      ),
                                      onPressed: _resetAll,
                                      child: Text('Reset',style: TextStyle(color: ColorManager.white,fontWeight: FontWeight.bold),)
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                )
          
            ],
          ),
        ),
      ),
    );
  }


  void _showDialog() async {

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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Customer Details',style: TextStyle(color: ColorManager.white,fontWeight: FontWeight.bold),),
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
                        TypeAheadField<String>(
                          suggestionsCallback: (search) => dummyStringList,
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
                            );
                          },
                          constraints: const BoxConstraints.tightFor(height: 250),
                          itemBuilder: (context, city) {
                            return ListTile(
                              title: Text(city),
                            );
                          },
                          onSelected: (city) {},
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
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
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
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
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _paymentModeController,
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
                              labelText: 'Mode of payment',
                              labelStyle: TextStyle(color: ColorManager.primary)
                          ),
                          onChanged: (value){},
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
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: ColorManager.primary,
                                shape: ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)
                                )
                            ),
                            onPressed: (){},
                            child: Text('OK',style: TextStyle(color: ColorManager.white,fontWeight: FontWeight.bold),)
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

          );
        }
      );
    });
  }


}
