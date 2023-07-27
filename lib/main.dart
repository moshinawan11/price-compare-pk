import 'package:flutter/material.dart';
import 'package:price_compare_pk/screens/daraz_product_details_screen.dart';
import 'package:price_compare_pk/screens/product_details_screen.dart';
import 'package:price_compare_pk/screens/search_product_screen.dart';
import './widgets/trending_products_widget.dart';
import './widgets/products_card.dart';
import './data.dart';
import './models/products.dart';
import './widgets/top_deals_widget.dart';
import './widgets/top_categories_widget.dart';
import 'package:provider/provider.dart';
import 'providers/products_provider.dart';
import './screens/navigation_bars.dart';
import './screens/auth_screen.dart';
import './providers/auth.dart';
import '../models/product.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<Auth>(
        create: (context) => Auth(),
      ),
      ChangeNotifierProxyProvider<Auth, ProductsProvider>(
        create: (_) => ProductsProvider(null, []),
        update: (ctx, auth, previousState) => ProductsProvider(
          auth.token,
          previousState == null ? [] : previousState.products,
        ),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: ((ctx, auth, _) => MaterialApp(
            title: 'Flutter Demo',
            home: auth.isAuth ? NavigationBars() : AuthScreen(),
            routes: {
              "/product_details_screen": (context) => ProductDetailsScreen(),
              "/search_product_screen": (context) => SearchProduct(),
            },
          )),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final searchedProduct = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductsProvider>(context, listen: false).fetchProducts();
    });
  }

  void _unfocusSearchBar() {
    _searchFocusNode.unfocus();
  }

  void openSearchProductScreen() {
    Navigator.of(context).pushNamed("/search_product_screen");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        searchedProduct.clear();
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
                focusNode: _searchFocusNode,
                onTap: () {
                  _unfocusSearchBar();
                  openSearchProductScreen();
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color.fromARGB(169, 255, 255, 255),
                  ),
                  hintText: "What are you looking for?",
                  hintStyle: TextStyle(
                    color: Color.fromARGB(169, 255, 255, 255),
                    fontSize: 18,
                  ),
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
                TopCategories(),
                SizedBox(
                  height: 40,
                ),
                TopDeals(),
                SizedBox(
                  height: 40,
                ),
                TrendingProducts(),
                SizedBox(
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


/*import 'package:flutter/material.dart';
import 'package:price_compare_pk/screens/product_details_screen.dart';
import 'package:price_compare_pk/screens/search_product_screen.dart';
import './widgets/trending_products_widget.dart';
import './widgets/products_card.dart';
import './data.dart';
import './models/products.dart';
import './widgets/top_deals_widget.dart';
import './widgets/top_categories_widget.dart';
import 'package:provider/provider.dart';
import 'providers/favorite_products_provider.dart';
import 'providers/products_provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<FavoriteProductsProvider>(
        create: (context) => FavoriteProductsProvider(),
      ),
      ChangeNotifierProvider<ProductsProvider>(
        create: (context) => ProductsProvider(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
      routes: {
        "/product_details_screen": (context) => ProductDetailsScreen(),
        "/search_product_screen": (context) => SearchProduct(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final searchedProduct = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductsProvider>(context, listen: false).fetchProducts();
    });
  }

  void _unfocusSearchBar() {
    _searchFocusNode.unfocus();
  }

  open_search_product_screen() {
    Navigator.of(context).pushNamed("/search_product_screen");
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        searchedProduct.clear();
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
                focusNode: _searchFocusNode,
                onTap:

                    //controller: searchedProduct,
                    //onEditingComplete: () {
                    () {
                  _unfocusSearchBar();
                  open_search_product_screen();
                },
                //},
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
                TopCategories(),
                SizedBox(
                  height: 40,
                ),
                TopDeals(),
                SizedBox(
                  height: 40,
                ),
                TrendingProducts(),
                SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 8, 30, 65),
      ),
    );
  }
}*/
