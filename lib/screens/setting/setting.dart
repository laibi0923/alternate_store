// ignore_for_file: import_of_legacy_library_into_null_safe, unnecessary_null_comparison

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alternate_store/constants.dart';
import 'package:alternate_store/model/user_model.dart';
import 'package:alternate_store/screens/setting/private_policy.dart';
import 'package:alternate_store/screens/setting/return_policy.dart';
import 'package:alternate_store/screens/setting/user_entrance.dart';
import 'package:alternate_store/viewmodel/setting_viewmodel.dart';
import 'package:alternate_store/widgets/setting_screen/setting_info.dart';
import 'package:alternate_store/widgets/setting_screen/setting_personal_image.dart';

class Setting extends StatefulWidget {

  final bool emailVerified;
  final bool signInStatus;

  const Setting({Key? key, required this.emailVerified, required this.signInStatus}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  
  @override
  Widget build(BuildContext context) {

    final userModel = Provider.of<UserModel>(context);
    final _settingviewmodel = Provider.of<SettingViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: widget.signInStatus == false || widget.emailVerified == false ? 
      UserEntrance(popBack: false, emailVerifed: widget.emailVerified,) :
      Container(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [

            userModel == null ? 
            Container() :
            Container(
              padding: const EdgeInsets.only(top: 60, bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //  User Photo
                  GestureDetector(
                    onTap: () =>  _settingviewmodel.userImageSetting(userModel.uid),
                    child: userImage(userModel.userPhoto),
                  ),

                  //  Change User Info Button
                  GestureDetector(
                    onTap: () => _settingviewmodel.userInfoSetting(),
                    child: settingInfo(userModel.name.toUpperCase()),
                  ),

                  // Signout Button
                  GestureDetector(
                    onTap: () => _settingviewmodel.signout(),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 0),
                      child: Text(
                        '登出',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: xTextSize16),
                      ),
                    ),
                  )
                
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.only(top: 30, bottom: 10),
              child: const Text(
                '訂單',
                style: TextStyle(fontSize: xTextSize18, fontWeight: FontWeight.bold),
              ),
            ),

            //  訂單紀錄
            GestureDetector(
              onTap: () => _settingviewmodel.orderhistory(),
              child: Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  children: const [
                    Expanded(
                      child: Text('訂單紀錄')
                    ),
                    Icon(Icons.arrow_right_outlined)
                  ],
                )
              ),
            ),

            //  出貸紀錄
            GestureDetector(
              onTap: () => _settingviewmodel.shippingHistory(),
              child: Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  children: const [
                    Expanded(
                      child: Text('出貨紀錄')
                    ),
                    Icon(Icons.arrow_right_outlined)
                  ],
                )
              ),
            ),

            //  退貨紀錄
            GestureDetector(
              onTap: () => _settingviewmodel..refundhistory(),
              child: Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  children: const [
                    Expanded(
                      child: Text('退貨紀錄')
                    ),
                    Icon(Icons.arrow_right_outlined)
                  ],
                )
              ),
            ),

            //  已使用優惠代碼
            GestureDetector(
              onTap: () => _settingviewmodel.couponHistory(),
              child: Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  children: const [
                    Expanded(
                      child: Text('優惠代碼紀錄')
                    ),
                    Icon(Icons.arrow_right_outlined)
                  ],
                )
              ),
            ),

            Container(
              padding: const EdgeInsets.only(top: 30, bottom: 10),
              child: const Text(
                '一般設定',
                style: TextStyle(fontSize: xTextSize18, fontWeight: FontWeight.bold),
              ),
            ),

            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                children: const [
                  Expanded(
                    child: Text('語言')
                  ),
                  Text('繁體'),
                ],
              )
            ),

            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                children: const [
                  Expanded(
                    child: Text('貨幣')
                  ),
                  Text('HKD'),
                ],
              )
            ),

            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                children: const [
                  Expanded(
                    child: Text('暗黑模式')
                  ),
                  Text('關閉'),
                ],
              )
            ),

            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: const Text(
                '關於我們',
                style: TextStyle(fontSize: xTextSize18, fontWeight: FontWeight.bold),
              ),
            ),

            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivatePolicy())),
              child: Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: const Text('私隱政策'),
              ),
            ),

            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ReturnPolicy())),
              child: Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: const Text('退貨政策'),
              ),
            ),
            
            Container(
              height: 150,
            )

          ],
        ),
      )
    
    );
  }

}