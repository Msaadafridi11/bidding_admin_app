// import 'package:bidding_admin/Screens/BottemNevigationScreen.dart';
// import 'package:bidding_admin/WidgetsScreen/CustomTextFormField.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class Loginscreen extends StatefulWidget {
//   const Loginscreen({super.key});
//
//   @override
//   State<Loginscreen> createState() => _LoginscreenState();
// }
//
// class _LoginscreenState extends State<Loginscreen> {
//   bool isBusy=false;
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.blue,
//         body: SafeArea(
//             child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
//           child: Form(
//             key: _formKey,
//             child: ListView(
//               children: [
//                 Center(
//                     child: Text(
//                   'Login here',
//                   style: GoogleFonts.aDLaMDisplay(fontSize: 20),
//                 )),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Custemtextformfield(
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your email';
//                       }
//                       if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                         return 'Please enter a valid email address';
//                       }
//                       return null;
//                     },
//                     controller: _emailController,
//                     hintText: 'Enter your email',
//                     maxLines: 1,
//                     readOnly: false,
//                     fillColor: Colors.white,
//                     filled: true,
//                     label: Text('Email'),
//                   ),
//                 ),
//                 Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Custemtextformfield(
//
//                       validator: (value){
//                         if(value==null || value.isEmpty){
//                           return 'Please enter your password';
//                         }
//                         if(value.length<6){
//                           return 'Password must be at least 6 characters long';
//                         }
//                         return null;
//                       },
//                       controller: _passwordController,
//                       hintText: 'Enter your password',
//                       maxLines: 1,
//                       readOnly: false,
//                       filled: true,
//                       fillColor: Colors.white,
//                       label: Text('Password'),
//                     )),
//                GestureDetector(
//                   onTap: isBusy ? null : () async {
//
//                     if (!_formKey.currentState!.validate()) {
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           content: Text('please fill all required fields')));
//                       return;
//                     }
//                     setState(() {
//                       isBusy=true;
//                     });
//                     try {
//                       final userCredential =
//                           await FirebaseAuth.instance.signInWithEmailAndPassword(
//                         email: _emailController.text.trim(),
//                         password: _passwordController.text.trim(),
//                       );
//                       ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text('Login Successful')));
//                           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Bottemnevigationscreen(),));
//                       print('User logged in: ${userCredential.user?.email}');
//                     } on FirebaseAuthException catch (e) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text('Login Failed: ${e.message}')));
//                       print('Login Failed: $e');
//                     }finally{
//                     setState(() {
//                       isBusy=false;
//                     });
//                     }
//                   },
//                   child: Container(
//                     width: double.infinity,
//                     height: 50,
//                     margin: EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                         color: Colors.green,
//                         borderRadius: BorderRadius.circular(5)),
//                     child: Center(
//                         child: isBusy? const CircularProgressIndicator(
//                           color: Colors.white,
//                         ): const
//                         Text(
//                       'Login',
//                       style: TextStyle(color: Colors.white, fontSize: 18),
//                     )),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         )));
//   }
// // }
// //}
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// // Aapke projects ke original imports
// import 'package:bidding_admin/Screens/BottemNevigationScreen.dart';
// import 'package:bidding_admin/WidgetsScreen/CustomTextFormField.dart';
// import 'package:bidding_admin/models/user_model.dart';
//
// class Loginscreen extends StatefulWidget {
//   const Loginscreen({super.key});
//
//   @override
//   State<Loginscreen> createState() => _LoginscreenState();
// }
//
// class _LoginscreenState extends State<Loginscreen> {
//   bool isBusy = false;
//   String? errorMessage; // 👈 Ismein hum message save karenge
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//
//   Future<void> loginUser() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() {
//       isBusy = true;
//       errorMessage = null; // Purana error saaf kar dein
//     });
//
//     try {
//       // 1. Firebase Auth Login
//       final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );
//
//       final String uid = userCredential.user!.uid;
//
//       // 2. Role Check from Firestore
//       final doc = await FirebaseFirestore.instance
//           .collection('userModel')
//           .doc(uid)
//           .get();
//
//       if (doc.exists && doc.data() != null) {
//         UserModel userModel = UserModel.fromJson(doc.data()!);
//
//         if (userModel.isRole == true) {
//           // ✅ Approved: Move to Dashboard
//           if (mounted) {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => const Bottemnevigationscreen()),
//             );
//           }
//         } else {
//           // ❌ Pending: Yahan message set karein aur logout karein
//           await FirebaseAuth.instance.signOut();
//           setState(() {
//             errorMessage = "⚠️ Your account is pending admin approval.";
//           });
//         }
//       } else {
//         await FirebaseAuth.instance.signOut();
//         setState(() {
//           errorMessage = "❌ No user record found in database.";
//         });
//       }
//     } on FirebaseAuthException catch (e) {
//       setState(() {
//         errorMessage = "🔑 ${e.message}";
//       });
//     } catch (e) {
//       setState(() {
//         errorMessage = "🚨 Error: Something went wrong.";
//       });
//     } finally {
//       if (mounted) setState(() => isBusy = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue,
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Login here',
//                     style: GoogleFonts.aDLaMDisplay(fontSize: 30, color: Colors.white),
//                   ),
//                   const SizedBox(height: 30),
//
//                   // Login Fields
//                   Custemtextformfield(
//                     controller: _emailController,
//                     hintText: 'Email',
//                     fillColor: Colors.white,
//                     filled: true,
//                     validator: (v) => v!.isEmpty ? 'Enter email' : null, maxLines: null, readOnly: false, label: Text('email'),
//                   ),
//                   const SizedBox(height: 15),
//                   Custemtextformfield(
//                     controller: _passwordController,
//                     hintText: 'Password',
//                     filled: true,
//                     validator: (v) => v!.isEmpty ? 'Enter password' : null,
//                   ),
//
//                   // 🔥 YAHAN ERROR MESSAGE SHOW HOGA (Agar access false hai)
//                   if (errorMessage != null)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 20),
//                       child: Container(
//                         padding: const EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           color: Colors.red.shade100,
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(color: Colors.red),
//                         ),
//                         child: Text(
//                           errorMessage!,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//
//                   const SizedBox(height: 30),
//
//                   // Login Button
//                   GestureDetector(
//                     onTap: isBusy ? null : loginUser,
//                     child: Container(
//                       width: double.infinity,
//                       height: 55,
//                       decoration: BoxDecoration(
//                         color: isBusy ? Colors.grey : Colors.green,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Center(
//                         child: isBusy
//                             ? const CircularProgressIndicator(color: Colors.white)
//                             : const Text(
//                           'Login',
//                           style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

// Aapke original projects ke imports
import 'package:bidding_admin/WidgetsScreen/CustomTextFormField.dart';
import 'package:bidding_admin/models/user_model.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  bool isBusy = false;

  // 1. Alert Dialog Function (Ye laazmi show hoga)
  Future<void> _showErrorDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User ko OK dabana hi parega
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Access Denied', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK', style: TextStyle(fontSize: 18)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isBusy = true);

    try {
      // Step 1: Login
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final String uid = userCredential.user!.uid;

      // Step 2: Get Role
      final doc = await FirebaseFirestore.instance
          .collection('userModel')
          .doc(uid)
          .get();

      if (doc.exists && doc.data() != null) {
        UserModel userModel = UserModel.fromJson(doc.data()!);

        if (userModel.isRole == true) {
          // Approved: AuthWrapper will automatically transition to Bottemnevigationscreen
          if (mounted && Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        } else {
          // PENDING: Sign out and show dialog
          await FirebaseAuth.instance.signOut();
          if (mounted) {
            await _showErrorDialog("Aapka account admin ki approval ke liye pending hai. Jab tak approval nahi milti aap login nahi kar sakte.");
          }
        }
      } else {
        await FirebaseAuth.instance.signOut();
        if (mounted) {
          await _showErrorDialog("Aapka record database mein nahi mila.");
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        await _showErrorDialog(e.message ?? "Login Failed");
      }
    } catch (e) {
      if (mounted) {
        await _showErrorDialog("Error: $e");
      }
    } finally {
      if (mounted) setState(() => isBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Center(
                  child: Text(
                    'Login here',
                    style: GoogleFonts.aDLaMDisplay(fontSize: 30, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 40),
                Custemtextformfield(
                  controller: _emailController,
                  hintText: 'Enter your email',  maxLines: null, readOnly: false, label: Text('email'),
                  fillColor: Colors.white,
                  filled: true,
                  validator: (value) => value!.isEmpty ? 'Enter email' : null,
                ),
                const SizedBox(height: 15),
                Custemtextformfield(
                  controller: _passwordController,
                  hintText: 'Enter your password', maxLines: null, readOnly: false, label: Text('password'),
                  fillColor: Colors.white,
                  filled: true,
                  validator: (value) => value!.isEmpty ? 'Enter password' : null,
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: isBusy ? null : loginUser,
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      color: isBusy ? Colors.grey : Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: isBusy
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}