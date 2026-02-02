import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'welcome_screen.dart';
import 'member_dashboard_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Loading spinner while checking Firebase auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // User not logged in → show WelcomeScreen
        if (!snapshot.hasData || snapshot.data == null) {
          return const WelcomeScreen();
        }

        // User logged in → show MemberDashboard
        return const MemberDashboardScreen();
      },
    );
  }
}