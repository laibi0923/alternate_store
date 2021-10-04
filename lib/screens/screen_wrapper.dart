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

  void _bottomNavigatorBarItemOnClick(value){
    setState(() => value != _currentIndex ? _currentIndex = value : _currentIndex);
  }

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);  
    final mailboxData = Provider.of<List<MailBoxModel>>(context);
    final _cartViewModel = Provider.of<CartViewModel>(context);

    List pages = [
      const Home(), 
      const WishList(), 
      const Cart(), 
      const Mailbox(), 
      Setting(signInStatus: authService.isSignedIn, emailVerified: authService.emailverify,)
    ];

    return Scaffold(
      body: pages[_currentIndex],
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
              showBadge: authService.isSignedIn == true &&
              AuthDatabase(authService.userUid).getUnReadMail(mailboxData) > 0 ? true : false,
              badgeContent:  Text(((){
                int unreadmail = AuthDatabase(authService.userUid).getUnReadMail(mailboxData);
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