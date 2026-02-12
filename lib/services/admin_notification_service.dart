import 'package:cloud_firestore/cloud_firestore.dart';

class AdminNotificationService {
  static final _firestore = FirebaseFirestore.instance;

  /// Check for expired kitchen subscriptions
  static Future<void> checkExpiredSubscriptions() async {
    final now = DateTime.now();

    final snapshot = await _firestore
        .collection('kitchen_subscriptions')
        .get();

    for (var doc in snapshot.docs) {
      final data = doc.data();

      if (!data.containsKey('expiryDate')) continue;

      final expiryDate =
          (data['expiryDate'] as Timestamp).toDate();

      if (expiryDate.isBefore(now)) {
        await _firestore.collection('admin_notifications').add({
          'title': 'Subscription Expired',
          'message':
              '${data['memberName']} subscription has expired.',
          'memberId': data['memberId'],
          'createdAt': Timestamp.now(),
          'type': 'expired',
          'read': false,
        });
      }
    }
  }
}