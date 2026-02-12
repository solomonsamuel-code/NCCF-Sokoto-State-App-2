import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAssignmentsViewScreen extends StatelessWidget {
  const AdminAssignmentsViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Program Assignments'),
        backgroundColor: Colors.green,
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

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text('No programs available'));
          }

          return ListView(
            children: docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return _monthCard(data);
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _monthCard(Map<String, dynamic> data) {
    return ExpansionTile(
      title: Text(
        data['month'],
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      children: [
        _programSection('Morning Devotion', data['morning_devotion']),
        _programSection('Evening Devotion', data['evening_devotion']),
        _programSection('Land Guard', data['land_guard']),
        _programSection('Sitting Room', data['sitting_room']),
        _kitchenSection(data['kitchen_roster']),
      ],
    );
  }

  Widget _programSection(String title, List? list) {
    if (list == null || list.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(title,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        ...list.map((e) => ListTile(
              title: Text(
                  '${e['name1']}${e['name2'] != '' ? ' & ${e['name2']}' : ''}'),
              subtitle: Text(
                  'Date: ${e['date']}${e['topic'] != '' ? '\nTopic: ${e['topic']}' : ''}'),
            )),
      ],
    );
  }

  Widget _kitchenSection(Map? roster) {
    if (roster == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text('Kitchen Roster',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        ...roster.entries.map((entry) => ListTile(
              title: Text(entry.key),
              subtitle: Text(entry.value.join(', ')),
            )),
      ],
    );
  }
}