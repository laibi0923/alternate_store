// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alternate_store/constants.dart';
import 'package:alternate_store/screens/setting/login.dart';
import 'package:alternate_store/screens/setting/register.dart';

class UserEntrance extends StatefulWidget {
  final bool popBack;
  final bool emailVerifed;
  const UserEntrance({key, this.emailVerifed, this.popBack}) : super(key: key);

  @override
  _UserEntranceState createState() => _UserEntranceState();
}

class _UserEntranceState extends State<UserEntrance> with TickerProviderStateMixin {
  final List<String> _tagtitle = ['登入', '註冊'];
  TabController _tabController;
  PageController _pageController;
   

  @override
  void initState() {
    _pageController = PageController();
    _tabController = TabController(length: _tagtitle.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _googleLogin(){
    // TODO Google 登入
  }

  void _facebookLogin(){
    // TODO Facebook 登入
  }

  void _changeTab(int index){
    _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void _onPageChange(int index){
    _tabController.animateTo(index, duration: const Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [

            widget.popBack == false ? Container() :
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 20, right: 20),
                child: IconButton(
                  onPressed: () => Navigator.pop(context), 
                  icon: const Icon(Icons.close)
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Column(
                children: [

                  Text(
                    storeName,
                    style: GoogleFonts.alata(
                      fontSize: xTextSize26,
                      fontWeight: FontWeight.bold,
                    ),
                  )

                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: TabBar(
                labelStyle: const TextStyle(fontSize: xTextSize16),
                controller: _tabController,
                tabs: _tagtitle.map((e) => Tab(text: e)).toList(),
                onTap: (index) => _changeTab(index),
                labelColor: Colors.black,
                indicatorColor: Colors.transparent,
              ),
            ),

            SizedBox(
              height: 350,
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChange,
                physics: const BouncingScrollPhysics(),
                children: [
                  
                  LoginScreen(popBack: widget.popBack, emailVerifed: widget.emailVerifed,),

                  const RegisterScreen()

                ],
              ),
            ),

            Padding(
               padding: const EdgeInsets.only(bottom: 0),
               child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Container(
                    height: 42,
                    width: 42,
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: const Color(cGrey),
                      borderRadius: BorderRadius.circular(99)
                    ),
                    child: GestureDetector(
                      onTap: () => _googleLogin(),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(999)
                        ),
                        child: const Image(
                          image: AssetImage('assets/icon/ic_google.png'),
                          color: Colors.white,
                        ),
                      ),
                    )
                  ),

                  Container(
                    height: 42,
                    width: 42,
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: const Color(cGrey),
                      borderRadius: BorderRadius.circular(99)
                    ),
                    child: GestureDetector(
                      onTap: () => _facebookLogin(),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(999)
                        ),
                        child: const Image(
                          image: AssetImage('assets/icon/ic_facebook.png'),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  // Container(
                  //   height: 42,
                  //   width: 42,
                  //   margin: const EdgeInsets.only(left: 10, right: 10),
                  //   decoration: BoxDecoration(
                  //     color: const Color(cGrey),
                  //     borderRadius: BorderRadius.circular(99)
                  //   ),
                  //   child: GestureDetector(
                  //     onTap: (){},
                  //     child: const Image(
                  //       image: AssetImage('assets/icon/ic_apple.jpg')
                  //     ),
                  //   ),
                  // ),

                ],
              ),
             )
            
          ],
        ),
      ),
    );
  }
}
