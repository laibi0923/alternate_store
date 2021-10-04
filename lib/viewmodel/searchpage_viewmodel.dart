// ignore_for_file: import_of_legacy_library_into_null_safe
import 'package:alternate_store/model/category_model.dart';
import 'package:alternate_store/model/product_model.dart';
import 'package:flutter/material.dart';

enum status{
  loading,
  completed
}

class SearchPageViewModel extends ChangeNotifier{

  List<ProductModel> _productlist = [];
  List<CategoryModel> _categorylist = [];

  final List<ProductModel> _searchResultList = [];
  var categoryliststate = status.loading;
  int _categoryCurrentIndex = 0;
  final TextEditingController _searchFliedController = TextEditingController();

  TextEditingController get searchFliedController{
    return _searchFliedController;
  }

  List<ProductModel> get searchResultList{
    return _searchResultList;
  }

  void setCategoryCurrentIndex(int index){
    _categoryCurrentIndex = index;
  }

  int get categoryCurrentIndex{
    return _categoryCurrentIndex;
  }

  void initViewModel(List<ProductModel> productlist, List<CategoryModel> categorylist){
    _productlist = productlist;
    _categorylist = categorylist;
    _categoryCurrentIndex = 0;
    _searchFliedController.clear();
    _searchResultList.clear();
  }

  List<CategoryModel> get getcategoryList{
    return _categorylist;
  }

  void setCategoryListStatus(List<CategoryModel> categorylist){
    // ignore: unnecessary_null_comparison
    if(categorylist == null){
      categoryliststate = status.loading;
    } else {
      categoryliststate = status.completed;
    }
  }


  //  Query from Category
  void queryfromCategory(int index){
    _categoryCurrentIndex = index;
    _searchResultList.clear();
    for(int i = 0; i < _productlist.length; i++){
      for(int k = 0; k < _productlist[i].category.length; k ++){
        if(_productlist[i].category[k].toString().trim().toLowerCase() == _categorylist[index].name.trim().toLowerCase()){
          _searchResultList.add(_productlist[i]);
        }
      }
    } 
    notifyListeners();
  }

  //  Query from Category by String
  void queryStringfromCategory(String queryString){
    for(int i = 0; i < _productlist.length; i++){
      for(int k = 0; k < _productlist[i].category.length; k ++){
        if(_productlist[i].category[k].toString().trim().toLowerCase() == queryString.trim().toLowerCase()){
          _searchResultList.add(_productlist[i]);
        }
      }
    }
    notifyListeners();
  }

  //  Query from user input
  void queryfromString(String queryString){
    _searchResultList.clear();
    for(int i = 0; i < _productlist.length; i++){
      if(_productlist[i].productName.trim().toLowerCase().contains(queryString.trim().toLowerCase())){
        _searchResultList.add(_productlist[i]);
      }
    }
    notifyListeners();
  }

}