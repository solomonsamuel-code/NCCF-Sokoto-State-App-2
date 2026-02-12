import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_monthly_program_screen.dart';

class AdminProgramsScreen extends StatelessWidget {
  const AdminProgramsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Programs'),
        backgroundColor: Colors.green,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateMonthlyProgramScreen(),
            ),
          );
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('monthly_programs')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final months = snapshot.data!.docs;

          if (months.isEmpty) {
            return const Center(
              child: Text('No monthly programs created yet'),
            );
          }

          return ListView.builder(
            itemCount: months.length,
            itemBuilder: (context, index) {
              final data =
                  months[index].data() as Map<String, dynamic>;

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.calendar_month),
                  title: Text(data['month']),
                  subtitle: const Text('Tap to manage programs'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}