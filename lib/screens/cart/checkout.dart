// ignore_for_file: import_of_legacy_library_into_null_safe
import 'dart:convert';
import 'dart:ui';

import 'package:alternate_store/widgets/custom_snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:alternate_store/constants.dart';
import 'package:alternate_store/model/order_model.dart';
import 'package:alternate_store/model/paymentmethod_model.dart';
import 'package:alternate_store/model/user_model.dart';
import 'package:alternate_store/screens/cart/shipping.dart';
import 'package:alternate_store/screens/payment_gateway/stripe_cardform.dart';
import 'package:alternate_store/viewmodel/checkout_viewmodel.dart';
import 'package:alternate_store/widgets/set_cachednetworkimage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class CheckOut extends StatefulWidget {
  final OrderModel? orderModel;
  const CheckOut({Key? key, this.orderModel}) : super(key: key);

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {

  int _initTagIndex = 0;
  Map<String, dynamic>? paymentIntentData;
  late CardDetails _card = CardDetails();
  String kApiUrl = 'https://api.stripe.com/v1/payment_intents';
  
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardExpDateController = TextEditingController();
  final TextEditingController _cardCVCController = TextEditingController();
  final TextEditingController _cardHolderNameController = TextEditingController();

  Future<void> makePayment() async {

    const url = 'https://us-central1-alternate-store.cloudfunctions.net/stripePayment';

    String amount = (widget.orderModel!.totalAmount * 100).toInt().toString();

    final http.Response response = await http.post(
      Uri.parse('$url?amount=$amount&currency=HKD')
    );

    paymentIntentData = json.decode(response.body);
    
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentData!['paymentIntent'],
        applePay: true,
        googlePay: true,
        style: ThemeMode.light,
        merchantCountryCode: 'HK',
        merchantDisplayName: 'XXXXX',
      )
    );
    setState(() {});
    displayPaymentSheet();
  }

  Future<void> displayPaymentSheet() async {
    try{
      await Stripe.instance.presentPaymentSheet(
        parameters: PresentPaymentSheetParameters(
          clientSecret: paymentIntentData!['paymentIntent'],
          confirmPayment: true
        )
      );
      setState(() {
        paymentIntentData = null;
      });
    }catch (e){
      print(e.toString());
    }
  }







  // Future<void> makePayment() async {
  //   try{

  //     paymentIntentData = await createPaymentIntent(
  //       widget.orderModel!.totalAmount, 
  //       'hkd'
  //     );

  //     await Stripe.instance.initPaymentSheet(
  //       paymentSheetParameters: SetupPaymentSheetParameters(
  //         paymentIntentClientSecret: paymentIntentData!['client_secret'],
  //         applePay: true,
  //         googlePay: true,
  //         testEnv: true,
  //         style: ThemeMode.light,
  //         merchantCountryCode: 'HK',
  //         merchantDisplayName: 'Test'
  //       )
  //     );

  //     displayPaymentSheet();

  //   } catch (e){
  //     print('exception: ' + e.toString());
  //   }

  // }

  // displayPaymentSheet() async {
  //   try{
  //     await Stripe.instance.presentPaymentSheet(
  //       // ignore: deprecated_member_use
  //       // parameters: PresentPaymentSheetParameters(
  //       //   clientSecret: paymentIntentData!['client_secret'],
  //       //   confirmPayment: true
  //       // )
  //     );
  //     setState(() {
  //       paymentIntentData = null;
  //     });

  //     CustomSnackBar().show(context, 'Payment Successfully');
  //   } on StripeException catch (e) {
  //     print(e.toString());
  //   }
  // }

  // createPaymentIntent(double amount, String currency) async {
  //   try{

  //     Map<String, dynamic> body = {
  //       'amount': calculateAmount(amount),
  //       'currency': currency,
  //       'payment_method_types[]': 'card'
  //     };

  //     var response = await http.post(
  //       Uri.parse('https://api.stripe.com/v1/payment_intents'),
  //       body: body,
  //       headers: {
  //         'Authorization' : 'Bearer sk_test_51JiJNYDvGyhPlIEQAjJUE013gILIUanUKN1aqaKsNfrKlN9ihXnsZ9mAgk7qe1xURTanDKlbqFl5AV9ZYpz2cenG00O2FrLD67',
  //         'Content-Type': 'application/x-www-form-urlencoded '
  //       }
  //     );
  //     print(jsonDecode(response.body.toString()));
  //     return jsonDecode(response.body.toString());

  //   } catch (e){
  //     print('exception: ' + e.toString());
  //   }
  // }

  // calculateAmount(double amount){
  //   final price = (amount * 100).toInt().toString();
  //   return price.toString();
  // }
  

  @override
  Widget build(BuildContext context) {

    // _card.copyWith(number: '4242 4242 4242 4242');
    // _card.copyWith(expirationMonth: 05);
    // _card.copyWith(expirationYear: 24);
    // _card.copyWith(cvc: '717');

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [

          ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [

              _buildShippingInformation(),

              //  Title
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(
                      '付款資料',
                      style: TextStyle(
                        fontSize: xTextSize26, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      '  (信用卡 / 借記卡)',
                      style: TextStyle(
                    fontSize: xTextSize18, 
                  ),
                    )
                  ],
                ),
              ),

              _buildCardIcon(),

              // CardField(
              //   numberHintText: '0000 xxxx pppp bbbb',
              // ),

              //  Total payment amount
              Padding(
                padding: const EdgeInsets.only(bottom: 20, top: 20),
                child: Text(
                '付款總額\nHKD\$ ${widget.orderModel?.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: xTextSize18, 
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center
                ),
              ),

              _buildCustomCardForm(),

              // CardField(),

              // const StripeCardForm(),
              // _buildPaymentMehtod(),

              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: ElevatedButton(
                  onPressed: (){
                    makePayment();
                    // _handlePayPress();
                  }, 
                  child: Text('testing payment button')
                ),
              )

              // Padding(
              //   padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100),
              //   child: customizeButton('提交訂單', startPayment()),
              // )
            ],
          ),

          //  關閉按鈕
          Positioned(
            top: 60,
            right: 30,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(99)),
              child: const Icon(Icons.close)),
            )
          ),

        ],
      ),
    );
  }
  
  Widget _buildCardIcon(){
    return Row(
      children: [
        Container(
          height: 50,
          margin: const EdgeInsets.only(top: 0, left: 20),
          child: setCachedNetworkImage(
            'https://logodix.com/logo/797210.png',
            BoxFit.cover
          ),
        )
      ],
    );
  }

  Widget _buildShippingInformation() {

    final _userInfo = Provider.of<UserModel>(context);

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 40, bottom: 20),
            child: Text(
              '運送地址',
              style: TextStyle(fontSize: xTextSize26, fontWeight: FontWeight.bold),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Shipping())),
            child: Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
              decoration: BoxDecoration(
                color: const Color(cGrey),
                borderRadius: BorderRadius.circular(7)
              ),
              // ignore: unnecessary_null_comparison
              child: _userInfo == null ?
              const Text('') :
              _userInfo.unitAndBuilding.isEmpty &&
              _userInfo.estate.isEmpty &&
              _userInfo.district.isEmpty ?
              const Center(
                child: Text('\n點擊設定運送地址 \n')
              ) :
              Text(
                '${_userInfo.recipientName} \n${_userInfo.unitAndBuilding} \n${_userInfo.estate} ${_userInfo.district}',
                style: const TextStyle(height: 1.5),
              ),
            ),
          ),
          Row(
            children: const [
              Expanded(
                child: Text('預計送貨時間約 7-11 天')
              ),
              Text('修改地址'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMehtod() {
    
    final _userInfo = Provider.of<UserModel>(context);
    final _paymentMethodList = Provider.of<List<PaymentMethodModel>>(context);
    final _checkoutviewmodel = Provider.of<CheckoutViewModel>(context);

    return _paymentMethodList == null || _paymentMethodList.isEmpty ? Container() :
    Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        //  Title
        const Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 30),
          child: Text(
            '支付方式',
            style:
                TextStyle(fontSize: xTextSize26, fontWeight: FontWeight.bold),
          ),
        ),

        //  Payment Method ListView
        Container(
          height: 30,
          margin: const EdgeInsets.only(bottom: 20),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: _paymentMethodList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                child: Container(
                  margin: const EdgeInsets.only(left: 20),
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                      color: _initTagIndex == index
                          ? const Color(cPrimaryColor)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(
                          color: const Color(cPrimaryColor), width: 1)),
                  child: Center(
                    child: Text(
                      _paymentMethodList[index].methodName,
                      style: index == _initTagIndex
                          ? const TextStyle(color: Colors.white)
                          : const TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    _initTagIndex = index;
                  });
                },
              );
            }
          ),
        ),

        //  QR Code
        GestureDetector(
          onTap: () {
            _checkoutviewmodel.downloadQRCode(_paymentMethodList[_initTagIndex]);
          },
          child: SizedBox(
            height: 250,
            child: setCachedNetworkImage(_paymentMethodList[_initTagIndex].qrImage, BoxFit.contain),
          ),
        ),

        //  Holder Name
        Center(
          child: Text(
          _paymentMethodList[_initTagIndex].holder,
          style: const TextStyle(
            fontSize: xTextSize18, 
            fontWeight: FontWeight.bold
          ),
        )),

        //  Total payment amount
        Center(
            child: Text(
          'HKD\$ ${widget.orderModel?.totalAmount.toStringAsFixed(2)}',
          style: const TextStyle(
              fontSize: xTextSize18, fontWeight: FontWeight.bold),
        )),

        //  Remark
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 40, right: 40),
          child: Center(
              child: Text(
            _paymentMethodList[_initTagIndex].remark,
            style: const TextStyle(
              fontSize: xTextSize14,
            ),
          )),
        ),

        //Image.file(),

        //  Upload Payment receipt and take order button
        Padding(
            padding: const EdgeInsets.only(
                top: 40, bottom: 100, left: 30, right: 30),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color(cPrimaryColor),
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
              ),
              onPressed: () {
                _checkoutviewmodel.uploadpaymentButtonOnClick(
                  context, 
                  _userInfo, 
                  widget.orderModel, 
                  _paymentMethodList[_initTagIndex].methodName
                );
              },
              child: const Text(
                '上載已支付証明',
              ),
            )),

        // Padding(
        //   padding: const EdgeInsets.only(top: 40, bottom: 100, left: 30, right: 30),
        //   child :ElevatedButton(
        //     style: ElevatedButton.styleFrom(
        //       primary: const Color(cPrimaryColor),
        //       elevation: 0,
        //       shape: const RoundedRectangleBorder(
        //         borderRadius: BorderRadius.all(Radius.circular(18)),
        //       ),
        //     ),
        //     onPressed: () => _imagepick(),
        //     child: const Text(
        //       'x',
        //     ),
        //   )
        // )
      ],
    );
  }

  Widget _buildCustomCardForm(){
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [

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
                  // onFocusChange: (hasfocus) => _stripeViewModel.cvcOnFocus(hasfocus),
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
