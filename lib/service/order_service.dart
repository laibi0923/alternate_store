// @dart=2.9
// ignore_for_file: missing_return

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alternate_store/model/order_model.dart';

class OrderService{
  final String uid;
  OrderService(this.uid);

  final FirebaseFirestore _mFirestore = FirebaseFirestore.instance;

  //  取得用戶過往下單紀錄
  Stream<List<OrderModel>> get orderHistory {
    if(uid.isNotEmpty){
      return _mFirestore
      .collection('user')
      .doc(uid)
      .collection('order').orderBy('ORDER_DATE', descending: true)
      .snapshots()
      .map((list) => list.docs.map((doc) => OrderModel.fromFirestore(doc.data(), doc.id)).toList());
    }
  }
  
  //  用戶下單
  Future takeOrder(OrderModel orderModel) async{

    try{
      DocumentReference xRef = FirebaseFirestore.instance.collection('user').doc(uid).collection('order').doc();
      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(xRef);
        if(!snapshot.exists){
          xRef.set({
            'ORDER_DATE' : orderModel.orderDate,
            'ORDER_NUMBER' : orderModel.orderNumber,
            'DISCOUNT_CODE' : orderModel.discountCode,
            'DISCOUNT_AMOUNT' : orderModel.discountAmount,
            'SUB_AMOUNT' : orderModel.subAmount,
            'SHIPPING_FREE' : orderModel.shippingAmount,
            'TOTAL_AMOUNT' : orderModel.totalAmount,
            'RECIPIENT_INFO' : orderModel.receipientInfo,
            'ORDER_PRODUCT' : orderModel.orderProduct,
            'PAYMENT_METHOD' : orderModel.paymentMothed
          });
        }
      });

      DocumentReference zRef = FirebaseFirestore.instance.collection('order').doc();
      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(zRef);
        if(!snapshot.exists){
          zRef.set({
            'ORDER_DATE' : orderModel.orderDate,
            'ORDER_NUMBER' : orderModel.orderNumber,
            'REF' : xRef,
            'ISCOMPLETE' : false,
          });
        }
      });
      
    }catch(e){
      // ignore: avoid_print
      print(e);
    }
  }


}