// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class UserProfilePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final User? user = FirebaseAuth.instance.currentUser;
//     final User? SURNAME = FirebaseAuth.instance.currentUser;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('                User Profile'),
//         backgroundColor: Color(0xFF212325),
//         elevation: 0,
//         iconTheme: IconThemeData(color: Colors.white), // لون السهم أبيض
//         titleTextStyle: TextStyle(
//           color: Colors.white, // لون النص أبيض
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             CircleAvatar(
//               radius: 50,
//               backgroundColor: Color(0xFFE57734),
//               child: Icon(
//                 Icons.person,
//                 size: 50,
//                 color: Colors.white,
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Name: ${user?.displayName ?? 'No Name Available'}',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//             Text(
//               'SURNAME: ${SURNAME?.displayName ?? 'No Name Available'}',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Email: ${user?.email ?? 'No Email Available'}',
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.grey[300],
//               ),
//             ),
//           ],
//         ),
//       ),
//       backgroundColor: Color(0xFF212325),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    String displayName = user?.displayName ?? 'No Name Available';
    List<String> nameParts = displayName.split(' '); // تقسيم الاسم الكامل
    String firstName = nameParts.isNotEmpty ? nameParts[0] : 'No Name';
    String surname = nameParts.length > 1 ? nameParts[1] : 'No Surname';

    return Scaffold(
      appBar: AppBar(
        title: Text('                User Profile'),
        backgroundColor: Color(0xFF212325),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white), // لون السهم أبيض
        titleTextStyle: TextStyle(
          color: Colors.white, // لون النص أبيض
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFFE57734),
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Name: $firstName',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Surname: $surname',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Email: ${user?.email ?? 'No Email Available'}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xFF212325),
    );
  }
}
