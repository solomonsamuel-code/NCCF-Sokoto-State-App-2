import 'package:flutter/material.dart';
import 'admin_kitchen_subscription_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// 🔥 KITCHEN MANAGEMENT CARD (TOP PRIORITY)
            _dashboardCard(
              context,
              title: "Kitchen Payments",
              subtitle: "Approve or reject kitchen subscriptions",
              icon: Icons.restaurant,
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const AdminKitchenSubscriptionScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 15),

            /// 💳 PAYMENT RECORDS CARD (if you want separation later)
            _dashboardCard(
              context,
              title: "Payment Records",
              subtitle: "View all kitchen payment history",
              icon: Icons.payment,
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const AdminKitchenSubscriptionScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 15),

            /// 🔔 NOTIFICATIONS CARD (if already implemented)
            _dashboardCard(
              context,
              title: "Notifications",
              subtitle: "View admin alerts",
              icon: Icons.notifications,
              color: Colors.purple,
              onTap: () {
                // Add your notification screen navigation here
              },
            ),

            const SizedBox(height: 15),

            /// ⚙ SETTINGS CARD (Future use)
            _dashboardCard(
              context,
              title: "Kitchen Settings",
              subtitle: "Control kitchen open & close status",
              icon: Icons.settings,
              color: Colors.green,
              onTap: () {
                // Add kitchen settings screen later if needed
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _dashboardCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}