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

  @override
  void initState() {
    super.initState();
    final _productlist = Provider.of<List<ProductModel>>(context, listen: false);
    final _categorylist = Provider.of<List<CategoryModel>>(context, listen: false);
    final _searchPageViewModel = Provider.of<SearchPageViewModel>(context, listen: false);
    _searchPageViewModel.initViewModel(_productlist, _categorylist);
    if(widget.searchKey.isNotEmpty){
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) { 
        _searchPageViewModel.queryStringfromCategory(widget.searchKey);
        _searchPageViewModel.searchFliedController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final _searchPageViewModel = Provider.of<SearchPageViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildSearchAppbar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: _searchPageViewModel.searchResultList.isEmpty ? 
        const Center(
          child: Text(
            '找不到結果',
            style: TextStyle(color: Colors.grey),
          ),
        ) :
        ProductGridview(
          productModelList: _searchPageViewModel.searchResultList,
          listLength: _searchPageViewModel.searchResultList.length,
        )
      )
    );
    
  }

  AppBar _buildSearchAppbar(){

    final _searchPageViewModel = Provider.of<SearchPageViewModel>(context);
    _searchPageViewModel.setCategoryListStatus(_searchPageViewModel.getcategoryList);

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
                onChanged: (value) => _searchPageViewModel.queryfromString(value)
              )
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search)
            )
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Container(
          height: 40,
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: _searchPageViewModel.categoryliststate == status.loading ?
          const Center(child: CircularProgressIndicator()) :
          _buildCategoryListView()
        ),
      )
    );
  }

  Widget _buildCategoryListView(){

    final _searchPageViewModel = Provider.of<SearchPageViewModel>(context);
    List<CategoryModel> list = _searchPageViewModel.getcategoryList;

    // ignore: unnecessary_null_comparison
    return ListView.builder(
      itemCount: list.length,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _searchPageViewModel.queryfromCategory(index),
          child: list[index].quickSearch == false ? Container() :
          Container(
            margin: const EdgeInsets.only(left: 10),
            padding: const EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              color: index == _searchPageViewModel.categoryCurrentIndex ? const Color(cPrimaryColor) : Colors.transparent,
              border: Border.all(
                width: 1.0,
                color: const Color(cPrimaryColor)
              ),
              borderRadius: BorderRadius.circular(99)
            ),
            child: Center(
              child: Text(
                list[index].name,
                style: index == _searchPageViewModel.categoryCurrentIndex ?
                const TextStyle(color: Colors.white) :
                const TextStyle(color: Colors.grey),
              ),
            ),
          ),
        );
      }
    );
  }

}
