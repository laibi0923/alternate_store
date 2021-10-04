import 'package:flutter/material.dart';
import 'package:alternate_store/constants.dart';
import 'package:alternate_store/widgets/set_cachednetworkimage.dart';

Widget userImage(String imageUri) {
  // ignore: unnecessary_null_comparison
  return imageUri == null || imageUri.isEmpty? 
  Container(
    height: 200,
    width: 200,
    padding: const EdgeInsets.all(30),
    margin:  const EdgeInsets.only(bottom: 20),
    decoration: BoxDecoration(
      color: const Color(cGrey),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Image.asset(
      'lib/assets/icon/ic_person.png',
      fit: BoxFit.cover,
    ),
  ) :
  Container(
    height: 200,
    width: 200,
    margin:  const EdgeInsets.only(bottom: 20),
    child: ClipRRect(borderRadius: BorderRadius.circular(99),
      child: setCachedNetworkImage(imageUri, BoxFit.cover)
    ),
  );
}
