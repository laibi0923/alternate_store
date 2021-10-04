import 'package:cloud_firestore/cloud_firestore.dart';

class CouponModel{
  final Timestamp createDate;
  final String couponCode;
  final double discountAmount;
  final double percentage;
  final Timestamp validDate;
  final String remark;
  final bool unLimited;

  CouponModel(this.createDate, this.couponCode, this.discountAmount, this.percentage, this.validDate, this.remark, this.unLimited);

  factory CouponModel.initialData(){
    return CouponModel(Timestamp.now(), '', 0.0, 0.0, Timestamp.now(), '', false);
  }

  CouponModel.fromFirestore(Map<String, dynamic> dataMap) :
    createDate = dataMap['CREATE_DATE'],
    couponCode = dataMap['CODE'],
    discountAmount = dataMap['DISCOUNT_AMOUNT'],
    percentage = dataMap['PERCENTAGE'],
    validDate = dataMap['VALID_DATE'],
    remark = dataMap['REMARK'],
    unLimited = dataMap['UNLIMITED'];

}