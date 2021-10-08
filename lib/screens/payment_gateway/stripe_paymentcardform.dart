import 'dart:math';

import 'package:alternate_store/constants.dart';
import 'package:alternate_store/screens/payment_gateway/stripe_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class StripePaymentCardForm extends StatefulWidget {
  const StripePaymentCardForm({ Key? key }) : super(key: key);

  @override
  _StripePaymentCardFormState createState() => _StripePaymentCardFormState();
}

class _StripePaymentCardFormState extends State<StripePaymentCardForm> with SingleTickerProviderStateMixin {

  final formKey = GlobalKey<FormState>();

  late final AnimationController _animationController;

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardExpDateController = TextEditingController();
  final TextEditingController _cardCVCController = TextEditingController();
  final TextEditingController _cardHolderNameController = TextEditingController();

  late StripeViewModel _stripeViewModel;

  @override
  void initState() {

    //  初始化 AnimationController; 需 SingleTickerProviderStateMixin
    _animationController = AnimationController(
      vsync: this, 
      duration: const Duration(milliseconds: 1000)
    );

    _stripeViewModel = StripeViewModel(_animationController);
    
    super.initState();

  }

  @override
  void dispose() {

    _animationController.dispose();

    _cardNumberController.dispose();
    _cardExpDateController.dispose();
    _cardCVCController.dispose();
    _cardHolderNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [

          Center(
            child: SizedBox(
              height: 250,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  CreditCardAnimatedBudiler(
                    animation: _stripeViewModel.moveToBack(),
                    child: CardFontSide(
                      cardNumberController: _cardNumberController,
                      cardExpDateController: _cardExpDateController,
                      cardCVCController: _cardCVCController,
                      cardHolderNameController: _cardHolderNameController,
                    )
                  ),
                  CreditCardAnimatedBudiler(
                    animation: _stripeViewModel.moveToFront(), 
                    child: CardBackSide(
                      cardCVCController: _cardCVCController,
                    )
                  )
                ],
              ),
            ),
          ),

          // _buildCardIcon(),

          CardInputTextFlied(
            // maxLength: 19,
            hintText: '信用卡號碼',
            suffixIcon: Icons.credit_card,
            textInputType: TextInputType.number,
            textEditingController: _cardNumberController,
            maskTextInputFormatter: MaskTextInputFormatter(
              mask: '#### #### #### ####', 
              filter: { "#": RegExp(r'[0-9]') }
            ),
          ),
          
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [

              Expanded(
                child: CardInputTextFlied(
                  // maxLength: 5,
                  hintText: 'MM/YY', 
                  suffixIcon: Icons.today,
                  textInputType: TextInputType.number,
                  textEditingController: _cardExpDateController,
                  maskTextInputFormatter: MaskTextInputFormatter(
                    mask: '##/##', 
                    filter: { "#": RegExp(r'[0-9]') }
                  ),
                )
              ),
              
              Container(width: 10,),

              Expanded(
                child: Focus(
                  onFocusChange: (hasfocus) => _stripeViewModel.cvcOnFocus(hasfocus),
                  child: CardInputTextFlied(
                    // maxLength: 3,
                    hintText: 'CVC',
                    suffixIcon: Icons.lock_open,
                    textInputType: TextInputType.number,
                    textEditingController: _cardCVCController,
                    maskTextInputFormatter: MaskTextInputFormatter(
                      mask: '###', 
                      filter: { "#": RegExp(r'[0-9]') }
                    ),
                  ),
                )
              ),

            ],
          ),

          CardInputTextFlied(
            // maxLength: 30,
            hintText: '持卡人名字', 
            suffixIcon: Icons.person,
            textInputType: TextInputType.text,
            textEditingController: _cardHolderNameController,
             maskTextInputFormatter: MaskTextInputFormatter(
              mask: '###########################', 
              filter: { "#": RegExp(r'[a-zA-Z0-9 .!,-]') }
            ),
          ),

        ],
      ),
    );

  }
}


class CardFontSide extends StatelessWidget {

  final TextEditingController cardNumberController;
  final TextEditingController cardExpDateController;
  final TextEditingController cardCVCController;
  final TextEditingController cardHolderNameController;

  const CardFontSide({
    Key? key, 
    required this.cardNumberController, 
    required this.cardExpDateController, 
    required this.cardCVCController, 
    required this.cardHolderNameController
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 200,
      // width: 300,
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
              children: [

                const Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.sensors, 
                    size: 40,
                    color: Colors.white,
                  )
                ),

                const Spacer(),

                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextField(
                    enabled: false,
                    controller: cardNumberController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      isDense: true,
                      border: InputBorder.none,
                      hintText: '0000 0000 0000 0000',
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: xTextSize22,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: xTextSize22,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      const Text(
                        'EXP Date  ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: xTextSize16,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          enabled: false,
                          controller: cardExpDateController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(0),
                            isDense: true,
                            border: InputBorder.none,
                            hintText: 'MM/YY',
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: xTextSize16,
                              fontWeight: FontWeight.bold
                            )
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: xTextSize16,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  )
                ),

                TextField(
                  enabled: false,
                  controller: cardHolderNameController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    isDense: true,
                    border: InputBorder.none,
                    hintText: 'Card Holder',
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: xTextSize16,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: xTextSize16,
                    fontWeight: FontWeight.bold
                  ),
                ),
               
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
}


class CardBackSide extends StatelessWidget {
  final TextEditingController cardCVCController;
  const CardBackSide({ Key? key, required this.cardCVCController }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 200,
      // width: 300,
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
                Container(
                  height: 50,
                  width: 100,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Center(
                    child: TextField(
                      enabled: false,
                      controller: cardCVCController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        isDense: true,
                        border: InputBorder.none,
                        hintText: 'CVC',
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: xTextSize16,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: xTextSize16,
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
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
}


class CardInputTextFlied extends StatelessWidget {
  final TextInputType? textInputType;
  // final int? maxLength;
  final TextEditingController? textEditingController;
  final String? hintText;
  final IconData? suffixIcon;
  final MaskTextInputFormatter? maskTextInputFormatter;

  const CardInputTextFlied({ 
    Key? key, 
    this.textInputType, 
    // this.maxLength, 
    this.textEditingController, 
    this.hintText, 
    this.suffixIcon, 
    this.maskTextInputFormatter 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
    margin: const EdgeInsets.only(top: 16),
      child: TextFormField(
        keyboardType: textInputType,
        controller: textEditingController,
        // maxLength: maxLength,
        inputFormatters: [maskTextInputFormatter!],
        decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          counterText: '',
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
        onChanged: (value){
          print(value);
        },
      ),
    );
  }
}


class CreditCardAnimatedBudiler extends StatelessWidget {
  final Animation<double>? animation;
  final Widget child;

  const CreditCardAnimatedBudiler({Key? key, this.animation, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation!,
      builder: (BuildContext context, Widget? child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(animation!.value),
          alignment: Alignment.center,
          child: this.child,
        );
      },
    );
  }
}
