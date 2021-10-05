// @dart=2.9
import 'package:alternate_store/model/banner_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class BannerService{

  final CollectionReference _ref = FirebaseFirestore.instance.collection('banner');

  //  取得主頁 Promotion Banner
  Stream<List<BannerModel>> get getBanner {
    return _ref
      .snapshots()
      .map((list) => list.docs
      .map((doc) => BannerModel.fromFirestore(doc.data(), doc.id))
      .toList());
  }


}