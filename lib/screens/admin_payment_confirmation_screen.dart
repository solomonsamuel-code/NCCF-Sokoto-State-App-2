import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPaymentConfirmationScreen extends StatelessWidget {
  const AdminPaymentConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Confirmation'),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('payments')
            .where('status', isEqualTo: 'pending')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No pending payments'),
            );
          }

          final payments = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: payments.length,
            itemBuilder: (context, index) {
              final data = payments[index];
              return _paymentCard(context, data);
            },
          );
        },
      ),
    );
  }

  Widget _paymentCard(BuildContext context, QueryDocumentSnapshot payment) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              payment['memberName'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            _row('Plan', payment['planName']),
            _row('Amount', '₦${payment['amount']}'),
            _row('Duration', '${payment['duration']} days'),
            _row('Reference', payment['reference']),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () => _approvePayment(context, payment),
                    child: const Text('Approve'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () => _rejectPayment(context, payment),
                    child: const Text('Reject'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  /// APPROVE PAYMENT
  Future<void> _approvePayment(
    BuildContext context,
    QueryDocumentSnapshot payment,
  ) async {
    final now = DateTime.now();
    final expiryDate =
        now.add(Duration(days: payment['duration']));

    final batch = FirebaseFirestore.instance.batch();

    // 1️⃣ Update payment status
    batch.update(payment.reference, {
      'status': 'approved',
      'approvedAt': Timestamp.fromDate(now),
    });

    // 2️⃣ Activate member subscription
    final memberRef = FirebaseFirestore.instance
        .collection('members')
        .doc(payment['memberId']);

    batch.update(memberRef, {
      'subscriptionActive': true,
      'planName': payment['planName'],
      'amountPaid': payment['amount'],
      'subscriptionStart': Timestamp.fromDate(now),
      'subscriptionEnd': Timestamp.fromDate(expiryDate),
    });

    await batch.commit();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment approved successfully')),
    );
  }

  /// REJECT PAYMENT
  Future<void> _rejectPayment(
    BuildContext context,
    QueryDocumentSnapshot payment,
  ) async {
    await FirebaseFirestore.instance
        .collection('payments')
        .doc(payment.id)
        .update({
      'status': 'rejected',
      'rejectedAt': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment rejected')),
    );
  }
}