//@dart=2.9
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:alternate_store/main.dart';
import 'package:alternate_store/model/order_model.dart';
import 'package:alternate_store/model/paymentmethod_model.dart';
import 'package:alternate_store/model/user_model.dart';
import 'package:alternate_store/screens/cart/thankyou_screen.dart';
import 'package:alternate_store/service/auth_database.dart';
import 'package:alternate_store/service/order_service.dart';
import 'package:alternate_store/service/servicesx.dart';
import 'package:alternate_store/viewmodel/cart_viewmodel.dart';
import 'package:alternate_store/widgets/custom_snackbar.dart';
import 'package:alternate_store/widgets/customize_dialog.dart';
import 'package:alternate_store/widgets/loading_indicator.dart';

class CheckoutViewModel extends ChangeNotifier{


  // 下載支付二維碼
  Future<void> downloadQRCode(PaymentMethodModel paymentMethodModel) async {
    var permissionStatus = await Permission.storage.status;

    if(permissionStatus.isGranted){

      try{
        
        // Directory directory = Platform.isAndroid ? 
        // await getExternalStorageDirectory() :
        // await getApplicationDocumentsDirectory();

        // print(directory.path);

        // await FlutterDownloader.enqueue(
        //   url: paymentMethodModel.qrImage,
        //   savedDir: directory.path,
        //   showNotification: true,
        //   openFileFromNotification: true,
        // );

        // print('>>>>>>');

      } on PlatformException catch (e){
        // ignore: avoid_print
        print('Failed to pick image : $e');
      }

    } else if(permissionStatus.isDenied) {

      Permission.storage.shouldShowRequestRationale.then((value) async {

        var requestresult = await Permission.storage.request();

        if(value == false && requestresult.isPermanentlyDenied){

          bool result = await showDialog(
            context: navigatorKey.currentContext,
            builder: (BuildContext context){
              return const CustomizeDialog(
                title: '存取檔案權限',
                content: '尚未取得存取檔案權限，如想使用此功能可前往設定頁面設定。',
                submitBtnText: '立即前往',
                cancelBtnText: '取消',
              );
            }
          );

          if(result == true) {openAppSettings();}

        }
      });

    }
  }

  //  訂單資料
  Future<void> uploadpaymentButtonOnClick(BuildContext context, UserModel userInfo, OrderModel orderModel, String paymentMothed) async {
    //  判斷送貨地址
    if (userInfo.unitAndBuilding.isEmpty &&
        userInfo.estate.isEmpty &&
        userInfo.district.isEmpty) {
      CustomSnackBar().show(context, '請輸入送貨地址');
      return;
    }

    //  上載支付收據
    String uploadImagepath = '';
    var permissionStatus = await Permission.storage.status;

    if (permissionStatus.isGranted) {
      try {
        final image =
            await ImagePicker().pickImage(source: ImageSource.gallery);

        if (image == null) {
          return;
        } else {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return loadingIndicator();
              });

          final File imageFile = File(image.path);
          uploadImagepath = await ServicesX().uploadImage(
              'payment/${ServicesX().randomStringGender(10, true).toUpperCase()}.jpg',
              imageFile);
        }
      } on PlatformException catch (e) {
        // ignore: avoid_print
        print('Failed to pick image : $e');
      }
    }

    if (permissionStatus.isDenied) {
      Permission.storage.shouldShowRequestRationale.then((value) async {
        var requestresult = await Permission.storage.request();
        if (value == false && requestresult.isPermanentlyDenied) {
          bool result = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return const CustomizeDialog(
                  title: '存取檔案權限',
                  content: '尚未取得存取檔案權限，如想使用此功能可前往設定頁面設定。',
                  submitBtnText: '立即前往',
                  cancelBtnText: '取消',
                );
              });
          if (result == true) {
            openAppSettings();
            return;
          }
        }
      });

      return;
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
      uploadImagepath
    );

    //  落單
    OrderService(userInfo.uid).takeOrder(tempOrderModel).then((value) {
      Provider.of<CartViewModel>(context, listen: false).clearCart();
      Navigator.pop(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const ThankYouScreen()));
    });

    //  紀錄用戶已使用此優惠
    if (orderModel.discountCode.isNotEmpty) {
      AuthDatabase(userInfo.uid)
          .addCouponRecord(orderModel.discountCode);
    }
  }


}