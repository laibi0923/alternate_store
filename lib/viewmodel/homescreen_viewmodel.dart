// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alternate_store/main.dart';


class HomeScreenViewModel extends ChangeNotifier{

  void navigatorPushtPage(page){
    Navigator.push(
      navigatorKey.currentContext!, 
      MaterialPageRoute(builder: (context) => page
      )
    );
  }

}