// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:alternate_store/model/order_product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alternate_store/main.dart';
import 'package:alternate_store/model/cart_model.dart';
import 'package:alternate_store/model/coupon_model.dart';
import 'package:alternate_store/model/order_model.dart';
import 'package:alternate_store/model/product_model.dart';
import 'package:alternate_store/model/usercoupon_model.dart';
import 'package:alternate_store/screens/cart/checkout.dart';
import 'package:alternate_store/screens/setting/user_entrance.dart';
import 'package:alternate_store/service/servicesx.dart';
import 'package:alternate_store/widgets/custom_snackbar.dart';
import 'package:alternate_store/widgets/textfelid_dialog.dart';

class CartViewModel extends ChangeNotifier {

  final SharedPreferences mSharedPreferences;
  CartViewModel({required this.mSharedPreferences});
  
  List<CartModel> _sharedPreferencesCartList = [];
  final List<ProductModel> _cartList = [];
  double subAmount = 0.0;
  String discountCode = '';
  double discountAmount = 0.0;
  double shippingFree = 0.0;
  double totalAmount = 0.0;
  final SlidableController _slidableController = SlidableController();
  
  
  //  加入購物車 (Product Details)
  addCart(CartModel item) {
    _sharedPreferencesCartList.add(item);
    _setSharedPreferences();
    notifyListeners();
  }

  void _setSharedPreferences() {
    mSharedPreferences.setString('cartInfo', CartModel.encode(_sharedPreferencesCartList));
  }

  void _getSharedPreferences(){
    String cartString = mSharedPreferences.getString('cartInfo') ?? '';
    _sharedPreferencesCartList = CartModel.decode(cartString);
  }

  //  取得 SharedPerferences 購物車
  List<CartModel> get getSharedPerferencesCartList{
    _getSharedPreferences();
    return _sharedPreferencesCartList;
  }


   //  取得購物車內貨品資料
  void setCatList(List<ProductModel> productlist){
    _cartList.clear();
    subAmount = 0.0;
    discountCode = '';
    discountAmount = 0.0;
    shippingFree = 0.0;
    totalAmount = 0.0;

    _getSharedPreferences();
    for (int i = 0; i < _sharedPreferencesCartList.length; i++) {
      for(int k = 0; k < productlist.length; k++){
        if(productlist[k].productNo == _sharedPreferencesCartList[i].productNo){
          _cartList.add(productlist[k]);
        }
      }    
    }
    sumAmount();
  }

  
  List<ProductModel> get getCartList{
    return _cartList;
  }


  SlidableController get slidableController{
    return _slidableController;
  }


  //  使用優惠代碼
  Future<void> verifyDiscountCode(bool isSign, List<CouponModel> couponModel, List<UserCouponModel> userCoupon) async {

    //  如用戶有登入跳出優惠碼輸入
    if(isSign){
      String dialogResult = await showDialog(
        context: navigatorKey.currentContext!, 
        builder: (BuildContext context){
          return textFelidDialog(
            context, 
            '輸入優惠代碼', 
            'NEWUSER2020'
          );
        }
      );

      if(dialogResult.isNotEmpty){
        //  檢查用戶有冇用過此代碼
        for (var element in userCoupon) {
          if(element.code.toUpperCase() == dialogResult.toUpperCase()){
            CustomSnackBar().show(navigatorKey.currentContext!, '此優惠代碼您已經使用過');
            return;
          }
        }
        //  判斷優惠代碼過期
        for (var element in couponModel) {
          if(element.couponCode.toUpperCase().trim() == dialogResult.toUpperCase().trim()){
            if(element.unLimited == false && element.validDate.millisecondsSinceEpoch < Timestamp.now().millisecondsSinceEpoch){
              
              CustomSnackBar().show(navigatorKey.currentContext!, '此優惠已失效');
              return;

            } else {

              //  判斷直接扣減銀碼
              if(element.percentage == 0){
                discountAmount = element.discountAmount;
                discountCode = element.couponCode;
                sumAmount();
                notifyListeners();
              }

              //  全單百分比折扣
              else {
                discountAmount = subAmount * element.percentage / 100;
                discountCode = element.couponCode;
                sumAmount();
                notifyListeners();
              }

            }
          } else {
            CustomSnackBar().show(navigatorKey.currentContext!, '您所輸入優惠碼不正確');
          }
        }
      }

    } else {
      Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => const UserEntrance()));
    }

    


  }

  //  移除單一購物車貨品
  removeCartItem(int index){
    _sharedPreferencesCartList.removeAt(index);
    _cartList.removeAt(index);
    _setSharedPreferences();
    sumAmount();
    notifyListeners();
  }

  //  清空購物車
  clearCart() {
    _sharedPreferencesCartList.clear();
    _setSharedPreferences();
    _cartList.clear();
    notifyListeners();
  }

  //  計算銀碼
  void sumAmount(){

    subAmount = 0.0;
    shippingFree = 0.0;
    totalAmount = 0.0;

    for (var element in _cartList) {
      if(element.discountPrice != 0){
        subAmount = subAmount + element.discountPrice;
      } else {
        subAmount = subAmount + element.price;
      }
    }
    totalAmount = subAmount - discountAmount + shippingFree;
  }

  //  結帳
  void checkbill(bool isLoggedIn){

    //  1. 重新將 Cart 內物品資料整理
    List<Map<String, dynamic>> tempProductList = [];

    for(int k = 0; k < _sharedPreferencesCartList.length; k++){
      tempProductList.add({
        'PRODUCT_NO' : _cartList[k].productNo,
        'PRODUCT_NAME' : _cartList[k].productName,
        'PRODUCT_IMAGE' : _cartList[k].imagePatch[0],
        'REFUND_ABLE' : _cartList[k].refundable,
        'PRICE' : _cartList[k].price,
        'DISCOUNT' : _cartList[k].discountPrice,
        'SIZE' : _cartList[k].size[_sharedPreferencesCartList[k].size],
        'COLOR_IMAGE' : _cartList[k].color[_sharedPreferencesCartList[k].color]['COLOR_IMAGE'],
        'COLOR_NAME' : _cartList[k].color[_sharedPreferencesCartList[k].color]['COLOR_NAME'],
        'SHIPPING_STATUS' : '',
        'REFUND_STATUS' : ''
      });
    }

    //  2. 判斷用戶有冇 Login , 有就跳去付款頁, 冇就跳去登入頁
    Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => !isLoggedIn ? 
    const UserEntrance(popBack: true) : 
      CheckOut(
        orderModel: OrderModel(
          Timestamp.now(), 
          'OD${ServicesX().randomStringGender(10, false)}', 
          subAmount, 
          shippingFree, 
          totalAmount, 
          discountCode, 
          discountAmount, 
          {},
          tempProductList,
          '',
          ''
        )
      )
    ));


  }

}
