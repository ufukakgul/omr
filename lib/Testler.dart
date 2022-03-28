// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omr/KullaniciIslemleri/Login.dart';
import 'package:omr/TestEkle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Testler extends StatefulWidget {
  const Testler(this.kAdi, this.kId, {Key? key}) : super(key: key);
  final String kAdi;
  final String kId;
  @override
  State<Testler> createState() => _TestlerState();
}

class _TestlerState extends State<Testler> {
  late String girisYapanKullaniciTestId;
  late String girisYapanKullaniciId;
  bool soruEklemeButonu = false;
  bool fabButtonGizle = false;
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

  Future<String> kayitListele(String kullanici_id) async {
    var url =
        Uri.parse("http://ufuk.site/omr/test_islemleri/testleri_listele.php");
    var veri = {
      "kullanici_id": kullanici_id,
    };
    var cevap = await http.post(url, body: veri);
    var jsonVeri = jsonDecode(cevap.body);
    if (cevap.body.contains("false")) {
      return "0";
    } else if (cevap.body.contains("true")) {
      girisYapanKullaniciId =
          (jsonVeri["kayitlar"][0]["kullanici_id"]).toString();
      girisYapanKullaniciTestId = jsonVeri["kayitlar"][0]["test_id"];
      return "1";
    } else {
      return "Hatalı Giriş";
    }
  }

  @override
  void initState() {
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
      floatingActionButton: fabButtonGizle == false ? FloatingActionButton(
        onPressed: () {
          setState(() {
            soruEklemeButonu = true;
            fabButtonGizle = true;
          });
          // Navigator.push(context, MaterialPageRoute(builder: (context) => TestEkle()));
        },
        backgroundColor: Color(0xff736e7e),
        child: Icon(Icons.add),
      ) : Text(""),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        color: Color(0xff5e4d91),
        shape: CircularNotchedRectangle(), //shape of notch
        notchMargin: soruEklemeButonu == true ? 0 : 5, //notche margin between floating button and bottom appbar
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.exit_to_app_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      cikisYap();
                    },
                  ),
                  Text("Çıkış Yap", style: TextStyle(color: Colors.white)),
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
      body: FutureBuilder<String>(
        future: kayitListele(widget.kId),
        builder: (context, snapshot) {
          if (snapshot.data == "1") {
            return Text("${snapshot.data}");
          } else if (snapshot.data == "0") {
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
                  soruEklemeButonu ?
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10, left: 30, right: 30, bottom: 10),
                    child: Column(
                      children: [
                        TextField(
                          controller: eklenenSoruSayisi,
                          decoration: InputDecoration(
                            hintText: "Soru Sayısı",
                            hintStyle: TextStyle(color: Colors.black, fontSize: 16),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.white, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> TestEkle(eklenenSoruSayisi.text)));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Ekle", style: TextStyle(fontSize: 16)),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xff736e7e),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                  )
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: (){
                                setState(() {
                                  soruEklemeButonu = false;
                                  fabButtonGizle = false;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("İptal", style: TextStyle(fontSize: 16)),
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xff736e7e),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                  )
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ) : Text(""),
                ],
              ),
            );
          } else {
            return Center(
              child: Text("---"),
            );
          }
        },
      ),
    );
  }
}

class TestSayisi extends StatefulWidget {
  const TestSayisi({Key? key}) : super(key: key);

  @override
  State<TestSayisi> createState() => _TestSayisiState();
}

class _TestSayisiState extends State<TestSayisi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Card(
              child: SizedBox(
                width: 50,
                height: 50,
                child: Center(
                  child: Column(
                    children: [Text("Ufuk")],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
