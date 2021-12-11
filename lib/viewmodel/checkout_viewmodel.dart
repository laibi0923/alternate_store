// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:alternate_store/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:alternate_store/model/order_model.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:alternate_store/model/user_model.dart';
import 'package:alternate_store/screens/cart/thankyou_screen.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:alternate_store/service/auth_database.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:alternate_store/service/order_service.dart';
import 'package:alternate_store/viewmodel/cart_viewmodel.dart';
import 'package:alternate_store/widgets/custom_snackbar.dart';

class CheckoutViewModel extends ChangeNotifier{

  List<bool> expansionPanelOpenStatus = [false, false];
  Map<String, dynamic>? paymentIntentData;
  bool _saveShippingAddress = false;
  bool _showLoadingscreen = false;
  late Map<String, String> _sfLockerLocation;
  late UserModel _userModel;

  void initData(){
    expansionPanelOpenStatus = [false, false];
    _saveShippingAddress = false;
    _showLoadingscreen = false;
    _sfLockerLocation = {};
  }

  bool get showloadingscreen{
    return _showLoadingscreen;
  }

  void setShowLoadingScreen(){
    if(_showLoadingscreen == true){
      _showLoadingscreen = false;
    } else {
      _showLoadingscreen = true;
    }
    notifyListeners();
  }

  void setSFLockerLocation(Map<String, String> location){
    _sfLockerLocation = location;
    notifyListeners();
  }
  
  Map<String, String> getSFLockerLocation(){
    return _sfLockerLocation;
  }

  //  儲存送貨地址狀態
  bool get shippingAddressStatus{
    return _saveShippingAddress;
  }

  //  儲存送貨地址
  void saveShippingAddress(){
    if(_saveShippingAddress == true){
      _saveShippingAddress = false;
    } else {
      _saveShippingAddress = true;
    }
    notifyListeners();
  }
  
  //  建立支付
  Future<void> makePayment(BuildContext context, OrderModel orderModel, UserModel userInfo) async {

    //  判斷送貨地址
    if (userInfo.unitAndBuilding.isEmpty &&
        userInfo.estate.isEmpty &&
        userInfo.district.isEmpty) {
      CustomSnackBar().show(context, '請輸入送貨地址');
      return;
    }

    setShowLoadingScreen();

    const url = 'https://us-central1-alternate-store.cloudfunctions.net/stripePayment';

    String amount = (orderModel.totalAmount * 100).toInt().toString();

    final http.Response response = await http.post(
      Uri.parse('$url?amount=$amount&currency=HKD')
    );

    paymentIntentData = json.decode(response.body);
    
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentData!['paymentIntent'],
        applePay: true,
        googlePay: true,
        style: ThemeMode.light,
        merchantCountryCode: 'HK',
        merchantDisplayName: storeName,
      )
    );

    try{
      await Stripe.instance.presentPaymentSheet(
        parameters: PresentPaymentSheetParameters(
          clientSecret: paymentIntentData!['paymentIntent'],
          confirmPayment: true
        )
      );
      paymentIntentData = null;
      orderInformation(context, userInfo, orderModel, '信用卡');
      setShowLoadingScreen();
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      setShowLoadingScreen();
    }

  }

  //  訂單資料
  Future<void> orderInformation(BuildContext context, UserModel userInfo, OrderModel orderModel, String paymentMothed) async {
    
    //  結用戶選中保存地址時用
    if(_saveShippingAddress == true){
      AuthDatabase(userInfo.uid).updateUserInfo(userInfo);
    }

    //  收件人資料
    Map<String, dynamic> receipientInfo = {
      'UNIT_AND_BUILDING': userInfo.unitAndBuilding,
      'ESTATE': userInfo.estate,
      'DISTRICT': userInfo.district,
      'CONTACT': userInfo.contactNo,
      'RECEIPIENT_NAME': userInfo.recipientName
    };

    //  訂單資料
    OrderModel tempOrderModel;
    tempOrderModel = OrderModel(
      Timestamp.now(),
      orderModel.orderNumber,
      orderModel.subAmount,
      orderModel.shippingAmount,
      orderModel.totalAmount,
      orderModel.discountCode,
      orderModel.discountAmount,
      receipientInfo,
      orderModel.orderProduct,
      paymentMothed,
    );

    //  落單
    OrderService(userInfo.uid).takeOrder(tempOrderModel).then((value) {
      Provider.of<CartViewModel>(context, listen: false).clearCart();
      Navigator.pop(context);
      
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ThankYouScreen()));
    });

    //  紀錄用戶已使用此優惠
    if (orderModel.discountCode.isNotEmpty) {
      AuthDatabase(userInfo.uid).addCouponRecord(orderModel.discountCode);
    }
  }

  //  運送地址列表切換
  void expansionPanelListToggler(int i, bool isOpen){
    for(int i = 0; i < expansionPanelOpenStatus.length; i ++){
      expansionPanelOpenStatus[i] = false;
    }
    expansionPanelOpenStatus[i] = !isOpen;
    notifyListeners();
  }



  //  ******************
  Future<void> newMakePayment(BuildContext context, UserModel userModel, OrderModel orderModel, String recipientName, String phone, String unit, String estate, String district) async {

    //  驗證資料
    verifyRecipientData(context, userModel, recipientName, phone, unit, estate, district);

    setShowLoadingScreen();

    const url = 'https://us-central1-alternate-store.cloudfunctions.net/stripePayment';

    String amount = (orderModel.totalAmount * 100).toInt().toString();

    final http.Response response = await http.post(
      Uri.parse('$url?amount=$amount&currency=HKD')
    );

    paymentIntentData = json.decode(response.body);
    
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentData!['paymentIntent'],
        applePay: true,
        googlePay: true,
        style: ThemeMode.light,
        merchantCountryCode: 'HK',
        merchantDisplayName: storeName,
      )
    );

    try{
      await Stripe.instance.presentPaymentSheet(
        parameters: PresentPaymentSheetParameters(
          clientSecret: paymentIntentData!['paymentIntent'],
          confirmPayment: true
        )
      );
      paymentIntentData = null;
      orderInformation(context, _userModel, orderModel, '信用卡');
      setShowLoadingScreen();
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      setShowLoadingScreen();
    }
  }

  //  驗證資料
  void verifyRecipientData(BuildContext context, UserModel userModel, String recipientName, String phone, String unit, String estate, String district){

    if(recipientName.trim().isEmpty){
      CustomSnackBar().show(context, '請選輸入收件人名稱');
      return;
    }
    if(phone.trim().isEmpty){
      CustomSnackBar().show(context, '請輸入聯絡電話');
      return;
    }
    if(expansionPanelOpenStatus[0] == false && expansionPanelOpenStatus[1] == false){
      CustomSnackBar().show(context, '請選擇送貨方式');
      return;
    }
    if(expansionPanelOpenStatus[0]){
      if(_sfLockerLocation.isEmpty){
        CustomSnackBar().show(context, '請選擇智能櫃地點');
        return;
      }
      _userModel = UserModel(
        userModel.lastModify, 
        userModel.uid,
        userModel.email, 
        userModel.name, 
        phone, 
        _sfLockerLocation['code'], 
        _sfLockerLocation['location'], 
        _sfLockerLocation['openingHour'], 
        '', 
        recipientName
      );
    }
    if(expansionPanelOpenStatus[1]){
      if(unit.trim().isEmpty){
        CustomSnackBar().show(context, '請輸入單位或樓層');
        return;
      }
      if(estate.trim().isEmpty){
        CustomSnackBar().show(context, '請輸入大廈名稱');
        return;
      }
      if(district.trim().isEmpty){
        CustomSnackBar().show(context, '請輸入地區');
        return;
      }
      _userModel = UserModel(
        userModel.lastModify, 
        userModel.uid,
        userModel.email, 
        userModel.name, 
        phone, 
        unit, 
        estate, 
        district, 
        '', 
        recipientName
      );
    }
  }


}