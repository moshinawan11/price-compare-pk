import 'package:flutter/material.dart';
import '../models/products.dart';
import '../models/product.dart';

class FavoriteProductsProvider with ChangeNotifier {
  List<Product> _favoriteProducts = [];

  List<Product> get favoriteProducts => _favoriteProducts;

  void addToFavorites(Product product) {
    if (!_favoriteProducts.contains(product)) {
      _favoriteProducts.add(product);
      notifyListeners();
    }
  }

  void removeFromFavorites(Product product) {
    if (_favoriteProducts.contains(product)) {
      _favoriteProducts.remove(product);
      notifyListeners();
    }
  }

  bool isFavorite(Product product) {
    return _favoriteProducts.contains(product);
  }
}
