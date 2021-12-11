
// ignore_for_file: import_of_legacy_library_into_null_safe
import 'package:alternate_store/constants.dart';
import 'package:alternate_store/model/product_model.dart';
import 'package:alternate_store/screens/product_details/product_photoview.dart';
import 'package:alternate_store/viewmodel/cart_viewmodel.dart';
import 'package:alternate_store/viewmodel/productdetails_viewmodel.dart';
import 'package:alternate_store/viewmodel/wishlist_viewmodel.dart';
import 'package:alternate_store/widgets/currency_textview.dart';
import 'package:alternate_store/widgets/expand_text.dart';
import 'package:alternate_store/widgets/set_cachednetworkimage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class ProductDetails extends StatefulWidget {
  final ProductModel productModel; 
  const ProductDetails({Key? key, required this.productModel}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {

  void _show(BuildContext context, CartViewModel cartViewModel, WishlistViewModel wishlistViewModel) {

    final _productViewModel = Provider.of<ProductDetailsViewModel>(context, listen: false);
    int currentColor = 0;
    String colorName = widget.productModel.color[0]['COLOR_NAME'];
    int currentSize = 0;

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.90,
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter mystate){
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(17), 
                  topRight: Radius.circular(17)
                )
              ),
              
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Center(
                    child: Container(
                      height: 8,
                      width: 60,
                      margin:  const EdgeInsets.only(top: 15, bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(99)
                      ),
                    ),
                  ),

                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [

                        //  Name
                        widget.productModel.productName.trim() == '' ? Container() :
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
                          child: Text(
                            widget.productModel.productName,
                            style: const TextStyle(
                              fontSize: xTextSize18, 
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                                
                        //  Product No.
                        widget.productModel.productName.trim() == '' ? Container() :
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Text(
                            widget.productModel.productNo,
                            style: const TextStyle(
                              color: Colors.grey
                            ),
                          ),
                        ),
                        
                        //  Description
                        widget.productModel.description.trim() == '' ? Container() :
                        ExpandText(content: widget.productModel.description),

                        //  Price
                        widget.productModel.price == null ? Container() :
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            children: [

                              Padding(
                                padding: const EdgeInsets.only(top: 20, right: 20),
                                child: CurrencyTextView(
                                  value: widget.productModel.price, 
                                  textStyle: TextStyle(
                                    fontSize: widget.productModel.discountPrice == 0 ? xTextSize18 : xTextSize14, 
                                    decoration: widget.productModel.discountPrice == 0 ?  null : TextDecoration.lineThrough
                                  ),
                                ),
                              ),
                    
                              widget.productModel.discountPrice == 0 ? Container() :
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: CurrencyTextView(
                                  value: widget.productModel.discountPrice, 
                                  textStyle: const TextStyle(
                                    fontSize: xTextSize18, 
                                    color: Color(cPink)
                                  ),
                                ),
                              ),
                                
                            ],
                          ),
                        ),

                        //  Shipping Time
                        const Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Text('預計送貨時間約 7-11 天'),
                        ),

                        //  Refundable
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: widget.productModel.refundable == true ? Container() :
                          const Text(
                            refundableText,
                            style: TextStyle(color: Color(cPink)),
                          ),
                        ),

                        //  Size
                        widget.productModel.size == null ? Container() :
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                              child: Text(
                                '呎碼',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              height: 30,
                              margin: const EdgeInsets.only(top: 15, bottom: 15),
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.productModel.size.length,
                                itemBuilder: (context, index){
                                  return GestureDetector(
                                    onTap: () {
                                      currentSize = index;
                                      mystate((){});
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 20),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: index == currentSize ? const Color(cPrimaryColor) : Colors.black,
                                          width: index == currentSize ? 2.0 : 0.0
                                        ),
                                        borderRadius: const BorderRadius.all(Radius.circular(99))
                                      ),
                                      child: Center(
                                        child: Container(
                                          //height: 20,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            //color: const Color(cPrimaryColor),
                                            borderRadius: BorderRadius.circular(99)
                                          ),
                                          child: Center(
                                            child: Text(
                                              widget.productModel.size[index],
                                              style: TextStyle(
                                                color: index == currentSize ? Colors.black : Colors.black
                                              ),
                                            )
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              ),
                            ),
                          ],
                        ),
                                
                        // Color
                        widget.productModel.color == null ? Container() :
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                              child: Text(
                                '顏色   ($colorName)',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              height: 50,
                              margin: const EdgeInsets.only(top: 15, bottom: 15),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.productModel.color.length,
                                itemBuilder: (context, index){
                                  return GestureDetector(
                                    onTap: (){
                                      currentColor = index;
                                      colorName = widget.productModel.color[index]['COLOR_NAME'];
                                      mystate((){});
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      margin: const EdgeInsets.only(left: 20),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: index == currentColor ? const Color(cPrimaryColor) : Colors.black,
                                          width: index == currentColor ? 2.0 : 1.0
                                        ),
                                        borderRadius: const BorderRadius.all(Radius.circular(99))
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(99),
                                        ),
                                        child: Center(
                                          child: SizedBox(
                                            height: 45,
                                            width: 45,
                                            child:  ClipRRect(borderRadius: BorderRadius.circular(99),
                                              child: setCachedNetworkImage(widget.productModel.color[index]['COLOR_IMAGE'], BoxFit.cover)
                                            ),
                                          )
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              ),
                            ),
                          ],
                        ),

                        Container(height: 150,)
                                
                      ],
                    ),
                  ),
          
                  //  Add to Cart Button
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color(cPrimaryColor),
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                        ),
                      ),
                      onPressed: () => _productViewModel.addCart(
                        cartViewModel,
                        wishlistViewModel,
                        widget.productModel,
                        currentSize, 
                        currentColor
                      ),
                      child: const Text(
                        '加入購物車',
                      ),
                    )
                  )
                  
                ],
              ),
            );
          }
        ),
      )
    );
  }
  
  @override
  void initState() {
    super.initState();
    Provider.of<ProductDetailsViewModel>(context, listen: false).initProductDetails();
  }

  @override
  Widget build(BuildContext context) {

    final PageController _pageController = PageController(initialPage: 0);
    final _cartviewmodel = Provider.of<CartViewModel>(context);
    final _wishlistviewmodel = Provider.of<WishlistViewModel>(context);
    final _productDetailsViewModel = Provider.of<ProductDetailsViewModel>(context);
    final wishlist = _wishlistviewmodel.getSharedPerferencesCartList;
    _productDetailsViewModel.checkOnWishlist(wishlist, widget.productModel.productNo);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          
          //  產品圖片
          _productImagePageView(_pageController, _productDetailsViewModel),
        
          //  關閉
          _closeCircleButton(),

          //  加入收藏清單
          _addToWishListButton(_productDetailsViewModel, _wishlistviewmodel),

          //  加入購物車
          _addToCartButton(_cartviewmodel, _wishlistviewmodel),
      
          //  產品圖片計算器
          _productImageCounter(
            (_productDetailsViewModel.imageIndex + 1).toString(),
            widget.productModel.imagePatch.length.toString()
          )

        ],
      ),
    );

  }

  Widget _productImagePageView(PageController pageController, ProductDetailsViewModel productDetailsViewModel){
    return PageView.builder( 
      controller: pageController,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: widget.productModel.imagePatch.length,
      onPageChanged: (index) => productDetailsViewModel.updateImageIndex(index),
      itemBuilder: (context, index){
        return GestureDetector(
          onTap: () async {
            var result = await Navigator.push(context, MaterialPageRoute(builder: (context){
              return ProductPhotoView(
                imageList: widget.productModel.imagePatch, 
                initPage: index
              );
            }));

            if(result != null){
              pageController.jumpToPage(result.toInt());
            }

          },
          child: CachedNetworkImage(
            imageUrl: widget.productModel.imagePatch[index],
            fit: BoxFit.cover,
          ),
        );
      }
    );
  }

  Widget _addToWishListButton(ProductDetailsViewModel productDetailsViewModel, WishlistViewModel wishlistViewModel){
    return Positioned(
      top: 60,
      left: 15,
      child: GestureDetector(
        onTap: (){
          productDetailsViewModel.addWishList(widget.productModel, wishlistViewModel);
        },
        child: Container(
          height: 42,
          width: 42,
          padding: const EdgeInsets.all(8),
          decoration:const BoxDecoration(
            color: Color(0x90000000),
            borderRadius: BorderRadius.all(
              Radius.circular(99)
            )
          ),
          child: Center(
            child: Image(
              image: productDetailsViewModel.onWishList == true ? const AssetImage('lib/assets/icon/ic_heart_fill.png') : const AssetImage('lib/assets/icon/ic_heart.png'),
              color: productDetailsViewModel.onWishList == true ? Colors.redAccent : Colors.redAccent,
            ),
          )
        ),
      )
    );
  }

  Widget _closeCircleButton(){
    return Positioned(
      top : 60,
      right: 15,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          height: 42,
          width: 42,
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0x90000000),
            borderRadius: BorderRadius.all(
              Radius.circular(99)
            ),
          ),
          child: const Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _addToCartButton(CartViewModel cartViewModel, WishlistViewModel wishlistViewModel){
    return Positioned(
      bottom: 42,
      child: GestureDetector(
        onTap: () => _show(context, cartViewModel, wishlistViewModel),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Container(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 5),
              decoration: const BoxDecoration(
                color: Color(0x90000000),
                borderRadius: BorderRadius.all(
                  Radius.circular(99),
                ),
              ),
              child: Column(
                children: [
                  CurrencyTextView(
                    value: widget.productModel.discountPrice == 0 ? widget.productModel.price : widget.productModel.discountPrice, 
                    textStyle: const TextStyle(color: Colors.white),
                  ),
                  const Text(
                    '產品資訊',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _productImageCounter(String currentIndex, String totalImage){
    return Positioned(
      top: 0,
      left: -15,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Transform(
            alignment: FractionalOffset.center,
            transform: Matrix4.rotationZ(-90 * math.pi / 180),
            child: Container(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 5),
              decoration: const BoxDecoration(
                color: Color(0x90000000),
                borderRadius: BorderRadius.all(
                  Radius.circular(99)
                )
              ),
              child: Text(
                currentIndex + ' / ' + totalImage,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      )
    );
  }
  
}
