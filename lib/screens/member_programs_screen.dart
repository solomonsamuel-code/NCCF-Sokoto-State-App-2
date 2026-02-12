import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MemberProgramsScreen extends StatefulWidget {
  const MemberProgramsScreen({super.key});

  @override
  State<MemberProgramsScreen> createState() => _MemberProgramsScreenState();
}

class _MemberProgramsScreenState extends State<MemberProgramsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final String _uid;

  @override
  void initState() {
    super.initState();
    _uid = _auth.currentUser!.uid;
  }

  /// Check if a duty needs reminder
  void _checkDutyReminder(Map<String, dynamic> duty) {
    final dateStr = duty['date'] as String? ?? '';
    if (dateStr.isEmpty) return;

    final dutyDate = DateTime.tryParse(dateStr);
    if (dutyDate == null) return;

    final now = DateTime.now();
    final diffDays = dutyDate.difference(now).inDays;

    if (diffDays == 7) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Reminder: Your duty for ${duty['program']} is in 7 days (${duty['date']})'),
        ),
      );
    }

    if (diffDays == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Reminder: Your duty for ${duty['program']} is tomorrow (${duty['date']})'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Programs')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('programs')
            .where('duties', arrayContains: {'memberId': _uid})
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading programs'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final programDocs = snapshot.data?.docs ?? [];
          if (programDocs.isEmpty) {
            return const Center(child: Text('No programs assigned yet'));
          }

          return ListView.builder(
            itemCount: programDocs.length,
            itemBuilder: (context, index) {
              final doc = programDocs[index];
              final programData = doc.data() as Map<String, dynamic>;
              final programType = programData['type'] ?? 'Unknown';
              final duties = List<Map<String, dynamic>>.from(
                  programData['duties'] ?? []);

              // Filter duties for this member
              final myDuties =
                  duties.where((d) => d['memberId'] == _uid).toList();

              return Card(
                margin: const EdgeInsets.all(8),
                child: ExpansionTile(
                  title: Text(programType,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  children: myDuties.map((duty) {
                    _checkDutyReminder(duty); // reminder check
                    return ListTile(
                      title: Text(duty['name'] ?? 'No Name'),
                      subtitle: Text(
                          'Date: ${duty['date'] ?? 'N/A'}${duty.containsKey('topic') ? ', Topic: ${duty['topic']}' : ''}'),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}