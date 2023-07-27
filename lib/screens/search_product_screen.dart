import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/product_details_screen.dart';
import '../data.dart';
import '../models/products.dart';
import '../widgets/searched_product_widget.dart';
import '../providers/favorite_products_provider.dart';
import '../models/product.dart';
import '../providers/products_provider.dart';

class SearchProduct extends StatefulWidget {
  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  final searchedProduct = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool productSearched = false;
  List<Products> foundProducts = [];
  bool isLoading = false;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // This will be executed after initState has completed.
      FocusScope.of(context).requestFocus(_searchFocusNode);
    });
  }

  searchForProduct() async {
    try {
      setState(() {
        isLoading = true;
      });

      String searchedTerm = searchedProduct.text;
      await Provider.of<ProductsProvider>(context, listen: false)
          .searchForProduct(searchedTerm);

      setState(() {
        isLoading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);

    // Get the searched products from the provider
    foundProducts = productsProvider.searchedProducts;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(190.0),
          child: Column(children: [
            SizedBox(
              height: 70,
            ),
            Container(
              child: Image.asset("assets/images/logo-no-background.png"),
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
            ),
            SizedBox(
              height: 20,
            ),
            Card(
              child: TextField(
                controller: searchedProduct,
                focusNode: _searchFocusNode,
                onEditingComplete: () {
                  searchForProduct();
                  FocusScope.of(context).unfocus();
                  productSearched = true;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color.fromARGB(169, 255, 255, 255),
                  ),
                  hintText: "What are you looking for?",
                  hintStyle: TextStyle(
                      color: Color.fromARGB(169, 255, 255, 255), fontSize: 18),
                  focusColor: Colors.white,
                  fillColor: Color.fromRGBO(60, 74, 98, 1),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(169, 255, 255, 255),
                    ),
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              margin: EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Color.fromARGB(255, 8, 30, 65),
              elevation: 4,
            ),
          ]),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Color.fromARGB(255, 8, 30, 65),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                isLoading // Show the loading spinner if isLoading is true
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : foundProducts.length > 0
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: foundProducts.length,
                            itemBuilder: (ctx, index) {
                              final product = foundProducts[index];
                              return ChangeNotifierProvider.value(
                                value: productsProvider,
                                child: SearchedProduct(product),
                              );
                            },
                          )
                        : productSearched
                            ? Center(
                                child: Text(
                                  "No products found",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              )
                            : SizedBox(
                                height: 40,
                              ),
              ],
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 8, 30, 65),
      ),
    );
  }
}
