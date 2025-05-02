import 'package:CoffeeShop/login.dart';
import 'package:CoffeeShop/screens/Welcome_screen.dart';
import 'package:CoffeeShop/screens/home_screen.dart';
import 'package:CoffeeShop/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/user_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  const FirebaseOptions(
    apiKey: 'AIzaSyDCrWZ9S-6rEas60F7uttbmO5nVmYbW4f4',
    appId: '1:271765655815:android:5515336163952830e2f5a2',
    messagingSenderId: '271765655815',
    projectId: 'untitled-b89ac',
  );
  runApp(myApp());
}

class myApp extends StatefulWidget {
  const myApp({super.key});

  @override
  State<myApp> createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('=====================User is currently signed out!');
      } else {
        print('========================User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Color(0xff212325)),
      home: FutureBuilder<bool>(
          future: _checkInitialRoute(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (FirebaseAuth.instance.currentUser == null ||
                !FirebaseAuth.instance.currentUser!.emailVerified) {
              return login();
            }

            // User is logged in and email is verified
            if (snapshot.data == true) {
              // User has seen welcome screen, go to home
              return HomeScreen();
            } else {
              // Show welcome screen first time
              return WelcomeScreen();
            }
          }),
      routes: {
        "login": (context) => login(),
        "signup": (context) => signup(),
        "WelcomeScreen": (context) => WelcomeScreen(),
        "HomeScreen": (context) => HomeScreen(),
      },
    );
  }

  Future<bool> _checkInitialRoute() async {
    if (FirebaseAuth.instance.currentUser != null &&
        FirebaseAuth.instance.currentUser!.emailVerified) {
      // Only check welcome screen status if user is logged in
      return await UserPreferences.hasSeenWelcome();
    }
    return false;
  }
}
