import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:khata_app/features/track_product/domain/model/track_model.dart';
import 'package:khata_app/features/track_product/domain/services/track_service.dart';
import 'package:khata_app/features/dashboard/presentation/home_screen.dart' as defaultBranch;
import '../../../common/colors.dart';

class TrackProduct extends ConsumerStatefulWidget {
  const TrackProduct({super.key});

  @override
  ConsumerState<TrackProduct> createState() => _TrackProductState();
}

class _TrackProductState extends ConsumerState<TrackProduct> {


  bool _isLoading = false;
  bool _showDetails = false;


  String? selectedBranch;
  String? selectedTokenName;


  Division? selectedDivision;

  List<TrackModel> trackModel=[];

  TokenModel? selectedToken;

  int branchId = 0;



  @override
  void initState(){
    super.initState();
    branchId = defaultBranch.branchId;
    selectedBranch = defaultBranch.branchName;

  }




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
          
          
              Column(
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
                                trackModel = [];
                                selectedDivision = null;
                                selectedTokenName = null;
                                selectedToken = null;
                                selectedToken = null;
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
                                selectedDivision = null;
                                selectedToken=changedData;
                                trackModel = [];

                              });
                            }

                          },
                        );
                      },
                      error: (error,stack)=>Text('Something is wrong'),
                      loading: ()=>SizedBox()
                  ),




                ],
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
                                if(selectedToken != null){
                                  setState(() {
                                    _isLoading =true;
                                    selectedTokenName = selectedToken!.tokenNumber;
                                    selectedDivision = null;
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
                                      _isLoading = false;
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
                              }, child: _isLoading? CircularProgressIndicator(color: ColorManager.white) :Text('Track',style: TextStyle(color: ColorManager.white),)),
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
                          final color = e.status == 0 ? Colors.brown
                              : e.status == 1 ? Colors.orange
                          : e.status == 2 ? Colors.green
                          : e.status == 3 ? Colors.red : Colors.black;
                         return Row(
                           children: [
                             GestureDetector(
                               onTap: (){

                                 if(e.status == 2){

                                   if(selectedDivision?.divisionName.toLowerCase() == e.divisionName.toLowerCase()){
                                     setState(() {
                                       selectedDivision = null;
                                     });
                                   }
                                   else{
                                     setState(() {
                                       selectedDivision = e;
                                     });
                                   }

                                 }
                                 else{
                                   setState(() {
                                     selectedDivision = null;
                                   });
                                 }
                                 
                               },
                               child: Container(
                                 padding: EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                                 decoration: BoxDecoration(
                                   color: color,
                                   borderRadius: BorderRadius.circular(10)
                                 ),
                                 child: Text(e.divisionName,style: TextStyle(color: ColorManager.white,fontSize: 20),),
                               ),
                             ),
                             const SizedBox(width: 10,),
                             if(!isLast)
                               Icon(Icons.double_arrow_sharp,size: 25,color: ColorManager.black,),
                             const SizedBox(width: 10,),

                           ],
                         );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Divider(),
                    const SizedBox(height: 10,),
                    if(selectedDivision != null)
                    Container(
                      decoration: BoxDecoration(
                        color: ColorManager.subtitleGrey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(selectedDivision!.divisionName,style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600),),
                          const SizedBox(height: 10,),
                          Text('Started Date : ${selectedDivision!.entryDate}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600)),
                          Text('Completed Date : ${selectedDivision!.verifiedDate}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600)),
                          Text('Verified By : ${selectedDivision!.verifiedBy}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600)),

                        ],
                      ),
                    )
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
