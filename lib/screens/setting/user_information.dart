// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alternate_store/constants.dart';
import 'package:alternate_store/model/user_model.dart';
import 'package:alternate_store/service/auth_database.dart';
import 'package:alternate_store/widgets/customize_phonetextfield.dart';
import 'package:alternate_store/widgets/customize_textfield.dart';
import 'package:alternate_store/widgets/custom_snackbar.dart';

class UserInformation extends StatefulWidget {
  const UserInformation({Key key}) : super(key: key);

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final TextEditingController _userNameEditingControlle = TextEditingController();
  final TextEditingController _emailEditingControlle = TextEditingController();
  final TextEditingController _phoneEditingControlle = TextEditingController();
  final TextEditingController _userRecipientEditingControlle = TextEditingController();
  final TextEditingController _unitEditingControlle = TextEditingController();
  final TextEditingController _estateEditingControlle = TextEditingController();
  final TextEditingController _districtEditingControlle = TextEditingController();

  void _updateUserInfo(UserModel usermodel) {
    if (_userNameEditingControlle.text.isEmpty) {
      CustomSnackBar().show(context, 'User Name Cannot be empty.');
      return;
    }
    AuthDatabase(usermodel.uid)
        .updateUserInfo(UserModel(
            Timestamp.now(),
            '',
            '',
            _userNameEditingControlle.text,
            _phoneEditingControlle.text,
            _unitEditingControlle.text,
            _estateEditingControlle.text,
            _districtEditingControlle.text,
            '',
            ''))
        .then((value) => Navigator.pop(context));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _userNameEditingControlle.dispose();
    _emailEditingControlle.dispose();
    _phoneEditingControlle.dispose();
    _userRecipientEditingControlle.dispose();
    _unitEditingControlle.dispose();
    _estateEditingControlle.dispose();
    _districtEditingControlle.dispose();
    super.dispose();
  }

  void initUserInfo(UserModel userInfo) {
    _emailEditingControlle.text = userInfo.email;
    _userNameEditingControlle.text = userInfo.name;
    _phoneEditingControlle.text = userInfo.contactNo;
    _userRecipientEditingControlle.text = userInfo.recipientName;
    _unitEditingControlle.text = userInfo.unitAndBuilding;
    _estateEditingControlle.text = userInfo.estate;
    _districtEditingControlle.text = userInfo.district;
  }

  @override
  Widget build(BuildContext context) {
    
    final userInfo = Provider.of<UserModel>(context);

    initUserInfo(userInfo);

    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 0, left: 30, right: 30),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40, bottom: 20),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '個人資料',
                            style: TextStyle(
                                fontSize: xTextSize26,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close))
                      ],
                    ),
                  ),
                  CustomizeTextField(
                    isenabled: false,
                    title: '用戶電郵',
                    isPassword: false,
                    mTextEditingController: _emailEditingControlle,
                  ),
                  CustomizeTextField(
                    title: '用戶名稱',
                    isPassword: false,
                    mTextEditingController: _userNameEditingControlle,
                  ),
                  CustomizePhoneTextField(
                    title: '聯絡電話',
                    isPassword: false,
                    mTextEditingController: _phoneEditingControlle,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 40, bottom: 20),
                    child: Text(
                      '送貨地址',
                      style: TextStyle(
                          fontSize: xTextSize26, fontWeight: FontWeight.bold),
                    ),
                  ),
                  CustomizeTextField(
                    title: '收件人名稱',
                    isPassword: false,
                    mTextEditingController: _userRecipientEditingControlle,
                  ),
                  CustomizeTextField(
                    title: '室 / 樓層',
                    isPassword: false,
                    mTextEditingController: _unitEditingControlle,
                  ),
                  CustomizeTextField(
                    title: '大廈名稱',
                    isPassword: false,
                    mTextEditingController: _estateEditingControlle,
                  ),
                  CustomizeTextField(
                    title: '屋苑名稱 / 地區',
                    isPassword: false,
                    mTextEditingController: _districtEditingControlle,
                  ),
                  Container(
                    height: 200,
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: const Color(cPrimaryColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(19))),
                onPressed: () => _updateUserInfo(userInfo),
                child: const Text(
                  '保存',
                  style: TextStyle(fontSize: xTextSize16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
