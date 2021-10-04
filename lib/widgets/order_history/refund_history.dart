// @dart=2.9
import 'package:flutter/material.dart';
import 'package:alternate_store/constants.dart';
import 'package:alternate_store/model/order_model.dart';

class RefundHistory extends StatelessWidget {

  final List<OrderModel> orderList;
  const RefundHistory({Key key, this.orderList}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return ListView.builder(
      itemCount: 1,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index){
        return GestureDetector(
          onTap: (){},
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            padding: const EdgeInsets.only(left: 20, right: 20, top:20, bottom: 20),
            decoration: BoxDecoration(
              color: const Color(cGrey),
              borderRadius: BorderRadius.circular(17)
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Expanded(
                  child: SizedBox(
                    height: 90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(orderList[index].orderDate.toString()),
                        Text(orderList[index].orderNumber),
                        const Spacer(),
                        const Text(
                          '已退出貨品',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ],
                    )
                  )
                ),

                Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    image: DecorationImage(
                      image: AssetImage(orderList[index].orderProduct[0]['PRODUCT_IMAGE']),
                      fit: BoxFit.cover
                    )
                  ),
                )
                
              ],
            ),
          )
        );
      },
    );
  }

  /*
  @override
  Widget build(BuildContext context) {
    return 
    ListView.builder(
      itemCount: 1,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index){
        return GestureDetector(
          onTap: (){},
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            padding: const EdgeInsets.only(left: 20, right: 20, top:20, bottom: 20),
            decoration: BoxDecoration(
              color: const Color(cGrey),
              borderRadius: BorderRadius.circular(17)
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Expanded(
                  child: SizedBox(
                    height: 90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(orderList[index].orderDate),
                        Text(orderList[index].orderNumber),
                        const Spacer(),
                        const Text(
                          '已退出貨品',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ],
                    )
                  )
                ),

                Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    image: DecorationImage(
                      image: AssetImage(orderList[index].orderProduct[0].imagePatch[0]),
                      fit: BoxFit.cover
                    )
                  ),
                )
                
              ],
            ),
          )
        );
      },
    );
  }
  */
}
