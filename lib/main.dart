import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'viewmodels/admin_profile_viewmodel.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/car_list_viewmodel.dart';
import 'viewmodels/dealer_viewmodel.dart';
import 'views/dashboard/bottom_navigation_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
  }

  try {
    await Supabase.initialize(
      url: "https://sjljnvlxrlhthpngwgpu.supabase.co",
      anonKey: "sb_publishable_0qRpHinpj2FzUCWNIwE3rQ_YAKAbeGO",
    );
  } catch (e) {
    debugPrint("Supabase initialization error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => CarListViewModel()),
        ChangeNotifierProvider(create: (_) => DealerViewModel()),
        ChangeNotifierProvider(create: (_) => AdminProfileViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bidding Admin',
        theme: AppTheme.lightTheme,
        home: const BottomNavigationView(),
      ),
    );
  }
}