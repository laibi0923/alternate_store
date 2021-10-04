import 'package:flutter/material.dart';
import 'dart:math' as math;

Widget productImageCount(BuildContext context, String currentIndex, String totalImage){
  return Positioned(
      top: 0,
      left: -15,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Transform(
            alignment: FractionalOffset.center,
            transform: Matrix4.rotationZ(-90 * math.pi / 180),
            child: Container(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 5),
              decoration: const BoxDecoration(
                color: Color(0x90000000),
                borderRadius: BorderRadius.all(
                  Radius.circular(99)
                )
              ),
              child: Text(
                currentIndex + ' / ' + totalImage,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
}
