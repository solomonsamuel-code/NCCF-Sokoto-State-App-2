import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_screen.dart';
import '../services/member_service.dart';
import 'register_member_screen.dart';

class AuthGate extends StatelessWidget {
  AuthGate({super.key});

  final MemberService _memberService = MemberService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        // 1️⃣ Checking authentication state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2️⃣ User NOT logged in → Login screen
        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        // 3️⃣ User logged in
        final user = snapshot.data!;

        return FutureBuilder(
          future: _memberService.getMember(user.uid),
          builder: (context, memberSnapshot) {

            // Checking Firestore
            if (memberSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // 4️⃣ Logged in BUT no member profile → Register
            if (!memberSnapshot.hasData) {
              return const RegisterMemberScreen();
            }

            // 5️⃣ Logged in AND member exists → Dashboard
            return const Scaffold(
              body: Center(
                child: Text(
                  'Welcome to NCCF Sokoto Dashboard',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            );
          },
        );
      },
    );
  }
}