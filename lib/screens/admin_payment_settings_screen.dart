import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPaymentSettingsScreen extends StatefulWidget {
  const AdminPaymentSettingsScreen({super.key});

  @override
  State<AdminPaymentSettingsScreen> createState() =>
      _AdminPaymentSettingsScreenState();
}

class _AdminPaymentSettingsScreenState
    extends State<AdminPaymentSettingsScreen> {
  final _accountNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _bankNameController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentDetails();
  }

  Future<void> _loadCurrentDetails() async {
    final doc = await FirebaseFirestore.instance
        .collection('admin_settings')
        .doc('payment')
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      _accountNameController.text = data['accountName'] ?? '';
      _accountNumberController.text = data['accountNumber'] ?? '';
      _bankNameController.text = data['bankName'] ?? '';
    }
  }

  Future<void> _saveDetails() async {
    setState(() => _isSaving = true);

    await FirebaseFirestore.instance
        .collection('admin_settings')
        .doc('payment')
        .set({
      'accountName': _accountNameController.text.trim(),
      'accountNumber': _accountNumberController.text.trim(),
      'bankName': _bankNameController.text.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment details updated')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Account Settings'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _accountNameController,
              decoration:
                  const InputDecoration(labelText: 'Account Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _accountNumberController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Account Number'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bankNameController,
              decoration:
                  const InputDecoration(labelText: 'Bank Name'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isSaving ? null : _saveDetails,
              child: _isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Save Details'),
            ),
          ],
        ),
      ),
    );
  }
}