import 'package:bidding_admin/AuthenticationScreens/LoginScreen.dart';
import 'package:bidding_admin/Models/user_model.dart';
import 'package:bidding_admin/Screens/BottemNevigationScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//
// class AuthWrapper extends StatefulWidget {
//   const AuthWrapper({super.key});
//
//   @override
//   State<AuthWrapper> createState() => _AuthWrapperState();
// }
//
// class _AuthWrapperState extends State<AuthWrapper> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasData) {
//             return const Bottemnevigationscreen();
//       }
//       return const Loginscreen();
//     });
//   }
// }

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 1. Check Connection State
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2. Agar User Login Mil Gaya (snapshot.hasData)
        if (snapshot.hasData && snapshot.data != null) {
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('userModel') // Aapka collection name
                .doc(snapshot.data!.uid)
                .get(),
            builder: (context, docSnapshot) {
              if (docSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('wating ...', style: TextStyle(fontSize: 20),),
                      Text('if process come back to Login Screen then you should idea that your not allowd', style: TextStyle(fontSize: 15),),
                    ],
                  )),
                );
              }

              if (docSnapshot.hasData && docSnapshot.data!.exists) {
                // 🔥 Yahan Model use ho raha hai
                UserModel userModel = UserModel.fromJson(
                  docSnapshot.data!.data() as Map<String, dynamic>,
                );

                // Role check karein
                if (userModel.isRole == true) {
                  return const Bottemnevigationscreen();
                } else {
                  // Agar role false hai to sign out karein aur login par rakhein
                  _forceSignOut();
                  return const Loginscreen();
                }
              }

              // Agar user ka record Firestore mein nahi mila
              _forceSignOut();
              return const Loginscreen();
            },
          );
        }

        // 3. Agar User Login Nahi Hai
        return const Loginscreen();
      },
    );
  }

  // Helper function to handle sign out
  void _forceSignOut() async {
    await FirebaseAuth.instance.signOut();
  }
}

