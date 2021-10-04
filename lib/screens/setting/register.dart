// @dart=2.9
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alternate_store/constants.dart';
import 'package:alternate_store/screens/setting/email_verify.dart';
import 'package:alternate_store/service/auth_services.dart';
import 'package:alternate_store/widgets/customize_textfield.dart';
import 'package:alternate_store/widgets/custom_snackbar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({ key }) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final TextEditingController _emailEditingController =  TextEditingController();
  final TextEditingController _pwEditingController =  TextEditingController();
  final TextEditingController _confirmpwEditingController =  TextEditingController();

  Future<void> _registerButtonOnClick() async {

    if (_emailEditingController.text.isEmpty){
      CustomSnackBar().show(context, '請輸入電郵');
    } else if (_pwEditingController.text.isEmpty){
      CustomSnackBar().show(context, '請輸入密碼');
    } else if(_confirmpwEditingController.text.isEmpty){
      CustomSnackBar().show(context, '請再次輸入密碼');
    } else if(_pwEditingController.text != _confirmpwEditingController.text){
      CustomSnackBar().show(context, '確認密碼不一致, 請重新輸入');
    } else {
      Provider.of<AuthService>(context, listen: false).register(_emailEditingController.text, _pwEditingController.text).then((value) {
        switch (value) {
          case 'Success':
            Navigator.push(context, MaterialPageRoute(builder: (context) => const EmailVerify()));
            AuthService().sendEmailVerification();
            break;

          case 'weak-password':
            CustomSnackBar().show(context, '請檢查你的密碼強度');
            break;

          case 'email-already-in-use':
            CustomSnackBar().show(context, '此電郵已註冊');
            break;

          case 'invalid-email':
            CustomSnackBar().show(context, '輸入電郵不正確');
            break;

          default:
            CustomSnackBar().show(context, '請與管理員聮絡');
            break;
        }

      });     
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        children: [

          CustomizeTextField(
            title: '電郵', 
            isPassword: false,
            mTextEditingController: _emailEditingController,
            maxLine: 1,
          ),

          CustomizeTextField(
            title: '密碼', 
            isPassword: true,
            mTextEditingController: _pwEditingController,
            maxLine: 1,
          ),

          CustomizeTextField(
            title: '確認密碼',
            isPassword: true,
            mTextEditingController: _confirmpwEditingController,
            maxLine: 1,
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child :ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color(cPrimaryColor),
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
              ),
              onPressed: () => _registerButtonOnClick(),
              child: const Text(
                '註冊',
              ),
            )
          )
           
        ],
      )
    );
  }
}