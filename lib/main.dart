import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ミミッミジェネレータ',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(title: const Text('ミミッミジェネレータ')),
        body: const Center(child: Text('ミミッミジェネレータ')),
      ),
    );
  }
}
