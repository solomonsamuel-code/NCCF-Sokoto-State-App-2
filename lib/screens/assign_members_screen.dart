import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssignMembersScreen extends StatefulWidget {
  final String monthId;   // e.g., "2026-02"
  final String monthName; // e.g., "February 2026"

  const AssignMembersScreen({
    super.key,
    required this.monthId,
    required this.monthName,
  });

  @override
  State<AssignMembersScreen> createState() => _AssignMembersScreenState();
}

class _AssignMembersScreenState extends State<AssignMembersScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Programs
  final List<String> singlePersonPrograms = [
    'Morning Devotion',
    'Evening Devotion',
    'Land Guard',
  ];

  final List<String> twoPersonPrograms = [
    'Sitting Room Cleaning',
  ];

  final List<String> kitchenDays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  // State
  Map<String, dynamic> singlePersonSelection = {};
  Map<String, dynamic> singlePersonTopic = {}; // for morning devotion
  Map<String, dynamic> twoPersonSelection = {};
  Map<String, dynamic> kitchenSelection = {};

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Members - ${widget.monthName}'),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // All members
          final members = snapshot.data!.docs
              .where((doc) => doc['role'] == 'member')
              .toList();

          if (members.isEmpty) {
            return const Center(child: Text('No members found.'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Single Person Programs',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...singlePersonPrograms.map((program) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(program,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        DropdownButton<String>(
                          hint: const Text('Select member'),
                          value: singlePersonSelection[program],
                          isExpanded: true,
                          items: members.map((doc) {
                            final name = doc['fullName'] ?? 'No Name';
                            return DropdownMenuItem(
                              value: doc.id,
                              child: Text(name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              singlePersonSelection[program] = value;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        if (program == 'Morning Devotion') ...[
                          TextField(
                            decoration: const InputDecoration(
                              labelText: 'Topic',
                            ),
                            onChanged: (value) {
                              singlePersonTopic[program] = value;
                            },
                          ),
                          const SizedBox(height: 8),
                        ],
                        ElevatedButton(
                          onPressed: () => _assignSinglePerson(program),
                          child: const Text('Assign'),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),
              const Text('Two Person Programs',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...twoPersonPrograms.map((program) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(program,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        DropdownButton<String>(
                          hint: const Text('Select first member'),
                          value: twoPersonSelection['${program}_1'],
                          isExpanded: true,
                          items: members.map((doc) {
                            final name = doc['fullName'] ?? 'No Name';
                            return DropdownMenuItem(
                              value: doc.id,
                              child: Text(name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              twoPersonSelection['${program}_1'] = value;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        DropdownButton<String>(
                          hint: const Text('Select second member'),
                          value: twoPersonSelection['${program}_2'],
                          isExpanded: true,
                          items: members.map((doc) {
                            final name = doc['fullName'] ?? 'No Name';
                            return DropdownMenuItem(
                              value: doc.id,
                              child: Text(name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              twoPersonSelection['${program}_2'] = value;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => _assignTwoPersons(program),
                          child: const Text('Assign'),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),
              const Text('Kitchen Roster',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...kitchenDays.map((day) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(day,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: members.map((doc) {
                            final name = doc['fullName'] ?? 'No Name';
                            final selected = kitchenSelection[day] != null &&
                                kitchenSelection[day].contains(doc.id);

                            return FilterChip(
                              label: Text(name),
                              selected: selected,
                              onSelected: (bool selectedValue) {
                                setState(() {
                                  kitchenSelection[day] ??= [];
                                  if (selectedValue) {
                                    kitchenSelection[day].add(doc.id);
                                  } else {
                                    kitchenSelection[day].remove(doc.id);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => _assignKitchen(day),
                          child: const Text('Assign'),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }

  Future<void> _assignSinglePerson(String program) async {
    final memberId = singlePersonSelection[program];
    if (memberId == null) {
      _showMessage('Please select a member for $program');
      return;
    }

    final memberDoc =
        await _firestore.collection('users').doc(memberId).get();
    final memberName = memberDoc['fullName'] ?? 'No Name';
    final data = {
      'programType': program,
      'userId': memberId,
      'userName': memberName,
      'date': DateTime.now(), // replace with date picker if needed
      'monthId': widget.monthId,
    };

    if (program == 'Morning Devotion') {
      final topic = singlePersonTopic[program] ?? '';
      data['topic'] = topic;
    }

    await _firestore
        .collection('monthly_programs')
        .doc(widget.monthId)
        .collection('assignments')
        .add(data);

    _showMessage('$memberName assigned to $program');
  }

  Future<void> _assignTwoPersons(String program) async {
    final member1 = twoPersonSelection['${program}_1'];
    final member2 = twoPersonSelection['${program}_2'];

    if (member1 == null || member2 == null) {
      _showMessage('Please select both members for $program');
      return;
    }

    final doc1 = await _firestore.collection('users').doc(member1).get();
    final doc2 = await _firestore.collection('users').doc(member2).get();

    await _firestore
        .collection('monthly_programs')
        .doc(widget.monthId)
        .collection('assignments')
        .add({
      'programType': program,
      'users': [
        {'userId': member1, 'userName': doc1['fullName'] ?? 'No Name'},
        {'userId': member2, 'userName': doc2['fullName'] ?? 'No Name'},
      ],
      'date': DateTime.now(),
      'monthId': widget.monthId,
    });

    _showMessage('Members assigned to $program');
  }

  Future<void> _assignKitchen(String day) async {
    final selected = kitchenSelection[day];
    if (selected == null || selected.isEmpty) {
      _showMessage('Please select at least one member for $day');
      return;
    }

    final users = await Future.wait(selected.map((uid) async {
      final doc = await _firestore.collection('users').doc(uid).get();
      return {'userId': uid, 'userName': doc['fullName'] ?? 'No Name'};
    }));

    await _firestore
        .collection('monthly_programs')
        .doc(widget.monthId)
        .collection('assignments')
        .add({
      'programType': 'Kitchen Roster',
      'day': day,
      'users': users,
      'monthId': widget.monthId,
    });

    _showMessage('Members assigned to Kitchen Roster on $day');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}