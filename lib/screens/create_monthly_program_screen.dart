import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateMonthlyProgramScreen extends StatefulWidget {
  const CreateMonthlyProgramScreen({super.key});

  @override
  State<CreateMonthlyProgramScreen> createState() =>
      _CreateMonthlyProgramScreenState();
}

class _CreateMonthlyProgramScreenState
    extends State<CreateMonthlyProgramScreen> {
  final _monthController = TextEditingController();

  final List<Map<String, dynamic>> morningDevotion = [];
  final List<Map<String, dynamic>> eveningDevotion = [];
  final List<Map<String, dynamic>> landGuard = [];
  final List<Map<String, dynamic>> sittingRoom = [];

  final Map<String, List<String>> kitchenRoster = {
    'Monday': [],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
    'Friday': [],
    'Saturday': [],
    'Sunday': [],
  };

  void addSimpleDuty(List<Map<String, dynamic>> list,
      {bool includeTopic = false, bool twoPeople = false}) {
    final name1 = TextEditingController();
    final name2 = TextEditingController();
    final date = TextEditingController();
    final topic = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Duty'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: name1,
                decoration:
                    const InputDecoration(labelText: 'Name'),
              ),
              if (twoPeople)
                TextField(
                  controller: name2,
                  decoration: const InputDecoration(
                      labelText: 'Second Name'),
                ),
              TextField(
                controller: date,
                decoration:
                    const InputDecoration(labelText: 'Date'),
              ),
              if (includeTopic)
                TextField(
                  controller: topic,
                  decoration:
                      const InputDecoration(labelText: 'Topic'),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Add'),
            onPressed: () {
              list.add({
                'name1': name1.text,
                'name2': name2.text,
                'date': date.text,
                'topic': topic.text,
              });
              setState(() {});
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  void addKitchenDuty(String day) {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add Kitchen Duty ($day)'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Member Name'),
        ),
        actions: [
          TextButton(
            child: const Text('Add'),
            onPressed: () {
              kitchenRoster[day]!.add(nameController.text);
              setState(() {});
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  Future<void> saveProgram() async {
    await FirebaseFirestore.instance
        .collection('monthly_programs')
        .add({
      'month': _monthController.text,
      'morning_devotion': morningDevotion,
      'evening_devotion': eveningDevotion,
      'land_guard': landGuard,
      'sitting_room': sittingRoom,
      'kitchen_roster': kitchenRoster,
      'createdAt': Timestamp.now(),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Monthly Program'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _monthController,
              decoration:
                  const InputDecoration(labelText: 'Month (e.g March 2026)'),
            ),
            const SizedBox(height: 20),

            section('Morning Devotion', () =>
                addSimpleDuty(morningDevotion, includeTopic: true)),
            section('Evening Devotion', () =>
                addSimpleDuty(eveningDevotion)),
            section('Land Guard', () =>
                addSimpleDuty(landGuard)),
            section('Sitting Room', () =>
                addSimpleDuty(sittingRoom, twoPeople: true)),

            const SizedBox(height: 20),
            const Text(
              'Kitchen Roster',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...kitchenRoster.keys.map((day) => ListTile(
                  title: Text(day),
                  subtitle: Text(
                      kitchenRoster[day]!.join(', ')),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => addKitchenDuty(day),
                  ),
                )),

            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: saveProgram,
              child: const Text('Save Monthly Program'),
            )
          ],
        ),
      ),
    );
  }

  Widget section(String title, VoidCallback onAdd) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style:
                const TextStyle(fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: onAdd,
          child: const Text('Add'),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}