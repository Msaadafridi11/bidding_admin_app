import 'dart:async';
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

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isInitialCheckDone = false;
  bool _isAuthenticatedAdmin = false;
  StreamSubscription<User?>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _initAuthListener();
  }

  void _initAuthListener() {
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) {
        if (mounted) {
          setState(() {
            _isAuthenticatedAdmin = false;
            _isInitialCheckDone = true;
          });
        }
      } else {
        try {
          final doc = await FirebaseFirestore.instance
              .collection('userModel')
              .doc(user.uid)
              .get();

          if (doc.exists && doc.data() != null) {
            final userModel = UserModel.fromJson(doc.data()!);
            if (userModel.isRole == true) {
              if (mounted) {
                setState(() {
                  _isAuthenticatedAdmin = true;
                  _isInitialCheckDone = true;
                });
              }
              return;
            }
          }
        } catch (e) {
          debugPrint("Auth verification error: $e");
        }

        // If not an approved admin or error, ensure unauthenticated state
        if (mounted) {
          setState(() {
            _isAuthenticatedAdmin = false;
            _isInitialCheckDone = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialCheckDone) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_isAuthenticatedAdmin) {
      return const Bottemnevigationscreen();
    }

    return const Loginscreen();
  }
}

