// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/products_provider.dart';

// class ProductDetailsScreen extends StatelessWidget {
//   const ProductDetailsScreen();

//   @override
//   Widget build(BuildContext context) {
//     final productDetails =
//         Provider.of<ProductsProvider>(context, listen: false).selectedProduct;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Product Details'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Display the received product details
//             Text('Title: ${productDetails.title}'),
//             Text('Price: ${productDetails.price}'),
//             // Add more widgets to display other product details as needed
//           ],
//         ),
//       ),
//     );
//   }
// }
