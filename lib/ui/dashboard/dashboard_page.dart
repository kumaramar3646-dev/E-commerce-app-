import 'package:flutter/material.dart';

import '../../data/model/product_model.dart';
import 'nav_pages/cart_page.dart';
import 'nav_pages/fab_page.dart';
import 'nav_pages/home_page/home_page.dart';
import 'nav_pages/menu_page.dart';
import 'nav_pages/my_profile_page.dart';

class DashBoardPage extends StatefulWidget {
  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  int selectedIndex = 2;

  List<Widget> mNav_pages = [
    MenuPage(),
    FavPage(),
    HomePage(),
    CartPage(),
    MyProfilePage(),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: mNav_pages[selectedIndex],
      bottomNavigationBar: BottomAppBar(
        notchMargin: 8,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              isSelected: selectedIndex == 0,
              onPressed: () {
                selectedIndex = 0;
                setState(() {});
              },
              icon: Icon(Icons.dashboard_outlined, color: Colors.grey),
              selectedIcon: Icon(
                Icons.dashboard_outlined,
                color: Colors.deepOrange,
              ),
            ),
            IconButton(
              isSelected: selectedIndex == 1,
              onPressed: () {
                selectedIndex = 1;
                setState(() {});
              },
              icon: Icon(Icons.favorite_outline, color: Colors.grey),
              selectedIcon: Icon(
                Icons.favorite_outline,
                color: Colors.deepOrange,
              ),
            ),
            SizedBox(
              width: 21,
            ),
            IconButton(
              isSelected: selectedIndex == 3,
              onPressed: () {
                selectedIndex = 3;
                setState(() {});
              },
              icon: Icon(Icons.shopping_cart_outlined, color: Colors.grey),
              selectedIcon: Icon(
                Icons.shopping_cart_outlined,
                color: Colors.deepOrange,
              ),
            ),
            IconButton(
              isSelected: selectedIndex == 4,
              onPressed: () {
                selectedIndex = 4;
                setState(() {});
              },
              icon: Icon(Icons.person_outline_rounded, color: Colors.grey),
              selectedIcon: Icon(
                Icons.person_outline_rounded,
                color: Colors.deepOrange,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          selectedIndex = 2;
          setState(() {

          });
        },
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(51),
        ),
        child: Icon(
          Icons.home_outlined,),
      ),
    );
  }
}