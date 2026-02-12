import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MemberKitchenSubscriptionScreen extends StatefulWidget {
  const MemberKitchenSubscriptionScreen({super.key});

  @override
  State<MemberKitchenSubscriptionScreen> createState() =>
      _MemberKitchenSubscriptionScreenState();
}

class _MemberKitchenSubscriptionScreenState
    extends State<MemberKitchenSubscriptionScreen> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  String? _selectedDuration;
  int? _amount;
  bool _loading = false;

  Map<String, dynamic>? _kitchenSettings;
  Map<String, dynamic>? _latestSubscription;
  String? _latestDocId;

  @override
  void initState() {
    super.initState();
    _loadKitchenSettings();
    _loadLatestSubscription();
  }

  /// 🔹 Load Kitchen Account Settings
  Future<void> _loadKitchenSettings() async {
    final doc = await _firestore
        .collection('kitchen_settings')
        .doc('default')
        .get();

    if (doc.exists) {
      setState(() {
        _kitchenSettings = doc.data();
      });
    }
  }

  /// 🔹 Load Latest Subscription
  Future<void> _loadLatestSubscription() async {
    final snapshot = await _firestore
        .collection('kitchen_payments')
        .where('uid', isEqualTo: user?.uid)
        .orderBy('paymentDate', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final doc = snapshot.docs.first;

      setState(() {
        _latestSubscription = doc.data();
        _latestDocId = doc.id;
      });

      _checkAndUpdateExpiry();
    }
  }

  /// 🔥 Automatic Expiry Checker (Simple Version)
  Future<void> _checkAndUpdateExpiry() async {
    if (_latestSubscription == null) return;

    if (_latestSubscription!['expiryDate'] == null) return;

    DateTime expiry =
        DateTime.parse(_latestSubscription!['expiryDate']);

    if (expiry.isBefore(DateTime.now()) &&
        _latestSubscription!['status'] == 'approved') {

      await _firestore
          .collection('kitchen_payments')
          .doc(_latestDocId)
          .update({
        'status': 'expired',
      });

      setState(() {
        _latestSubscription!['status'] = 'expired';
      });

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Subscription Expired"),
            content: const Text(
                "Your kitchen contribution has expired. Please renew."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              )
            ],
          ),
        );
      }
    }
  }

  /// 🔹 Set Duration & Amount
  void _setDuration(String duration) {
    setState(() {
      _selectedDuration = duration;

      if (duration == '1 month') {
        _amount = 17000;
      } else if (duration == '2 weeks') {
        _amount = 10000;
      } else if (duration == '1 week') {
        _amount = 6500;
      }
    });
  }

  /// 🔹 Submit Payment
  Future<void> _submitPayment() async {
    if (_selectedDuration == null || _amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select duration')),
      );
      return;
    }

    setState(() => _loading = true);

    await _firestore.collection('kitchen_payments').add({
      'uid': user?.uid,
      'name': user?.displayName ?? 'Unknown',
      'amount': _amount,
      'duration': _selectedDuration,
      'paymentDate': Timestamp.now(),
      'expiryDate': null,
      'status': 'pending',
    });

    setState(() {
      _loading = false;
      _selectedDuration = null;
      _amount = null;
    });

    _loadLatestSubscription();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment submitted successfully')),
    );
  }

  /// 🔹 Status Color
  Color _statusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'expired':
        return Colors.red;
      case 'rejected':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  /// 🔹 Format Expiry Date
  String _formatDate(String date) {
    DateTime dt = DateTime.parse(date);
    return "${dt.day}/${dt.month}/${dt.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitchen Subscription'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// 🔔 STATUS CARD
            if (_latestSubscription != null)
              Card(
                elevation: 3,
                child: ListTile(
                  title: const Text("Current Subscription Status"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _latestSubscription!['status']
                            .toString()
                            .toUpperCase(),
                        style: TextStyle(
                          color: _statusColor(
                              _latestSubscription!['status']),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (_latestSubscription!['expiryDate'] != null)
                        Text(
                          "Expires: ${_formatDate(_latestSubscription!['expiryDate'])}",
                        ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 20),

            /// 💳 PAYMENT ACCOUNT INFO
            if (_kitchenSettings != null)
              Card(
                color: Colors.orange[50],
                child: ListTile(
                  title: const Text("Pay to this account"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Bank: ${_kitchenSettings!['bankName']}"),
                      Text("Account Name: ${_kitchenSettings!['accountName']}"),
                      Text("Account Number: ${_kitchenSettings!['accountNumber']}"),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 20),

            /// SELECT DURATION
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Select Duration"),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _durationButton("1 month"),
                _durationButton("2 weeks"),
                _durationButton("1 week"),
              ],
            ),

            const SizedBox(height: 20),

            if (_amount != null)
              Text(
                "Amount: ₦$_amount",
                style: const TextStyle(fontSize: 18),
              ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _loading ? null : _submitPayment,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Submit Payment"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _durationButton(String duration) {
    final selected = _selectedDuration == duration;

    return ElevatedButton(
      onPressed: () => _setDuration(duration),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            selected ? Colors.green : Colors.grey[300],
      ),
      child: Text(
        duration,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}