import 'package:flutter/material.dart';
import '../models/daraz_product_details.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

class DarazPriceAlertScreen extends StatefulWidget {
  DarazProduct? product;
  DarazPriceAlertScreen(this.product);

  @override
  State<DarazPriceAlertScreen> createState() => _DarazPriceAlertScreenState();
}

class _DarazPriceAlertScreenState extends State<DarazPriceAlertScreen> {
  var isLoading = false;
  final _priceController = TextEditingController();

  String? _priceValidator(String? value) {
    var currentPrice =
        int.parse(widget.product!.price.replaceAll(RegExp(r'[^\d]'), ''));
    if (value == null || value.isEmpty) {
      return 'Please enter a price';
    }
    int price;
    try {
      price = int.parse(value);
    } catch (error) {
      return 'Invalid price format';
    }
    if (price <= 0) {
      return 'Price must be greater than zero';
    }
    if (price >= currentPrice) {
      return 'Price must be less than the current price';
    }
    return null;
  }

  void _submit() {
    setState(() {
      isLoading = true;
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Price Alert'),
        backgroundColor: Color.fromRGBO(60, 74, 98, 1),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Color.fromARGB(255, 8, 30, 65),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Text(
              'Current Price:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Rs. ${widget.product!.price}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 60),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Target Price',
                      style: TextStyle(
                        color: Color.fromARGB(255, 8, 30, 65),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          fontSize: 20, color: Color.fromARGB(255, 8, 30, 65)),
                      decoration: InputDecoration(
                        hintText: 'Enter base price',
                      ),
                      onSubmitted: (_) => _submit(),
                    ),
                    SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 11.0),
                        backgroundColor: Color.fromARGB(255, 8, 30, 65),
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: Text('Set Price Alert'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
