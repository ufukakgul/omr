// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
class TestEkle extends StatefulWidget {
  const TestEkle(this.eklenenSoruSayisi, this.kAdi, {Key? key}) : super(key: key);
  final String eklenenSoruSayisi;
  final String kAdi;

  @override
  State<TestEkle> createState() => _TestEkleState();
}

class _TestEkleState extends State<TestEkle> {
  bool bgColor = false;
  int? soruIndex;
  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;
    Color renk = Colors.grey;
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
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: int.parse(widget.eklenenSoruSayisi),
                  itemBuilder: (context, index) {
                    return Card(
                      //color: Color(0xff736e7e),
                      // color: Colors.purple.shade200.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      shadowColor: Colors.black,
                      elevation: 20,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${index + 1} -", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  bgColor =true;
                                });
                              },
                              onLongPress: (){
                                setState(() {
                                  bgColor = false;
                                });
                              },
                              child: Text(
                                "A",
                                style: TextStyle(color: Colors.black),
                              ),
                              style: TextButton.styleFrom(
                                  backgroundColor: bgColor == true ? Colors.grey : Colors.white,
                                  // backgroundColor: bgColor == true ? Colors.grey : Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                      side: BorderSide(color: Colors.black))),
                            ),
                            TextButton(
                              onPressed: () {},
                              child:
                              Text("B", style: TextStyle(color: Colors.black)),
                              style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                      side: BorderSide(color: Colors.black))),
                            ),
                            TextButton(
                              onPressed: () {},
                              child:
                              Text("C", style: TextStyle(color: Colors.black)),
                              style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                      side: BorderSide(color: Colors.black))),
                            ),
                            TextButton(
                              onPressed: () {},
                              child:
                              Text("D", style: TextStyle(color: Colors.black)),
                              style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                      side: BorderSide(color: Colors.black))),
                            ),
                            TextButton(
                              onPressed: () {},
                              child:
                              Text("E", style: TextStyle(color: Colors.black)),
                              style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                      side: BorderSide(color: Colors.black))),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
              ),
            ],
          ),
        ));
  }
}
