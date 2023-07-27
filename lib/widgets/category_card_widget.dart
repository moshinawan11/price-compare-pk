import 'package:flutter/material.dart';
import '../screens/category_products_screen.dart';

class CategoryCard extends StatelessWidget {
  final String imageUrl;
  final String categoryName;

  CategoryCard({required this.imageUrl, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CategoryProductsScreen(categoryName),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            decoration:
                BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              height: 50,
              width: 50,
            ),
          ),
          SizedBox(height: 5),
          Text(
            categoryName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
