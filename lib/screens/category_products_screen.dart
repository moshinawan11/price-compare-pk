import 'package:flutter/material.dart';
import 'package:price_compare_pk/providers/products_provider.dart';
import 'package:provider/provider.dart';
import '../models/products.dart';
import '../models/product.dart';
import '../screens/daraz_product_details_screen.dart';
import '../screens/mega_product_details_screen.dart';
import '../screens/shophive_product_details_screen.dart';
import '../screens/priceoye_product_details_screen.dart';
import '../screens/myshop_product_details_screen.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String categoryName;

  const CategoryProductsScreen(this.categoryName);

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreen();
}

class _CategoryProductsScreen extends State<CategoryProductsScreen> {
  bool _isLoading = true;
  List<Products> foundProducts = [];
  bool productSearched = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchForProduct();
    });
  }

  searchForProduct() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await Provider.of<ProductsProvider>(context, listen: false)
          .searchForProduct(widget.categoryName);

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    foundProducts = productsProvider.searchedProducts;
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoryName}'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Color.fromRGBO(60, 74, 98, 1),
      ),
      backgroundColor: Color.fromARGB(255, 8, 30, 65),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(), // Loading spinner
            )
          : foundProducts.isEmpty
              ? Center(
                  child: Text(
                    'No products found.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ListView.builder(
                    itemCount: foundProducts.length,
                    itemBuilder: (context, index) {
                      return ProductCard(foundProducts[index]);
                    },
                  ),
                ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final Products product;

  ProductCard(this.product);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
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
                  image: NetworkImage(widget.product.imageURL),
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.title,
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
                    'Rs. ${widget.product.price}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(height: 8),
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
    );
  }
}
