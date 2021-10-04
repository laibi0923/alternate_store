// @dart=2.9
import 'package:flutter/material.dart';
import 'package:alternate_store/constants.dart';
import 'package:alternate_store/screens/setting/user_entrance.dart';

Widget emptyUserMailBoxView(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        const Text(
          '快啲加入我地成為會員啦\n我地定期都會推出新產品同好多最新優惠, 想拎多啲著數? 加入我地, 一有就會係呢到通知精明既你架啦!!!',
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 40,),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary:  const Color(cPrimaryColor),
            elevation: 0,
            shape:  const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
          ),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UserEntrance(popBack: true,))),
          child:  const Text(
            '加入成為會員',
          ),
        )


      ],
    ),
  );
}
