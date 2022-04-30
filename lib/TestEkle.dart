// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:omr/TestleriListele.dart';
import 'package:omr/main.dart';

class TestEkle extends StatefulWidget {
  const TestEkle(this.eklenenSoruSayisi, this.kAdi, this.kId, {Key? key})
      : super(key: key);
  final String eklenenSoruSayisi;
  final String kAdi;
  final String kId;

  @override
  State<TestEkle> createState() => _TestEkleState();
}

class _TestEkleState extends State<TestEkle> {
  var secenek = ["A", "B", "C", "D", "E"];
  var secilen = <int, int>{};
  var cevapAnahtari = <int, String>{};
  int eklenenSoruSayac = 0;
  var siralanmisCevapAnahtari;

  Future<String> testEkle(String kullanici_id, String cevap_anahtari) async {
    var url = Uri.parse("https://ufuk.site/omr/test_islemleri/test_ekle.php");
    var veri = {
      "kullanici_id": kullanici_id,
      "cevap_anahtari": cevap_anahtari,
    };
    var cevap = await http.post(url, body: veri);
    print("Cevap: ${cevap.body}");
    if (cevap.body.contains("true")) {
      return cevap.body.toString();
    } else if (cevap.body.contains("false")) {
      return cevap.body.toString();
    } else {
      return cevap.body.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff5e4d91).withOpacity(0.8),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Optik Form Okuma Sistemi",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.add),
                hoverColor: Colors.white,
              )
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
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  for (int i = 0; i < int.parse(widget.eklenenSoruSayisi); i++)
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      shadowColor: Colors.black,
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("${i + 1} -",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                            for (int j = 1; j <= 5; j++)
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      secilen[i] = j;
                                      cevapAnahtari[i + 1] = secenek[j - 1];
                                      siralanmisCevapAnahtari = SplayTreeMap<int, String>.from(cevapAnahtari);
                                      eklenenSoruSayac++;
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: secilen[i] == j
                                          ? Colors.grey
                                          : Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          side:
                                              BorderSide(color: Colors.black))),
                                  child: Text(
                                    secenek[j - 1],
                                    style: TextStyle(color: Colors.black),
                                  ))
                          ],
                        ),
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ElevatedButton.icon(
                            onPressed: () async {
                              if (cevapAnahtari.length <
                                  int.parse(widget.eklenenSoruSayisi)) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        content: Text(
                                  "Tüm Şıkları İşaretleyin",
                                )));
                                print(siralanmisCevapAnahtari);
                              } else {
                                testEkle(
                                    widget.kId, siralanmisCevapAnahtari.values.toString());
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        content: Text(
                                  "Cevaplarınız Kaydedildi",
                                )));
                                await Future.delayed(Duration(seconds: 5));
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyApp()));
                              }
                            },
                            icon: Icon(
                              Icons.add,
                              color: Colors.black,
                            ),
                            label: SizedBox(
                              height: 40,
                              width: 80,
                              child: Center(
                                child: Text(
                                  "Tamamla",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.grey,
                                textStyle: TextStyle(color: Colors.black),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    side: BorderSide(color: Colors.black)))),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TestleriListele(widget.kAdi, widget.kId)));
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_rounded,
                              color: Colors.black,
                            ),
                            label: SizedBox(
                              height: 40,
                              width: 80,
                              child: Center(
                                child: Text(
                                  "Geri Dön",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.grey,
                                textStyle: TextStyle(color: Colors.black),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    side: BorderSide(color: Colors.black)))),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
