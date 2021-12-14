// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:alternate_store/viewmodel/shipped_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alternate_store/model/order_model.dart';
import 'package:alternate_store/model/user_model.dart';
import 'package:alternate_store/widgets/order_history/shipped_product_view.dart';

class ShippingHistory extends StatelessWidget {
  const ShippingHistory({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: _buildListView(context)
    );
  }

  AppBar _buildAppBar(BuildContext context){
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: const Text('出貨紀錄'),
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

  Widget _buildListView(BuildContext context){

    final shippedViewModel = Provider.of<ShippedViewModel>(context);
    final orderHistoryList = Provider.of<List<OrderModel>>(context);    

    // ignore: unnecessary_null_comparison
    if(orderHistoryList == null){
      return const Center(
        child: CircularProgressIndicator()
      );
    } else {
      shippedViewModel.getShippedProduct(orderHistoryList);
    }

    if(shippedViewModel.shippedList.isEmpty){
      return const Center(
        child: Text('沒有出貨s紀錄'),
      );
    }

    return ListView.builder(
      itemCount: shippedViewModel.shippedList.length,
      itemBuilder: (context, index){
        return _buildListViewItem(context, index);
      }
    );
  }

  Widget _buildListViewItem(BuildContext context, int index){

    final userInfo = Provider.of<UserModel>(context);
    final orderHistoryList = Provider.of<List<OrderModel>>(context);
    final shippedViewModel = Provider.of<ShippedViewModel>(context);

    return GestureDetector(
      onTap: () => shippedViewModel.requestRefund(context, userInfo.uid, orderHistoryList[index], index),
      child: shippedProductView(
        shippedViewModel.shippedList[index],
        orderHistoryList[index].orderNumber
      ),
    ); 
  }

}