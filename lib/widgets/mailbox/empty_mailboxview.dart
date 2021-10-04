import 'package:flutter/material.dart';

Widget emptyMailBoxScreen() {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Image.asset(
            'lib/assets/icon/ic_mail.png', 
            color: Colors.grey,
          ),

           const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              '一有新通知即時會通知你',
              style: TextStyle(color: Colors.grey),
            ),
          )
          
        ],
      ),
    ),
  );
}