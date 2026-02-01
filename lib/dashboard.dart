import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NCCF Dashboard"),
      ),
      body: const Center(
        child: Text(
          "Welcome to NCCF Sokoto Dashboard",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}