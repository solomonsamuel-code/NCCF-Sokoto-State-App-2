import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionExpiryService {
  static Future<void> checkAndNotifyExpiredSubscriptions() async {
    final now = DateTime.now();
    final querySnapshot = await FirebaseFirestore.instance
        .collection('kitchen_subscriptions')
        .where('status', isEqualTo: 'active')
        .get();

    for (var doc in querySnapshot.docs) {
      final endDate = (doc['subscriptionEnd'] as Timestamp).toDate();
      if (now.isAfter(endDate)) {
        await doc.reference.update({'status': 'expired'});
        await FirebaseFirestore.instance.collection('admin_notifications').add({
          'title': 'Subscription Expired',
          'message': 'Member ${doc['memberName'] ?? doc.id}\'s subscription has expired.',
          'memberId': doc.id,
          'createdAt': Timestamp.now(),
          'read': false,
        });
      }
    }
  }
}