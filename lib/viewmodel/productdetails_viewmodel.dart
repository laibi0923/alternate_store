// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:alternate_store/main.dart';
import 'package:alternate_store/model/cart_model.dart';
import 'package:alternate_store/model/product_model.dart';
import 'package:alternate_store/model/wishlist_model.dart';
import 'package:alternate_store/viewmodel/wishlist_viewmodel.dart';
import 'package:alternate_store/viewmodel/cart_viewmodel.dart';
import 'package:share_plus/share_plus.dart';

class ProductDetailsViewModel extends ChangeNotifier{

  bool onWishList = false;
  int wishlistIndex = 0;
  int imageIndex = 0;

  void initProductDetails(){
    wishlistIndex = 0;
    imageIndex = 0;
    onWishList = false;
  }

  //  Update image index when user scoll image pageview
  void updateImageIndex(int index){
    imageIndex = index;
    notifyListeners();
  }
 
  //  Check on wishlist or not
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

  //  Share product information to social media
  Future<void> sharedProductDetails(String imageUri, String uri) async {
    //  TODO shared product to outside
    await Share.share('Testing : \n\n $imageUri \n\n $uri');
  }



}