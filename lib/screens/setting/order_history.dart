// @dart=2.9
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alternate_store/model/order_model.dart';
import 'package:alternate_store/screens/setting/revieworder.dart';
import 'package:alternate_store/widgets/order_history/order_itemview.dart';

class OrderHistory extends StatelessWidget {
  const OrderHistory({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final orderHistoryList = Provider.of<List<OrderModel>>(context);
    if(orderHistoryList == null){ return Container();}

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('訂單紀錄'),
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
      body: 
      orderHistoryList == null ? Container() :
      orderHistoryList.isEmpty ? _emptyView() :
      ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: orderHistoryList.length,
        itemBuilder: (context, index){
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewOrder(orderModel: orderHistoryList[index],))),
            child: orderItemView(orderHistoryList[index])
          );
        }
      ),
    );
  
  }
}

Widget _emptyView(){
  return const Center(
    child: Text(
      '你仲未有訂單喎!!!\n\n快啲幫襯下支持下我地啦!!!',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.grey),
    ),
  );
}