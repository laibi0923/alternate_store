// @dart=2.9
import 'package:alternate_store/constants.dart';
import 'package:alternate_store/service/auth_services.dart';
import 'package:flutter/material.dart';

class EmailVerify extends StatelessWidget {
  const EmailVerify({ key }) : super(key: key);

  void _resendemail(BuildContext context){
    AuthService().sendEmailVerification();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Stack(
          children: [

            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:  [

                  const Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: Icon(
                      Icons.mark_email_read_outlined, 
                      color: Colors.grey,
                      size: 100,
                    ),
                  ),

                  const Center(
                    child: Text(
                      '我們已發送確認電郵到閣下郵箱，\n請登入你的電郵點擊生效你的帳戶。',
                      textAlign: TextAlign.center,
                    ),
                  ),


                  const Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: Text('還沒有收到電郵嗎?'),
                  ),
            
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary:  const Color(cPrimaryColor),
                        elevation: 0,
                        shape:  const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                        ),
                      ),
                      onPressed: () => _resendemail(context),
                      child:  const Text(
                        '重新發送確認電郵',
                      ),
                    ),
                  )

                ],
              ),
            ),

            Positioned(
              top: 60,
              right: 0,
              child: IconButton(
                onPressed: () {
                  AuthService().signOut().then((value) => Navigator.pop(context));
                }, 
                icon: const Icon(Icons.close)
              ),
            ),

          
          ],
        ),
      ),
    );
  }
}