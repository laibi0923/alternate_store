import 'package:cloud_firestore/cloud_firestore.dart';

class OrderReceiptModel{
  final Timestamp orderDate;
  final String orderNumber;
  final DocumentReference ref;
  final bool isComplete;
  final String docId;

  OrderReceiptModel(this.orderDate, this.orderNumber, this.ref, this.isComplete, this.docId);

  OrderReceiptModel.fromFirestore(Map<String, dynamic> dataMap, String id) :
    orderDate = dataMap['ORDER_DATE'],
    orderNumber= dataMap['ORDER_NUMBER'],
    ref = dataMap['REF'],
    isComplete = dataMap['ISCOMPLETE'],
    docId = id;
    
}