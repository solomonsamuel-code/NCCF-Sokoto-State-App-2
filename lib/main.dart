import 'screens/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: AuthGate(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NCCF Sokoto'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.church, size: 80, color: Colors.green),
              SizedBox(height: 20),
              Text(
                'Nigeria Christian Corpers’ Fellowship\nSokoto State',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Welcome to the official NCCF Sokoto mobile app',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}