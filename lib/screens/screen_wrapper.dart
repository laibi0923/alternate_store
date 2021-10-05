// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:alternate_store/constants.dart';
import 'package:alternate_store/model/mailbox_model.dart';
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
import 'package:provider/provider.dart';


class ScreenWarpper extends StatefulWidget {
  const ScreenWarpper({Key? key}) : super(key: key);

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
            icon: Icon(Icons.roofing)
          ),
          const BottomNavigationBarItem(
            label: '',
            icon: ImageIcon(AssetImage('lib/assets/icon/ic_heart.png')),
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
              child: const ImageIcon(AssetImage('lib/assets/icon/ic_shoppingbag.png')),
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
              child: const ImageIcon(AssetImage('lib/assets/icon/ic_mail.png')),
            )
          ),
          const BottomNavigationBarItem(
            label: '',
            icon: ImageIcon(AssetImage('lib/assets/icon/ic_settingmenu.png') )
          ),
        ]
      ),
    );
  
  }

}