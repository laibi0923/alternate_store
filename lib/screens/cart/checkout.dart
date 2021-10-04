// ignore_for_file: import_of_legacy_library_into_null_safe
//@dart=2.9
import 'dart:isolate';
import 'dart:ui';

import 'package:alternate_store/constants.dart';
import 'package:alternate_store/model/order_model.dart';
import 'package:alternate_store/model/paymentmethod_model.dart';
import 'package:alternate_store/model/user_model.dart';
import 'package:alternate_store/screens/cart/shipping.dart';
import 'package:alternate_store/viewmodel/checkout_viewmodel.dart';
import 'package:alternate_store/widgets/set_cachednetworkimage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';

class CheckOut extends StatefulWidget {
  final OrderModel orderModel;
  const CheckOut({Key key, this.orderModel}) : super(key: key);

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {

  int _initTagIndex = 0;

  // ignore: prefer_final_fields
  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      // ignore: unused_local_variable
      String id = data[0];
      // ignore: unused_local_variable
      DownloadTaskStatus status = data[1];
      // ignore: unused_local_variable
      int progress = data[2];
      setState((){ });
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [

          Container(
            color: Colors.white,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                _buildShippingInformation(),
                _buildPaymentMehtod(),
              ],
            ),
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
              )),
        ],
      ),
    );
  }

  Widget _buildShippingInformation() {

    final _userInfo = Provider.of<UserModel>(context);

    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 40, bottom: 20),
            child: Text(
              '運送地址',
              style: TextStyle(fontSize: xTextSize22, fontWeight: FontWeight.bold),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Shipping())),
            child: Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
              decoration: BoxDecoration(
                  color: const Color(cGrey),
                  borderRadius: BorderRadius.circular(7)),
              child: Text(
                _userInfo.unitAndBuilding.isEmpty &&
                _userInfo.estate.isEmpty &&
                _userInfo.district.isEmpty
                ? '點擊設定運送地址 \n'
                : '${_userInfo.recipientName} \n${_userInfo.unitAndBuilding} \n${_userInfo.estate} ${_userInfo.district}',
                style: const TextStyle(height: 1.5),
              ),
            ),
          ),
          const Align(alignment: Alignment.centerRight, child: Text('修改')),
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
                TextStyle(fontSize: xTextSize22, fontWeight: FontWeight.bold),
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
          onTap: () => _checkoutviewmodel.downloadQRCode(_paymentMethodList[_initTagIndex]),
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
          'HKD\$ ${widget.orderModel.totalAmount}',
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

}
