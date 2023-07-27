class Products {
  final int? id;
  final String title;
  final String price;
  final String imageURL;
  final String productURL;
  bool isFavorite;

  Products(
      {this.id,
      required this.title,
      required this.price,
      required this.imageURL,
      required this.productURL,
      this.isFavorite = false});
}
