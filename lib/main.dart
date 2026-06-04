import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

  Widget foodCard(String imagePath, String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Image.asset(imagePath, width: double.infinity, height: 200, fit: BoxFit.cover),
            Align(
              alignment: Alignment.topRight,
              child: Icon(Icons.favorite, color: Colors.red),
            ),
          ],
        ),
        Text(title),
        Text(subtitle),
      ],
    );
  }

  Widget createLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Expanded(child: foodCard('images/food1.jpg', 'Burger and Fries', 'American')),
            Expanded(child: foodCard('images/food2.jpg', 'Mini Pizzas', 'Italian')),
          ],
        ),
        Row(
          children: [
            Expanded(child: foodCard('images/food3.jpg', 'Dumplings', 'Turkish')),
            Expanded(child: foodCard('images/food4.jpg', 'Sushi Platter', 'Japanese')),
          ],
        ),
        Row(
          children: [
            Expanded(child: foodCard('images/food5.jpg', 'Chocolate Brownie', 'Dessert')),
            Expanded(child: foodCard('images/food6.jpg', 'Red Velvet Cake', 'Dessert')),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Favourite Recipes')),
        body: SingleChildScrollView(child: createLayout()),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.black,), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.search, color: Colors.black), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.favorite, color: Colors.black), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart, color: Colors.black), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.person, color: Colors.black  ), label: ''),
          ],
        ),
      ),
    );
  }
}