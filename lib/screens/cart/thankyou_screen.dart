
import 'package:alternate_store/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          children: [
            const Icon(null),
            const Expanded(
              child: Text('')
            ),
            IconButton(
              onPressed: () => Navigator.pop(context), 
              icon: const Icon(Icons.close)
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: const [

            Text(
              'THANK YOU',
              style: TextStyle(fontSize: xTextSize22, color: Colors.grey, fontWeight: FontWeight.bold),
            ),

            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Icon(Icons.done, size: 80, color: Color(cPrimaryColor),),
            ),

            Text(
              '我們已收到您的訂單 \n 請耐心等侯，我們會盡快將貨品送到你手上。 \n 你隨時可以到訂單紀錄查看您的訂單。',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            )

          ],
        ),
      ),
    );
  }
}