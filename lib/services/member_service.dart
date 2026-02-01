import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/member.dart';

class MemberService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveMember(Member member) async {
    await _firestore
        .collection('members')
        .doc(member.uid)
        .set(member.toMap(), SetOptions(merge: true));
  }

  Future<Member?> getMember(String uid) async {
    final doc = await _firestore.collection('members').doc(uid).get();
    if (!doc.exists) return null;
    return Member.fromMap(doc.data()!);
  }
}