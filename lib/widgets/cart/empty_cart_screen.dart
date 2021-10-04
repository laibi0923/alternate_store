import 'package:flutter/material.dart';

Widget emptyCartScreen() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        
        Image.asset(
          'lib/assets/icon/ic_shoppingbag.png',
          color: Colors.grey,
        ),
        
        const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            '你的購物車已空.', 
            style : TextStyle(color: Colors.grey)
          ),
        )

      ],
    ),
  );
}
