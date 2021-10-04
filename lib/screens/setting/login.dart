// @dart=2.9
import 'package:alternate_store/constants.dart';
import 'package:alternate_store/screens/setting/email_verify.dart';
import 'package:alternate_store/service/auth_services.dart';
import 'package:alternate_store/widgets/custom_snackbar.dart';
import 'package:alternate_store/widgets/customize_dialog.dart';
import 'package:alternate_store/widgets/customize_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  final bool popBack;
  final bool emailVerifed;
  const LoginScreen({ key, this.emailVerifed, this.popBack }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailEditingController =  TextEditingController();
  final TextEditingController _pwEditingController =  TextEditingController();

  void _forgotPassword() async{

    if(_emailEditingController.text.isEmpty){
      CustomSnackBar().show(context, '請輸入電郵');
    } else {

      bool result = await showDialog(
        context: context, builder: (BuildContext context){
          return const CustomizeDialog(
            title: '重置密碼', 
            content: '我們將會電郵重置密碼郵件到閣下電郵中\n要確認重置嗎?',
            submitBtnText: '確認',
            cancelBtnText: '取消',
          );
        }
      );

      if (result == true){

        Provider.of<AuthService>(context, listen: false).passwordReset(_emailEditingController.text).then((value) {
          if(value != 'Success'){
              switch (value) {
                case 'invalid-email':
                  CustomSnackBar().show(context, '電郵帳戶不正確');
                  break;
                case 'user-not-found':
                  CustomSnackBar().show(context, '電郵帳戶不正確');
                  break;
                default:
                  CustomSnackBar().show(context, '請與我們聯絡');
                  break;
              }
          }else {
            AuthService().passwordReset(_emailEditingController.text);
          }
        });

      }
      
    }
  }

  void _loginButtonOnclick() async {

    if(_emailEditingController.text.isEmpty){
      CustomSnackBar().show(context, '請輸入電郵');
    } else if (_pwEditingController.text.isEmpty){
      CustomSnackBar().show(context, '請輸入密碼');
    } else {
      Provider.of<AuthService>(context, listen: false).signIn(_emailEditingController.text, _pwEditingController.text).then((value) {
        if(value != 'Success'){

          switch (value) {
            case 'wrong-password':
            CustomSnackBar().show(context, '電郵帳戶 / 密碼不正確');
              break;
            case 'invalid-email':
            CustomSnackBar().show(context, '電郵帳戶 / 密碼不正確');
              break;
            case 'user-not-found':
            CustomSnackBar().show(context, '電郵帳戶 / 密碼不正確');
              break;
            case 'too-many-requests':
            CustomSnackBar().show(context, '請稍後再嘗試');
              break;
            default:
            CustomSnackBar().show(context, '請與我們聯絡');
              break;
          }
          
        } else if (value == "Success"){
          if(AuthService().emailverify == false){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const EmailVerify()));
          } 
          if(widget.popBack == true){
            Navigator.pop(context);
          }
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
            title: '電子郵件', 
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

          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: () => _forgotPassword(),
                  child: const Text('忘記密碼')
                )
              ],
            ),
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
              onPressed: () => _loginButtonOnclick(),
              child: const Text(
                '登入',
              ),
            )
          )

        ],
      ),
    );
  }
}