import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alternate_store/constants.dart';
import 'package:alternate_store/model/privatepolicy_model.dart';

class PrivatePolicy extends StatelessWidget {
  const PrivatePolicy({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final privatepolicyModel = Provider.of<PrivatePolicyModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [

          // ignore: unnecessary_null_comparison
          privatepolicyModel == null ? Container() :
          ListView(
            physics: const BouncingScrollPhysics(),
            children: [

              const Padding(
                padding: EdgeInsets.only(top: 40, bottom: 40),
                child: Center(
                  child: Text(
                    '隱私政策',
                    style: TextStyle(fontSize: xTextSize18, fontWeight: FontWeight.bold),
                  )
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '上次修改時間 : ${DateFormat('yyyy年MM月dd日').format(
                        DateTime.fromMicrosecondsSinceEpoch(privatepolicyModel.lastModify.microsecondsSinceEpoch)
                      )}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        privatepolicyModel.content
                      ),
                    )
                  ],
                ),
              ),


            ],
          ),
        
          Positioned(
            top:55,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999)
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context), 
                icon: const Icon(Icons.close)
              ),
            ),
          )
        
        ],
      ),
    );
  }
}