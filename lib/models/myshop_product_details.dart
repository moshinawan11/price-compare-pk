class MyshopProduct {
  String title;
  String price;
  String image;
  Map<String, String>? tableData;

  MyshopProduct({
    required this.title,
    required this.price,
    required this.image,
    this.tableData,
  });
}
