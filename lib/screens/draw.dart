import 'package:CoffeeShop/Widgets/FavoritesScreen%20.dart';
import 'package:CoffeeShop/Widgets/UserProfilePage.dart';
import 'package:CoffeeShop/Widgets/basket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class drawer extends StatefulWidget {
  final Function(int) onTabSelected;
  const drawer({super.key, required this.onTabSelected});

  @override
  State<drawer> createState() => _drawerState();
}

class _drawerState extends State<drawer> {
  final TextEditingController _feedbackController = TextEditingController();

  Future<void> _submitFeedback() async {
    String feedbackText = _feedbackController.text.trim();

    if (feedbackText.isNotEmpty) {
      try {
        // الحصول على اسم المستخدم
        String? username = FirebaseAuth.instance.currentUser?.displayName;

        // إضافة التعليق إلى Firebase في مجموعة 'feedback'
        await FirebaseFirestore.instance.collection('feedback').add({
          'feedback': feedbackText,
          'username':
              username ?? 'Anonymous', // في حال لم يكن هناك اسم للمستخدم
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Feedback submitted successfully!")),
        );

        // مسح النص بعد الإرسال
        _feedbackController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to submit feedback: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter some feedback")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Theme(
        data: ThemeData(
          iconTheme: IconThemeData(color: Colors.white),
        ),
        child: Container(
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(color: Color(0xFFE57734), Icons.coffee),
                  Text(
                    "Coffe Shop",
                    style: GoogleFonts.pacifico(
                      fontSize: 20,
                      color: Color(0xFFE57734),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Leave Feedback Please",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              // Feedback Section
              TextFormField(
                controller: _feedbackController,
                style: TextStyle(color: Colors.black), // لون النص داخل الحقل
                cursorColor: Colors.black, // لون المؤشر

                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.black, // لون نص التلميح
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 17,
                      horizontal: 10), // المسافة حول النص داخل الحقل
                  border: UnderlineInputBorder(
                    // الخط تحت الحقل
                    borderSide: BorderSide(
                      color: Colors.black, // لون الخط تحت الحقل
                      width: 2, // سمك الخط
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    // الخط عند التحديد
                    borderSide: BorderSide(
                      color: Colors.black, // لون الخط عند التركيز
                      width: 2,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    // الخط عند التفعيل
                    borderSide: BorderSide(
                      color: Colors.black, // لون الخط عند التفعيل
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.transparent, // خلفية شفافة
                ),
              ),
              SizedBox(height: 12),
              Center(
                child: ElevatedButton(
                  onPressed: _submitFeedback,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE57734),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    "Submit",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.person_2_sharp),
                title: Text('Account'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfilePage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.favorite),
                title: Text('Favorites'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => favoritespage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.shopping_basket),
                title: Text('Basket'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BasketPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.coffee_outlined),
                title: Text('Coffee'),
                onTap: () {
                  Navigator.pop(context);
                  widget.onTabSelected(1);
                },
              ),
              ListTile(
                leading: Icon(Icons.free_breakfast_sharp),
                title: Text('Tea'),
                onTap: () {
                  Navigator.pop(context);
                  widget.onTabSelected(2);
                },
              ),
              ListTile(
                leading: Icon(Icons.local_bar_sharp),
                title: Text('Cold'),
                onTap: () {
                  Navigator.pop(context);
                  widget.onTabSelected(3);
                },
              ),
              ListTile(
                leading: Icon(Icons.local_fire_department_outlined),
                title: Text('Hot'),
                onTap: () {
                  Navigator.pop(context);
                  widget.onTabSelected(4);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.arrow_left_rounded,
                  size: 27,
                ),
                title: Text('LogOut'),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("login", (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
