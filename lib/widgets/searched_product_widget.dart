import 'dart:math';

import 'package:flutter/material.dart';
import 'package:price_compare_pk/providers/products_provider.dart';
import 'package:price_compare_pk/screens/daraz_product_details_screen.dart';
import '../screens/myshop_product_details_screen.dart';
import '../models/products.dart';
import '../providers/favorite_products_provider.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/daraz_product_details.dart';
import '../screens//product_details_screen2.dart';
import '../screens/mega_product_details_screen.dart';
import '../screens/priceoye_product_details_screen.dart';
import '../screens/shophive_product_details_screen.dart';

class SearchedProduct extends StatefulWidget {
  final Products product;
  const SearchedProduct(this.product);

  @override
  State<SearchedProduct> createState() => _SearchedProductState();
}

class _SearchedProductState extends State<SearchedProduct> {
  void selectProduct(BuildContext context) {
    Navigator.of(context).pushNamed("/product_details_screen",
        arguments: {"id": widget.product.id});
  }

  void navigateToNextScreen(BuildContext context) async {
    try {
      final storeName;
      final String url = widget.product.productURL.toLowerCase();

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
                DarazProductDetailsScreen(widget.product.productURL, storeName),
          ),
        );
      } else if (storeName == 'mega') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                MegaProductDetailsScreen(widget.product.productURL, storeName),
          ),
        );
      } else if (storeName == 'myshop') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MyshopProductDetailsScreen(
                widget.product.productURL, storeName),
          ),
        );
      } else if (storeName == 'priceoye') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PriceoyeProductDetailsScreen(
                widget.product.productURL, storeName),
          ),
        );
      } else if (storeName == 'shophive') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ShophiveProductDetailsScreen(
                widget.product.productURL, storeName),
          ),
        );
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    bool isFavorite = widget.product.isFavorite;
    return InkWell(
      onTap: () {
        navigateToNextScreen(context);
      },
      child: /*Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(255, 28, 55, 98),
        ),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.all(10),
              width: 70,
              height: 70,
              child: Image.network(product.image),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Rs. ${product.price.toString()}",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 18,
                  ),
                ),
              ],
            )
          ],
        ),
      ),*/
          Card(
        color: Color.fromARGB(255, 28, 55, 98),
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left side: Image
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(10),
                width: 100,
                height: 100,
                child: Image.network(widget.product.imageURL),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: Text(
                        widget.product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Rs. ${widget.product.price}', // Replace with your product price
                        style: TextStyle(
                          fontSize: 19,
                          color: Color.fromARGB(255, 255, 153, 0),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 15),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  productsProvider
                      .addOrRemoveProductFromFavorites(widget.product);
                  setState(() {});
                },
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
