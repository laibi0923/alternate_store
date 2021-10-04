// @dart=2.9
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alternate_store/constants.dart';

class CustomizePhoneTextField extends StatelessWidget {
  final String title;
  final bool isPassword;
  final TextEditingController mTextEditingController;
  final bool isenabled;
  final int minLine;
  final int maxLine;

  const CustomizePhoneTextField(
      {Key key,
      this.title,
      this.isPassword,
      this.mTextEditingController,
      this.isenabled,
      this.minLine,
      this.maxLine})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
        decoration: const BoxDecoration(
            color: Color(cGrey),
            borderRadius: BorderRadius.all(Radius.circular(7))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            TextFormField(
              minLines: minLine,
              maxLines: maxLine,
              enabled: isenabled,
              maxLength: 8,
              controller: mTextEditingController,
              keyboardType: TextInputType.number,
              obscureText: isPassword == true ? true : false,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(0),
                isDense: true,
                border: InputBorder.none,
                counterStyle: TextStyle(height: double.minPositive,),
                counterText: ""
              ),
            ),
          ],
        ),
      ),
    );
  }
}
