import 'package:CoffeeShop/Widgets/items_widget.dart';
import 'package:CoffeeShop/screens/appBar.dart';
import 'package:CoffeeShop/screens/draw.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tapController;
  List<String> favorites = [];
  int selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> imageList = [
    'assets/images/American.png',
    'assets/images/Black Coffee.png',
    'assets/images/Black Tea Latte.png',
    'assets/images/Capuchino.png',
    'assets/images/Caramel Cold.png',
    'assets/images/Caramel Macchiato.png',
    'assets/images/Caramelized Latte.png',
    'assets/images/Espresso.png',
    'assets/images/ice Coffee.png',
    'assets/images/ice Frappuccino.png',
    'assets/images/ice Latte.png',
    'assets/images/Iced Coffee Mocha.png',
    'assets/images/Irish Coffee.png',
    'assets/images/Latte.png',
    'assets/images/Toffee Latte.png',
    'assets/images/Toffee Nut Latte.png',
  ];

  // قائمة أسماء المنتجات
  final List<String> productNames = [
    "American Coffee",
    "Black Coffee",
    "Black Tea Latte",
    "Capuchino",
    "Caramel Cold",
    "Caramel Macchiato",
    "Caramelized Latte",
    "Espresso",
    "Ice Coffee",
    "Ice Frappuccino",
    "Ice Latte",
    "Iced Coffee Mocha",
    "Irish Coffee",
    "Latte",
    "Toffee Latte",
    "Toffee Nut Latte",
  ];

  @override
  void initState() {
    super.initState();
    _tapController = TabController(length: 5, vsync: this, initialIndex: 0);
    _tapController.addListener(() {
      setState(() {});
    });
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _tapController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: appBar(),
      ),
      drawer: drawer(
        onTabSelected: (index) {
          setState(() {
            _tapController.index = index;
          });
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 45),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "It's a Great Day for Coffee",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  width: MediaQuery.of(context).size.width,
                  height: 45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          spreadRadius: 1,
                          blurRadius: 8,
                        ),
                      ],
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(40)),
                  child: TextFormField(
                    controller: _searchController,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search drink....?",
                      hintStyle: TextStyle(
                        color: Color(0xFFE57734),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Color(0xFFE57734),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 11.0, horizontal: 20.0),
                      alignLabelWithHint: true,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                // إضافة السلايدر
                CarouselSlider(
                  options: CarouselOptions(
                    height: 230.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    onPageChanged: (index, reason) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  ),
                  items: imageList
                      .asMap()
                      .map((index, item) {
                        return MapEntry(
                          index,
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(1),
                                  child: Image.asset(
                                    item,
                                    width: MediaQuery.of(context).size.width,
                                    height: 150,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  productNames[index],
                                  style: TextStyle(
                                    color: Color(0xFFE57734),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                      .values
                      .toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imageList.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => setState(() => selectedIndex = entry.key),
                      child: Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (selectedIndex == entry.key
                              ? Color(0xFFE57734)
                              : Colors.white),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 30,
                ),
                TabBar(
                  dividerColor: Color(0xff212325),
                  controller: _tapController,
                  labelColor: Color(0xFFE57734),
                  unselectedLabelColor: Colors.white,
                  isScrollable: true,
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 3, color: Color(0xFFE57734)),
                    insets: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  labelStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  labelPadding: EdgeInsets.symmetric(horizontal: 20),
                  tabs: [
                    Tab(text: "All"),
                    Tab(text: "Coffee"),
                    Tab(text: "Tea"),
                    Tab(text: "Cold"),
                    Tab(text: "Hot"),
                  ],
                ),

                Center(
                  child: ItemsWidget(
                    favoritespage: favorites,
                    selectedIndex: _tapController.index,
                    searchQuery: _searchQuery,
                    productNames: productNames,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
