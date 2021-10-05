//@dart=2.9
class BannerModel{
  final String bannerUri;
  final String queryString;
  String docid;

  BannerModel(this.bannerUri, this.queryString);
  
  factory BannerModel.initdata(){
    return BannerModel('', '', );
  }

  BannerModel.fromFirestore(Map<String, dynamic> dataMap, String id) :
    bannerUri = dataMap['BANNER_URI'],
    queryString = dataMap['QUERY_STRING'],
    docid = id;
}