// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alternate_store/model/order_model.dart';
import 'package:alternate_store/model/refund_model.dart';
import 'package:alternate_store/model/user_model.dart';
import 'package:alternate_store/service/refund_services.dart';
import 'package:alternate_store/widgets/customize_dialog.dart';import 'package:alternate_store/widgets/order_history/shipped_product_view.dart';

class ShippingHistory extends StatelessWidget {
  const ShippingHistory({ Key? key }) : super(key: key);

  Future<void> _requestRefund(
    BuildContext context, String uid, OrderModel orderModel, int index) async {

    if(orderModel.orderProduct[index]['REFUND_ABLE'] == false){
      return;
    } 

    bool dialogResult = await showDialog(
      context: context, 
      builder: (BuildContext context){
        return const CustomizeDialog(
          title: '退貨申請',
          content: '確定要退此貨品嗎? \n 申請後我們會以電郵形式與您了解。', 
          submitBtnText: '確定',
          cancelBtnText: '取消'
        );
      }
    );

    if(dialogResult == true){

      orderModel.orderProduct[index]['REFUND_STATUS'] = '退貨申請中';

      RefundServices(uid).makeRefund(
        RefundModle(
          Timestamp.now(), 
          orderModel.orderProduct[index], 
        ),
        orderModel.docId,
        orderModel.orderProduct
      );
    }

  }

  @override
  Widget build(BuildContext context) {

    final userInfo = Provider.of<UserModel>(context);
    final orderHistoryList = Provider.of<List<OrderModel>>(context);
    // ignore: unnecessary_null_comparison
    if(orderHistoryList == null) {return Container();}
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('出貨紀錄'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () => Navigator.pop(context), 
              icon: const Icon(Icons.close)
            ),
          )
        ],
      ),
      body: Center(
        child: orderHistoryList.isEmpty ? 
        const Text(
          '尚未有任何出貨紀錄',
          style: TextStyle(color: Colors.grey),
        ) :
        ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: orderHistoryList.length,
          itemBuilder: (context, index){
            return ListView.builder(
              itemCount: orderHistoryList[index].orderProduct.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 20, right: 20),
              itemBuilder: (context, zindex){
                return GestureDetector(
                  onTap: () => _requestRefund(
                    context, 
                    userInfo.uid, 
                    orderHistoryList[index],
                    zindex
                  ),
                  child: shippedProductView(
                    orderHistoryList[index].orderProduct[zindex],
                    orderHistoryList[index].orderNumber
                  ),
                );
              }
            );
          }
        ),
      ),
    );
  }
}