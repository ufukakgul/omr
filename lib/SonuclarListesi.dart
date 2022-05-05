import 'package:flutter/material.dart';

class SonuclarListesi extends StatefulWidget {
  SonuclarListesi(this.testId, {Key? key}) : super(key: key);
  int testId;

  @override
  State<SonuclarListesi> createState() => _SonuclarListesiState();
}

class _SonuclarListesiState extends State<SonuclarListesi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("${widget.testId}"),
      ),
    );
  }
}
