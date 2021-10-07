import 'dart:math';

import 'package:flutter/animation.dart';

class StripeViewModel{

  final AnimationController _animationController;
  StripeViewModel(this._animationController);

  //  初始化向後翻動畫
  Animation<double> moveToBack(){
    return TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: pi / 2).chain(
          CurveTween(curve: Curves.easeInBack)
        ),
        weight: 50.0
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(pi / 2), 
        weight: 50.0
      )
    ]).animate(_animationController);
  }


  //  初始化向前翻動畫
  Animation<double> moveToFront(){
    return TweenSequence<double>([
      TweenSequenceItem(
        tween: ConstantTween<double>(pi / 2), 
        weight: 50.0
      ),
      TweenSequenceItem(
        tween: Tween(begin: -pi / 2, end: 0.0).chain(
          CurveTween(curve: Curves.easeOutBack)
        ), 
        weight: 50.0
      )
    ]).animate(_animationController);
  }

  //  當用戶於 CVC Textflied 時實現向後翻轉;
  //  當用戶離開 CVC Textflied 時實現向後翻轉;
  void cvcOnFocus(bool hasfocus){
    if(hasfocus){
      _animationController.forward().orCancel;
    } else {
      _animationController.reverse().orCancel;
    }
  }

}