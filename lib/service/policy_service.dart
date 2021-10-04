// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alternate_store/model/privatepolicy_model.dart';
import 'package:alternate_store/model/returnpolicy_model.dart';

class PrivatePolicyService{

  final FirebaseFirestore _mFirestore = FirebaseFirestore.instance;

  //  取得用戶政策
  Stream<PrivatePolicyModel> get getPrivatePolicyContent{
    return _mFirestore
    .collection('policy')
    .doc('private_policy')
    .snapshots()
    .map((list) => PrivatePolicyModel.fromFirestore(list.data()));
  }

  //  取得退貨政策
  Stream<ReturnPolicyModel> get getReturnPolicyContent{
    return _mFirestore
    .collection('policy')
    .doc('return_policy')
    .snapshots()
    .map((list) => ReturnPolicyModel.fromFirestore(list.data()));
  }



}