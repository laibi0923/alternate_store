// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:alternate_store/main.dart';
import 'package:alternate_store/model/cart_model.dart';
import 'package:alternate_store/model/product_model.dart';
import 'package:alternate_store/model/wishlist_model.dart';
import 'package:alternate_store/viewmodel/wishlist_viewmodel.dart';
import 'package:alternate_store/viewmodel/cart_viewmodel.dart';

class ProductDetailsViewModel extends ChangeNotifier{

  bool onWishList = false;
  int wishlistIndex = 0;
  int imageIndex = 0;

  void initProductDetails(){
    wishlistIndex = 0;
    imageIndex = 0;
    onWishList = false;
  }

  void updateImageIndex(int index){
    imageIndex = index;
    notifyListeners();
  }
 
  //  Check wishlist or not
  void checkOnWishlist(List<WishListModel> wishlist, String productNo){
    if(wishlist.isNotEmpty){
      for(int i = 0; i < wishlist.length; i++){
        if(wishlist[i].productNo == productNo){
          onWishList = true;
          wishlistIndex = i;
          break;
        }
      }
    }
  }

  //  Add to cart
  Future<void> addCart(CartViewModel cartViewModel, WishlistViewModel wishlistViewModel,  ProductModel productModel, int sizeIndex, int colorIndex,) async {
    await cartViewModel.addCart(
      CartModel(productModel.productNo, sizeIndex, colorIndex)
    );
    if(onWishList == true){
      wishlistViewModel.removeWishListItem(wishlistIndex);
    }
    Navigator.pop(navigatorKey.currentContext!);
    Navigator.pop(navigatorKey.currentContext!);
  }

  //  Add to wishlist
  Future<void> addWishList(ProductModel productModel, WishlistViewModel wishlistViewModel) async {
    if(onWishList == true){
      onWishList = false;
      wishlistViewModel.removeWishListItem(wishlistIndex);
      notifyListeners();
    } else {
      onWishList = true;
      wishlistViewModel.addWishList(WishListModel(productModel.productNo));
      notifyListeners();
    }
  }

  // void setCurrentSize(int index){
  //   currentSize = index;
  //   print('currentSize: $currentSize');
  //   notifyListeners();
  // }

  // void setCurrentColor(int index, String colorName){
  //   this.colorName = colorName;
  //   currentColor = index;
  //   notifyListeners();
  // }



}