// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:alternate_store/constants.dart';
import 'package:alternate_store/model/user_model.dart';
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
  Future<void> verifyDiscountCode(TextEditingController textEditingController, bool isSign, List<CouponModel> couponModel, List<UserCouponModel> userCoupon) async {

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

  //  
  Future<void> showDiscountBottomSheet(BuildContext context, bool isSign, TextEditingController textEditingController, List<CouponModel> couponModel, List<UserCouponModel> userCoupon) async {

    textEditingController.clear();

    if(!isSign){
      Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => const UserEntrance()));
    }else {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter mystate){
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(17), 
                      topRight: Radius.circular(17)
                    )
                  ),
                  
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Center(
                        child: Container(
                          height: 8,
                          width: 60,
                          margin:  const EdgeInsets.only(top: 15, bottom: 15),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(99)
                          ),
                        ),
                      ),

                      const Center(
                        child: Text(
                          '輸入優惠代碼',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                        )
                      ),

                      Container(height: 30,),

                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom:20),
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: TextFormField(
                          autofocus: true,
                          textAlign: TextAlign.center,
                          controller: textEditingController,
                          decoration: const InputDecoration(
                            enabledBorder:  OutlineInputBorder(
                              borderSide:  BorderSide(color: Colors.grey, width: 0.0),
                            ),
                            focusedBorder:  OutlineInputBorder(
                              borderSide:  BorderSide(color: Colors.grey, width: 0.0),
                            ),
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 10, bottom: 5, top: 5, right: 10),
                            // hintText: hints,
                            hintStyle: TextStyle(color: Colors.grey, fontSize: xTextSize14)
                          ),
                        ),
                      ),

                      Container(height: 30,),
              
                      //  
                      Container(
                        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: const Color(cPrimaryColor),
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(18)),
                            ),
                          ),
                          child: const Text('確認'),
                          onPressed: () {

                            if(textEditingController.text.isEmpty){
                              Navigator.pop(context);
                              CustomSnackBar().show(navigatorKey.currentContext!, '您所輸入優惠碼不正確');
                              return;
                            }

                            //  檢查用戶有冇用過此代碼
                            for (var element in userCoupon) {
                              if(element.code.toUpperCase() == textEditingController.text.toUpperCase()){
                                Navigator.pop(context);
                                CustomSnackBar().show(navigatorKey.currentContext!, '此優惠代碼您已經使用過');
                                return;
                              }
                            }

                            bool _findCoupon = false;
                            CouponModel icouponModel = CouponModel.initialData();
                            for(var element in couponModel){
                              if(element.couponCode.toUpperCase() == textEditingController.text.toUpperCase()){
                                _findCoupon = true;
                                icouponModel = element;
                              } else {
                                _findCoupon = false;
                              }
                            }

                            if(_findCoupon == false){
                              Navigator.pop(context);
                              CustomSnackBar().show(navigatorKey.currentContext!, '您所輸入優惠碼不正確');
                            } else {
                              if(icouponModel.unLimited == false && icouponModel.validDate.millisecondsSinceEpoch < Timestamp.now().millisecondsSinceEpoch){       
                                CustomSnackBar().show(navigatorKey.currentContext!, '此優惠已失效');
                                Navigator.pop(context);
                                return;
                              } else {
                                if(icouponModel.percentage == 0){
                                  //  判斷直接扣減銀碼
                                  discountAmount = icouponModel.discountAmount;
                                  discountCode = icouponModel.couponCode;
                                  sumAmount();
                                  notifyListeners();
                                } else {
                                  //  全單百分比折扣
                                  discountAmount = subAmount * icouponModel.percentage / 100;
                                  discountCode = icouponModel.couponCode;
                                  sumAmount();
                                  notifyListeners();
                                }
                                Navigator.pop(context);
                              }
                            }
                          },
                        )
                      )
                      
                    ],
                  ),
                );
              }
            ),
          ),
        )
      );
    }
  }

  //  移除單一購物車貨品
  void removeCartItem(int index){
    _sharedPreferencesCartList.removeAt(index);
    _cartList.removeAt(index);
    _setSharedPreferences();
    sumAmount();
    notifyListeners();
  }

  //  清空購物車
  void clearCart() {
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
  void checkbill(bool isLoggedIn, UserModel userModel){

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
        userModel: userModel,
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
        )
      ), 
    ));


  }

}
