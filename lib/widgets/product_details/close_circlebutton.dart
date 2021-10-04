//  Date :  30 Jul 2021
//  Create : by Leo
//  Description : This is Product Details Page Close
import 'package:flutter/material.dart';

Widget closeCircleButton(BuildContext context){
  return Positioned(
    top : 42,
    right: 15,
    child: GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        height: 42,
        width: 42,
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color(0x90000000),
          borderRadius: BorderRadius.all(
            Radius.circular(99)
          ),
        ),
        child: const Icon(
          Icons.close,
          color: Colors.white,
        ),
      ),
    ),
  );
}
