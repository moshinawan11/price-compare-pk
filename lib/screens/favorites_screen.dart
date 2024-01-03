import 'package:flutter/material.dart';
import 'package:price_compare_pk/providers/products_provider.dart';
import 'package:price_compare_pk/screens/daraz_price_alert_screen.dart';
import 'package:provider/provider.dart';
import '../models/products.dart';
import '../models/product.dart';
import '../screens/daraz_product_details_screen.dart';
import '../screens/mega_product_details_screen.dart';
import '../screens/shophive_product_details_screen.dart';
import '../screens/priceoye_product_details_screen.dart';
import '../screens/myshop_product_details_screen.dart';

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

  void navigateToNextScreen(BuildContext context) async {
    try {
      final storeName;
      final String url = product.productURL.toLowerCase();

      if (url.contains('shophive.com')) {
        storeName = 'shophive';
      } else if (url.contains('daraz.pk')) {
        storeName = 'daraz';
      } else if (url.contains('myshop.pk')) {
        storeName = 'myshop';
      } else if (url.contains('priceoye.pk')) {
        storeName = 'priceoye';
      } else if (url.contains('mega.pk')) {
        storeName = 'mega';
      } else {
        storeName = null;
      }
      if (storeName == 'daraz') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                DarazProductDetailsScreen(product.productURL, storeName),
          ),
        );
      } else if (storeName == 'mega') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                MegaProductDetailsScreen(product.productURL, storeName),
          ),
        );
      } else if (storeName == 'myshop') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                MyshopProductDetailsScreen(product.productURL, storeName),
          ),
        );
      } else if (storeName == 'priceoye') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                PriceoyeProductDetailsScreen(product.productURL, storeName),
          ),
        );
      } else if (storeName == 'shophive') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                ShophiveProductDetailsScreen(product.productURL, storeName),
          ),
        );
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigateToNextScreen(context);
      },
      child: Container(
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
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
