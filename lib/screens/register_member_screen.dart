import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/member.dart';
import '../services/member_service.dart';

class RegisterMemberScreen extends StatefulWidget {
  const RegisterMemberScreen({super.key});

  @override
  State<RegisterMemberScreen> createState() => _RegisterMemberScreenState();
}

class _RegisterMemberScreenState extends State<RegisterMemberScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController nyscController = TextEditingController();

  String selectedBatch = 'A';
  String selectedStream = '1';

  bool isLoading = false;

  final MemberService _memberService = MemberService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Member Registration')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your name' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: nyscController,
                decoration: const InputDecoration(
                  labelText: 'NYSC State Code',
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter state code' : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedBatch,
                decoration: const InputDecoration(labelText: 'Batch'),
                items: const [
                  DropdownMenuItem(value: 'A', child: Text('Batch A')),
                  DropdownMenuItem(value: 'B', child: Text('Batch B')),
                  DropdownMenuItem(value: 'C', child: Text('Batch C')),
                ],
                onChanged: (value) =>
                    setState(() => selectedBatch = value!),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedStream,
                decoration: const InputDecoration(labelText: 'Stream'),
                items: const [
                  DropdownMenuItem(value: '1', child: Text('Stream 1')),
                  DropdownMenuItem(value: '2', child: Text('Stream 2')),
                ],
                onChanged: (value) =>
                    setState(() => selectedStream = value!),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: isLoading ? null : _submit,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => isLoading = true);

    final member = Member(
      uid: user.uid,
      name: nameController.text.trim(),
      nyscStateCode: nyscController.text.trim(),
      batch: selectedBatch,
      stream: selectedStream,
      email: user.email ?? '',
      phoneNumber: user.phoneNumber ?? '',
    );

    await _memberService.saveMember(member);

    setState(() => isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful')),
      );
    }
  }
}