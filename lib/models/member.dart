class Member {
  String uid;
  String name;
  String nyscStateCode;
  String batch; // A, B, or C
  String stream; // 1 or 2
  String email; // optional
  String phoneNumber; // optional
  bool isAdmin; // true for admins
  int subscriptionAmount; // amount paid this month
  DateTime createdAt;

  Member({
    required this.uid,
    required this.name,
    required this.nyscStateCode,
    required this.batch,
    required this.stream,
    this.email = '',
    this.phoneNumber = '',
    this.isAdmin = false,
    this.subscriptionAmount = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'nyscStateCode': nyscStateCode,
      'batch': batch,
      'stream': stream,
      'email': email,
      'phoneNumber': phoneNumber,
      'isAdmin': isAdmin,
      'subscriptionAmount': subscriptionAmount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      uid: map['uid'],
      name: map['name'],
      nyscStateCode: map['nyscStateCode'],
      batch: map['batch'],
      stream: map['stream'],
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      isAdmin: map['isAdmin'] ?? false,
      subscriptionAmount: map['subscriptionAmount'] ?? 0,
      createdAt: DateTime.tryParse(map['createdAt'] ?? ''),
    );
  }
}