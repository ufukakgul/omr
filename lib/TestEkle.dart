// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class TestEkle extends StatefulWidget {
  const TestEkle(this.eklenenSoruSayisi, this.kAdi, {Key? key})
      : super(key: key);
  final String eklenenSoruSayisi;
  final String kAdi;

  @override
  State<TestEkle> createState() => _TestEkleState();
}

class _TestEkleState extends State<TestEkle> {
  int secilenIndex = 0;
  var secenek = ["A", "B", "C", "D", "E"];
  var secilen = <int, int>{};
  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff5e4d91).withOpacity(0.8),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Optik Form Okuma Sistemi",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text("  --  "),
              Text(
                widget.kAdi,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          leading: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("resimler/optikForm.jpg"),
                  )),
            ),
          ),
        ),
        body: Container(
          width: ekranGenisligi,
          height: ekranYuksekligi,
          child: Column(
            children: [
              for(int i = 0; i<=int.parse(widget.eklenenSoruSayisi); i++)
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                 Padding(
                   padding: const EdgeInsets.all(16.0),
                   child: Text("${i+1}"),
                 ),
                 for(int j = 1; j<=5; j++)
                   TextButton(onPressed: (){
                     setState(() {
                       secilen[i]=j;
                     });
                   }, child: Text(secenek[j-1], style: TextStyle(backgroundColor: secilen[i]==j ? Colors.grey : Colors.white),))
               ],)
            ],
          ),
        ));
  }
}
