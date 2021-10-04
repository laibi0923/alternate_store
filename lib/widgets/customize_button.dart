
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alternate_store/constants.dart';

Widget customizeButton1(String title, void onClick){
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      primary: const Color(cPrimaryColor),
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
    ),
    onPressed: () => onClick,
    child: Text(title),
  );
}

// class CustomizeButton1 extends StatelessWidget {
//   final VoidCallback buttonOnclick;
//   //final TextStyle textStyle;
//   final String btnText;

//   const CustomizeButton1({Key? key, required this.buttonOnclick, required this.btnText}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         primary: const Color(cPrimaryColor),
//         elevation: 0,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(18)),
//         ),
//       ),
//       onPressed: () => buttonOnclick,
//       child: Text(btnText),
//     );
//   }
// }

