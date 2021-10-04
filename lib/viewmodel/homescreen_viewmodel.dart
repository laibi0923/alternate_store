// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alternate_store/main.dart';
import 'package:alternate_store/model/product_model.dart';

enum status{
  loading,
  completed
}

class HomeScreenViewModel extends ChangeNotifier{

  status _productlistState = status.loading;

  status get productlistState{
    return _productlistState;
  }

  void setProductlistStatus(List<ProductModel> productList){
    // ignore: unnecessary_null_comparison
    if(productList == null){
      _productlistState = status.loading;
    } else {
      _productlistState = status.completed;
    }
  }

  void navigatorPushtPage(page){
    Navigator.push(
      navigatorKey.currentContext!, 
      MaterialPageRoute(builder: (context) => page
      )
    );
  }

}