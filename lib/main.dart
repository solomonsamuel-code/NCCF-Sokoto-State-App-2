import 'package:flutter/material.dart';

void main() {
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
      home: const HomePage(),
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