import "package:flutter/material.dart";
import '../models/products.dart';
import "../data.dart";
import '../widgets/product_info_widget.dart';
import '../widgets/product_availability_widget.dart';
import "../widgets/product_details_widget.dart";
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../screens/navigation_bars.dart';
import '../models/product.dart';
import '../providers/favorite_products_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen();

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<FavoriteProductsProvider>(context);
    final arguments = ModalRoute.of(context)!.settings.arguments;
    final int id = (arguments as dynamic)["id"];
    var product = DUMMY_PRODUCTS.firstWhere((product) {
      return product.id == id;
    });
    bool isFavorite = productsProvider.isFavorite(product);
    int numOfOffers = product.availability.length;
    return Scaffold(
      floatingActionButton: Align(
        alignment: Alignment.topRight,
        child: Column(
          children: [
            FloatingActionButton(
              heroTag: "button1",
              onPressed: () {
                if (isFavorite) {
                  productsProvider.removeFromFavorites(product);
                } else {
                  productsProvider.addToFavorites(product);
                }
              },
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.white,
              ),
            ),
            SizedBox(height: 10),
            FloatingActionButton(
              heroTag: "button2",
              onPressed: () {
                if (isFavorite) {
                  productsProvider.removeFromFavorites(product);
                } else {
                  productsProvider.addToFavorites(product);
                }
              },
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.white,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            ProductInfo(product.id, product.image, product.title, product.price,
                numOfOffers),
            SizedBox(
              height: 40,
            ),
            ProductAvailability(product.id),
            SizedBox(
              height: 50,
            ),
            //ProductDetails(product.description),
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 8, 30, 65),
    );
  }
}
