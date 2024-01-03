class MegaProduct {
  String title;
  String price;
  String image;
  String? brand;
  Map<String, Map<String, dynamic>>? productSpecs;

  MegaProduct({
    required this.title,
    required this.price,
    required this.image,
    this.brand,
    this.productSpecs,
  });
}
