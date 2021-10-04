// @dart=2.9
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
            Text(
              productModel.discountPrice == 0 ? 'HKD\$ ' + productModel.price.toStringAsFixed(2) : 'HKD\$ ' + productModel.discountPrice.toStringAsFixed(2),
              style: const TextStyle(color: Colors.white),
            ),
            const Text(
              '加入購物車',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    ),
  );
}




