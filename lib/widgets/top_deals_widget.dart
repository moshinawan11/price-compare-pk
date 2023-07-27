import 'package:flutter/material.dart';
import '../models/products.dart';
import '../data.dart';
import '../widgets/products_card.dart';
import '../models/product.dart';

class TopDeals extends StatelessWidget {
  const TopDeals({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Top Deals",
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...DUMMY_PRODUCTS.map(
                  (product) {
                    return ProductsCard(product.id, product.title,
                        product.image, product.price);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
