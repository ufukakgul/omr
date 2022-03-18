import 'package:flutter/material.dart';
import 'package:omr/Login.dart';
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Optical Mark Recognition',
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}
