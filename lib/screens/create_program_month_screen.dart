import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CreateProgramMonthScreen extends StatefulWidget {
  const CreateProgramMonthScreen({super.key});

  @override
  State<CreateProgramMonthScreen> createState() =>
      _CreateProgramMonthScreenState();
}

class _CreateProgramMonthScreenState
    extends State<CreateProgramMonthScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime selectedMonth = DateTime.now();

  Future<void> _createMonth() async {
    final monthId = DateFormat('yyyy-MM').format(selectedMonth);
    final monthName = DateFormat('MMMM yyyy').format(selectedMonth);

    await FirebaseFirestore.instance
        .collection('monthly_programs')
        .doc(monthId)
        .set({
      'month': monthName,
      'createdAt': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Monthly program created')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Program Month'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ListTile(
                title: const Text('Select Month'),
                subtitle:
                    Text(DateFormat('MMMM yyyy').format(selectedMonth)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedMonth,
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    setState(() {
                      selectedMonth = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createMonth,
                child: const Text('Create Month'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}