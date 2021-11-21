// @dart=2.9
import 'package:alternate_store/widgets/currency_textview.dart';
import 'package:flutter/material.dart';
import 'package:alternate_store/model/product_model.dart';

Widget addCartButton(BuildContext context, ProductModel productModel){
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Center(
      child: Container(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 5),
        decoration: const BoxDecoration(
          color: Color(0x90000000),
          borderRadius: BorderRadius.all(
            Radius.circular(99),
          ),
        ),
        child: Column(
          children: [
            CurrencyTextView(
              value: productModel.discountPrice == 0 ? productModel.price : productModel.discountPrice, 
              textStyle: const TextStyle(color: Colors.white),
            ),
            const Text(
              '產品資訊',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    ),
  );
}




