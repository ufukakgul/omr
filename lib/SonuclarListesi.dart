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
  String? cevapId;

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

  Future<String> cevapSil(String cevaplar_id) async {
    var url = Uri.parse("http://ufuk.site/omr/test_islemleri/cevap_sil.php");
    var veri = {
      "cevaplar_id": cevaplar_id,
    };
    var cevap = await http.post(url, body: veri);
    return cevap.body;
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
          backgroundColor: Colors.indigoAccent.shade700.withOpacity(0.5),
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
                          // color: Color(0xff5e4d91).withOpacity(0.6),
                          color: Colors.indigoAccent.shade100.withOpacity(0.5),
                          //elevation: 10,
                          child: Padding(padding: EdgeInsets.only(left: 16, right: 24),
                          child: SizedBox(
                            height: 60,
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
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("${sonuc.ogrenci_numarasi}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                                      Text("${sonuc.ogrenci_adi}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                                      // Text("${sonuc.cevaplar_id}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                  SizedBox(
                                    width: ekranGenisligi/7,
                                  ),
                                  Spacer(),
                                  SizedBox(
                                    width: ekranGenisligi/5,
                                    child: Text("${sonuc.alinan_puan}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                                  ),
                                  PopupMenuButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(8.0),
                                        bottomRight: Radius.circular(8.0),
                                        topLeft: Radius.circular(8.0),
                                        topRight: Radius.circular(8.0),
                                      ),
                                    ),
                                    child: Icon(Icons.more_vert),
                                    itemBuilder: (context) => [
                                      PopupMenuItem(value: 1, child: Row(
                                        children: [
                                          Icon(Icons.person_search_outlined),
                                          SizedBox(width: 5,),
                                          Text("İncele")
                                        ],
                                      )),
                                      PopupMenuItem(value: 2, child: Row(
                                        children: [
                                          Icon(Icons.delete),
                                          SizedBox(width: 5,),
                                          Text("Sil")
                                        ],
                                      )),
                                    ],
                                    onSelected: (menuItemValue) async {
                                      if (menuItemValue == 1) {

                                      }else if(menuItemValue == 2){
                                        cevapSil(sonuc.cevaplar_id).then((value) => value.contains("true") ?
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                            content: Text(
                                                "Kayıt Silindi")))
                                            : ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                            content: Text(
                                                "Kayıt Silinemedi"))));
                                        await Future.delayed(
                                            Duration(seconds: 3));
                                        setState(() {
                                        });
                                      }
                                    },
                                  )
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
