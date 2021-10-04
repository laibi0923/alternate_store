import 'package:flutter/material.dart';
import 'package:alternate_store/constants.dart';

Widget settingInfo(String username){
  return Center(
    child: Column(
      children: [
        Text(
          username,
          style: const TextStyle(fontSize: xTextSize22),
        ),
        const Text(
          '編輯你的個人資料',
          style: TextStyle(fontSize: xTextSize14),
        )
      ],
    ),
  );
}
