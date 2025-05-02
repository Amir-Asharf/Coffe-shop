import 'package:flutter/material.dart';

import '../screens/single_item_screen.dart';

class ItemsWidget extends StatelessWidget {
  final List<String> img = [
    'Espresso',
    'Black Coffee',
    'Latte',
    'ice Coffee',
    'ice Frappuccino',
    'American',
    'Black Tea Latte',
    'Capuchino',
    'Caramel Cold',
    'Caramel Macchiato',
    'Caramelized Latte',
    'Irish Coffee',
    'Iced Coffee Mocha',
    'Toffee Latte',
    'Toffee Nut Latte',
  ];

  final List<double> prices = [
    5.0,
    4.0,
    3.5,
    4.5,
    4.0,
    6.0,
    3.0,
    2.0,
    3.5,
    5.0,
    6.5,
    3.0,
    5.5,
    5.0,
    7.0,
    6.0,
  ];

  final List<double> star = [
    4.7,
    4.2,
    3.4,
    4.6,
    4.8,
    5.0,
    3.8,
    3.5,
    3.1,
    5.0,
    4.2,
    3.8,
    5.0,
    3.4,
    4.9,
    4.7,
  ];

  final List<String> coffeeItems = [
    'Latte',
    'Espresso',
    'Black Coffee',
    'American',
    'Capuchino',
  ];

  final List<String> teaItems = [
    'Black Tea Latte',
  ];

  final List<String> coldItems = [
    'ice Coffee',
    'ice Frappuccino',
    'Caramel Cold',
    'Iced Coffee Mocha',
    'Caramel Macchiato',
    'Caramelized Latte',
    'Toffee Latte',
    'Toffee Nut Latte',
  ];

  final List<String> hotItems = [
    'Latte',
    'Espresso',
    'Black Coffee',
    'American',
    'Black Tea Latte',
    'Capuchino',
    'Irish Coffee',
  ];

  final List<String> favoritespage;
  final int selectedIndex;
  final String searchQuery;
  final List<String> productNames;

  ItemsWidget({
    required this.favoritespage,
    required this.selectedIndex,
    required this.searchQuery,
    required this.productNames,
  });

  @override
  Widget build(BuildContext context) {
    List<String> itemsToDisplay = [];

    // Apply search filter first
    if (searchQuery.isNotEmpty) {
      // Search through all available drinks
      itemsToDisplay = img
          .where((item) =>
              item.toLowerCase().contains(searchQuery.toLowerCase()) ||
              item
                  .replaceAll(' ', '')
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
          .toList();
    } else {
      // If no search, show items based on selected tab
      if (selectedIndex == 0) {
        itemsToDisplay = [
          ...coffeeItems,
          ...teaItems,
          ...coldItems,
          ...hotItems
        ];
      } else if (selectedIndex == 1) {
        itemsToDisplay = coffeeItems;
      } else if (selectedIndex == 2) {
        itemsToDisplay = teaItems;
      } else if (selectedIndex == 3) {
        itemsToDisplay = coldItems;
      } else if (selectedIndex == 4) {
        itemsToDisplay = hotItems;
      }
    }

    if (itemsToDisplay.isEmpty) {
      return Center(
        child: Text(
          "لم يتم العثور على المشروب",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (searchQuery.isNotEmpty) ...[
            Container(
              height: 280,
              child: ListView.builder(
                padding: EdgeInsets.all(12),
                scrollDirection: Axis.horizontal,
                itemCount: itemsToDisplay.length,
                itemBuilder: (context, index) {
                  return _buildListItem(context, itemsToDisplay[index]);
                },
              ),
            ),
          ] else if (selectedIndex != 0) ...[
            _buildListView(itemsToDisplay),
          ] else ...[
            _buildListViewForAll(coffeeItems, "Coffee"),
            _buildListViewForAll(teaItems, "Tea"),
            _buildListViewForAll(coldItems, "Cold Drinks"),
            _buildListViewForAll(hotItems, "Hot Drinks"),
          ],
        ],
      ),
    );
  }

  String _getCategoryName(int selectedIndex) {
    if (selectedIndex == 1) return "Coffee";
    if (selectedIndex == 2) return "Tea";
    if (selectedIndex == 3) return "Cold Drinks";
    if (selectedIndex == 4) return "Hot Drinks";
    return "All Items";
  }

  Widget _buildListView(List<String> items) {
    return Container(
      //كوفي
      height: 210,
      child: ListView.builder(
        padding: EdgeInsets.all(12),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _buildListItem(context, items[index]);
        },
      ),
    );
  }

  Widget _buildListViewForAll(List<String> items, String categoryName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Text(
            categoryName,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE57734),
            ),
          ),
        ),
        Container(
          height: 210, // ال all
          child: ListView.builder(
            padding: EdgeInsets.all(12),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return _buildListItem(context, items[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(BuildContext context, String item) {
    int index = img.indexOf(item);

    if (index == -1) {
      return SizedBox.shrink();
    }

    return Container(
      width: 190,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Color(0xFF212325),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFE57734),
            spreadRadius: 1,
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 25,
              ),
              Icon(color: const Color.fromARGB(255, 230, 212, 54), Icons.star),
              Text(
                "${star[index]}",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SingleItemScreen(
                    img: img[index],
                    price: prices[index],
                    favoritespage: favoritespage,
                  ),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/${img[index]}.png",
                  width: 90,
                  height: 70,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          Text(
            img[index],
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE57734),
            ),
          ),
          SizedBox(height: 10),
          Text(
            "\$${prices[index].toStringAsFixed(2)}",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
