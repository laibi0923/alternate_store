import 'dart:ui';
// ignore: import_of_legacy_library_into_null_safe
import 'package:alternate_store/model/order_model.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:alternate_store/model/user_model.dart';
import 'package:alternate_store/viewmodel/checkout_viewmodel.dart';
import 'package:alternate_store/widgets/customize_phonetextfield.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:alternate_store/widgets/customize_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alternate_store/constants.dart';
import 'package:alternate_store/widgets/set_cachednetworkimage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckOut extends StatefulWidget {
  final OrderModel? orderModel;
  const CheckOut({Key? key, this.orderModel}) : super(key: key);

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {

  // bool _saveShippingAddres = false;
  final TextEditingController _userRecipientEditingControlle = TextEditingController();
  final TextEditingController _phoneEditingControlle = TextEditingController();
  final TextEditingController _unitEditingControlle = TextEditingController();
  final TextEditingController _estateEditingControlle = TextEditingController();
  final TextEditingController _districtEditingControlle = TextEditingController();
  
  @override
  void dispose() {
    _userRecipientEditingControlle.dispose();
    _phoneEditingControlle.dispose();
    _unitEditingControlle.dispose();
    _estateEditingControlle.dispose();
    _districtEditingControlle.dispose();
    super.dispose();
  }

  void initUserInfo(UserModel userInfo) {
    _phoneEditingControlle.text = userInfo.contactNo;
    _userRecipientEditingControlle.text = userInfo.recipientName;
    _unitEditingControlle.text = userInfo.unitAndBuilding;
    _estateEditingControlle.text = userInfo.estate;
    _districtEditingControlle.text = userInfo.district;
  }

  @override
  Widget build(BuildContext context) {

    final userInfo = Provider.of<UserModel>(context);
    final checkoutViewModel = Provider.of<CheckoutViewModel>(context);

    // ignore: unnecessary_null_comparison
    if(userInfo != null){
      initUserInfo(userInfo); 
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [

          ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(top: 80, left: 20, right: 20),
            children: [

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '運送地址',
                    style: TextStyle(fontSize: xTextSize26, fontWeight: FontWeight.bold),
                  ),
                  CustomizeTextField(
                    title: '收件人名稱',
                    maxLine: 1,
                    mTextEditingController: _userRecipientEditingControlle,
                  ),
                  CustomizePhoneTextField(
                    title: '聯絡電話',
                    isPassword: false,
                    mTextEditingController: _phoneEditingControlle,
                  ),
                  CustomizeTextField(
                    title: '室 / 樓層',
                    maxLine: 1,
                    mTextEditingController: _unitEditingControlle,
                  ),
                  CustomizeTextField(
                    title: "大廈名稱",
                    maxLine: 1,
                    mTextEditingController: _estateEditingControlle,
                  ),
                  CustomizeTextField(
                    title:'屋苑名稱 / 地區',
                    maxLine: 1,
                    mTextEditingController: _districtEditingControlle,
                  ),
                  GestureDetector(
                    onTap: () => checkoutViewModel.setShippingAddress(),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: checkoutViewModel.shippingAddressStatus ?
                            const Icon(
                              Icons.radio_button_checked,
                              color: Color(cPrimaryColor)
                            ) : 
                            const Icon(
                              Icons.radio_button_unchecked,
                              color: Color(cPrimaryColor),                  
                            ),
                          ),
                          const Text('保存運送地址')
                        ],
                      ),
                    ),
                  )
                ],
              ),

              //  Total payment amount
              Padding(
                padding: const EdgeInsets.only(bottom: 40, top: 20),
                child: Text(
                '付款總額\nHKD\$ ${widget.orderModel?.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: xTextSize18, 
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center
                ),
              ),
 
              Row(
                children: [
                  SizedBox(
                    height: 50,
                    child: setCachedNetworkImage(
                      'https://logodix.com/logo/797210.png',
                      BoxFit.cover
                    ),
                  )
                ],
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color(cPrimaryColor),
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                  ),
                ),
                onPressed: () {
                  UserModel usermodel = UserModel(
                    Timestamp.now(),
                    userInfo.uid,
                    userInfo.email,
                    userInfo.name, 
                    _phoneEditingControlle.text, 
                    _unitEditingControlle.text, 
                    _estateEditingControlle.text, 
                    _districtEditingControlle.text, 
                    '', 
                    _userRecipientEditingControlle.text
                  );
                  checkoutViewModel.makePayment(
                    context,
                    widget.orderModel!,
                    usermodel
                  );
                },
                child: const Text('輸入信用卡付款')
              )

            ],
          ),

          //  關閉按鈕
          Positioned(
            top: 60,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(99)
              ),
              child: const Icon(Icons.close)),
            )
          ),

          checkoutViewModel.showloadingscreen ?
          Container(
            color: const Color(0x90000000),
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(cPrimaryColor),
              )
            ),
          ) : 
          Container()

        ],
      ),
    );
  }

}
