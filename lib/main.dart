import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/member_dashboard_screen.dart';
import 'screens/admin_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NCCF Sokoto App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Replace with your login screen
      return const Scaffold(
        body: Center(child: Text("Login Screen Placeholder")),
      );
    }

    // Simple admin check by email
    if (user.email != null && user.email!.contains('admin')) {
      return const AdminDashboardScreen();
    } else {
      return const MemberDashboardScreen();
    }
  }
}