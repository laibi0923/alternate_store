// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alternate_store/constants.dart';
import 'package:alternate_store/widgets/set_cachednetworkimage.dart';


Widget shippedProductView(Map<String, dynamic> shippedProductData, String productNumber){
  return shippedProductData['SHIPPING_STATUS'] == '' ?  Container() :
  Container(
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
            child: setCachedNetworkImage(shippedProductData['COLOR']['COLOR_IMAGE'], BoxFit.cover)
          ),
        ),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                children: [
                  Expanded(
                    child: Text(
                      productNumber.toUpperCase(),
                      style: const TextStyle(color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      shippedProductData['SHIPPING_STATUS'],
                      style: const TextStyle(color: Color(cPrimaryColor)),
                    ),
                  ) 

                ],
              ),

              //  Product Name
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  shippedProductData['PRODUCT_NAME'],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              const Spacer(),

              //  Refund
              shippedProductData['REFUND_ABLE'] == true ? Container() :
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  refundableText,
                  style: TextStyle(color: Color(cPink)),
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  shippedProductData['REFUND_STATUS'],
                  style: const TextStyle(color: Color(cPink)),
                ),
              ),

              const Spacer(),

              Row(
                children: [

                  // Product Color
                  Text(
                    '${shippedProductData['COLOR']['COLOR_NAME']} / ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  //  Product Size
                  Text(
                    shippedProductData['SIZE'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  // Prouct Price
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children:  [
                        
                        // 判斷如商品冇特價時不顯示, 相反則顥示正價 (刪除線)
                        shippedProductData['DISCOUNT'] == 0 ? Container() :
                        Text(
                          'HKD\$ ' + shippedProductData['PRICE'].toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: xTextSize11,
                            decoration: TextDecoration.lineThrough
                          ),
                        ),
                        
                        //  判斷如商品冇特價時顯示正價, 相反以紅色顯示特價銀碼
                        shippedProductData['DISCOUNT'] != 0 ?
                        Text(
                          'HKD\$ ' + shippedProductData['DISCOUNT'].toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: xTextSize14,
                            color: Color(cPink)
                          ),
                        ) :
                        Text(
                          'HKD\$ ' + shippedProductData['PRICE'].toStringAsFixed(2),
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
