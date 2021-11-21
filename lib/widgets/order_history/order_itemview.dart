// @dart=2.9
import 'package:alternate_store/model/order_product_model.dart';
import 'package:alternate_store/widgets/currency_textview.dart';
import 'package:flutter/material.dart';
import 'package:alternate_store/constants.dart';
import 'package:alternate_store/model/order_model.dart';
import 'package:intl/intl.dart';
import 'package:alternate_store/widgets/set_cachednetworkimage.dart';


Widget orderItemView(OrderModel orderModel){

  return Container(
    margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
    padding: const EdgeInsets.only(left: 20, right: 20, top:20, bottom: 20),
    decoration: BoxDecoration(
      color: const Color(cGrey),
      borderRadius: BorderRadius.circular(17)
    ),
    child: Row(
      children: [
         //  Order Date & Order Number & Total Price
        Expanded(
          child: SizedBox(
            height: 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('yyyy/MM/dd  kk:mm').format(DateTime.fromMicrosecondsSinceEpoch(orderModel.orderDate.microsecondsSinceEpoch))
                ),
                Text(orderModel.orderNumber),
                const Spacer(),
                Text(orderModel.orderProduct.length.toString() + ' 件商品'),
                CurrencyTextView(
                  value: orderModel.totalAmount, 
                  textStyle: TextStyle()
                )
              ],
            ),
          ),
        ),
        // Order Image
        orderModel.orderProduct.length == 1 ?
        _buildSingleImage(
          OrderProductModel.fromFirestore(orderModel.orderProduct[0]).colorImage
        ) :
        _buildMutilImage(
          OrderProductModel.fromFirestore(orderModel.orderProduct[0]).colorImage,
          OrderProductModel.fromFirestore(orderModel.orderProduct[1]).colorImage
        )
      ],
    ),
  );
}


Widget _buildSingleImage(String uri){
  return SizedBox(
    height: 90,
    width: 90,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(17),
      child: setCachedNetworkImage(
        uri,
        BoxFit.cover
      )
    ),
  );
}

Widget _buildMutilImage(String uri1, String uri2){
  return SizedBox(
    height: 90,
    width: 90,
    child: Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          child: SizedBox(
            height: 80,
            width: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: setCachedNetworkImage(
                uri1,
                BoxFit.cover
              ),
            ),
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: SizedBox(
            height: 80,
            width: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: setCachedNetworkImage(
                uri2,
                BoxFit.cover
              )
            ),
          ),
        ),
      ],
    ),
  );
}