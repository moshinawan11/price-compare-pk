import 'package:flutter/material.dart';

class ProductsCard extends StatelessWidget {
  final int id;
  final String title;
  final String image;
  final String price;
  ProductsCard(this.id, this.title, this.image, this.price);

  void selectProduct(BuildContext context) {
    Navigator.of(context)
        .pushNamed("/product_details_screen", arguments: {"id": id});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        selectProduct(context);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        child: Container(
          width: 110,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: Container(
                  height: 100,
                  child: Image.network(image, fit: BoxFit.cover),
                  padding: EdgeInsets.all(10),
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                height: 34,
                child: Text(
                  "$title",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  softWrap: false,
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                child: Text(
                  "Rs. ${price.toString()}",
                  style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 255, 153, 0),
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                  softWrap: false,
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ],
          ),
          margin: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color.fromARGB(255, 28, 55, 98),
          ),
        ),
      ),
    );
  }
}
