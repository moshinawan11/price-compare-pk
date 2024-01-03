import 'package:flutter/material.dart';
import '../models/products.dart';
import '../data.dart';
import '../widgets/products_card.dart';
import "./category_card_widget.dart";
import '../models/product.dart';

class TopCategories extends StatelessWidget {
  const TopCategories({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Top Categories",
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 0,
              runSpacing: 0,
              children: [
                Padding(
                  padding: EdgeInsets.all(4),
                  child: CategoryCard(
                    imageUrl:
                        "https://images.priceoye.pk/apple-iphone-14-pakistan-priceoye-3j7db.jpg",
                    categoryName: "Mobiles",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4),
                  child: CategoryCard(
                    imageUrl:
                        "https://assets.stickpng.com/images/588524d86f293bbfae451a31.png",
                    categoryName: "Laptops",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4),
                  child: CategoryCard(
                    imageUrl:
                        "https://www.notebookcheck.net/fileadmin/Notebooks/News/_nc3/redmi_tv_6.jpg",
                    categoryName: "TVs",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4),
                  child: CategoryCard(
                    imageUrl:
                        "https://media.istockphoto.com/id/1128905977/photo/womens-clothing-with-personal-accessories-isolated-on-white-background.jpg?s=612x612&w=0&k=20&c=M55Wl8BSbV3PlT51g07njlZ-YBPnInNMy3OpoAxTsg8=",
                    categoryName: "Clothes",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4),
                  child: CategoryCard(
                    imageUrl:
                        "https://www.pngmart.com/files/6/Home-Appliance-PNG-Image.png",
                    categoryName: "Appliances",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4),
                  child: CategoryCard(
                    imageUrl:
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTzVF9lFcI__f1s3LR_f1bGgCzmuhlrfv084A&usqp=CAU",
                    categoryName: "Accessories",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4),
                  child: CategoryCard(
                    imageUrl:
                        "https://w7.pngwing.com/pngs/285/102/png-transparent-personal-care-cosmetics-detergent-catalog-personal-care-purple-cosmetics-plastic-bottle-thumbnail.png",
                    categoryName: "Beauty",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
