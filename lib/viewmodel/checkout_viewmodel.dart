// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:alternate_store/constants.dart';
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

  Map<String, dynamic>? paymentIntentData;

  bool _saveShippingAddress = false;

  bool _showLoadingscreen = false;

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

  bool get shippingAddressStatus{
    return _saveShippingAddress;
  }

  void setShippingAddress(){
    if(_saveShippingAddress == true){
      _saveShippingAddress = false;
    } else {
      _saveShippingAddress = true;
    }
    notifyListeners();
  }
  
  Future<void> makePayment(BuildContext context, OrderModel orderModel, UserModel userInfo) async {

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
    
    //  判斷送貨地址
    if (userInfo.unitAndBuilding.isEmpty &&
        userInfo.estate.isEmpty &&
        userInfo.district.isEmpty) {
      CustomSnackBar().show(context, '請輸入送貨地址');
      return;
    }

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


}