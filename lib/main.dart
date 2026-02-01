import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/auth': (context) => const AuthGate(),
      },
    );
  }
}