import 'package:flutter/material.dart';
import 'package:mimimmi_generator_flutter/generator_page.dart';
import 'package:mimimmi_generator_flutter/output_page.dart';

void main() {
  initOutputPage();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ミミッミジェネレータ',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: GeneratorPage(),
    );
  }
}
