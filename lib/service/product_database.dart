// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alternate_store/model/product_model.dart';

class ProductDatabase {

  final CollectionReference _ref = FirebaseFirestore.instance.collection('product');

  //  取得所有貨品
  Stream<List<ProductModel>> get getProduct {
    return _ref
      .where('INSTOCK', isEqualTo: true)
      .snapshots()
      .map((list) => list.docs
      .map((doc) => ProductModel.fromFirestore(doc.data()))
      .toList());
  }

}
