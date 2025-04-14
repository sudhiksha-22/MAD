import 'package:flutter/material.dart';
import 'package:mad/auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: AuthScreen());
  }
}
