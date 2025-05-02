import 'package:flutter/material.dart';

class customtextform extends StatelessWidget {
  final String hinttext;
  final TextEditingController mycontroller;
  final String? Function(String?)? validator;

  const customtextform({
    super.key,
    required this.hinttext,
    required this.mycontroller,
    required this.validator,
    required TextEditingController MYcontroller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.white), // لون النص داخل الحقل
      cursorColor: Colors.white, // لون المؤشر
      validator: validator,
      controller: mycontroller,
      decoration: InputDecoration(
        hintText: hinttext, // نص التلميح
        hintStyle: TextStyle(
          fontSize: 15,
          color: Colors.white, // لون نص التلميح
        ),
        contentPadding: EdgeInsets.symmetric(
            vertical: 17, horizontal: 10), // المسافة حول النص داخل الحقل
        border: UnderlineInputBorder(
          // الخط تحت الحقل
          borderSide: BorderSide(
            color: Colors.white, // لون الخط تحت الحقل
            width: 2, // سمك الخط
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          // الخط عند التحديد
          borderSide: BorderSide(
            color: Colors.white, // لون الخط عند التركيز
            width: 2,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          // الخط عند التفعيل
          borderSide: BorderSide(
            color: Colors.white, // لون الخط عند التفعيل
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Colors.transparent, // خلفية شفافة
      ),
    );
  }
}
