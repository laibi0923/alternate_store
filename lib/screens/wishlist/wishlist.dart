// @dart=2.9
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
        child: _wishlistServices.getWishList.isEmpty ? emptyWishlistScreen(context) : 
          ProductGridview(
            productModelList: _wishlistServices.getWishList,
            listLength: _wishlistServices.getWishList.length,
          ),
      ),
    );
  
  }

}
