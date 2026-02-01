import '../config/admins.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/member.dart';

class MemberService {
  final CollectionReference membersCollection =
      FirebaseFirestore.instance.collection('members');

  /// Create or update a member
  Future<void> saveMember(Member member) async {
  final bool isAdminUser = adminUIDs.contains(member.uid);

  final Member updatedMember = Member(
    uid: member.uid,
    name: member.name,
    nyscStateCode: member.nyscStateCode,
    batch: member.batch,
    stream: member.stream,
    email: member.email,
    phoneNumber: member.phoneNumber,
    isAdmin: isAdminUser,
    subscriptionAmount: member.subscriptionAmount,
    createdAt: member.createdAt,
  );

  await membersCollection.doc(member.uid).set(
    updatedMember.toMap(),
    SetOptions(merge: true),
  );
}

  /// Get a member by UID
  Future<Member?> getMember(String uid) async {
    final doc = await membersCollection.doc(uid).get();
    if (doc.exists) {
      return Member.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  /// Check if member is admin
  Future<bool> isAdmin(String uid) async {
    final member = await getMember(uid);
    return member?.isAdmin ?? false;
  }

  /// Update subscription payment
  Future<void> updateSubscription({
    required String uid,
    required int amountPaid,
  }) async {
    await membersCollection.doc(uid).update({
      'subscriptionAmount': amountPaid,
    });
  }

  /// Get all members (admin use)
  Stream<List<Member>> getAllMembers() {
    return membersCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              Member.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
}