// @dart=2.9
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alternate_store/constants.dart';
import 'package:alternate_store/screens/screen_wrapper.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({ key }) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    _navigatorHomeScreen();
    super.initState();
  }

  _navigatorHomeScreen() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ScreenWarpper()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(cPrimaryColor),
      body: Center(
        child: Text(
          storeName, 
          style: GoogleFonts.alata(
            fontSize: 40,
            color: Colors.white
          )
        ),
      ),
    );
  }

}