import 'package:flutter/material.dart';
import '../models/member.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _stateCodeController = TextEditingController();

  String batch = 'A';
  String stream = '1';

  void registerMember() {
    final member = Member(
      fullName: _nameController.text,
      stateCode: _stateCodeController.text,
      batch: batch,
      stream: stream,
    );

    // TEMP: print to console
    print(member.fullName);
    print(member.stateCode);
    print(member.batch);
    print(member.stream);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Member registered (local only)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NCCF Member Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: _stateCodeController,
              decoration: const InputDecoration(
                labelText: 'NYSC State Code',
              ),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField(
              value: batch,
              items: ['A', 'B', 'C']
                  .map((b) => DropdownMenuItem(value: b, child: Text('Batch $b')))
                  .toList(),
              onChanged: (value) => setState(() => batch = value!),
              decoration: const InputDecoration(labelText: 'Batch'),
            ),

            DropdownButtonFormField(
              value: stream,
              items: ['1', '2']
                  .map((s) =>
                      DropdownMenuItem(value: s, child: Text('Stream $s')))
                  .toList(),
              onChanged: (value) => setState(() => stream = value!),
              decoration: const InputDecoration(labelText: 'Stream'),
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: registerMember,
              child: const Text('Register'),
            )
          ],
        ),
      ),
    );
  }
}