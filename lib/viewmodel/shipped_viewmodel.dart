// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:alternate_store/model/order_model.dart';
import 'package:alternate_store/model/order_product_model.dart';
import 'package:alternate_store/model/refund_model.dart';
import 'package:alternate_store/service/refund_services.dart';
import 'package:alternate_store/widgets/customize_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShippedViewModel extends ChangeNotifier{

  final List<OrderProductModel> shippedList = [];

  void getShippedProduct(List<OrderModel> list){
    shippedList.clear();
    for(int i = 0; i < list.length; i++){
      for(int k = 0; k < list[i].orderProduct.length; k++){
        OrderProductModel orderProductModel = OrderProductModel.fromFirestore(list[i].orderProduct[k]);
        if(orderProductModel.shippingStatus.isNotEmpty){
          shippedList.add(orderProductModel);
        }
      }
    }
  }

  Future<void> requestRefund(BuildContext context, String uid, OrderModel orderModel, int index) async {
    if(orderModel.orderProduct[index]['REFUND_ABLE'] == false) return;
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

}