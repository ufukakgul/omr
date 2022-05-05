// ignore_for_file: unnecessary_string_interpolations, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omr/Dbo/Sonuclar.dart';
import 'package:omr/Dbo/SonuclarCevap.dart';
import 'package:http/http.dart' as http;
import 'package:omr/main.dart';

class SonuclarListesi extends StatefulWidget {
  SonuclarListesi(this.testId, this.testBaslik, {Key? key}) : super(key: key);
  int testId;
  String testBaslik;

  @override
  State<SonuclarListesi> createState() => _SonuclarListesiState();
}


class _SonuclarListesiState extends State<SonuclarListesi> {
  bool durum = false;

  List<Sonuclar> parseSonuclarCevap(String cevap) {
    var jsonVeri = json.decode(cevap);
    var sonuclarCevap = SonuclarCevap.fromJson(jsonVeri);
    List<Sonuclar> sonuclarListesi = sonuclarCevap.sonuclarListesi;
    durum = sonuclarCevap.durum;
    return sonuclarListesi;
  }

  Future<List<Sonuclar>> sonuclarListele(String test_id) async {
    var url =
        Uri.parse("http://ufuk.site/omr/test_islemleri/test_sonuc_listele.php");
    var veri = {
      "test_id": test_id,
    };
    var cevap = await http.post(url, body: veri);
    return parseSonuclarCevap(cevap.body);
  }

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Color(0xff5e4d91).withOpacity(0.8),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${widget.testId} - ${widget.testBaslik} Sınav Sonuçları",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MyApp()));
                },
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                ),
                hoverColor: Colors.white,
              )
            ],
          ),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            FutureBuilder<List<Sonuclar>>(
              future: sonuclarListele(widget.testId.toString()),
              builder: (context, snapshot) {
                if (snapshot.hasData && durum == true) {
                  var sonuclarListesi = snapshot.data;
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: sonuclarListesi!.length,
                      itemBuilder: (context, indeks) {
                        var sonuc = sonuclarListesi[indeks];
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(30))),
                          color: Color(0xff5e4d91).withOpacity(0.4),
                          child: Padding(padding: EdgeInsets.only(left: 16, right: 24),
                          child: SizedBox(
                            height: 50,
                            child: Padding(
                              padding: EdgeInsets.all(6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(padding: EdgeInsets.only(right: 12), child:
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(60)),
                                    ),
                                    child: Center(
                                      child: Text("${indeks+1}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                                    ),
                                  ),),
                                  Container(
                                    width: ekranGenisligi/3.5,
                                    child: Text("${sonuc.ogrenci_numarasi}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
                                  ),
                                  Container(
                                    width: ekranGenisligi/3.5,
                                    child: Text("${sonuc.ogrenci_adi}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                                  ),
                                  Container(
                                    width: ekranGenisligi/6,
                                    child: Text("${sonuc.alinan_puan}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ),
                        );
                      });
                } else if (snapshot.hasData && durum==false){
                  return Center(
                    child: Text("\n\nSınav Sonucu Bulunmuyor", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                  );
                }else{
                  return Center(
                    child: Text("$durum -++-"),
                  );
                }
              },
            )
          ],
        ));
  }
}