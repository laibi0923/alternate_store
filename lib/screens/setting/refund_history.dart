// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:alternate_store/model/order_product_model.dart';
import 'package:alternate_store/viewmodel/refundhistory_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alternate_store/constants.dart';
import 'package:alternate_store/model/order_model.dart';
import 'package:alternate_store/widgets/set_cachednetworkimage.dart';

class RefundHistory extends StatelessWidget {
  const RefundHistory({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: _buildRefundListView(context)
    );
  }

  AppBar _buildAppBar(BuildContext context){
    return AppBar(
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
    );
  }

  Widget _buildRefundItem(OrderModel orderModel, OrderProductModel orderProductModel){
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
              child: setCachedNetworkImage(
                orderProductModel.colorImage, 
                BoxFit.cover
              )
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
                      orderProductModel.productName,
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
                    '${orderProductModel.colorName} / ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  //  Product Size
                  Expanded(
                    child: Text(
                      orderProductModel.size,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  const Text(
                    '已退出貨品',
                    style: TextStyle(color: Colors.redAccent),
                  ),

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

  Widget _buildRefundListView(BuildContext context){

    final orderHistoryList = Provider.of<List<OrderModel>>(context);
    final refundProductViewModel = Provider.of<RefundProductViewModel>(context);

    // ignore: unnecessary_null_comparison
    if(orderHistoryList == null){
      return const Center(
        child: CircularProgressIndicator()
      );
    } else {
      refundProductViewModel.findRefundproduct(orderHistoryList);
    }

    if(refundProductViewModel.refundProductList.isEmpty){
      return const Center(
        child: Text('沒有退貨紀錄'),
      );
    }

    return ListView.builder(
      itemCount: refundProductViewModel.refundProductList.length,
      itemBuilder: (context, index){
        return _buildRefundItem(
          orderHistoryList[index],
          refundProductViewModel.refundProductList[index]
        );
      }
    );

  }
}