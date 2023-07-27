import 'package:flutter/material.dart';
import '../data.dart';
import '../models/products.dart';
import '../widgets/product_availability_card_widget.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../models/product.dart';

class ProductAvailability extends StatelessWidget {
  final int id;
  ProductAvailability(this.id);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context).products;

    Product product = products.firstWhere((product) {
      return product.id == id;
    });

    List<Map<String, dynamic>> availabilityList = product.availability;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Available at",
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ...availabilityList.map((store) {
            final storeName = store["store"];
            final price = store["price"];
            return ProductAvailabilityCard(storeName, price);
          }).toList(),
        ],
      ),
    );
  }
}
