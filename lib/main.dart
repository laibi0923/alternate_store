// @dart=2.9
// ignore_for_file: missing_required_param

import 'package:alternate_store/constants.dart';
import 'package:alternate_store/screens/splash_page.dart';
import 'package:alternate_store/service/auth_database.dart';
import 'package:alternate_store/service/auth_services.dart';
import 'package:alternate_store/service/category_database.dart';
import 'package:alternate_store/service/coupon_service.dart';
import 'package:alternate_store/service/order_service.dart';
import 'package:alternate_store/service/paymentmethod_service.dart';
import 'package:alternate_store/service/policy_service.dart';
import 'package:alternate_store/service/product_database.dart';
import 'package:alternate_store/service/refund_services.dart';
import 'package:alternate_store/viewmodel/cart_viewmodel.dart';
import 'package:alternate_store/viewmodel/checkout_viewmodel.dart';
import 'package:alternate_store/viewmodel/homescreen_viewmodel.dart';
import 'package:alternate_store/viewmodel/mailbox_viewmodel.dart';
import 'package:alternate_store/viewmodel/productdetails_viewmodel.dart';
import 'package:alternate_store/viewmodel/searchpage_viewmodel.dart';
import 'package:alternate_store/viewmodel/setting_viewmodel.dart';
import 'package:alternate_store/viewmodel/wishlist_viewmodel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await FlutterDownloader.initialize(debug: true);
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: AuthService()),
      FutureProvider(
        create: (_) => SharedPreferences.getInstance(),
        lazy: false, initialData: null,
      )
    ],
    child: const MyApp(),
  ));
}

//  
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    //  強制直屏
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    //  Status Bar 透明化
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ));

    return MultiProvider(
      providers: [

        //  Stream Provider
        StreamProvider.value(
            value: AuthDatabase(authService.userUid).userInformation, 
        ),

        StreamProvider.value(
          value: ProductDatabase().getProduct, 
        ),

        StreamProvider.value(
          value: CategoryDatabase().getCategory, 
        ),

        StreamProvider.value(
          value: AuthDatabase(authService.userUid).getmaillist()
        ),

        StreamProvider.value(
            value: OrderService(authService.userUid).orderHistory, 
        ),

        StreamProvider.value(
          value: RefundServices(authService.userUid).getRefund, 
        ),

        StreamProvider.value(
          value: PrivatePolicyService().getPrivatePolicyContent, 
        ),

        StreamProvider.value(
          value: PrivatePolicyService().getReturnPolicyContent, 
        ),

        StreamProvider.value(
          value: CouponService().getCouponCode, 
        ),

        StreamProvider.value(
          value: AuthDatabase(authService.userUid).getUserCouponRecord(), 
        ),

        StreamProvider.value(
          value: PaymentMethodService().getPaymentMethod, 
        ),

        ChangeNotifierProvider<SearchPageViewModel>(
          create: (context) => SearchPageViewModel()
        ),
        
        ChangeNotifierProvider<ProductDetailsViewModel>(
          create: (context) => ProductDetailsViewModel()
        ),

        //  ChangeNotifierProvider
        ChangeNotifierProvider<HomeScreenViewModel>(
          create: (context) => HomeScreenViewModel()
        ),

        ChangeNotifierProvider<WishlistViewModel>(
          create: (_) => WishlistViewModel(mSharedPreferences: Provider.of(context))
        ),

        ChangeNotifierProvider<CartViewModel>(
          create: (_) => CartViewModel(mSharedPreferences: Provider.of(context))
        ),

        ChangeNotifierProvider<CheckoutViewModel>(
          create: (_) => CheckoutViewModel()
        ),

        ChangeNotifierProvider<MailboxViewModel>(
          create: (context) => MailboxViewModel()
        ),

        ChangeNotifierProvider<SettingViewModel>(
          create: (context) => SettingViewModel()
        ),

        

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        title: storeName,
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          //  主顏色
          //  White = Statusbar icon = black;
          //  Black = Statusbar icon = white;
          primaryColor: Colors.white,

          //  ???
          //  primarySwatch: Colors.red,

          //  下劃線樣式
          dividerColor: Colors.white54,

          //
          textSelectionTheme:
              const TextSelectionThemeData(cursorColor: Color(cPrimaryColor)),

          //  文字樣式
          primaryTextTheme: const TextTheme(),

          //  Appbar 樣式
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: xTextSize18,
                fontWeight: FontWeight.bold),
            iconTheme: IconThemeData(color: Colors.black),
          ),
        ),
        home: const SplashPage(),
      ),
    );
  }
}
