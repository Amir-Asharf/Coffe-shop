import 'package:CoffeeShop/components/textformfield.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
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
              padding: EdgeInsets.all(20),
              child: Form(
                key: formstate, // تأكد من أن الـ Form يحتوي على GlobalKey
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // لتوسيط المحتوى عموديًا
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // لتوسيط المحتوى أفقيًا
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    Center(
                      child: Text(
                        "SignIN",
                        style: GoogleFonts.pacifico(
                          fontSize: 50,
                          color: Color(0xFFE57734),
                        ),
                      ),
                    ),
                    SizedBox(height: 160),
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
                    SizedBox(
                      height: 30,
                    ),
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
                    SizedBox(
                      height: 90,
                    ),
                    Center(
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        height: 40,
                        minWidth: double.infinity,
                        textColor: Colors.white,
                        color: const Color(0xFFE57734),
                        onPressed: () async {
                          if (formstate.currentState!.validate()) {
                            try {
                              isloading = true;
                              setState(() {});

                              // تسجيل الدخول باستخدام البريد وكلمة المرور
                              final credential = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                email: email.text,
                                password: password.text,
                              );

                              isloading = false;
                              setState(() {});

                              // التحقق من حالة البريد الإلكتروني
                              if (credential.user!.emailVerified) {
                                Navigator.of(context)
                                    .pushReplacementNamed("WelcomeScreen");
                              } else {
                                await FirebaseAuth.instance.currentUser!
                                    .sendEmailVerification();

                                await AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.success,
                                  animType: AnimType.rightSlide,
                                  title: 'Successfully',
                                  desc:
                                      'Please go to your email and click activate account.',
                                  btnOkOnPress: () {},
                                ).show();
                              }
                            } on FirebaseAuthException catch (e) {
                              isloading = false;
                              setState(() {});

                              // معالجة الأخطاء
                              if (e.code == 'user-not-found') {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  title: 'Error',
                                  desc: 'No user found for that email.',
                                ).show();
                              } else if (e.code == 'wrong-password') {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.info,
                                  animType: AnimType.rightSlide,
                                  title: 'Error',
                                  desc:
                                      'Wrong password provided for that user.',
                                ).show();
                              } else {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  title: 'Error',
                                  desc:
                                      'An unexpected error occurred. Please try again.',
                                ).show();
                              }
                            } catch (e) {
                              isloading = false;
                              setState(() {});

                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc:
                                    'An unexpected error occurred. Please try again later.',
                              ).show();
                            }
                          } else {
                            print("Form is not valid");
                          }
                        },
                        child: const Text(
                          "SIGN IN",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (email.text == "") {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'error ',
                            desc:
                                'please write your email and click forgot password',
                          ).show();
                          return;
                        }

                        try {
                          await FirebaseAuth.instance
                              .sendPasswordResetEmail(email: email.text);
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.success,
                            animType: AnimType.rightSlide,
                            title: 'confirm ',
                            desc:
                                'A Password reset message has been sent to your email. Please go to your email and change your password',
                          ).show();
                        } catch (e) {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'error ',
                            desc: "Please check the email you entered",
                          ).show();
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 65, bottom: 20),
                        alignment: Alignment.topRight,
                        child: Text.rich(TextSpan(children: [
                          TextSpan(
                              text: "forgot ",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          TextSpan(
                              text: "password",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold))
                        ])),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed("signup");
                          },
                          child: Center(
                            child: Text.rich(TextSpan(children: [
                              TextSpan(
                                  text: "Don’t Have an account? ",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              TextSpan(
                                  text: "signup",
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Color(0xFFE57734),
                                      fontWeight: FontWeight.bold))
                            ])),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 350),
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
