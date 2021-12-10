import 'package:alternate_store/widgets/currency_textview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:alternate_store/constants.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:alternate_store/model/product_model.dart';
import 'package:alternate_store/screens/product_details/product_details.dart';
import 'package:alternate_store/widgets/set_cachednetworkimage.dart';


Widget productGridView(BuildContext context, List<ProductModel> list, int listLength){

  var size = MediaQuery.of(context).size;
  final double itemWidth = size.width / 2;
  final double itemHeight = itemWidth + 80;
  list.shuffle();

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
      
        return list.isEmpty || list == null || list.length <= index ?
        Container(
          height: itemWidth - 30,
          color: const Color(cGrey),
          margin: const EdgeInsets.only(bottom: 10),
        ):
        GestureDetector(
          onTap: () async => await Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetails(productModel: list[index]))),
          child: Column(
            children: [

              SizedBox(
                height: itemWidth - 30,
                child: Stack(
                  children: [

                    SizedBox(
                      width: itemWidth,
                      child: ClipRRect(borderRadius: BorderRadius.circular(7),
                        child: setCachedNetworkImage(
                          list[index].imagePatch[0].toString(), 
                          BoxFit.cover
                        )
                      ),
                    ),

                    list[index].tag.isEmpty ? Container() :
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                        color: Colors.white.withOpacity(0.6),
                        child: Text(
                          list[index].tag
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
                    list[index].discountPrice == 0 ? 
                    const Text('') : 
                    CurrencyTextView(
                      value: list[index].price, 
                      textStyle: const TextStyle(
                        fontSize: xTextSize11,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),

                    //  Product Price
                    CurrencyTextView(
                      value: list[index].discountPrice == 0 ? list[index].price : list[index].discountPrice, 
                      textStyle: TextStyle(
                        fontSize: xTextSize16,
                        color: list[index].discountPrice == 0 ? Colors.black : const Color(cPink),
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
