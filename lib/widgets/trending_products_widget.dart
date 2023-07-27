import 'package:flutter/material.dart';
import '../models/products.dart';
import '../data.dart';
import '../widgets/products_card.dart';
import '../providers/products_provider.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';

class TrendingProducts extends StatefulWidget {
  const TrendingProducts({super.key});

  @override
  State<TrendingProducts> createState() => _TrendingProductsState();
}

class _TrendingProductsState extends State<TrendingProducts> {
  @override
  Widget build(BuildContext context) {
    List<Product> products = Provider.of<ProductsProvider>(context).products;
    print(products);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Trending Products",
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
                ...products.map(
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
