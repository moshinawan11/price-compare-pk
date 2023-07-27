class DarazProduct {
  String title;
  String price;
  List<String> images;
  String? brand;
  String? shippingFee;
  List<String>? productHighlights;
  List<String>? productDetails;
  List<Map<String, dynamic>>? additionalDetails;
  String? inTheBox;

  DarazProduct({
    required this.title,
    required this.price,
    required this.images,
    this.brand,
    this.shippingFee,
    this.productHighlights,
    this.productDetails,
    this.additionalDetails,
    this.inTheBox,
  });
}
