// @dart=2.9
import 'package:alternate_store/widgets/currency_textview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:alternate_store/constants.dart';
import 'package:alternate_store/model/product_model.dart';
import 'package:alternate_store/screens/product_details/product_details.dart';
import 'package:alternate_store/widgets/set_cachednetworkimage.dart';

class ProductGridview extends StatelessWidget {

  final List<ProductModel> productModelList;
  final int listLength;

  const ProductGridview({Key key, this.productModelList, this.listLength}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    
    final double itemWidth = size.width / 2;
    final double itemHeight = itemWidth + 80;

    return GridView.builder(
      shrinkWrap: true,
      itemCount: listLength,
      padding: const EdgeInsets.all(0),
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        childAspectRatio: (itemWidth / itemHeight)
      ),  
      itemBuilder: (context, index){

        return productModelList.isEmpty || productModelList == null || productModelList.length <= index ?
        Container(
          height: itemWidth - 30,
          color: const Color(cGrey),
          margin: const EdgeInsets.only(bottom: 10),
        ):
        GestureDetector(
          onTap: () async => await Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetails(productModel: productModelList[index]))),
          child: Column(
            children: [

              SizedBox(
                height: itemWidth - 30,
                child: Stack(
                  children: [

                    SizedBox(
                      width: itemWidth,
                      child: ClipRRect(borderRadius: BorderRadius.circular(7),
                        child: setCachedNetworkImage(productModelList[index].imagePatch[0], BoxFit.cover)
                      ),
                    ),

                    productModelList[index].tag.isEmpty ? Container() :
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                        color: Colors.white.withOpacity(0.6),
                        child: Text(
                          productModelList[index].tag
                        ),
                      )
                    ),

                  ],
                ),
              ),
            
              Container(
                padding: const EdgeInsets.only(top: 10),
                height: 50,
                child: Column(
                  children: [

                    // Product Price
                    productModelList[index].discountPrice == 0 ? 
                    const Text('') : 
                    CurrencyTextView(
                      value: productModelList[index].price, 
                      textStyle: const TextStyle(
                        fontSize: xTextSize11,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),

                    //  Product Price
                    CurrencyTextView(
                      value: productModelList[index].discountPrice == 0 ? productModelList[index].price : productModelList[index].discountPrice, 
                      textStyle: TextStyle(
                        fontSize: xTextSize16,
                        color: productModelList[index].discountPrice == 0 ? Colors.black : const Color(cPink),
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}