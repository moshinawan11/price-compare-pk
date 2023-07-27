import 'dart:ui';

import 'package:flutter/material.dart';

class ProductInfo extends StatelessWidget {
  final int id;
  final String image;
  final String title;
  final String price;
  final int numOfOffers;
  const ProductInfo(
      this.id, this.image, this.title, this.price, this.numOfOffers);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 28, 55, 98),
      child: Column(
        children: [
          Container(
            child: Image.network(
              image,
              fit: BoxFit.contain,
            ),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            height: 350,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 30),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 23,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "from  ",
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(207, 255, 255, 255),
                ),
              ),
              Text(
                "Rs. ${price.toString()}",
                style: TextStyle(
                  fontSize: 25,
                  color: Color.fromARGB(255, 255, 153, 0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 320,
            height: 50,
            child: ElevatedButton(
              child: Text(
                "$numOfOffers offers",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              onPressed: (() {}),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
