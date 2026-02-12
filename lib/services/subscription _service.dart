import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubscriptionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Check subscription and send reminders
  Future<void> checkAndNotify() async {
    final user = _auth.currentUser;
    if (user == null) return;
    final uid = user.uid;

    final doc = await _firestore.collection('subscriptions').doc(uid).get();
    if (!doc.exists) return;

    final data = doc.data()!;
    final expiry = (data['expiry'] as Timestamp).toDate();
    final status = data['status'] ?? 'Pending';
    final now = DateTime.now();

    final diffDays = expiry.difference(now).inDays;

    // Notify member 1 week and 1 day before expiry
    if (diffDays == 7 || diffDays == 1) {
      await _firestore.collection('notifications').add({
        'userId': uid,
        'message': 'Your kitchen subscription expires in $diffDays day(s). Please renew.',
        'timestamp': DateTime.now(),
      });
    }

    // Notify if subscription expired
    if (now.isAfter(expiry) && status != 'Expired') {
      await _firestore.collection('subscriptions').doc(uid).update({
        'status': 'Expired',
      });

      await _firestore.collection('notifications').add({
        'userId': uid,
        'message': 'Your kitchen subscription has expired. Please renew.',
        'timestamp': DateTime.now(),
      });

      // Notify all admins
      final admins = await _firestore.collection('users')
          .where('role', whereIn: ['admin1','admin2','admin3'])
          .get();

      for (var admin in admins.docs) {
        await _firestore.collection('notifications').add({
          'userId': admin.id,
          'message': 'Member ${data['fullName'] ?? uid} subscription has expired.',
          'timestamp': DateTime.now(),
        });
      }
    }
  }
}