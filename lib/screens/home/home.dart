// ignore_for_file: import_of_legacy_library_into_null_safe, unnecessary_null_comparison
import 'package:alternate_store/constants.dart';
import 'package:alternate_store/model/banner_model.dart';
import 'package:alternate_store/model/product_model.dart';
import 'package:alternate_store/screens/product_details/product_details.dart';
import 'package:alternate_store/screens/search_center/search_page.dart';
import 'package:alternate_store/viewmodel/homescreen_viewmodel.dart';
import 'package:alternate_store/widgets/currency_textview.dart';
import 'package:alternate_store/widgets/product_gridview.dart';
import 'package:alternate_store/widgets/set_cachednetworkimage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {

    final _productlist = Provider.of<List<ProductModel>>(context);
    final _homeScreenViewModel = Provider.of<HomeScreenViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
      floatHeaderSlivers: false,
      headerSliverBuilder: (content, innerBoxIsScrolled) => [
        _appBar(context) 
      ],
      body: _productlist == null ?
      const Center(
        child: CircularProgressIndicator()
      ) :
      ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 20, right: 20),
        children: [

          _buildBannerList(context),

          _buildLeaderboard(
            context, 
            _homeScreenViewModel, 
            _productlist
          ),

          _buildRecommendList(
            context, 
            _productlist
          ),

          Container(
            height: 100,
          )
        
        ],
      ),
    ));
  }

  Widget _appBar(BuildContext context){
    return SliverAppBar(
      elevation: 0,
      floating: true,
      snap: true,
      centerTitle: true,
      title: Text(
        storeName,
        style: GoogleFonts.alata(
          fontWeight: FontWeight.bold
        )
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen(searchKey: '')));
              setState(() {});
            },
            icon: const Icon(Icons.search)
          ),
        ),
      ],
    );
  }

  Widget _buildBannerList(BuildContext context){

    final _bannerlist = Provider.of<List<BannerModel>>(context);
    final _homeScreenViewModel = Provider.of<HomeScreenViewModel>(context);

    return _bannerlist == null || _bannerlist.isEmpty ? Container() :
    ListView.builder(
      itemCount: _bannerlist.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      itemBuilder: (context, index){
        return GestureDetector(
          onTap:() => _homeScreenViewModel.navigatorPushtPage(SearchScreen(searchKey: _bannerlist[index].queryString)),
          child: Container(
            height: 220,
            margin: const EdgeInsets.only(bottom: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: setCachedNetworkImage(
                _bannerlist[index].bannerUri, 
                BoxFit.cover
              )
            ),
          ),
        );
      }
    );
    
  }

  Widget _buildLeaderboard(BuildContext context, HomeScreenViewModel homeScreenViewModel, List<ProductModel> productlist){

    productlist.sort((a, b) => (b.sold).compareTo(a.sold));

    var size = MediaQuery.of(context).size;
      final double itemHeight = size.width / 2;
      final double itemWidth = size.width / 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top:20, bottom: 10),
          child: Text(
            '人氣排行榜',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ), 
        
        GridView.builder(
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            itemCount: 3,
            physics: const BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              childAspectRatio: (itemWidth / itemHeight)
            ),  
            itemBuilder: (context, index){
              return Stack(
                children: [
                  productlist.isEmpty || productlist == null || productlist.length <= index ? 
                  ClipRRect(borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 180,
                      width: 180,
                      color: const Color(cGrey),
                    )
                  ) :
                  GestureDetector(
                    onTap: () => homeScreenViewModel.navigatorPushtPage(ProductDetails(productModel: productlist[index])),
                    child: ClipRRect(borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 180,
                        width: 180,
                        color: const Color(cGrey),
                        child: setCachedNetworkImage(
                          productlist[index].imagePatch[0], 
                          BoxFit.cover
                        )
                      )
                    ),
                  ),

                  SizedBox(
                    height: 30,
                    width: 30,
                    child: Image.asset(
                      'lib/assets/icon/ic_crown.png',
                      color : 
                      index == 1 ? Colors.white60 : 
                      index == 2 ? const Color(0xFFB87333) : 
                      const Color(0xFFFFD700)
                    ),
                  )

                ],
              );
            }
        ),
      ],
    );

  }

  Widget _buildRecommendList(BuildContext context, List<ProductModel> list){

    final _homeScreenViewModel = Provider.of<HomeScreenViewModel>(context);
    

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Padding(
          padding: EdgeInsets.only(top:20, bottom: 20),
          child: Text(
            '為你推薦',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ), 

        _productGridView(context, list, 20),

        InkWell(
          onTap: () => _homeScreenViewModel.navigatorPushtPage(const SearchScreen(searchKey: '新品')),
          child: Container(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: const Center(
              child: Text('更多推薦產品')
            )
          ),
        ),

      ],
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






