// ignore_for_file: import_of_legacy_library_into_null_safe, unnecessary_null_comparison

import 'package:alternate_store/constants.dart';
import 'package:alternate_store/model/product_model.dart';
import 'package:alternate_store/screens/product_details/product_details.dart';
import 'package:alternate_store/screens/search_center/search_page.dart';
import 'package:alternate_store/viewmodel/homescreen_viewmodel.dart';
import 'package:alternate_store/widgets/product_gridview.dart';
import 'package:alternate_store/widgets/set_cachednetworkimage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class Home extends StatelessWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final productlist = Provider.of<List<ProductModel>>(context);
    final _homeScreenViewModel = Provider.of<HomeScreenViewModel>(context);
    _homeScreenViewModel.setProductlistStatus(productlist);

    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
      floatHeaderSlivers: false,
      headerSliverBuilder: (content, innerBoxIsScrolled) => [
        _appBar(context) 
      ],
      body: _homeScreenViewModel.productlistState == status.loading ?
      const Center(
        child: CircularProgressIndicator()
      ) :
      ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 20, right: 20),
        children: [

          _buildImageSilder(context),

          _buildHotItem(),

          _buiildLeaderboard(
            context, 
            _homeScreenViewModel, 
            productlist
          ),
          
          _buildRecommendList(
            context, 
            productlist
          ),

          Container(
            height: 100,
          )
        
        ],
      ),
    ));
  }
  
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
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  const SearchScreen(searchKey: '',))),
          icon: const Icon(Icons.search)
        ),
      ),
    ],
  );
}


Widget _buildImageSilder(BuildContext context){

  final _homeScreenViewModel = Provider.of<HomeScreenViewModel>(context);

  return Column(
    children: [
      // 
       GestureDetector(
        onTap:() => _homeScreenViewModel.navigatorPushtPage(const SearchScreen(searchKey: '半截裙')),
        child: Container(
          height: 220,
          decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(
              Radius.circular(16)
            ),
            image: DecorationImage(
              image: AssetImage('lib/assets/img/00_01.jpg'),
              fit: BoxFit.cover
            )
          ),         
        ),
      ),

      Container(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              margin: const EdgeInsets.only(left: 5, right: 5),
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(999)
              ),
            ),

            Container(
              margin: const EdgeInsets.only(left: 5, right: 5),
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(999)
              ),
            ),

            Container(
              margin: const EdgeInsets.only(left: 5, right: 5),
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(999)
              ),
            ),
            
          ],
        ),
      ),

    ],
  );
}


Widget _buildHotItem(){
  return Container(
    height: 220,
    margin: const EdgeInsets.only(top: 20),
    decoration: BoxDecoration(
      color: Colors.grey,
      borderRadius: BorderRadius.circular(17)
    ),
    child: const Center(
      child: Text('熱賣產品'),
    ),
  );
}


Widget _buiildLeaderboard(BuildContext context, HomeScreenViewModel homeScreenViewModel, List<ProductModel> productlist){

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
                productlist.isEmpty || productlist == null? 
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
    children: [
      const Padding(
        padding: EdgeInsets.only(top: 20),
        child: Text(
          '為你推薦',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),

      ProductGridview(
        productModelList: list,
        listLength: 20,
      ),

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