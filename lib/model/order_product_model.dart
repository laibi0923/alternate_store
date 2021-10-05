//@dart=2.9
class OrderProductModel {
  final String colorName;
  final String colorImage;
  final dynamic discount;
  final dynamic price;
  final String productImage;
  final String productName;
  final String productNo;
  final bool refundAble;
  final String refundStatus;
  final String shippingDate;
  final String shippingStatus;
  final String size;

  OrderProductModel({
    this.colorName,
    this.colorImage,
    this.discount,
    this.price,
    this.productImage,
    this.productName,
    this.productNo,
    this.refundAble,
    this.refundStatus,
    this.shippingDate,
    this.shippingStatus,
    this.size
  });

  OrderProductModel.fromFirestore(Map<String, dynamic> json) :
    colorName = json['COLOR_NAME'],
    colorImage = json['COLOR_IMAGE'],
    discount = json['DISCOUNT'],
    price = json['PRICE'],
    productImage = json['PRODUCT_IMAGE'],
    productName = json['PRODUCT_NAME'],
    productNo = json['PRODUCT_NO'],
    refundAble = json['REFUND_ABLE'],
    refundStatus = json['REFUND_STATUS'],
    shippingDate = json['SHIPPING_DATE'],
    shippingStatus = json['SHIPPING_STATUS'],
    size = json['SIZE'];

}
