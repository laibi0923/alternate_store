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
import 'package:alternate_store/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckOut extends StatefulWidget {
  final OrderModel? orderModel;
  const CheckOut({Key? key, this.orderModel}) : super(key: key);

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {

  final TextEditingController _userRecipientEditingControlle = TextEditingController();
  final TextEditingController _phoneEditingControlle = TextEditingController();
  final TextEditingController _unitEditingControlle = TextEditingController();
  final TextEditingController _estateEditingControlle = TextEditingController();
  final TextEditingController _districtEditingControlle = TextEditingController();

  @override
  void initState() {
    super.initState();

    final _userModel = Provider.of<UserModel>(context, listen: false);
    _phoneEditingControlle.text = _userModel.contactNo;
    _userRecipientEditingControlle.text = _userModel.recipientName;
    _unitEditingControlle.text = _userModel.unitAndBuilding;
    _estateEditingControlle.text = _userModel.estate;
    _districtEditingControlle.text = _userModel.district;

    final checkoutViewModel = Provider.of<CheckoutViewModel>(context, listen: false);
    checkoutViewModel.initData();
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
              _checkoutDetails()
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
                    checkoutViewModel.setSFLockerLocation(result);
                    // setState(() {
                    //   sfLockerLocation = result;
                    // });
                  }

                },
                child: checkoutViewModel.getSFLockerLocation().isEmpty ? 
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
                      checkoutViewModel.getSFLockerLocation()['code'].toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(height: 5,),
                    Text(
                      checkoutViewModel.getSFLockerLocation()['location'].toString()
                    ),
                    Container(height: 10,),
                    Text(
                      checkoutViewModel.getSFLockerLocation()['openingHour'].toString()
                    ),
                  ],
                ),
              ),
            )
          ),

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

  Widget _checkoutDetails(){

    final checkoutViewModel = Provider.of<CheckoutViewModel>(context);
    final _userModel = Provider.of<UserModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

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
              checkoutViewModel.newMakePayment(
                context, 
                _userModel,
                widget.orderModel!,
                _userRecipientEditingControlle.text, 
                _phoneEditingControlle.text, 
                _unitEditingControlle.text, 
                _estateEditingControlle.text, 
                _districtEditingControlle.text
              );

            },
            child: const Text('輸入信用卡付款')
          ),
        ),

        Container(height: 30)
      ],
    );
  }

} 
