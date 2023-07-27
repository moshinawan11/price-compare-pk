import "package:flutter/material.dart";
import 'package:price_compare_pk/models/daraz_product_details.dart';
import 'package:price_compare_pk/widgets/product_highlights_widget.dart';
import '../models/products.dart';
import "../data2.dart";
import '../widgets/product_info_widget.dart';
import '../widgets/product_availability_widget.dart';
import "../widgets/product_details_widget.dart";
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../screens/navigation_bars.dart';
import '../models/product.dart';
import '../providers/products_provider.dart';
import '../widgets/additional_details_widget.dart';
import '../models/mega_product_details.dart';
import 'dart:math' as math;

class MegaProductDetailsScreen extends StatefulWidget {
  final String productURL;
  final String storeName;
  const MegaProductDetailsScreen(this.productURL, this.storeName);

  @override
  State<MegaProductDetailsScreen> createState() =>
      _MegaProductDetailsScreenState();
}

class _MegaProductDetailsScreenState extends State<MegaProductDetailsScreen> {
  MegaProduct? product;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchProductDetails();
    });
  }

  Future<void> fetchProductDetails() async {
    try {
      await Provider.of<ProductsProvider>(context, listen: false)
          .fetchProductDetails(widget.productURL);
      setState(() {
        product = Provider.of<ProductsProvider>(context, listen: false)
            .selectedMegaProduct;
      });
    } catch (error) {
      // Handle error if product details couldn't be fetched
      print('Error occurred while fetching product details: $error');
    }
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    //bool isFavorite = productsProvider.isFavorite(product);
    if (product == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Product Details'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      //floatingActionButton: Align(
      //  alignment: Alignment.topRight,
      //   child: Column(
      //     children: [
      //       FloatingActionButton(
      //         heroTag: "button1",
      //         onPressed: () {
      //           if (isFavorite) {
      //             productsProvider.removeFromFavorites(product);
      //           } else {
      //             productsProvider.addToFavorites(product);
      //           }
      //         },
      //         child: Icon(
      //           isFavorite ? Icons.favorite : Icons.favorite_border,
      //           color: isFavorite ? Colors.red : Colors.white,
      //         ),
      //       ),
      //       SizedBox(height: 10),
      //       FloatingActionButton(
      //         heroTag: "button2",
      //         onPressed: () {
      //           if (isFavorite) {
      //             productsProvider.removeFromFavorites(product);
      //           } else {
      //             productsProvider.addToFavorites(product);
      //           }
      //         },
      //         child: Icon(
      //           isFavorite ? Icons.favorite : Icons.favorite_border,
      //           color: isFavorite ? Colors.red : Colors.white,
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
              //color: Color.fromARGB(255, 28, 55, 98),
              child: Column(
                children: [
                  Container(
                    child: Image.network(
                      product!.image,
                      fit: BoxFit.contain,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    height: 350,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      product!.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 23,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // New Container to display price, arrow button, and store logo
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                //color: Color.fromARGB(255, 28, 55, 98),
              ),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rs. ${product!.price}', // Display the product price
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      // Add more product details as needed
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          primary: Colors
                              .orange, // Set button background color to orange
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'To Shop',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(width: 10),
                            Transform.rotate(
                              angle: -math.pi / 4, // Tilt the icon upwards
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Display the store logo image here
                  Image.asset(
                    "assets/images/${widget.storeName}.png",
                    height: 120,
                    width: 120,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            //ProductHighlights(product!.productHighlights),
            //ProductDetails(product!.productDetails),
            //AdditionalDetailsWidget(
            //    additionalDetails: product!.additionalDetails),
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 8, 30, 65),
    );
  }
}
