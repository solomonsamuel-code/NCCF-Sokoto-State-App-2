import 'package:flutter/material.dart';

import '../screens/admin_dashboard_screen.dart';
import '../screens/member_dashboard_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  // TEMP mock role switch
  final bool isAdmin = true; // change to false to test member

  @override
  Widget build(BuildContext context) {
    if (isAdmin) {
      return const AdminDashboardScreen();
    } else {
      return const MemberDashboardScreen();
    }
  }
}