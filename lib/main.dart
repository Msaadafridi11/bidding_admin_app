import 'package:bidding_admin/AuthenticationScreens/AuthWrapper.dart';
import 'package:bidding_admin/Screens/DealerRegistrarion.dart';
import 'package:bidding_admin/Screens/DealerRegistrationForm.dart';
import 'package:bidding_admin/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{
    WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: "https://sjljnvlxrlhthpngwgpu.supabase.co",
    anonKey: "sb_publishable_0qRpHinpj2FzUCWNIwE3rQ_YAKAbeGO",
    );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AuthWrapper(),
    );
  }
}