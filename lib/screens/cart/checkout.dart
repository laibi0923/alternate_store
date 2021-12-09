import 'dart:ui';
// ignore: import_of_legacy_library_into_null_safe
import 'package:alternate_store/model/order_model.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:alternate_store/model/user_model.dart';
import 'package:alternate_store/screens/cart/sf_lockerlocation.dart';
import 'package:alternate_store/viewmodel/checkout_viewmodel.dart';
import 'package:alternate_store/widgets/currency_textview.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:alternate_store/widgets/customize_phonetextfield.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:alternate_store/widgets/customize_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alternate_store/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckOut extends StatefulWidget {
  final UserModel? userModel;
  final OrderModel? orderModel;
  const CheckOut({Key? key, this.orderModel, this.userModel}) : super(key: key);

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {

  final TextEditingController _userRecipientEditingControlle = TextEditingController();
  final TextEditingController _phoneEditingControlle = TextEditingController();
  final TextEditingController _unitEditingControlle = TextEditingController();
  final TextEditingController _estateEditingControlle = TextEditingController();
  final TextEditingController _districtEditingControlle = TextEditingController();
  Map<String, String> sfLockerLocation = {};

  @override
  void initState() {
    super.initState();
    _phoneEditingControlle.text = widget.userModel!.contactNo;
    _userRecipientEditingControlle.text = widget.userModel!.recipientName;
    _unitEditingControlle.text = widget.userModel!.unitAndBuilding;
    _estateEditingControlle.text = widget.userModel!.estate;
    _districtEditingControlle.text = widget.userModel!.district;
  }

  @override
  void dispose() {
    _userRecipientEditingControlle.dispose();
    _phoneEditingControlle.dispose();
    _unitEditingControlle.dispose();
    _estateEditingControlle.dispose();
    _districtEditingControlle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [

          Column(
            children: [

              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 80, left: 20, right: 20),
                  children: [

                    const Text(
                      '收件人資料',
                      style: TextStyle(fontSize: xTextSize26, fontWeight: FontWeight.bold),
                    ),

                    CustomizeTextField(
                      title: '收件人名稱',
                      maxLine: 1,
                      mTextEditingController: _userRecipientEditingControlle,
                    ),
                    CustomizePhoneTextField(
                      title: '聯絡電話',
                      isPassword: false,
                      mTextEditingController: _phoneEditingControlle,
                    ),

                    Container(height: 20,),

                    const Text(
                      '運送地址',
                      style: TextStyle(fontSize: xTextSize26, fontWeight: FontWeight.bold),
                    ),

                    Container(height: 20,),

                    _expansionPanelList(),

                  ],
                ),
              ),

              _checkoutDetails(widget.userModel!)
            ],
          ),

          //  關閉按鈕
          Positioned(
            top: 60,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(99)
              ),
              child: const Icon(Icons.close)),
            )
          ),

          //  Loading Screen
          _showLoadingScreen()

        ],
      ),
    );
  }

  

  Widget _showLoadingScreen(){

    final checkoutViewModel = Provider.of<CheckoutViewModel>(context);

    return checkoutViewModel.showloadingscreen ?
    Container(
      color: const Color(0x90000000),
      child: const Center(
        child: CircularProgressIndicator(
          color: Color(cPrimaryColor),
        )
      ),
    ) : 
    Container();
  }

  Widget _checkoutDetails(UserModel userInfo){

    final checkoutViewModel = Provider.of<CheckoutViewModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        //  Total payment amount
        const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Center(
            child: Text(
              '付款總額',
              style: TextStyle(
                fontSize: xTextSize18, 
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Center(
            child: CurrencyTextView(
              value: widget.orderModel!.totalAmount, 
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              // textAlign: TextAlign.center
            ),
          )
        ),

        // Center(
        //   child: SizedBox(
        //     height: 50,
        //     child: setCachedNetworkImage(
        //       'https://logodix.com/logo/797210.png',
        //       BoxFit.cover
        //     ),
        //   ),
        // ),
        
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: const Color(cPrimaryColor),
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
            ),
            onPressed: () {
              UserModel usermodel = UserModel(
                Timestamp.now(),
                userInfo.uid,
                userInfo.email,
                userInfo.name, 
                _phoneEditingControlle.text, 
                _unitEditingControlle.text, 
                _estateEditingControlle.text, 
                _districtEditingControlle.text, 
                '', 
                _userRecipientEditingControlle.text
              );
              checkoutViewModel.makePayment(
                context,
                widget.orderModel!,
                usermodel
              );
            },
            child: const Text('輸入信用卡付款')
          ),
        ),

        Container(height: 30)
      ],
    );
  }

  Widget _expansionPanelList(){

    final checkoutViewModel = Provider.of<CheckoutViewModel>(context);

    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 0),
      child: ExpansionPanelList(
        elevation: 0,
        expandedHeaderPadding: const EdgeInsets.all(0),
        expansionCallback: (i, isOpen) => checkoutViewModel.expansionPanelListToggler(i, isOpen),
        children: [

          ExpansionPanel(
            canTapOnHeader: true,
            isExpanded: checkoutViewModel.expansionPanelOpenStatus[0],
            headerBuilder: (context, isOpen){
              return const Align(
                alignment: Alignment.centerLeft,
                child: Text('順豐智能櫃')
              );
            },
            body: Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () async {
                  var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const SFLockerLocation()));
                  
                  if(result.isNotEmpty){
                    setState(() {
                      sfLockerLocation = result;
                    });
                  }

                },
                child: sfLockerLocation.isEmpty ? 
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Center(
                    child: Text('點擊選擇地點')
                  ),
                ) : 
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sfLockerLocation['code'].toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(height: 5,),
                    Text(
                      sfLockerLocation['location'].toString()
                    ),
                    Container(height: 10,),
                    Text(
                      sfLockerLocation['openingHour'].toString()
                    ),
                  ],
                ),
              ),
            )
          ),

          // ExpansionPanel(
          //   canTapOnHeader: true,
          //   isExpanded: _isOpen[1],
          //   headerBuilder: (context, isOpen){
          //     return const Align(
          //       alignment: Alignment.centerLeft,
          //       child: Text('7-ELEVEN 交貨便')
          //     );
          //   },
          //   body: Align(
          //     alignment: Alignment.topLeft,
          //     child: Column(
          //       children: const [
          //         Text('Test content 1'),
          //         Text('Test content 1'),
          //         Text('Test content 1'),
          //       ],
          //     ),
          //   )
          // ),

          ExpansionPanel(
            canTapOnHeader: true,
            isExpanded: checkoutViewModel.expansionPanelOpenStatus[1],
            headerBuilder: (context, isOpen){
              return const Align(
                alignment: Alignment.centerLeft,
                child: Text('送貨至...')
              );
            },
            body: _buildAddressFrom()
          ),
          
        ],
      ),
    );
  }

  Widget _buildAddressFrom(){
    return Column(
      children: [
        CustomizeTextField(
          title: '室 / 樓層',
          maxLine: 1,
          mTextEditingController: _unitEditingControlle,
        ),
        CustomizeTextField(
          title: "大廈名稱",
          maxLine: 1,
          mTextEditingController: _estateEditingControlle,
        ),
        CustomizeTextField(
          title:'屋苑名稱 / 地區',
          maxLine: 1,
          mTextEditingController: _districtEditingControlle,
        ),
        _saveAddressButton(),
        Container(height: 50)
      ],
    );
  }

  Widget _saveAddressButton(){
    return Consumer<CheckoutViewModel>(
      builder: (context, checkoutViewModel, child) {
        return GestureDetector(
          onTap: () => checkoutViewModel.saveShippingAddress(),
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: checkoutViewModel.shippingAddressStatus ?
                  const Icon(
                    Icons.radio_button_checked,
                    color: Color(cPrimaryColor)
                  ) : 
                  const Icon(
                    Icons.radio_button_unchecked,
                    color: Color(cPrimaryColor),                  
                  ),
                ),
                const Text('保存運送地址')
              ],
            ),
          ),
        );
      }
    );
  }

}
