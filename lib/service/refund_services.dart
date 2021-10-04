// @dart=2.9
// ignore_for_file: missing_return

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alternate_store/model/refund_model.dart';

class RefundServices{

  final String uid;
  RefundServices(this.uid);

  final FirebaseFirestore _mFirestore = FirebaseFirestore.instance;

  //  取得用戶過往下單紀錄
  Stream<List<RefundModle>> get getRefund {
    if(uid.isNotEmpty){
      return _mFirestore
      .collection('user')
      .doc(uid)
      .collection('refund').orderBy('CREATE_DATE', descending: true)
      .snapshots()
      .map((list) => list.docs.map((doc) => RefundModle.fromFirestore(doc.data())).toList());
    }
  }

  //  用戶退貨
  Future makeRefund(RefundModle refundModle, String docid, List productList) async{

    try{

      //  於 Order Histoty 修改 RefundStatus
      DocumentReference xRef = FirebaseFirestore.instance.collection('user').doc(uid).collection('order').doc(docid);
      FirebaseFirestore.instance.runTransaction((transaction) async {
        xRef.update({
          'ORDER_PRODUCT' : productList,
        });
      });


      //  向店主發送通知
      DocumentReference zRef = FirebaseFirestore.instance.collection('refund').doc();
      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(zRef);
        if(!snapshot.exists){
          zRef.set({
            'CREATE_DATE' : refundModle.createDate,
            'REF' : xRef,
          });
        }
      });
      
    }catch(e){
      // ignore: avoid_print
      print(e);
    }
  }



}