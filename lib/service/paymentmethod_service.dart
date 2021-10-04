import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alternate_store/model/paymentmethod_model.dart';

class PaymentMethodService{

  final FirebaseFirestore _mFirestore = FirebaseFirestore.instance;

  //  取得支付方式
  Stream<List<PaymentMethodModel>> get getPaymentMethod{
    return _mFirestore
      .collection('payment_method').orderBy('CREATE_DATE', descending: true)
      .snapshots()
      .map((list) => 
      list.docs.map((doc) => 
      PaymentMethodModel.fromFirestore(doc.data(), doc.id)).toList());
  }
  
  
}