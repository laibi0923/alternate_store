import 'package:alternate_store/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ProductPhotoView extends StatelessWidget {
  final List<dynamic> imageList;
  final int initPage;
  const ProductPhotoView({ Key? key, required this.imageList, required this.initPage }) : super(key: key);

  
  @override
  Widget build(BuildContext context) {

    final PageController _pageController = PageController(initialPage: initPage);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: imageList.length,
            itemBuilder: (context, index){
              return CachedNetworkImage(
                imageUrl: imageList[index],
                imageBuilder: (context, imageProvider){
                  return PhotoView(imageProvider: imageProvider);
                },
              );
            }
          ),

          Positioned(
            top: 40,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: IconButton(
                onPressed: () => Navigator.pop(context, _pageController.page),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          )

        ],
      )
    );
  }
}