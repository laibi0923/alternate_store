// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:alternate_store/model/order_model.dart';
import 'package:alternate_store/model/order_product_model.dart';
import 'package:flutter/material.dart';

class RefundProductViewModel extends ChangeNotifier{

  final List<OrderProductModel> refundProductList = [];

  void findRefundproduct(List<OrderModel> list){
    refundProductList.clear();
    for(int i = 0; i < list.length; i++){
      for(int k = 0; k < list[i].orderProduct.length; k++){
        OrderProductModel orderProductModel = OrderProductModel.fromFirestore(list[i].orderProduct[k]);
        if(orderProductModel.refundStatus == '已退貨'){
          refundProductList.add(orderProductModel);
        }
      }
    }
  }

}