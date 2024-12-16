



import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:khatasystem/common/colors.dart';
import 'package:khatasystem/features/pos/domain/model/pos_model.dart';
import 'package:khatasystem/features/pos/domain/services/pos_services.dart';


class ReceivedAmountTable extends ConsumerWidget {
  final int id;
  ReceivedAmountTable({required this.id});

  void _delDialog(BuildContext context,ref,ReceivedAmountModel receivedAmount) async {
    await showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Confirm Delete',style: TextStyle(color: ColorManager.black),),
            backgroundColor: ColorManager.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Do you want to delete the received amount?',style: TextStyle(fontSize: 16),),
                const SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.errorRed
                        ),
                        onPressed: () async {
                          final response = await POSServices().deleteReceivedAmount(receivedAmount: receivedAmount);
                          if(response.isLeft()){
                            final leftValue = response.fold((l) => l, (r) => null);
                            Fluttertoast.showToast(
                              msg: '$leftValue',
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: ColorManager.errorRed.withOpacity(0.9),
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            Navigator.pop(context);
                          }
                          else{
                            Fluttertoast.showToast(
                              msg: 'Transaction deleted',
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: ColorManager.errorRed.withOpacity(0.9),
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            ref.refresh(receivedAmountProvider(id));
                            ref.refresh(receivedTotalAmountProvider(id));
                            Navigator.pop(context);
                          }
                        },
                        child: Text('Yes',style: TextStyle(color: ColorManager.white),)
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.iconGray.withOpacity(0.5)
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
  Widget build(BuildContext context,ref) {
    final receivedAmountData = ref.watch(receivedAmountProvider(id));
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        backgroundColor: ColorManager.primary,
        leading: IconButton(onPressed: (){
          ref.refresh(receivedAmountProvider(id));
          ref.refresh(receivedTotalAmountProvider(id));
          Get.back();
        }, icon: Icon(Icons.chevron_left,color: ColorManager.white,)),
        title: Text('Received amount',style: TextStyle(color: ColorManager.white),),
        centerTitle: true,
      ),
      body: receivedAmountData.when(
          data: (receivedAmounts){
            return Row(
              children: [
                Expanded(
                  child: DataTable(
                      headingTextStyle: TextStyle(color: ColorManager.white,fontWeight: FontWeight.w500),
                      headingRowColor: MaterialStateColor.resolveWith((states) => ColorManager.primary),
                      columns: const [
                        DataColumn(label: Text('Ledger(Received)')),
                        DataColumn(label: Text('Amount')),
                        DataColumn(label: Text('Action')),
                      ],
                      rows: receivedAmounts.map((e) =>
                          DataRow(cells: [
                            DataCell(Text(e.ledgerName)),
                            DataCell(Text(e.drAmt.toString())),
                            DataCell(IconButton(
                                style: IconButton.styleFrom(
                                    backgroundColor: ColorManager.white
                                ),
                                onPressed: ()=>_delDialog(context, ref, e),
                                icon: Icon(Icons.delete,color: ColorManager.red,))),
                          ])
                      ).toList()
                  ),
                ),
              ],
            );
          },
          error: (error,stack) => Center(child: Text('$error'),), 
          loading: ()=>Center(child: CircularProgressIndicator(color: ColorManager.primary,),)
      )
    );
  }

}
