import 'package:flutter/material.dart';

import 'screens/home.dart';
import 'widgets/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tourist Personal Assistant',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: const MyHomePage(),
    );
  }
}
