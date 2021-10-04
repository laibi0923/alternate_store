// @dart=2.9
import 'package:flutter/material.dart';
import 'package:alternate_store/model/order_model.dart';
import 'package:alternate_store/widgets/cart/cart_summary_itemview.dart';
import 'package:intl/intl.dart';
import 'package:alternate_store/widgets/order_history/ordered_product_view.dart';

class ReviewOrder extends StatefulWidget {
  final OrderModel orderModel;
  const ReviewOrder({Key key, this.orderModel}) : super(key: key);

  @override
  State<ReviewOrder> createState() => _ReviewOrderState();
}

class _ReviewOrderState extends State<ReviewOrder> {

  //  Dummy Data
  final List dummyCartList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [

          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [

                Container(height: 80,),

                CartSummaryItemView(
                  title: '訂單日期', 
                  value: DateFormat('yyyy/MM/dd  kk:mm').format(DateTime.fromMicrosecondsSinceEpoch(widget.orderModel.orderDate.microsecondsSinceEpoch)), 
                  isbold: false, 
                  showAddBox: false
                ),

                CartSummaryItemView(
                  title: '訂單編號', 
                  value: widget.orderModel.orderNumber, 
                  isbold: false, 
                  showAddBox: false
                ),

                CartSummaryItemView(
                  title: '收件人', 
                  value: '${widget.orderModel.receipientInfo['RECEIPIENT_NAME']}',
                  isbold: false, 
                  showAddBox: false
                ),

                CartSummaryItemView(
                  title: '聯絡電話', 
                  value: '${widget.orderModel.receipientInfo['CONTACT']}',
                  isbold: false, 
                  showAddBox: false
                ),

                CartSummaryItemView(
                  title: '運送地址', 
                  value: '${widget.orderModel.receipientInfo['UNIT_AND_BUILDING']}\n${widget.orderModel.receipientInfo['ESTATE']}\n${widget.orderModel.receipientInfo['DISTRICT']}', 
                  isbold: false, 
                  showAddBox: false
                ),

                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.orderModel.orderProduct.length,
                  itemBuilder: (context, index){
                    return orderedProductView(widget.orderModel.orderProduct[index]);
                  }
                ),

                CartSummaryItemView(
                  title: '小計', 
                  value: 'HKD\$ ${widget.orderModel.subAmount}', 
                  isbold: false, 
                  showAddBox: false
                ),

                CartSummaryItemView(
                  title: widget.orderModel.discountCode.isEmpty ? '折扣' : '折扣代碼【${widget.orderModel.discountCode}】', 
                  value: '-HKD\$ ${widget.orderModel.discountAmount}', 
                  isbold: false, 
                  showAddBox: false
                ),

                CartSummaryItemView(
                  title: '運費', 
                  value: 'HKD\$ ${widget.orderModel.shippingAmount}', 
                  isbold: false, 
                  showAddBox: false
                ),

                CartSummaryItemView(
                  title: '總計', 
                  value: 'HKD\$ ${widget.orderModel.totalAmount}', 
                  isbold: true, 
                  showAddBox: false
                ),

                CartSummaryItemView(
                  title: '支付方式', 
                  value: widget.orderModel.paymentMothed, 
                  isbold: false, 
                  showAddBox: false
                ),

                Container(height: 80,),

              ],
            )
          ),

          Positioned(
            top: 40,
            right: 10,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
            )
          )

        ],
      ),

    );
  }
}