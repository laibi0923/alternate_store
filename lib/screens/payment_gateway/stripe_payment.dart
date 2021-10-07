import 'package:alternate_store/constants.dart';
import 'package:alternate_store/screens/payment_gateway/stripe_cardfrom.dart';
import 'package:alternate_store/widgets/set_cachednetworkimage.dart';
import 'package:flutter/material.dart';
import 'package:stripe_sdk/stripe_sdk_ui.dart';

class StripePayment extends StatefulWidget {
  const StripePayment({ Key? key }) : super(key: key);

  @override
  _StripePaymentState createState() => _StripePaymentState();
}

class _StripePaymentState extends State<StripePayment> {

  final formKey = GlobalKey<FormState>();
  final card = StripeCard();

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [

          _buildFrontCard(context),

          // _buildBackCard(context),

          _buildCardIcon(),

          _buildTextFlied(
            '信用卡號碼', 
            Icons.credit_card,
            TextInputType.number
          ),
          
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: _buildTextFlied(
                  'MM/YY', 
                  Icons.today,
                  TextInputType.number
                )
              ),
              Container(width: 10,),
              Expanded(
                child: _buildTextFlied(
                  'CVC', 
                  Icons.lock_open,
                  TextInputType.number
                )
              ),
            ],
          ),

          _buildTextFlied(
            '持卡人名字', 
            Icons.person,
            TextInputType.text
          ),

        ],
      ),
    );
    // return CustomizeCardForm(
    //   card: card,
    //   formKey: formKey,
    //   displayAnimatedCard: true,
    //   cardNumberDecoration: inputdecoration('信用卡號碼', Icons.credit_card),
    //   cardExpiryDecoration: inputdecoration('MM/YY', Icons.calendar_today),
    //   cardCvcDecoration: inputdecoration('CVC', Icons.lock_open),
    //   postalCodeDecoration: inputdecoration('持卡人名字', Icons.person),
    // );
  }
}

Widget _buildFrontCard(BuildContext context){
  return Container(
    height: 230,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      color: const Color(0xff212121),
      borderRadius: BorderRadius.circular(10),
      boxShadow: const [
        BoxShadow(
          color: Colors.black,
          blurRadius:12.0,
          spreadRadius: 0.2,
          offset: Offset(3.0, 3.0)
        )
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  const [

              Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.sensors, 
                  size: 40,
                  color: Colors.white,
                )
              ),

              Spacer(),

              Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Text(
                  '0000 0000 0000 0000',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: xTextSize22,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  'EXP. Date  MM/YY',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: xTextSize16,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),

              Text(
                'Card Holder',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: xTextSize16,
                  fontWeight: FontWeight.bold
                ),
              )

            ],
          ),
          const Positioned(
            bottom: 0,
            right: 0,
            child: Icon(
              Icons.ac_unit_outlined, 
              color: Colors.white,
              size: 40,
            ),
          )
        ],
      ),
    )
  );
}

Widget _buildBackCard(BuildContext context){
  return Container(
    height: 230,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      color: const Color(0xffffffff),
      borderRadius: BorderRadius.circular(10),
      boxShadow: const [
        BoxShadow(
          color: Colors.black,
          blurRadius:12.0,
          spreadRadius: 0.2,
          offset: Offset(3.0, 3.0)
        )
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
          
          Container(
            height: 50,
            margin: const EdgeInsets.only(top: 5, bottom: 25),
            color: Colors.black,
          ),
          
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  color: Colors.grey,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  'CVC',
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
              )
            ],
          ),

        ],
      ),
    )
  );
}

Widget _buildCardIcon(){
  return Row(
    children: [
      Container(
        height: 50,
        margin: const EdgeInsets.only(top: 16),
        child: setCachedNetworkImage(
          'https://logodix.com/logo/797210.png',
          BoxFit.cover
        ),
      )
    ],
  );
}

Widget _buildTextFlied(String hintText, IconData suffixIcon, TextInputType textInputType){
  return Container(
    margin: const EdgeInsets.only(top: 16),
    child: TextFormField(
      keyboardType: textInputType,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        suffixIcon: Container(
          height: 20,
          width: 20,
          padding: const EdgeInsets.only(right: 10.0),
          child: Icon(
            suffixIcon, 
            color: Colors.grey,
            size: 15,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
      ),
    ),
  );
}
