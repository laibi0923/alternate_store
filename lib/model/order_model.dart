// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final Timestamp orderDate;
  final String orderNumber;
  final double subAmount;
  final double shippingAmount;
  final double totalAmount;
  final String discountCode;
  final double discountAmount;
  final Map<String, dynamic> receipientInfo;
  final List orderProduct;
  final String paymentMothed;
  final String paymentReceipt;
  String docId;

  OrderModel(this.orderDate, this.orderNumber, this.subAmount, this.shippingAmount, this.totalAmount, this.discountCode, this.discountAmount, this.receipientInfo, this.orderProduct, this.paymentMothed, this.paymentReceipt);
  
  OrderModel.fromFirestore(Map<String, dynamic> dataMap, String id) :
    orderDate = dataMap['ORDER_DATE'],
    orderNumber = dataMap['ORDER_NUMBER'],
    subAmount = dataMap['SUB_AMOUNT'],
    shippingAmount = dataMap['SHIPPING_FREE'],
    totalAmount = dataMap['TOTAL_AMOUNT'],
    discountAmount = dataMap['DISCOUNT_AMOUNT'],
    discountCode = dataMap['DISCOUNT_CODE'],
    receipientInfo = dataMap['RECIPIENT_INFO'],
    orderProduct = dataMap['ORDER_PRODUCT'],
    paymentMothed = dataMap['PAYMENT_METHOD'],
    paymentReceipt = dataMap['PAYMENT_RECEIPT'],
    docId = id;
}
