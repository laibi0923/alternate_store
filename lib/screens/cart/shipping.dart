// @dart=2.9
import 'package:alternate_store/constants.dart';
import 'package:alternate_store/model/user_model.dart';
import 'package:alternate_store/service/auth_database.dart';
import 'package:alternate_store/widgets/custom_snackbar.dart';
import 'package:alternate_store/widgets/customize_phonetextfield.dart';
import 'package:alternate_store/widgets/customize_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Shipping extends StatefulWidget {
  const Shipping({ key }) : super(key: key);

  @override
  State<Shipping> createState() => _ShippingState();
}

class _ShippingState extends State<Shipping> {

  final TextEditingController _clientNameEditingControlle =  TextEditingController();
  final TextEditingController _clientPhoneEditingControlle =  TextEditingController();
  final TextEditingController _address1EditingControlle =  TextEditingController();
  final TextEditingController _address2EditingControlle =  TextEditingController();
  final TextEditingController _address3EditingControlle =  TextEditingController();

  void _saveAddressButtonOnClick(String userId, UserModel userInfo){

    if(_clientNameEditingControlle.text.isEmpty){
      CustomSnackBar().show(context, '請輸入收件人名稱');
    } else if (_clientPhoneEditingControlle.text.isEmpty){
      CustomSnackBar().show(context, '請輸入聯絡電話');
    } else if(_address1EditingControlle.text.isEmpty){
      CustomSnackBar().show(context, '請輸入室號及樓層');
    } else if(_address2EditingControlle.text.isEmpty){
      CustomSnackBar().show(context, '請輸入大廈名稱');
    } else if(_address3EditingControlle.text.isEmpty){
      CustomSnackBar().show(context, '請輸入地區');
    } else {
      AuthDatabase(userId).updateUserInfo(
        UserModel(
          Timestamp.now(), 
          '', 
          '', 
          userInfo.name, 
          _clientPhoneEditingControlle.text, 
          _address1EditingControlle.text, 
          _address2EditingControlle.text, 
          _address3EditingControlle.text, 
          '', 
          _clientNameEditingControlle.text
        )
      );
      Navigator.pop(context);
    }
    
  }

  @override
  Widget build(BuildContext context) {

    final userInfo = Provider.of<UserModel>(context);

    _clientNameEditingControlle.text = userInfo.recipientName;
    _clientPhoneEditingControlle.text = userInfo.contactNo;
    _address1EditingControlle.text = userInfo.unitAndBuilding;
    _address2EditingControlle.text = userInfo.estate;
    _address3EditingControlle.text = userInfo.district;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(top: 60, left: 30, right: 30),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
        
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      '運送地址',
                      style: TextStyle(fontSize: xTextSize26, fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close)
                  )
                ],
              ),
            ),

            CustomizeTextField(
              title: '收件人名稱', 
              isPassword: false,
              mTextEditingController: _clientNameEditingControlle,
            ),

            CustomizePhoneTextField(
              title: '聯絡電話', 
              isPassword: false,
              mTextEditingController: _clientPhoneEditingControlle,
            ),
        
            CustomizeTextField(
              title: '室 / 樓層 及 大廈名稱', 
              isPassword: false,
              mTextEditingController: _address1EditingControlle,
            ),
        
            CustomizeTextField(
              title: '屋苑 / 屋邨名稱',
              isPassword: false,
              mTextEditingController: _address2EditingControlle,
            ),
        
            CustomizeTextField(
              title: '地區', 
              isPassword: false,
              mTextEditingController: _address3EditingControlle,
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 20),
              child :ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color(cPrimaryColor),
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                  ),
                ),
                onPressed: () => _saveAddressButtonOnClick(userInfo.uid, userInfo),
                child: const Text(
                  '保存',
                ),
              )
            )
        
          ],
        ),
      ),
    );
  }
}