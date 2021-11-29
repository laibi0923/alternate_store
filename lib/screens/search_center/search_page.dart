// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:alternate_store/constants.dart';
import 'package:alternate_store/model/category_model.dart';
import 'package:alternate_store/model/product_model.dart';
import 'package:alternate_store/viewmodel/searchpage_viewmodel.dart';
import 'package:alternate_store/widgets/product_gridview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  final String searchKey;
  const SearchScreen({Key? key, required this.searchKey}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  // final List<ProductModel> _searchList = [];
  // final TextEditingController _searchTextController = TextEditingController();
  // late int _searchResultCounter = 0;

  @override
  void initState() {
    super.initState();
    
    final _searchPageViewModel = Provider.of<SearchPageViewModel>(context, listen: false);
    _searchPageViewModel.initViewModel();

    final _productlist = Provider.of<List<ProductModel>>(context, listen: false); 
    
    if(widget.searchKey.isNotEmpty){
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        _searchPageViewModel.queryStringfromCategory(widget.searchKey, _productlist);
        _searchPageViewModel.searchFliedController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final _productLIst = Provider.of<List<ProductModel>>(context);
    final _searchPageViewModel = Provider.of<SearchPageViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildSearchAppbar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          children: [
            _searchPageViewModel.searchResultList.isEmpty ? Container() :
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 20),
              child: Text(
                '共找到 ${_searchPageViewModel.searchResultList.length} 筆相關資料',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            Expanded(
              child: _searchPageViewModel.searchFliedController.text.isNotEmpty || _searchPageViewModel.searchResultList.isNotEmpty ?
              _buildProductGirdView(_searchPageViewModel.searchResultList) :
              _buildProductGirdView(_productLIst)
            )
          ],
        )
        
      )
    );
    
  }

  AppBar _buildSearchAppbar(){

    final _categorylist = Provider.of<List<CategoryModel>>(context);
    final _productlist = Provider.of<List<ProductModel>>(context); 
    final _searchPageViewModel = Provider.of<SearchPageViewModel>(context);

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Container(
        decoration: const BoxDecoration(
          color: Color(cGrey),
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, size: 20)
            ),
            Expanded(
                child: TextField(
                  controller: _searchPageViewModel.searchFliedController,
                  decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(0),
                  isDense: true,
                  hintText: '輸入產品名稱',
                ),
                onChanged: (value) => _searchPageViewModel.queryfromString(value, _productlist)
              )
            ),
            const Padding(
              padding: EdgeInsets.only(right: 15),
              child: Icon(Icons.search),
            )
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Container(
          height: 40,
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          // ignore: unnecessary_null_comparison
          child: _categorylist == null ?
          const Center(child: CircularProgressIndicator()) :
          _buildCategoryListView(_categorylist, _productlist, _searchPageViewModel)
        ),
      )
    );
  }

  Widget _buildCategoryListView(List<CategoryModel> categorylist, List<ProductModel> productlist, SearchPageViewModel searchPageViewModel){

    // ignore: unnecessary_null_comparison
    return categorylist == null ? Container() :
    ListView.builder(
      itemCount: categorylist.length,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => searchPageViewModel.queryfromCategory(index, categorylist[index].name , productlist),
          child: categorylist[index].quickSearch == false ? Container() :
          Container(
            margin: const EdgeInsets.only(left: 10),
            padding: const EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              color: index == searchPageViewModel.categoryCurrentIndex ? const Color(cPrimaryColor) : Colors.transparent,
              border: Border.all(
                width: 1.0,
                color: const Color(cPrimaryColor)
              ),
              borderRadius: BorderRadius.circular(99)
            ),
            child: Center(
              child: Text(
                categorylist[index].name,
                style: index == searchPageViewModel.categoryCurrentIndex ?
                const TextStyle(color: Colors.white) :
                const TextStyle(color: Colors.grey),
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _buildProductGirdView(List<ProductModel> list){

    if(list == null){
      return const Center(
        child: CircularProgressIndicator(color: Colors.grey),
      );
    }

    if(list.isEmpty){
      return const Center(
        child: Text(
          '找不到捜尋結果',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ProductGridview(
      productModelList: list,
      listLength: list.length,
    );
  }

}
