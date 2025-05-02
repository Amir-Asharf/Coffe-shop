import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/user_preferences.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      padding: EdgeInsets.only(top: 100, bottom: 40),
      decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
            opacity: 0.6,
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Coffee Shop",
            style: GoogleFonts.pacifico(
              fontSize: 50,
              color: Colors.white,
            ),
          ),
          Column(
            children: [
              Text(
                "Feeling Low? Take a Sip of Coffee",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 80),
              Material(
                color: Color(0xFFE57734),
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () async {
                    // Mark welcome screen as seen
                    await UserPreferences.setHasSeenWelcome();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    child: Text(
                      "Get Start",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    ));
  }
}
