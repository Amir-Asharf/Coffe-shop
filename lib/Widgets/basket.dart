import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BasketPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Center(
            child: Text(
          'Your Basket',
          style: TextStyle(color: Colors.white),
        )),
        backgroundColor: Color(0xff212325),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('basket').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!.docs;

          if (items.isEmpty) {
            return Center(
              child: Text(
                'Your basket is empty!',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            );
          }

          items.forEach((item) {
// حساب السعر الإجمالي
          });

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      leading: Image.asset(
                        "assets/images/${item['item']}.png",
                        width: 50,
                        height: 50,
                      ),
                      title: Text(
                        item['item'],
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Price: \$${item['price']} | Quantity: ${item['quantity']}',
                        style: TextStyle(color: Colors.white70),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('basket')
                              .doc(item.id)
                              .delete(); // حذف العنصر من السلة
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      backgroundColor: Color(0xff212325),
    );
  }
}
