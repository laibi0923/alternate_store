// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alternate_store/model/category_model.dart';

class CategoryDatabase{

  final CollectionReference _ref = FirebaseFirestore.instance.collection('category');

  //  取得所有貨品
  Stream<List<CategoryModel>> get getCategory {
    return _ref
      .orderBy('CREATE_DATE' , descending: false)  
      .snapshots()
      .map((list) => list.docs
      .map((doc) => CategoryModel.fromFirestore(doc.data()))
      .toList());
  }

  //  新增
  void addCategory(CategoryModel categoryModel){

    DocumentReference docRef = _ref.doc();
    FirebaseFirestore.instance.runTransaction((transaction) async {
      //DocumentSnapshot snapshot = await transaction.get(docRef);
      docRef.set({
        'CREATE_DATE' : categoryModel.createDate,
        'NAME' : categoryModel.name,
        'QUICK_SEARCH' : categoryModel.quickSearch
      });
    });
    
  }

  // 刪除
  void delCategory(String docId){
    _ref.doc(docId).delete();
  }

  void setQuickSearch (String docId, bool isSeted){
    if(isSeted == true){
      _ref.doc(docId).update({
        'QUICK_SEARCH' : false
      });
    } else {
      _ref.doc(docId).update({
        'QUICK_SEARCH' : true
      });
    }
    
  }


  
}