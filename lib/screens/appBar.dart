import 'package:CoffeeShop/Widgets/FavoritesScreen%20.dart';
import 'package:CoffeeShop/Widgets/basket.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class appBar extends StatefulWidget {
  const appBar({super.key});

  @override
  State<appBar> createState() => _appBarState();
}

class _appBarState extends State<appBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(color: Color(0xFFE57734), Icons.coffee),
          Text(
            "Coffee Shop",
            style: GoogleFonts.pacifico(
              fontSize: 30,
              color: Color(0xFFE57734),
            ),
          ),
        ],
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BasketPage()),
              );
            },
            child: Icon(
              Icons.shopping_basket,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => favoritespage()),
              );
            },
            child: Icon(
              Icons.favorite,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ],
      backgroundColor: Color(0xff212325),
    );
  }
}
