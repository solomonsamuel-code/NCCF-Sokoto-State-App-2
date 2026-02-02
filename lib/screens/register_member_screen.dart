import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/member.dart';

class RegisterMemberScreen extends StatefulWidget {
  const RegisterMemberScreen({super.key});

  @override
  State<RegisterMemberScreen> createState() => _RegisterMemberScreenState();
}

class _RegisterMemberScreenState extends State<RegisterMemberScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _stateCodeController = TextEditingController();
  final TextEditingController _batchController = TextEditingController();
  final TextEditingController _streamController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _registerMember() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Create user in Firebase Auth
      UserCredential userCred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim());

      // Create member object
      Member newMember = Member(
        uid: userCred.user!.uid,
        name: _nameController.text.trim(),
        nyscStateCode: _stateCodeController.text.trim(),
        batch: _batchController.text.trim(),
        stream: _streamController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
      );

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('members')
          .doc(newMember.uid)
          .set(newMember.toMap());

      // Registration successful → redirect to Dashboard via AuthGate
      // FirebaseAuth automatically updates auth state

    } on FirebaseAuthException catch (e) {
      String message = 'Registration failed';
      if (e.code == 'email-already-in-use') {
        message = 'Email already registered';
      } else if (e.code == 'weak-password') {
        message = 'Password is too weak';
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _stateCodeController.dispose();
    _batchController.dispose();
    _streamController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Member')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Full Name'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter full name' : null,
                    ),
                    TextFormField(
                      controller: _stateCodeController,
                      decoration:
                          const InputDecoration(labelText: 'NYSC State Code'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter state code' : null,
                    ),
                    TextFormField(
                      controller: _batchController,
                      decoration: const InputDecoration(labelText: 'Batch (A/B/C)'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter batch' : null,
                    ),
                    TextFormField(
                      controller: _streamController,
                      decoration:
                          const InputDecoration(labelText: 'Stream (1/2)'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter stream' : null,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter email' : null,
                    ),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: 'Phone'),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) =>
                          value!.length < 6 ? 'Password too short' : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _registerMember,
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}