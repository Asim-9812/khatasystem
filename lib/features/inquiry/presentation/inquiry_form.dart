





import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:khata_app/common/colors.dart';
import 'package:khata_app/features/inquiry/domain/model/model.dart';

import '../../../common/common_provider.dart';

class InquiryForm extends ConsumerWidget {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _remarksController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context,ref) {
    final demoList = ['Account','Account + Inventory','Inventory','Pharmacy','Manufacturer','Other'];
    final selectedDemo = ref.watch(itemProvider).inquiryForm;
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorManager.primary,
          automaticallyImplyLeading: false,
          leading: IconButton(onPressed: ()=>Get.back, icon: Icon(Icons.chevron_left,color: ColorManager.white,)),
          title: Text('Inquiry Form',style: TextStyle(color: ColorManager.white),),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    labelText: 'Organization Name',

                  ),
                  validator: (value){
                    if(value!.trim().isEmpty){
                      return 'Name is required';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    labelText: 'Address',

                  ),
                  validator: (value){
                    if(value!.trim().isEmpty){
                      return 'Address is required';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  controller: _contactController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    labelText: 'Contact',

                  ),
                  validator: (value){
                    if(value!.trim().isEmpty){
                      return 'Contact is required';
                    }
                    else if(value.length > 10){
                      return 'Invalid number';
                    }
                    else{
                      try{
                        final toInt = int.parse(value);
                      }catch(e){
                        return 'Invalid number';
                      }
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    labelText: 'Email',

                  ),
                  validator: (value){
                    if(value!.trim().isEmpty){
                      return 'Email is required';
                    }
                    else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Invalid email';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 10,),
                DropdownSearch<String>(
                  items: demoList,
                  selectedItem: selectedDemo == '' ? demoList[0] : selectedDemo ,
                  dropdownDecoratorProps:
                  DropDownDecoratorProps(
                    baseStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                    dropdownSearchDecoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color:
                            Colors.black.withOpacity(0.45),
                            width: 2,
                          )),
                      contentPadding: const EdgeInsets.all(15),
                      focusedBorder: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.primary,
                              width: 1)),
                      floatingLabelStyle: TextStyle(
                          color: ColorManager.primary),
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
                  onChanged: (dynamic value) {
                    ref.read(itemProvider).updateSelectedDemo(value);
                  },
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  controller: _remarksController,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    labelText: 'Remarks',

                  ),
                  // validator: (value){
                  //   if(value!.trim().isEmpty){
                  //     return 'Email is required';
                  //   }
                  //   else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  //     return 'Invalid email';
                  //   }
                  //   return null;
                  // },
                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 10,),
                ElevatedButton(
                  onPressed: (){
                    if(_formKey.currentState!.validate()){
                      InquiryModel inquiry = InquiryModel(
                          inquiryId: inquiryId,
                          organizationName: organizationName,
                          address: address,
                          contact: _con,
                          email: _emailController.text.trim(),
                          nature: 0,
                          inquiryDateTime: DateTime.now().toString()
                      )
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: ColorManager.primary,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(
                        color: ColorManager.white,
                        fontFamily: 'Ubuntu',
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
