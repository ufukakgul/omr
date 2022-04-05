// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omr/Dbo/Testler.dart';
import 'package:omr/Dbo/TestlerCevap.dart';
import 'package:omr/KullaniciIslemleri/Login.dart';
import 'package:omr/TestEkle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TestleriListele extends StatefulWidget {
  const TestleriListele(this.kAdi, this.kId, {Key? key}) : super(key: key);
  final String kAdi;
  final String kId;
  @override
  State<TestleriListele> createState() => _TestleriListeleState();
}

class _TestleriListeleState extends State<TestleriListele> {
  late String girisYapanKullaniciTestId;
  late String girisYapanKullaniciId;
  bool soruEklemeButonu = false;
  bool fabButtonGizle = false;
  var sayac = <int>[];
  var testId = <int>[];
  var cevap_anahtari = <String>[];
  var soruSayisi = <int>[];
  int testSayisi = 1;
  bool durum = false;

  Future<String> kullanici_adi() async {
    var sp = await SharedPreferences.getInstance();
    String? kAdi = sp.getString("kullanici_adi");
    return kAdi.toString();
  }

  Future<String> kullanici_id() async {
    var sp = await SharedPreferences.getInstance();
    String? kId = sp.getString("kullanici_id");
    return kId.toString();
  }

  Future<void> cikisYap() async {
    var sp = await SharedPreferences.getInstance();
    sp.remove("girisDurum");
    sp.remove("kullanici_adi");
    sp.remove("kullanici_id");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  List<Testler> parseTestlerCevap(String cevap) {
    var jsonVeri = json.decode(cevap);
    var testlerCevap = TestlerCevap.fromJson(jsonVeri);
    List<Testler> testlerListesi = testlerCevap.testlerListesi;
    durum =testlerCevap.durum;
    return testlerListesi;
  }

  Future<List<Testler>> testleriListele(String kullanici_id) async {
    var url = Uri.parse("http://ufuk.site/omr/test_islemleri/testleri_listele.php");
    var veri = {"kullanici_id": kullanici_id,};
    var cevap = await http.post(url, body: veri);
    return parseTestlerCevap(cevap.body);
  }

  Future<void> testIslemleri() async {
    var liste = await testleriListele(widget.kId);
    for (var k in liste) {
      sayac.add(k.sayac);
      testId.add(int.parse(k.test_id));
      cevap_anahtari.add(k.cevap_anahtari);
      soruSayisi.add(k.cevap_anahtari.length ~/ 3);
    }
    durum ? testSayisi = sayac.last : 0;
  }

  @override
  void initState() {
    testIslemleri();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;
    var eklenenSoruSayisi = TextEditingController();
    return Scaffold(
      floatingActionButton: fabButtonGizle == false
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  soruEklemeButonu = true;
                  fabButtonGizle = true;
                });
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        contentPadding: EdgeInsets.only(top: 0.0),
                        content: (Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                              decoration: BoxDecoration(
                                color: Color(0xff5e4d91),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(32.0),
                                    topRight: Radius.circular(32.0)),
                              ),
                              child: Text(
                                "Soru Ekle",
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 12.0, left: 12, right: 12),
                              child: TextField(
                                controller: eklenenSoruSayisi,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                //autofocus: true,
                                enabled: true,
                                showCursor: false,
                                maxLines: 1,
                                decoration: InputDecoration(
                                  hintText: "Soru Sayısı",
                                  hintStyle: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    eklenenSoruSayisi.text != ""
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => TestEkle(
                                                    eklenenSoruSayisi.text,
                                                    widget.kAdi,
                                                    widget.kId)))
                                        : Text("Hata");
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Ekle",
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      primary: Color(0xff5e4d91),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      )),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    soruEklemeButonu = false;
                                    fabButtonGizle = false;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("İptal",
                                      style: TextStyle(fontSize: 16)),
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xff5e4d91),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    )),
                              ),
                            ],
                          )
                        ],
                      );
                    });
              },
              backgroundColor: Color(0xff736e7e),
              child: Icon(Icons.add),
            )
          : Text(""),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        color: Color(0xff5e4d91),
        shape: CircularNotchedRectangle(), //shape of notch
        notchMargin: soruEklemeButonu == true
            ? 0
            : 5, //notche margin between floating button and bottom appbar
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      cikisYap();
                    },
                    icon: Icon(
                      Icons.exit_to_app_rounded,
                      color: Colors.white,
                    ),
                    label: Text("Çıkış Yap",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
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
      body: FutureBuilder<List<Testler>>(
        future: testleriListele(widget.kId),
        builder: (context, snapshot) {
          if (durum==false) {
            return Container(
              width: ekranGenisligi,
              height: ekranYuksekligi,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomRight,
                    stops: const [
                      0.1,
                      0.2,
                      0.8,
                      0.9,
                    ],
                    colors: [
                      Color(0xff5e4d91).withOpacity(0.7),
                      Color(0xff5e4d91).withOpacity(0.6),
                      Color(0xff5e4d91).withOpacity(0.2),
                      Color(0xff5e4d91).withOpacity(0.1),
                    ],
                  )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Text(
                      "Testiniz bulunmuyor.\nAşağıdaki butona basarak test ekleyebilirsiniz.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.robotoMono(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      for (int i = 0; i < testSayisi; i++)
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(5))),
                          shadowColor: Colors.black,
                          elevation: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 8.0, top: 4),
                                //child: Text("Test ID: $durum"),
                                child: Text("Test ID: ${testId[i]}"),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text("Soru Sayısı: ${soruSayisi[i]}"),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8),
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      child: Text("Düzenle", style: TextStyle(color: Colors.grey.shade600),),
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          side:
                                          BorderSide(color: Colors.grey)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      child: Text("Sınav Tara", style: TextStyle(color: Colors.grey.shade600),),
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          side:
                                          BorderSide(color: Colors.grey)),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Text("Sil", style: TextStyle(color: Colors.grey.shade600),),
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        side: BorderSide(color: Colors.grey)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
