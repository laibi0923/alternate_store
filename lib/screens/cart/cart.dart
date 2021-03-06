// ignore_for_file: import_of_legacy_library_into_null_safe
import 'package:alternate_store/constants.dart';
import 'package:alternate_store/model/coupon_model.dart';
import 'package:alternate_store/model/product_model.dart';
import 'package:alternate_store/model/user_model.dart';
import 'package:alternate_store/model/usercoupon_model.dart';
import 'package:alternate_store/service/auth_services.dart';
import 'package:alternate_store/viewmodel/cart_viewmodel.dart';
import 'package:alternate_store/widgets/cart/cart_itemview.dart';
import 'package:alternate_store/widgets/cart/cart_summary_itemview.dart';
import 'package:alternate_store/widgets/cart/empty_cart_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class Cart extends StatefulWidget {

  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {

  TextEditingController couponTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final productlist = Provider.of<List<ProductModel>>(context, listen: false);
    Provider.of<CartViewModel>(context, listen: false).setCatList(productlist);
  }

  @override
  void dispose() {
    super.dispose();
    couponTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final _cartViewModel = Provider.of<CartViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: const [
            Expanded(
              child: Center(
                child: Text('購物車')
              )
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: _cartViewModel.getCartList.isEmpty ? Container() : _buildCouponButton()
        ),
      ),
      body: _cartViewModel.getCartList.isEmpty ? 
      emptyCartScreen() : 
      Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _cartViewModel.getCartList.length + 1,
                itemBuilder: (BuildContext context, int index){

                  if(index == _cartViewModel.getCartList.length){
                    return _buildSummary();
                  } else {
                    return _buildItemView(index);
                  }

                }
              )
            ),

            //  結帳按鈕
            _cartViewModel.getCartList.isEmpty ? Container() : _buildCheckbillButton()
  
          ],
        ),
      )
    );
  
  }

  Widget _buildSummary(){

    final _cartViewModel = Provider.of<CartViewModel>(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        children: [

          CartSummaryItemView(
            title: '小計', 
            value: 'HKD\$ ' + _cartViewModel.subAmount.toStringAsFixed(2),
            isbold: false,
            showAddBox: false,
          ),

          CartSummaryItemView(
            title: _cartViewModel.discountCode.isEmpty ? '折扣' : '折扣代碼【${_cartViewModel.discountCode}】', 
            value: '-HKD\$ ' + _cartViewModel.discountAmount.toStringAsFixed(2),
            isbold: false,
            showAddBox: false,
          ),

          CartSummaryItemView(
            title: '運費', 
            value: 'HKD\$ ' + _cartViewModel.shippingFree.toStringAsFixed(2),
            isbold: false,
            showAddBox: false,
          ),

          CartSummaryItemView(
            title: '總計', 
            value: 'HKD\$ ' + _cartViewModel.totalAmount.toStringAsFixed(2),
            isbold: true,
            showAddBox: false,
          ),

        ],
      ),
    ); 
  }

  Widget _buildItemView(int index){

    final _cartViewModel = Provider.of<CartViewModel>(context);

    return Slidable(
      key: Key(_cartViewModel.getCartList[index].productNo),
      controller: _cartViewModel.slidableController,
      actionPane: const SlidableScrollActionPane(),
      secondaryActions: [
        GestureDetector(
          onTap: () => _cartViewModel.removeCartItem(index),
          child: Container(
            color: const Color(cPink),
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.delete, color: Colors.white),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      '刪除', 
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            )
          ),
        ),
      ],
      child: Builder(builder: (context){
        return GestureDetector(
          onTap: (){
            final slidable = Slidable.of(context);
            if(slidable != null){
              final isClose = slidable.renderingMode == SlidableRenderingMode.none;
              if(isClose){
                slidable.open(actionType: SlideActionType.secondary);
              } else {
                slidable.close();
              }
            }
          },
          child: cartItemView(
            _cartViewModel.getSharedPerferencesCartList[index], 
            _cartViewModel.getCartList[index]
          )
        );
      })
    );
  }

  Widget _buildCouponButton(){

    final _authService = Provider.of<AuthService>(context);
    final _couponModel = Provider.of<List<CouponModel>>(context);
    final _userCouponList = Provider.of<List<UserCouponModel>>(context);
    final _cartViewModel = Provider.of<CartViewModel>(context);


    return InkWell(
      splashColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(cGrey),
          borderRadius: BorderRadius.circular(7)
        ),
        margin: const EdgeInsets.only(left: 15, right: 15),
        padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom:10),
        child: Row(
          children: const [
            Text('輸入優惠代碼'),
            Spacer(),
            Icon(Icons.arrow_right)
          ],
        ),
      ),
      onTap: () => _cartViewModel.showDiscountBottomSheet(
        context, 
        _authService.isSignedIn,
        couponTextController, 
        _couponModel, 
        _userCouponList
      ),
    );
  }

  Widget _buildCheckbillButton(){

    final authService = Provider.of<AuthService>(context);
    final _cartViewModel = Provider.of<CartViewModel>(context);
    final _userModel = Provider.of<UserModel>(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 10),
      child : ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: const Color(cPrimaryColor),
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
        ),
        onPressed: () => _cartViewModel.checkbill(authService.isSignedIn, _userModel),
        child: const Text(
          '輸入運送地址及付款',
        ),
      )
    );
  }

  
}
