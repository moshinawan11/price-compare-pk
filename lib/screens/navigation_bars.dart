import 'package:flutter/material.dart';
import '../screens/favorites_screen.dart';
import '../main.dart';
import './search_product_screen.dart';

class NavigationBars extends StatefulWidget {
  NavigationBars();

  @override
  State<NavigationBars> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBars> {
  int selectedItem = 0;

  List<Widget> navigationOptions = [
    MyHomePage(),
    SearchProduct(),
    FavoritesScreen(),
    Container(),
  ];

  void onTapped(int index) {
    setState(() {
      selectedItem = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationOptions[selectedItem],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedItem,
        onTap: onTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
            backgroundColor: Color.fromRGBO(60, 74, 98, 1),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
            ),
            label: 'Search',
            backgroundColor: Color.fromRGBO(60, 74, 98, 1),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
            ),
            label: 'Favorites',
            backgroundColor: Color.fromRGBO(60, 74, 98, 1),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'My Profile',
            backgroundColor: Color.fromRGBO(60, 74, 98, 1),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromRGBO(45, 60, 86, 1),
        selectedItemColor: Color.fromARGB(255, 255, 153, 0),
        unselectedItemColor: Color.fromARGB(255, 202, 202, 202),
        selectedFontSize: 12,
        unselectedFontSize: 12,
      ),
    );
  }
}
