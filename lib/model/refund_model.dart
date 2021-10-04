import 'package:cloud_firestore/cloud_firestore.dart';

class RefundModle{
  final Timestamp createDate;
  final Map<String, dynamic> product;

  RefundModle(this.createDate, this.product);

  factory RefundModle.initialData(){
    return RefundModle(Timestamp.now(), {});
  }

  RefundModle.fromFirestore(Map<String, dynamic> dataMap):
    createDate = dataMap['CREATE_DATE'],
    product = dataMap['PRODUCT'];
    

}