// @dart=2.9
import 'package:alternate_store/constants.dart';
import 'package:alternate_store/model/mailbox_model.dart';
import 'package:alternate_store/model/product_model.dart';
import 'package:alternate_store/screens/cart/cart.dart';
import 'package:alternate_store/screens/home/home.dart';
import 'package:alternate_store/screens/mailbox/mailbox.dart';
import 'package:alternate_store/screens/setting/setting.dart';
import 'package:alternate_store/screens/wishlist/wishlist.dart';
import 'package:alternate_store/service/auth_database.dart';
import 'package:alternate_store/service/auth_services.dart';
import 'package:alternate_store/viewmodel/cart_viewmodel.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';


class ScreenWarpper extends StatefulWidget {
  const ScreenWarpper({Key key}) : super(key: key);

  @override
  State<ScreenWarpper> createState() => _ScreenWarpperState();
}

class _ScreenWarpperState extends State<ScreenWarpper> {

  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  void _bottomNavigatorBarItemOnClick(value){
    setState(() {
      if(value != _currentIndex){
        _currentIndex = value;
        _pageController.animateToPage(
          value, duration: const Duration(milliseconds: 300),
          curve: Curves.decelerate)
        ;
      }
    });
    setState(() => value != _currentIndex ? _currentIndex = value : _currentIndex);
  }


  Future<void> initUniLinks() async {
    String initialLink;
    // ********* collectable43424://productdetails?name=SKU0929883339
    try {
      initialLink = await getInitialLink();
      if(initialLink != null){
        print('>>>>>>>>>>>>>>>> $initialLink');
      }
    } on PlatformException{
      print('Failed to get initial link');
    } on FormatException{
      print('Failed to parse the initial link as Uri.');
    }

    // App開啟的狀態監聽scheme
    linkStream.listen((String link) {
      if (!mounted || link == null) {
        return;
      } else {
        print('link--$link');
        //  跳轉到指定頁面
        schemeJump(context, link);  
      }
    }, onError: (Object err) {
      if (!mounted) return;
    });

  }

  Future<void> schemeJump(BuildContext context, link) async {

    final Uri _jumpUri = Uri.parse(link.replaceFirst(
      'collectable43424://',
      'http://path/',
    ));

    // print('JumpUri Patch: ${_jumpUri.path}');
    // print('Link Patch: ${_jumpUri.queryParameters['name']}');

    switch (_jumpUri.path) {
      case '/productdetails':
        ProductModel sku = getProductformSUK(_jumpUri.queryParameters['name']);
        Navigator.of(context).pushNamed(
          '/productdetails',
          arguments: sku,
        );
        break;
      default:
        break;
    }
  }

  ProductModel getProductformSUK(String sku) {

    final productList = Provider.of<List<ProductModel>>(context, listen: false);

    if(productList != null){
      for(int i = 0; i < productList.length; i++){
        if(productList[i].productNo == sku){
          return productList[i];
        }
      }
    }
    return productList[0];
    
  }

  @override
  void initState() {
    super.initState();
    initUniLinks();
  }

  @override
  Widget build(BuildContext context) {

    final _authService = Provider.of<AuthService>(context);  
    final _mailboxData = Provider.of<List<MailBoxModel>>(context);
    final _cartViewModel = Provider.of<CartViewModel>(context);

    List pages = [
      const Home(), 
      const WishList(), 
      const Cart(), 
      const Mailbox(), 
      Setting(signInStatus: _authService.isSignedIn, emailVerified: _authService.emailverify,)
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        itemCount: pages.length,
        onPageChanged: (index){
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index){
          return pages[index];
        }
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (value) => _bottomNavigatorBarItemOnClick(value),
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            label: '',
            icon: Icon(Icons.roofing),
            backgroundColor: Colors.redAccent,
          ),
          const BottomNavigationBarItem(
            label: '',
            icon: ImageIcon(AssetImage('assets/icon/ic_heart.png')),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Badge(
              position: const BadgePosition(bottom: -13),
              badgeColor: const Color(cPrimaryColor),
              showBadge: _cartViewModel.getSharedPerferencesCartList.isEmpty ? false : true,
              badgeContent:  Text(((){
                int cartLenght = _cartViewModel.getSharedPerferencesCartList.length;
                if(cartLenght > 99) () => '99+';
                return cartLenght.toString();
              })(),
                style: const TextStyle(color: Colors.white, fontSize: 10)
              ),
              child: const ImageIcon(AssetImage('assets/icon/ic_shoppingbag.png')),
            )
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Badge(
              position: const BadgePosition(bottom: -13),
              badgeColor: const Color(cPrimaryColor),
              showBadge: _authService.isSignedIn == true &&
              AuthDatabase(_authService.userUid).getUnReadMail(_mailboxData) > 0 ? true : false,
              badgeContent:  Text(((){
                int unreadmail = AuthDatabase(_authService.userUid).getUnReadMail(_mailboxData);
                if(unreadmail > 99) () => '99+';
                return unreadmail.toString();
              })(),
                style: const TextStyle(color: Colors.white, fontSize: 10)
              ),
              child: const ImageIcon(AssetImage('assets/icon/ic_mail.png')),
            )
          ),
          const BottomNavigationBarItem(
            label: '',
            icon: ImageIcon(AssetImage('assets/icon/ic_settingmenu.png') )
          ),
        ]
      ),
    );
  
  }

}