class ShophiveProduct {
  String title;
  String price;
  String image;
  String? brand;
  String? availability;
  List<String>? productDetails;
  Map<String, String>? productSpecs;

  ShophiveProduct({
    required this.title,
    required this.price,
    required this.image,
    this.brand,
    this.availability,
    this.productDetails,
    this.productSpecs,
  });
}
