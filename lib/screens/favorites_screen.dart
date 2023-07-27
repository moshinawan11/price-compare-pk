import 'package:flutter/material.dart';
import 'package:price_compare_pk/providers/products_provider.dart';
import 'package:provider/provider.dart';
import '../models/products.dart';
import '../models/product.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductsProvider>(context, listen: false)
          .getFavoriteProducts()
          .then((_) {
        // After fetching the products, set loading to false
        setState(() {
          _isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProducts =
        Provider.of<ProductsProvider>(context).favoriteProducts;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Favorites'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Color.fromRGBO(60, 74, 98, 1),
      ),
      backgroundColor: Color.fromARGB(255, 8, 30, 65),
      body:
          _isLoading // Check loading state and show spinner or content accordingly
              ? Center(
                  child: CircularProgressIndicator(), // Loading spinner
                )
              : favoriteProducts.isEmpty
                  ? Center(
                      child: Text(
                        'No favorite products found.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ListView.builder(
                        itemCount: favoriteProducts.length,
                        itemBuilder: (context, index) {
                          return ProductCard(favoriteProducts[index]);
                        },
                      ),
                    ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Products product;

  ProductCard(this.product);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Color.fromARGB(255, 28, 55, 98),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(product.imageURL),
              ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Rs. ${product.price}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(height: 8),
                // Add more product details as needed
                ElevatedButton(
                  onPressed: () {
                    // Implement add to cart functionality
                  },
                  child: Text('Add to Cart'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange,
                    textStyle: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
