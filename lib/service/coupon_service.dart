import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alternate_store/model/coupon_model.dart';

class CouponService{

  final FirebaseFirestore _mFirestore = FirebaseFirestore.instance;

  //  取得折扣代碼
  Stream<List<CouponModel>> get getCouponCode{
    return _mFirestore
      .collection('coupon')
      .snapshots()
      .map((list) => 
      list.docs.map((doc) => 
      CouponModel.fromFirestore(doc.data())).toList());
  }

}