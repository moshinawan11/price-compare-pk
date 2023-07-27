class PriceoyeProduct {
  String title;
  String price;
  String image;
  String? availability;
  String? rating;
  List<String>? colors;
  Map<String, Map<String, dynamic>>? specifications;

  PriceoyeProduct({
    required this.title,
    required this.price,
    required this.image,
    this.availability,
    this.rating,
    this.colors,
    this.specifications,
  });
}
