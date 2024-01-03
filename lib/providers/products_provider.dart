import 'package:flutter/material.dart';
import '../models/products.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';
import '../models/http_exception.dart';
import '../models/daraz_product_details.dart';
import '../models/mega_product_details.dart';
import '../models/priceoye_product_details.dart';
import '../models/shophive_product_details.dart';
import '../models/myshop_product_details.dart';

class ProductsProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Products> _searchedProducts = [];
  final String? authToken;
  List<Products> _favoriteProducts = [];
  List<Products> _priceAlertProducts = [];
  DarazProduct? _selectedDarazProduct;
  MegaProduct? _selectedMegaProduct;
  PriceoyeProduct? _selectedPriceoyeProduct;
  ShophiveProduct? _selectedShophiveProduct;
  MyshopProduct? _selectedMyshopProduct;

  ProductsProvider(this.authToken, this._products);

  DarazProduct? get selectedDarazProduct => _selectedDarazProduct;
  MegaProduct? get selectedMegaProduct => _selectedMegaProduct;
  PriceoyeProduct? get selectedPriceoyeProduct => _selectedPriceoyeProduct;
  ShophiveProduct? get selectedShophiveProduct => _selectedShophiveProduct;
  MyshopProduct? get selectedMyshopProduct => _selectedMyshopProduct;
  List<Product> get products => _products;
  List<Products> get favoriteProducts => _favoriteProducts;
  List<Products> get priceAlertProducts => _priceAlertProducts;
  List<Products> get searchedProducts => _searchedProducts;

  String? extractStoreNameFromProductURL(String url) {
    if (url.contains('shophive.com')) {
      return 'shophive';
    } else if (url.contains('daraz.pk')) {
      return 'daraz';
    } else if (url.contains('myshop.pk')) {
      return 'myshop';
    } else if (url.contains('priceoye.pk')) {
      return 'priceoye';
    } else if (url.contains('mega.pk')) {
      return 'mega';
    } else {
      return null;
    }
  }

  String extractPrice(priceString) {
    priceString = priceString.replaceAll("Rs.", "");
    priceString = priceString.replaceAll(RegExp(r'[^\d,.]'), '');
    priceString = priceString.split('.').first;
    return priceString;
  }

  String ipaddress = '192.168.189.147';

  Future<void> fetchProductDetails(String productURL) async {
    String? storeName = extractStoreNameFromProductURL(productURL);
    if (storeName != null) {
      try {
        if (storeName == 'daraz') {
          productURL = 'https:' + productURL;
        }
        final url =
            'http://$ipaddress:3000/get-$storeName-products?productURL=$productURL';
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          print(responseData);
          if (storeName == 'daraz') {
            _selectedDarazProduct = extractDarazProductData(responseData);
          } else if (storeName == 'mega') {
            _selectedMegaProduct = extractMegaProductData(responseData);
          } else if (storeName == 'shophive') {
            _selectedShophiveProduct = extractShophiveProductData(responseData);
          } else if (storeName == 'priceoye') {
            _selectedPriceoyeProduct = extractPriceoyeProductData(responseData);
            print(_selectedPriceoyeProduct);
          } else if (storeName == 'myshop') {
            _selectedMyshopProduct = extractMyshopProductData(responseData);
          }

          notifyListeners();
        }
      } catch (error) {
        print('Error occurred while fetching product details: $error');
      }
    }
  }

  Future<void> fetchProducts() async {
    final response = await http.get(
        Uri.parse('http://$ipaddress:3000/get-products'),
        headers: {"authorization": authToken!});
    print("Token:" + authToken!);
    try {
      final List<dynamic> responseData = json.decode(response.body);

      _products = responseData.map((item) {
        List<Map<String, dynamic>> availabilityData =
            (item['availability'] as List<dynamic>)
                .cast<Map<String, dynamic>>();
        return Product(
          id: item['id'],
          title: item['title'],
          image: item['image'],
          price: item['price'],
          date: item['date'],
          description: item['description'],
          availability: availabilityData,
        );
      }).toList();
    } catch (error) {
      print(error);
    }

    notifyListeners();
  }

  Future<void> searchForProduct(String searchString) async {
    try {
      final response = await http.get(
          Uri.parse(
              'http://$ipaddress:3000/search-product?searchString=$searchString'),
          headers: {"authorization": authToken!});
      print(authToken!);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        List<Products> productsList = [];

        if (responseData is List) {
          productsList = responseData.map((data) {
            String priceString = extractPrice(data['price']);
            return Products(
              title: data['title'],
              price: priceString,
              imageURL: data['imageURL'],
              productURL: data['productURL'],
              //isFavorite: data['isFavorite'],
            );
          }).toList();
        }

        _searchedProducts.clear();
        _searchedProducts.addAll(productsList);

        notifyListeners();
      }
    } catch (error) {
      print('Error occurred while fetching data: $error');
      throw error;
    }
  }

  Future<void> addOrRemoveProductFromFavorites(Products product) async {
    try {
      final response = await http.post(
        Uri.parse('http://$ipaddress:3000/save-product'),
        headers: {
          "authorization": authToken!,
          "Content-Type": "application/json",
        },
        body: json.encode({
          "title": product.title,
          "price": product.price,
          "imageURL": product.imageURL,
          "productURL": product.productURL,
          "isFavorite": product.isFavorite
        }),
      );

      if (response.statusCode == 200) {
        product.isFavorite = !product.isFavorite;

        notifyListeners();
      } else {
        throw HttpException('Failed to add to favorites');
      }
    } catch (error) {
      print('Error occurred while adding to favorites: $error');
      throw error;
    }
  }

  Future<void> setPriceAlertOnProduct(Products product, int basePrice) async {
    try {
      final response = await http.post(
        Uri.parse('http://$ipaddress:3000/save-product'),
        headers: {
          "authorization": authToken!,
          "Content-Type": "application/json",
        },
        body: json.encode({
          "title": product.title,
          "price": product.price,
          "imageURL": product.imageURL,
          "productURL": product.productURL,
          "basePrice": basePrice
        }),
      );

      if (response.statusCode == 200) {
        _priceAlertProducts.add(product);
        notifyListeners();
      } else {
        throw HttpException('Failed to set price alert');
      }
    } catch (error) {
      print('Error occurred while setting price alert: $error');
      throw error;
    }
  }

  Future<void> getFavoriteProducts() async {
    try {
      final response = await http.get(
        Uri.parse('http://$ipaddress:3000/get-favorite-products'),
        headers: {
          "authorization": authToken!,
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        List<Products> favoriteProductsList = [];

        if (responseData is List) {
          favoriteProductsList = responseData.map((data) {
            // Extract the price string from the data
            String priceString = data['price'];

            priceString = priceString.replaceAll("Rs.", "");

            // Remove any non-digit characters except commas
            priceString =
                priceString = priceString.replaceAll(RegExp(r'[^\d,.]'), '');

            // Remove the decimal point and anything after it
            priceString = priceString.split('.').first;

            return Products(
              title: data['title'],
              price: priceString, // Keep the price as a string
              imageURL: data['imageUrl'],
              productURL: data['productUrl'],
            );
          }).toList();

          _favoriteProducts.addAll(favoriteProductsList);
        }

        notifyListeners();
      }
    } catch (error) {
      print('Error occurred while getting favorites: $error');
      // Handle any other errors that might occur
      throw error;
    }
  }

  DarazProduct extractDarazProductData(Map<String, dynamic> responseData) {
    String priceString = extractPrice(responseData['price']);
    return DarazProduct(
      title: responseData['title'],
      price: priceString,
      images: List<String>.from(responseData['images']),
      brand: responseData['brand'] ?? null,
      shippingFee: responseData['shippingFee'] ?? null,
      productHighlights: responseData['productHighlights'] != null
          ? List<String>.from(responseData['productHighlights'])
          : null,
      productDetails: responseData['productDetails'] != null
          ? List<String>.from(responseData['productDetails'])
          : null,
      additionalDetails: responseData['additionalDetails'] != null
          ? List<Map<String, dynamic>>.from(responseData['additionalDetails'])
          : null,
      inTheBox: responseData['inTheBox'],
    );
  }

  MegaProduct extractMegaProductData(Map<String, dynamic> responseData) {
    print(responseData['productSpecs']);
    String priceString = extractPrice(responseData['price']);
    return MegaProduct(
      title: responseData['title'],
      price: priceString,
      image: responseData['image'],
      brand: responseData['brand'] ?? null,
      productSpecs: responseData['productSpecs'] != null
          ? Map<String, Map<String, dynamic>>.from(responseData['productSpecs'])
          : null,
    );
  }

  ShophiveProduct extractShophiveProductData(
      Map<String, dynamic> responseData) {
    String priceString = extractPrice(responseData['price']);
    return ShophiveProduct(
      title: responseData['title'],
      price: priceString,
      image: responseData['image'],
      brand: responseData['brand'] ?? null,
      availability: responseData['availability'] ?? null,
      productDetails: responseData['productDetails'] != null
          ? List<String>.from(responseData['productDetails'])
          : null,
      productSpecs: responseData['productSpecs'] != null
          ? Map<String, String>.from(responseData['productSpecs'])
          : null,
    );
  }

  MyshopProduct extractMyshopProductData(Map<String, dynamic> responseData) {
    String priceString = extractPrice(responseData['price']);
    return MyshopProduct(
      title: responseData['title'],
      price: priceString,
      image: responseData['image'],
      tableData: responseData['tableData'] != null
          ? Map<String, String>.from(responseData['tableData'])
          : null,
    );
  }

  PriceoyeProduct extractPriceoyeProductData(
      Map<String, dynamic> responseData) {
    String priceString = extractPrice(responseData['price']);
    print(responseData['specifications']);
    return PriceoyeProduct(
      title: responseData['title'],
      price: priceString,
      image: responseData['image'],
      availability: responseData['availability'] ?? null,
      rating: responseData['rating'] ?? null,
      colors: responseData['colors'] != null
          ? List<String>.from(
              responseData['colors'].map((color) => color.toString()))
          : null,
      specifications: responseData['specifications'] != null
          ? Map<String, Map<String, dynamic>>.from(
              responseData['specifications'])
          : null,
    );
  }

  void addToFavorites(Products product) {
    if (!_favoriteProducts.contains(product)) {
      _favoriteProducts.add(product);
      notifyListeners();
    }
  }

  void removeFromFavorites(Products product) {
    if (_favoriteProducts.contains(product)) {
      _favoriteProducts.remove(product);
      notifyListeners();
    }
  }

  bool isFavorite(Products product) {
    return product.isFavorite;
  }
}
