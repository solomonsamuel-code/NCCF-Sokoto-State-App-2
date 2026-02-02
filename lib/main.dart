import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }
  runApp(const NCCFSokotoApp());
}

class NCCFSokotoApp extends StatelessWidget {
  const NCCFSokotoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NCCF Sokoto',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const AuthGate(), // Entry point: decides where to go
    );
  }
}