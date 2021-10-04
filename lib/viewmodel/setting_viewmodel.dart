// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:alternate_store/main.dart';
import 'package:alternate_store/screens/setting/coupon_history.dart';
import 'package:alternate_store/screens/setting/order_history.dart';
import 'package:alternate_store/screens/setting/refund_history.dart';
import 'package:alternate_store/screens/setting/shipped_history.dart';
import 'package:alternate_store/screens/setting/user_information.dart';
import 'package:alternate_store/service/auth_database.dart';
import 'package:alternate_store/service/auth_services.dart';
import 'package:alternate_store/service/servicesx.dart';
import 'package:alternate_store/widgets/customize_dialog.dart';

class SettingViewModel extends ChangeNotifier{


  void orderhistory(){
    Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => const OrderHistory()));
  }

  void shippingHistory(){
    Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => const ShippingHistory()));
  }

  void refundhistory(){
    Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => const RefundHistory()));
  }

  void couponHistory(){
    Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => const CouponHistory()));
  }

  void userInfoSetting(){
    Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => const UserInformation()));
  }


  Future<void> userImageSetting(String uid) async {

    try{
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if(image == null){
        return;
      } else {

        final File imageFile = File(image.path);
        String uploadImagepath = await ServicesX().uploadImage(
          'user/${ServicesX().randomStringGender(20, true).toUpperCase()}.jpg',
          imageFile
        );
        AuthDatabase(uid).setUserPhoto(uploadImagepath);
      }
    } on PlatformException catch (e){
      // ignore: avoid_print
      print('Failed to pick image : $e');
    }

    // var permissionStatus = await Permission.storage.status;
    // if(permissionStatus.isGranted){
    // } else if(permissionStatus.isDenied) {
    //   Permission.storage.shouldShowRequestRationale.then((value) async {

    //     var requestresult = await Permission.storage.request();

    //     if(value == false && requestresult.isPermanentlyDenied){

    //       bool result = await showDialog(
    //         context: navigatorKey.currentContext!, 
    //         builder: (BuildContext context){
    //           return const CustomizeDialog(
    //             title: '存取檔案權限', 
    //             content: '尚未取得存取檔案權限，如想使用此功能可前往設定頁面設定。',
    //             submitBtnText: '立即前往',
    //             cancelBtnText: '取消',
    //           );
    //         }
    //       );

    //       if(result == true) {openAppSettings();}

    //     }
    //   });
    // }
    
  }
  

  Future<void> signout() async {
    bool result = await showDialog(
      context: navigatorKey.currentContext!, builder: (BuildContext context){
        return const CustomizeDialog(
          title: '登出',
          content: '確定要登出?',
          submitBtnText: '登出',
          cancelBtnText: '取消',
        );
      }
    );
    if(result == true){
      Provider.of<AuthService>(navigatorKey.currentContext!, listen: false).signOut();
    } 
  }

}