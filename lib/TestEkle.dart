// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class TestEkle extends StatefulWidget {
  const TestEkle(this.eklenenSoruSayisi, {Key? key}) : super(key: key);
  final String eklenenSoruSayisi;
  @override
  State<TestEkle> createState() => _TestEkleState();
}

class _TestEkleState extends State<TestEkle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: Text(widget.eklenenSoruSayisi)),
      ),
    );
  }
}
