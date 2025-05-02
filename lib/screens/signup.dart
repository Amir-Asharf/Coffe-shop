import 'package:CoffeeShop/components/textformfield.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  TextEditingController username = TextEditingController();
  TextEditingController SURNAME = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // إضافة صورة خلفية
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.jpg", // مسار الصورة
              fit: BoxFit.cover, // تغطي الشاشة بالكامل
            ),
          ),

          // الحقول والزر
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formstate, // تأكد من أن الـ Form يحتوي على GlobalKey
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // لتوسيط المحتوى عموديًا
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // لتوسيط المحتوى أفقيًا
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed("login");
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        )),
                    Center(
                      child: Text(
                        "Sign UP",
                        style: GoogleFonts.pacifico(
                          fontSize: 50,
                          color: const Color(0xFFE57734),
                        ),
                      ),
                    ),
                    const SizedBox(height: 110),
                    customtextform(
                      hinttext: "NAME",
                      mycontroller: username,
                      MYcontroller: username,
                      validator: (val) {
                        if (val == "") {
                          return "can’t be empty";
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    customtextform(
                      hinttext: "SURNAME",
                      mycontroller: SURNAME,
                      MYcontroller: SURNAME,
                      validator: (val) {
                        if (val == "") {
                          return "can’t be empty";
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    customtextform(
                      hinttext: "EMAIL",
                      mycontroller: email,
                      MYcontroller: email,
                      validator: (val) {
                        if (val == "") {
                          return "can’t be empty";
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    customtextform(
                      hinttext: "PASSWORD",
                      mycontroller: password,
                      MYcontroller: password,
                      validator: (val) {
                        if (val == "") {
                          return "can’t be empty";
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    customtextform(
                      hinttext: "REPEAT PASSWORD",
                      mycontroller: confirmPassword,
                      MYcontroller: confirmPassword,
                      validator: (val) {
                        if (val == "") {
                          return "can’t be empty";
                        }
                        if (val != password.text) {
                          return "Passwords do not match"; // التحقق من تطابق كلمة المرور
                        }
                      },
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: 40,
                          textColor: Colors.white,
                          color: const Color(0xFFE57734),
                          onPressed: () async {
                            if (formstate.currentState!.validate()) {
                              try {
                                // إنشاء حساب عبر Firebase
                                final credential = await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                  email: email.text,
                                  password: password.text,
                                );

                                // تحديث الاسم الكامل للمستخدم
                                String fullName =
                                    "${username.text} ${SURNAME.text}";
                                await credential.user
                                    ?.updateDisplayName(fullName);

                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.success,
                                  animType: AnimType.rightSlide,
                                  title: 'Account Created',
                                  desc:
                                      'Your account has been created successfully. Please go to the Sign In page and log in with your account.',
                                  btnOkOnPress: () {
                                    // الانتقال إلى صفحة تسجيل الدخول بعد إغلاق الحوار
                                    Navigator.of(context)
                                        .pushReplacementNamed("login");
                                  },
                                ).show();
                              } on FirebaseAuthException catch (e) {
                                // معالجة أخطاء Firebase
                                if (e.code == "weak-password") {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.rightSlide,
                                    title: 'Error',
                                    desc: 'The password provided is too weak.',
                                  ).show();
                                } else if (e.code == 'email-already-in-use') {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.info,
                                    animType: AnimType.rightSlide,
                                    title: 'Error',
                                    desc:
                                        'The account already exists for that email.',
                                  ).show();
                                }
                              } catch (e) {
                                // معالجة الأخطاء العامة
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  title: 'Error',
                                  desc:
                                      'An unexpected error occurred. Please try again later.',
                                ).show();
                              }
                            }
                          },
                          child: const Text(
                            "signup",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed("login");
                      },
                      child: const Center(
                        child: Text.rich(TextSpan(children: [
                          TextSpan(
                              text: "Have an account? ",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          TextSpan(
                              text: "login",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Color(0xFFE57734),
                                  fontWeight: FontWeight.bold))
                        ])),
                      ),
                    ),
                    const SizedBox(height: 350),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
