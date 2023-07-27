import 'package:flutter/material.dart';

class ProductAvailabilityCard extends StatelessWidget {
  final String store;
  final int price;
  const ProductAvailabilityCard(this.store, this.price);

  @override
  Widget build(BuildContext context) {
    String logoPath;
    switch (store) {
      case "daraz.pk":
        logoPath = "daraz";
        break;
      case "homeshopping.pk":
        logoPath = "homeshopping";
        break;
      case "mega.pk":
        logoPath = "mega";
        break;
      case "ishopping.pk":
        logoPath = "ishopping";
        break;
      case "yayvo.com":
        logoPath = "yayvo";
        break;
      case "alibaba.com":
        logoPath = "alibaba";
        break;
      case "shophive.com":
        logoPath = "shophive";
        break;
      case "symbios.pk":
        logoPath = "symbios";
        break;
      case "telemart.pk":
        logoPath = "telemart";
        break;
      default:
        logoPath = "unknown";
        break;
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Card(
          color: Color.fromARGB(255, 28, 55, 98),
          child: Row(
            children: [
              Container(
                height: 100,
                width: 100,
                padding: EdgeInsets.symmetric(horizontal: 10),
                color: Colors.white,
                child: Image.asset(
                  "assets/images/$logoPath.png",
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                children: [
                  Text(
                    "Rs. ${price.toString()}",
                    style: TextStyle(
                      fontSize: 21,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 205,
                    height: 40,
                    child: ElevatedButton(
                      child: Text(
                        "Visit site",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      onPressed: (() {}),
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
