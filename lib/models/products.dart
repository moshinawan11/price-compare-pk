class Product {
  final int id;
  final String title;
  final String image;
  final String price;
  final String date;
  final String description;
  final List<Map<String, dynamic>> availability;

  const Product(
      {required this.id,
      required this.title,
      required this.image,
      required this.price,
      required this.date,
      required this.description,
      required this.availability});
}
