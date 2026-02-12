import 'package:flutter/material.dart';

class MemberDashboardScreen extends StatelessWidget {
  const MemberDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Member Dashboard'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.restaurant_menu),
                title: const Text('Kitchen Subscription'),
                subtitle: const Text('View your subscription'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.payment),
                title: const Text('Payments'),
                subtitle: const Text('Confirm your payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}