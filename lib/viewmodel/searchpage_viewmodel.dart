// ignore_for_file: import_of_legacy_library_into_null_safe
import 'package:alternate_store/model/product_model.dart';
import 'package:flutter/material.dart';

class SearchPageViewModel extends ChangeNotifier{

  final List<ProductModel> _searchResultList = [];
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

  //  Init viewmodel
  void initViewModel(){
    _categoryCurrentIndex = 9999999;
    _searchFliedController.clear();
    _searchResultList.clear();
    // _searchResultCounter = 0;
  }

  //  Query from Category
  void queryfromCategory(int index, String queryString, List<ProductModel> productlist){
    _categoryCurrentIndex = index;
    _searchResultList.clear();
    for(int i = 0; i < productlist.length; i++){
      for(int k = 0; k < productlist[i].category.length; k ++){
        if(productlist[i].category[k].toString().trim().toLowerCase() == queryString.trim().toLowerCase()){
          _searchResultList.add(productlist[i]);
        }
      }
    } 
    notifyListeners();
  }

  //  Query from Category by String
  void queryStringfromCategory(String queryString, List<ProductModel> productlist){
    for(int i = 0; i < productlist.length; i++){
      for(int k = 0; k < productlist[i].category.length; k ++){
        if(productlist[i].category[k].toString().trim().toLowerCase() == queryString.trim().toLowerCase()){
          _searchResultList.add(productlist[i]);
        }
      }
    }
    notifyListeners();
  }

  //  Query from user input
  void queryfromString(String queryString, List<ProductModel> productlist){
    _categoryCurrentIndex = 9999999;
    if(queryString.trim().isEmpty){
      _searchResultList.clear();
    } else {
      _searchResultList.clear();
      for(int i = 0; i < productlist.length; i++){
        if(productlist[i].productName.toUpperCase().contains(queryString.toUpperCase())){
          _searchResultList.add(productlist[i]);
        }
      }
    }
    notifyListeners();
  }

}