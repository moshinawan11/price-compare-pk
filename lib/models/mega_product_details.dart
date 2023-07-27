class MegaProduct {
  String title;
  String price;
  String image;
  String? brand;
  Map<String, Map<String, String>>? productSpecs;

  MegaProduct({
    required this.title,
    required this.price,
    required this.image,
    this.brand,
    this.productSpecs,
  });
}
