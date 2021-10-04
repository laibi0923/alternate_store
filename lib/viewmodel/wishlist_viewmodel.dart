// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alternate_store/model/product_model.dart';
import 'package:alternate_store/model/wishlist_model.dart';

class WishlistViewModel extends ChangeNotifier{

  final SharedPreferences mSharedPreferences;

  WishlistViewModel({required this.mSharedPreferences});

  List<WishListModel> _sharedPreferencesWishlist = []; 
  final List<ProductModel> _wishList = [];

  void _setSharedPreferences() {
  mSharedPreferences.setString('wishListInfo', WishListModel.encode(_sharedPreferencesWishlist));
}

  void _getSharedPreferences(){
    String wishString = mSharedPreferences.getString('wishListInfo') ?? '';
    _sharedPreferencesWishlist = WishListModel.decode(wishString);
  }

  //  取得 SharedPerferences 喜好清單
  List<WishListModel> get getSharedPerferencesCartList{
    _getSharedPreferences();
    return _sharedPreferencesWishlist;
  }

  //  取得喜好清單內貨品資料
  void getProductData(List<ProductModel> productlist){
    _wishList.clear();
    _getSharedPreferences();

    for (int i = 0; i < _sharedPreferencesWishlist.length; i++) {
      for(int k = 0; k < productlist.length; k++){
        if(productlist[k].productNo == _sharedPreferencesWishlist[i].productNo){
          _wishList.add(productlist[k]);
        }
      }    
    }
  }

  List<ProductModel> get getWishList{
    return _wishList;
  }


  //  加入喜好貨品
  addWishList(WishListModel item) {
    _sharedPreferencesWishlist.add(item);
    _setSharedPreferences();
    notifyListeners();
  }
 
  //  移除單一喜好貨品
  removeWishListItem(int index){ 
    _sharedPreferencesWishlist.removeAt(index);
    _setSharedPreferences();
    notifyListeners();
  }

  //  清空喜好貨品
  clearWishList() {
    _sharedPreferencesWishlist.clear();
    _setSharedPreferences();
    notifyListeners();
  }

  refresh(){
    notifyListeners();
  }

}