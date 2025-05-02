import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class SingleItemScreen extends StatefulWidget {
  final String img;
  final double price;
  final List<String> favoritespage;

  SingleItemScreen({
    required this.img,
    required this.price,
    required this.favoritespage,
  });

  @override
  _SingleItemScreenState createState() => _SingleItemScreenState();
}

class _SingleItemScreenState extends State<SingleItemScreen> {
  bool isfavoritespage = false;
  int quantity = 1; // العدد الافتراضي
  double totalPrice = 0.0; // السعر الإجمالي
  List<String> sizes = ["S"]; // قائمة الأحجام
  List<int> sugarLevels = [2]; // قائمة مستويات السكر
  int rating = 0; // التقييم الافتراضي
  TextEditingController tableNumberController =
      TextEditingController(); // متغير لإدخال رقم الطاولة

  // @override
  // void initState() {
  //   super.initState();
  //   isfavoritespage = widget.favoritespage.contains(widget.img);
  //   totalPrice = widget.price; // تعيين السعر الإجمالي المبدئي
  // }

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus(); // التحقق من حالة المفضلة عند تحميل الصفحة
    totalPrice = widget.price; // تعيين السعر الإجمالي المبدئي
  }

  // دالة للتحقق من حالة المفضلة
  void _checkFavoriteStatus() async {
    String? username = FirebaseAuth.instance.currentUser?.displayName;
    if (username == null) return;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('favorites')
        .where('item', isEqualTo: widget.img)
        .where('username', isEqualTo: username)
        .get();

    setState(() {
      isfavoritespage = querySnapshot.docs.isNotEmpty; // تحديث حالة المفضلة
    });
  }

  void _updateTotalPrice() {
    double newTotalPrice = 0.0;
    for (int i = 0; i < quantity; i++) {
      double itemPrice = widget.price;

      // إضافة الزيادة بناءً على الحجم
      if (sizes[i] == "M") {
        itemPrice += 2;
      } else if (sizes[i] == "L") {
        itemPrice += 4;
      }

      newTotalPrice += itemPrice; // إضافة السعر لكل عنصر
    }

    setState(() {
      totalPrice = newTotalPrice;
    });
  }

  Future<void> _submitRating() async {
    try {
      String? username = FirebaseAuth.instance.currentUser?.displayName;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('ratings')
          .where('item', isEqualTo: widget.img)
          .where('username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          await doc.reference.delete();
        }
      }

      await FirebaseFirestore.instance.collection('ratings').add({
        'item': widget.img,
        'rating': rating,
        'username': username,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Rating submitted successfully!"),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to submit rating: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 30, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await _addtoFirebase();
                          setState(() {
                            isfavoritespage = !isfavoritespage;
                          });
                        },
                        icon: Icon(
                          isfavoritespage
                              ? Icons.favorite
                              : Icons.favorite_outline,
                          color: isfavoritespage ? Colors.red : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  child: Image.asset(
                    "assets/images/${widget.img}.png",
                    width: MediaQuery.of(context).size.width / 1.2,
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "BEST COFFEE",
                        style: TextStyle(color: Colors.white.withOpacity(0.4)),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.img,
                            style: TextStyle(
                              fontSize: 20,
                              letterSpacing: 1,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                iconSize: 30,
                                icon: Icon(
                                  Icons.remove_circle_outlined,
                                  color: Color(0xFFE57734),
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (quantity > 1) {
                                      quantity--;
                                      sizes.removeLast();
                                      sugarLevels.removeLast();
                                      _updateTotalPrice();
                                    }
                                  });
                                },
                              ),
                              Text(
                                quantity.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                iconSize: 30,
                                icon: Icon(
                                  Icons.add_circle,
                                  color: Color(0xFFE57734),
                                ),
                                onPressed: () {
                                  setState(() {
                                    quantity++;
                                    sizes.add("S");
                                    sugarLevels.add(2);
                                    _updateTotalPrice();
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: List.generate(5, (index) {
                          return IconButton(
                            icon: Icon(
                              index < rating ? Icons.star : Icons.star_border,
                              color: Colors.yellow,
                            ),
                            onPressed: () {
                              setState(() {
                                rating = index + 1;
                              });
                              _submitRating();
                            },
                          );
                        }),
                      ),
                      Text(
                        "Please Rate the Drink After Drinking it .",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 30),
                      TextField(
                        controller: tableNumberController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Enter Table Number",
                          hintStyle: TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: Colors.white24,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 30),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: quantity,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Item ${index + 1}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE57734),
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                "Choose Size",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 12),
                              Wrap(
                                spacing: 30,
                                children: [
                                  _buildSizeOption("S", index),
                                  _buildSizeOption("M", index),
                                  _buildSizeOption("L", index),
                                ],
                              ),
                              SizedBox(height: 15),
                              Text(
                                "Sugar Level",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 10),
                              Wrap(
                                spacing: 15,
                                runSpacing: 20,
                                children: [
                                  _buildSugarOption(0, index),
                                  _buildSugarOption(1, index),
                                  _buildSugarOption(2, index),
                                  _buildSugarOption(3, index),
                                  _buildSugarOption(4, index),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Price \$${totalPrice.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                await _addToFirebase();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFE57734),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: Text(
                                "Buy Now",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSizeOption(String size, int index) {
    double price = widget.price;
    if (size == "M") price += 2;
    if (size == "L") price += 4;

    return GestureDetector(
      onTap: () {
        setState(() {
          sizes[index] = size; // تحديث الحجم
          _updateTotalPrice(); // تحديث السعر الإجمالي
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
        decoration: BoxDecoration(
          gradient: sizes[index] == size
              ? LinearGradient(
                  colors: [Color(0xFFE57734), Color(0xFFFC8A3D)], // تدرج لوني
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [Colors.white24, Colors.white24], // تدرج لوني شفاف
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(50), // زاوية دائرية أكثر
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 4),
            ), // إضافة تأثير الظل
          ],
        ),
        child: Text(
          size,
          style: TextStyle(
            color: sizes[index] == size ? Colors.white : Colors.white70,
            fontSize: 24, // تقليل الحجم ليكون أكثر توازنًا
            fontWeight: FontWeight.w600, // تحسين سمك الخط
          ),
        ),
      ),
    );
  }

  Widget _buildSugarOption(int level, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          sugarLevels[index] = level;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color:
              sugarLevels[index] == level ? Color(0xFFE57734) : Colors.white24,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          "$level spoons",
          style: TextStyle(
            color: sugarLevels[index] == level ? Colors.white : Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _addToFirebase() async {
    if (tableNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Enter Table Number!"),
          duration: Duration(seconds: 3),
        ),
      );
      return; // الخروج من الدالة فقط، ولكن يبقى على الصفحة
    }
    try {
      String? displayName = FirebaseAuth.instance.currentUser?.displayName;
      if (displayName == null || displayName.isEmpty) {
        displayName = 'No Name'; // إذا كان الاسم غير موجود
      }

      var uuid = Uuid();
      String orderId = uuid.v4(); // توليد معرف فريد للطلب

      await FirebaseFirestore.instance.collection('orders').doc(orderId).set({
        'item': widget.img,
        'table_number': tableNumberController.text,
        'price': totalPrice, // إرسال السعر الإجمالي
        'quantity': quantity,
        'sizes': sizes,
        'sugar_levels': sugarLevels,
        'username': displayName, // استخدام الاسم الكامل
        'timestamp': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance.collection('basket').doc(orderId).set({
        'item': widget.img,
        'price': totalPrice,
        'quantity': quantity,
        'sizes': sizes,
        'sugar_levels': sugarLevels,
        'username': displayName,
        'table_number': tableNumberController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Order placed successfully! Please Wait 5-10 minutes for delivery."),
          duration: Duration(seconds: 10),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to place order: $e"),
        ),
      );
    }
  }

 

  Future<void> _addtoFirebase() async {
    try {
      String? username = FirebaseAuth.instance.currentUser?.displayName;
      if (username == null) return;

      // التحقق من وجود العنصر بالفعل في المفضلة
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .where('item', isEqualTo: widget.img)
          .where('username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // إذا كان العنصر موجودًا، يتم حذفه
        for (var doc in querySnapshot.docs) {
          await doc.reference.delete();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Removed from favorites!"),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        // إذا لم يكن العنصر موجودًا، يتم إضافته
        await FirebaseFirestore.instance.collection('favorites').add({
          'item': widget.img,
          'username': username,
          'timestamp': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Added to favorites!"),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update favorites: $e"),
        ),
      );
    }
  }
}
