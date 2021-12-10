// @dart=2.9
import 'package:alternate_store/constants.dart';
import 'package:alternate_store/screens/product_details/product_details.dart';
import 'package:alternate_store/widgets/currency_textview.dart';
import 'package:alternate_store/widgets/set_cachednetworkimage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alternate_store/model/product_model.dart';
import 'package:alternate_store/screens/search_center/search_page.dart';
import 'package:alternate_store/viewmodel/wishlist_viewmodel.dart';
import 'package:alternate_store/widgets/product_gridview.dart';
import 'package:alternate_store/widgets/wishlist/empty_wishlist_screen.dart';

class WishList extends StatefulWidget {
  const WishList({Key key}) : super(key: key);

  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {

  @override
  Widget build(BuildContext context) {
    
    final _wishlistServices = Provider.of<WishlistViewModel>(context);

    final productlist = Provider.of<List<ProductModel>>(context, listen: false);
    Provider.of<WishlistViewModel>(context, listen: false).getProductData(productlist);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('喜愛清單'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  const SearchScreen(searchKey: '',))),
              icon: const Icon(Icons.search)
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: _wishlistServices.getWishList.isEmpty ? 
        emptyWishlistScreen(context) : 
        _productGridView(context, _wishlistServices.getWishList, _wishlistServices.getWishList.length)
      ),
    );
  
  }


  Widget _productGridView(BuildContext context, List<ProductModel> list, int listLength){

    var size = MediaQuery.of(context).size;
    final double itemWidth = size.width / 2;
    final double itemHeight = itemWidth + 80;
    List<ProductModel> tempList = [];
    tempList.addAll(list);
    tempList.shuffle();

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
        return tempList.isEmpty || tempList == null || tempList.length <= index ?
        Container(
          height: itemWidth - 30,
          color: const Color(cGrey),
          margin: const EdgeInsets.only(bottom: 10),
        ):
        GestureDetector(
          onTap: () async => await Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetails(productModel: tempList[index]))),
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
                          tempList[index].imagePatch[0].toString(), 
                          BoxFit.cover
                        )
                      ),
                    ),

                    tempList[index].tag.isEmpty ? Container() :
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                        color: Colors.white.withOpacity(0.6),
                        child: Text(
                          tempList[index].tag
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
                    tempList[index].discountPrice == 0 ? 
                    const Text('') : 
                    CurrencyTextView(
                      value: tempList[index].price, 
                      textStyle: const TextStyle(
                        fontSize: xTextSize11,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),

                    //  Product Price
                    CurrencyTextView(
                      value: tempList[index].discountPrice == 0 ? tempList[index].price : tempList[index].discountPrice, 
                      textStyle: TextStyle(
                        fontSize: xTextSize16,
                        color: tempList[index].discountPrice == 0 ? Colors.black : const Color(cPink),
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
