import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screen/login_screen.dart';

class AdminGuard extends StatelessWidget {
  final Widget child;

  const AdminGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // If not logged in, send to login
    if (user == null) {
      return const LoginScreen();
    }

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get(),
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // No user record
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(
              child: Text(
                'Access denied.\nUser record not found.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;

        // Not admin
        if (data['role'] != 'admin') {
          return const Scaffold(
            body: Center(
              child: Text(
                'Admins only.\nYou do not have permission.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }

        // Authorized admin
        return child;
      },
    );
  }
}