import 'package:flutter/material.dart';
import 'package:alternate_store/constants.dart';

class CustomSnackBar{
  
  void show(BuildContext context, String content){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        action: SnackBarAction(
          textColor: const Color(cPrimaryColor),
          label: 'Dismiss', 
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()
        ),
      ),
    );
  }

}