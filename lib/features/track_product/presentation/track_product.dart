



import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:khata_app/features/track_product/domain/model/track_model.dart';
import 'package:khata_app/features/track_product/domain/services/track_service.dart';

import '../../../common/colors.dart';

class TrackProduct extends ConsumerStatefulWidget {
  const TrackProduct({super.key});

  @override
  ConsumerState<TrackProduct> createState() => _TrackProductState();
}

class _TrackProductState extends ConsumerState<TrackProduct> {

  bool _isSearching = false;

  bool _isLoading = false;


  String? selectedBranch;
  String? selectedTokenName;

  List<TrackModel> trackModel=[];

  TokenModel? selectedToken;

  int branchId = 0;

  final _searchController = TextEditingController();




  @override
  Widget build(BuildContext context) {
    final allTokenList = ref.watch(getAllTokenList);
    final branchList = ref.watch(getBranches);
    final tokenList = ref.watch(getTokenList(branchId));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.primary,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 28,
            color: Colors.white,
          ),
        ),
        title: const Text('Track Products'),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        toolbarHeight: 70,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        color: Colors.brown,
                      ),
                      const SizedBox(width: 5,),
                      Text('On hold'),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 5,),
                      Text('Processing'),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        color: Colors.green,
                      ),
                      const SizedBox(width: 5,),
                      Text('Completed'),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        color: Colors.red,
                      ),
                      const SizedBox(width: 5,),
                      Text('Cancel'),
                    ],
                  ),


                ],
              ),

              Divider(),
              const SizedBox(height: 10,),

              TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    labelText: 'Search',
                    hintText: 'Search for product',
                    suffixIcon: IconButton(onPressed: null, icon: Icon(Icons.search,color: ColorManager.primary,))
                ),
                onChanged: (v){
                  setState(() {
          
                  });
                },
              ),
              
          
              const SizedBox(height: 10,),
          
          
              Visibility(
                  visible: _searchController.text.trim().isEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      branchList.when(
                          data: (branches){
                            return DropdownSearch<String>(
          
                              items: branches.map((e) => e.branchName.toString()).toList(),
                              selectedItem: selectedBranch,
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
                                  labelText: 'Branch Name',
                                  labelStyle: TextStyle(color: ColorManager.primary),
                                ),
                              ),
                              validator: (value){
                                if(value== null){
                                  return 'Please select a branch';
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
                                  final changedData = branches.firstWhere((element) => element.branchName.toLowerCase() == value.toString().toLowerCase());
                                  final newId = changedData.branchId;
                                  setState(() {
                                    branchId = newId;
                                    selectedBranch = changedData.branchName;
                                  });
                                }
          
                              },
                            );
                          },
                          error: (error,stack)=>Text('$error'),
                          loading: ()=>SizedBox()
                      ),
                      const SizedBox(height: 10,),
                      tokenList.when(
                          data: (tokens){
                            if(tokens.isEmpty){
                              return DropdownSearch<String>(

                                items: ['No token batch'],
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
                                    labelText: 'Token Batch',
                                    labelStyle: TextStyle(color: ColorManager.primary),
                                  ),
                                ),
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
                              );
                            }
                            return DropdownSearch<String>(
          
                              items: tokens.map((e) => e.tokenNumber.toString()).toList(),
                              selectedItem: selectedTokenName,
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
                                  labelText: 'Token Batch',
                                  labelStyle: TextStyle(color: ColorManager.primary),
                                ),
                              ),
                              validator: (value){
                                if(value== null){
                                  return 'Please select a token';
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
                                  final changedData = tokens.firstWhere((element) => element.tokenNumber.toLowerCase() == value.toString().toLowerCase());
                                   
                                  setState(() {
                                    selectedTokenName = changedData.tokenNumber;
                                    selectedToken = changedData;
                                  });
                                }
          
                              },
                            );
                          },
                          error: (error,stack)=>Text('Something is wrong'),
                          loading: ()=>SizedBox()
                      ),


                      
                      
                    ],
                  )
              ),
              const SizedBox(height: 10,),
              allTokenList.when(
                  data: (tokens){
                    return Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorManager.primary,
                                shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                                )
                              ),
                              onPressed: () async {
                                if(_searchController.text.trim().isNotEmpty){
                                  final selectedName = _searchController.text.trim();
                                  final changedData = tokens.where((element) => element.tokenNumber.toLowerCase() == selectedName.toLowerCase()).firstOrNull;
                          
                                  if(changedData != null){
                                    setState(() {
                                      selectedTokenName = changedData.tokenNumber;
                                      selectedToken = changedData;
                                    });
                                    final response = await TrackServices.getTrackingList(tokenData: selectedToken!);
                                    if(response.isLeft()){
                                      final leftV = response.fold((l) => l, (r) => null);
                                      Fluttertoast.showToast(
                                        msg: '$leftV',
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: ColorManager.red.withOpacity(0.9),
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    }
                                    else{
                                      final tracks = response.fold((l) => null, (r) => r);
                          
                                      setState(() {
                                        trackModel = tracks!;
                                      });
                                    }
                          
                                  }
                                  else{
                                    Fluttertoast.showToast(
                                      msg: 'Product not found',
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: ColorManager.red.withOpacity(0.9),
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  }
                          
                          
                                }
                                else{
                                  if(selectedToken != null){
                                    final response = await TrackServices.getTrackingList(tokenData: selectedToken!);
                                    if(response.isLeft()){
                                      final leftV = response.fold((l) => l, (r) => null);
                                      Fluttertoast.showToast(
                                        msg: '$leftV',
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: ColorManager.red.withOpacity(0.9),
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    }
                                    else{
                                      final tracks = response.fold((l) => null, (r) => r);
                          
                                      setState(() {
                                        trackModel = tracks!;
                                      });
                                    }
                                  }
                                  else{
                                    Fluttertoast.showToast(
                                      msg: 'Select a token batch first',
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: ColorManager.red.withOpacity(0.9),
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  }
                          
                                }
                              }, child: Text('Track',style: TextStyle(color: ColorManager.white),)),
                        ),
                      ],
                    );
                  },
                  error: (error,stack)=>Text('Something is wrong'),
                  loading: ()=>SizedBox()
              ),

              const SizedBox(height: 20,),

              if(trackModel.isNotEmpty)
              Visibility(
                visible: trackModel.isNotEmpty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Track Products',style: TextStyle(fontSize: 16),),
                        const SizedBox(width: 5,),
                        if(selectedTokenName !=null)
                          Text('- ${selectedTokenName}',style: TextStyle(fontSize: 16))
                      ],
                    ),
                    Divider(),
                    const SizedBox(height: 10,),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: trackModel.first.division.map((e) {
                          final isLast = e.divisionName == trackModel.first.division.last.divisionName;
                         return Row(
                           children: [
                             Container(
                               padding: EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                               decoration: BoxDecoration(
                                 color: Colors.brown.withOpacity(0.7),
                                 borderRadius: BorderRadius.circular(10)
                               ),
                               child: Text(e.divisionName,style: TextStyle(color: ColorManager.white,fontSize: 20),),
                             ),
                             const SizedBox(width: 5,),
                             if(!isLast)
                               Icon(Icons.double_arrow_sharp,size: 30,color: ColorManager.black,),
                             const SizedBox(width: 5,),

                           ],
                         );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
