import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminKitchenSubscriptionScreen extends StatelessWidget {
  const AdminKitchenSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitchen Payments'),
        backgroundColor: Colors.deepOrange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('kitchen_payments')
            .orderBy('paymentDate', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final payments = snapshot.data!.docs;

          if (payments.isEmpty) {
            return const Center(child: Text('No payment records'));
          }

          return ListView.builder(
            itemCount: payments.length,
            itemBuilder: (context, index) {
              final data =
                  payments[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text('${data['name']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Amount: ₦${data['amount']}'),
                      Text('Duration: ${data['duration']}'),
                      Text('Status: ${data['status']}'),
                    ],
                  ),
                  trailing: data['status'] == 'pending'
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check,
                                  color: Colors.green),
                              onPressed: () =>
                                  _approvePayment(payments[index].id),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close,
                                  color: Colors.red),
                              onPressed: () =>
                                  _rejectPayment(payments[index].id),
                            ),
                          ],
                        )
                      : const Icon(Icons.verified,
                          color: Colors.grey),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _approvePayment(String docId) async {
    final doc = FirebaseFirestore.instance
        .collection('kitchen_payments')
        .doc(docId);

    final snapshot = await doc.get();
    final data = snapshot.data()!;

    DateTime now = DateTime.now();
    DateTime expiry;

    if (data['amount'] == 17000) {
      expiry = now.add(const Duration(days: 30));
    } else if (data['amount'] == 10000) {
      expiry = now.add(const Duration(days: 14));
    } else {
      expiry = now.add(const Duration(days: 7));
    }

    await doc.update({
      'status': 'approved',
      'expiryDate': expiry.toIso8601String(),
    });
  }

  Future<void> _rejectPayment(String docId) async {
    await FirebaseFirestore.instance
        .collection('kitchen_payments')
        .doc(docId)
        .update({'status': 'rejected'});
  }
}