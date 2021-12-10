// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alternate_store/constants.dart';
import 'package:alternate_store/model/product_model.dart';
import 'package:alternate_store/widgets/product_gridview.dart';

Widget emptyWishlistScreen(BuildContext context) {

  final productData = Provider.of<List<ProductModel>>(context);
  
  return ListView(
    physics: const BouncingScrollPhysics(),
    children: [

      Padding(
        padding: const EdgeInsets.only(top:20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/icon/ic_heart.png', 
              color: Colors.grey,
            ),

            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 40),
              child: Text(
                '還沒有加入喜愛商品',
                style: TextStyle(color: Colors.grey),
              ),
            ),

          ],
        ),
      ),

      const Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Text(
          '為你推薦',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: xTextSize18),
        ),
      ),
      
      productGridView(context, productData, productData.length)
      // ProductGridview(
      //   productModelList: productData,
      //   listLength: productData.length,
      // ),
      
    ],
  );
}
