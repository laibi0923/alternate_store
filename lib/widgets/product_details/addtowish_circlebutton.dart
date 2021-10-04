import 'package:flutter/material.dart';

Widget addToWishListButton(bool onList){
  return Container(
    height: 42,
    width: 42,
    padding: const EdgeInsets.all(8),
    decoration:const BoxDecoration(
      color: Color(0x90000000),
      borderRadius: BorderRadius.all(
        Radius.circular(99)
      )
    ),
    child: Center(
      child: Image(
        image: onList == true ? const AssetImage('lib/assets/icon/ic_heart_fill.png') : const AssetImage('lib/assets/icon/ic_heart.png'),
        color: onList == true ? Colors.redAccent : Colors.redAccent,
      ),
    )
  ); 
}
