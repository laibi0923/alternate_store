// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alternate_store/constants.dart';
import 'package:alternate_store/model/order_model.dart';
import 'package:alternate_store/widgets/set_cachednetworkimage.dart';

class RefundHistory extends StatelessWidget {
  const RefundHistory({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final orderHistoryList = Provider.of<List<OrderModel>>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('退貨紀錄'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () => Navigator.pop(context), 
              icon: const Icon(Icons.close)
            ),
          )
        ],
      ),
      body: orderHistoryList.isEmpty ? const Text('尚未有任何退貨紀錄') :
      ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: orderHistoryList.length,
          itemBuilder: (context, index){
            return ListView.builder(
              itemCount: orderHistoryList[index].orderProduct.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 20, right: 20),
              itemBuilder: (context, zindex){
                return orderHistoryList[index].orderProduct[zindex]['REFUND_STATUS'] != '已退貨' ?  Container() :
                _buildRefundItem(
                  orderHistoryList[index],
                  orderHistoryList[index].orderProduct[zindex]
                );
              }
            );
          }
        ),
    );
  }

  Widget _buildRefundItem(OrderModel orderModel, dynamic productList){
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top:20, bottom: 20),
      decoration: BoxDecoration(
        color: const Color(cGrey),
        borderRadius: BorderRadius.circular(17)
      ),
      child: Row(
        children: [
          Container(
            height: 110,
            width: 110,
            margin: const EdgeInsets.only(right: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: setCachedNetworkImage(productList['COLOR']['COLOR_IMAGE'], BoxFit.cover)
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('訂單編號 : '),
                      Expanded(
                        child: Text(
                          orderModel.orderNumber.toUpperCase(),
                          style: const TextStyle(color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      productList['PRODUCT_NAME'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Spacer(),
                  
                  Row(
                children: [

                  // Product Color
                  Text(
                    '${productList['COLOR']['COLOR_NAME']} / ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  //  Product Size
                  Expanded(
                    child: Text(
                      productList['SIZE'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  const Text(
                    '已退出貨品',
                    style: TextStyle(color: Colors.redAccent),
                  ),


                  // Prouct Price
                  // Expanded(
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.end,
                  //     children:  [
                        
                  //       // 判斷如商品冇特價時不顯示, 相反則顥示正價 (刪除線)
                  //       productList['DISCOUNT'] == 0 ? Container() :
                  //       Text(
                  //         'HKD\$ ' + productList['PRICE'].toStringAsFixed(2),
                  //         style: const TextStyle(
                  //           fontSize: xTextSize11,
                  //           decoration: TextDecoration.lineThrough
                  //         ),
                  //       ),
                        
                  //       //  判斷如商品冇特價時顯示正價, 相反以紅色顯示特價銀碼
                  //       productList['DISCOUNT'] != 0 ?
                  //       Text(
                  //         'HKD\$ ' + productList['DISCOUNT'].toStringAsFixed(2),
                  //         style: const TextStyle(
                  //           fontSize: xTextSize14,
                  //           color: Color(cPink)
                  //         ),
                  //       ) :
                  //       Text(
                  //         'HKD\$ ' + productList['PRICE'].toStringAsFixed(2),
                  //       )
                
                  //     ],
                  //   ),
                  // ),

                ],
              ),
                  
                ],
              )
            )
          ),
        ],
      ),
    );
  }
}