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
      FocusScope.of(context).requestFocus(_searchFocusNode);
    });
  }

  searchForProduct() async {
    String searchedTerm = searchedProduct.text;
    if (searchedTerm != '') {
      try {
        setState(() {
          isLoading = true;
        });
        await Provider.of<ProductsProvider>(context, listen: false)
            .searchForProduct(searchedTerm);
        setState(() {
          isLoading = false;
        });
        productSearched = true;
      } catch (error) {
        print(error);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);

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
        body: Container(
          color: Color.fromARGB(255, 8, 30, 65),
          child: ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : foundProducts.length > 0
                      ? Column(
                          children: foundProducts.map((product) {
                            return ChangeNotifierProvider.value(
                              value: productsProvider,
                              child: SearchedProduct(product),
                            );
                          }).toList(),
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
        backgroundColor: Color.fromARGB(255, 8, 30, 65),
      ),
    );
  }
}
