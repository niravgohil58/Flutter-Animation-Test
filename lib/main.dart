import 'package:flutter/material.dart';
import 'package:flutter_test_animation/screens/demo_screen.dart';
import 'package:flutter_test_animation/screens/dock/dock_items.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DemoScreen(),
    );
  }
}

class MyAppNew extends StatelessWidget {
  const MyAppNew({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Dock(
            icons: [
              Icons.home,
              Icons.search,
              Icons.notifications,
              Icons.settings,
              Icons.person,
            ],
          ),
        ),
      ),
    );
  }
}







