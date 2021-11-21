// @dart=2.9
import 'package:alternate_store/model/order_product_model.dart';
import 'package:alternate_store/widgets/currency_textview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alternate_store/constants.dart';
import 'package:alternate_store/widgets/set_cachednetworkimage.dart';


Widget orderedProductView(Map<String, dynamic> orderProductData){

  OrderProductModel orderProductModel = OrderProductModel.fromFirestore(orderProductData);

  return Container(
    height: 150,
    margin: const EdgeInsets.only(top: 10, bottom: 10),
    padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
    decoration: const BoxDecoration(
      color: Color(cGrey),
      borderRadius: BorderRadius.all(Radius.circular(7))
    ),
    child: Row(
      children: [

        //  Product Image
        Container(
          height: 110,
          width: 110,
          margin: const EdgeInsets.only(right: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: setCachedNetworkImage(orderProductModel.productImage, BoxFit.cover)
          ),
        ),
        
        //  Product Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //  Product Name
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  orderProductModel.productName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              const Spacer(),

              //  Refundable
              orderProductModel.refundAble == false ? Container():
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  refundableText,
                  style: TextStyle(color: Color(cPink)),
                ),
              ),

              const Spacer(),

              Row(
                children: [
                  
                  //  Product Color
                  Text(
                    '${orderProductModel.colorName} / ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  //  Product Size
                  Text(
                    orderProductModel.size,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  // Prouct Price
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children:  [
                        
                        // 判斷如商品冇特價時不顯示, 相反則顥示正價 (刪除線)
                        orderProductModel.discount == 0 ? Container() :
                        CurrencyTextView(
                          value: orderProductModel.price, 
                          textStyle: const TextStyle(
                            fontSize: xTextSize11,
                            decoration: TextDecoration.lineThrough
                          ),
                        ),
                        
                        //  判斷如商品冇特價時顯示正價, 相反以紅色顯示特價銀碼
                        orderProductModel.discount != 0 ?
                        CurrencyTextView(
                          value: orderProductModel.discount, 
                          textStyle: const TextStyle(
                            fontSize: xTextSize14,
                            color: Color(cPink)
                          ),
                        ) :
                        CurrencyTextView(
                          value: orderProductModel.price, 
                          textStyle: const TextStyle()
                        )
                
                      ],
                    ),
                  ),

                ],
              ),
              
            ],
          )
        ),

      ],
    ),
  );
}
