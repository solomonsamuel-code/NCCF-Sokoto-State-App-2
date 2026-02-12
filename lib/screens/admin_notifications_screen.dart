import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminNotificationsScreen extends StatelessWidget {
  const AdminNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Notifications'),
        backgroundColor: Colors.deepOrange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('admin_notifications')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading notifications'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No notifications yet'),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: Icon(
                    Icons.notifications,
                    color: data['type'] == 'expired'
                        ? Colors.red
                        : Colors.orange,
                  ),
                  title: Text(data['title']),
                  subtitle: Text(data['message']),
                  trailing: Text(
                    (data['createdAt'] as Timestamp)
                        .toDate()
                        .toString()
                        .substring(0, 16),
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}